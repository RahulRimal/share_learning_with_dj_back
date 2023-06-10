import 'package:flutter/cupertino.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/order_request_api.dart';
import '../models/book.dart';
import '../models/order.dart';
import '../models/order_request.dart';

class OrderRequestProvider with ChangeNotifier {
  List<OrderRequest> _orderRequestsByUser = [];
  List<OrderRequest> _orderRequestsForUser = [];

  bool _loading = false;

  OrderRequestError? _orderRequestError;

  List<OrderRequest> get orderRequestsByUser => [..._orderRequestsByUser];
  List<OrderRequest> get orderRequestsForUser => [..._orderRequestsForUser];
  bool get loading => _loading;
  OrderRequestError? get orderRequestError => _orderRequestError;

  setOrderRequestsByUser(List<OrderRequest> orderRequestsByUser) {
    _orderRequestsByUser = orderRequestsByUser;
  }

  setOrderRequestsForUser(List<OrderRequest> orderRequestsForUser) {
    _orderRequestsForUser = orderRequestsForUser;
  }

  setLoading(bool loading) {
    _loading = loading;
  }

  setOrderRequestError(OrderRequestError orderRequestError) {
    _orderRequestError = orderRequestError;
  }

//  -------------------------- Create order requests using the cart starts here ---------------------------

  // Future<bool> createOrderRequest(Session loggedInSession) async {
  //   setLoading(true);
  //   var response = await OrderRequestApi.placeOrderRequest(loggedInSession);
  //   // print(response);
  //   if (response is Success) {
  //     _orderRequests.add(response.response as OrderRequest);
  //     setLoading(false);
  //     notifyListeners();
  //     return true;
  //   } else if (response is Failure) {
  //     OrderRequestError orderRequestError = OrderRequestError(
  //         code: response.code, message: response.errorResponse);
  //     setOrderRequestError(orderRequestError);
  //     setLoading(false);
  //     notifyListeners();
  //   }
  //   return false;
  // }

  //  -------------------------- Create order requests using the cart ends here ---------------------------

  Future<bool> createOrderRequest(
      Session loggedInSession, Map<String, dynamic> requestInfo) async {
    setLoading(true);
    var response =
        await OrderRequestApi.placeOrderRequest(loggedInSession, requestInfo);
    // print(response);
    if (response is Success) {
      _orderRequestsByUser.add(response.response as OrderRequest);
      setLoading(false);
      notifyListeners();
      return true;
    } else if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
          code: response.code, message: response.errorResponse);
      setOrderRequestError(orderRequestError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  Future<Object> getOrderRequestsByUser(Session loggedInSession) async {
    var response = await OrderRequestApi.getUserOrderRequests(loggedInSession);
    // print(response);

    if (response is Success) {
      setOrderRequestsByUser(response.response as List<OrderRequest>);
      // return response.response;
      return _orderRequestsByUser;
    }
    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      return _orderRequestError as OrderRequestError;
    }
    OrderRequestError orderRequestError = OrderRequestError(
      code: (response as Failure).code,
      message: response.errorResponse,
    );
    setOrderRequestError(orderRequestError);
    return _orderRequestError as OrderError;
  }

  Future<Object> getRequestsForUser(Session loggedInSession) async {
    var response =
        await OrderRequestApi.getOrderRequestsForUser(loggedInSession);
    // print(response);

    if (response is Success) {
      setOrderRequestsForUser(response.response as List<OrderRequest>);

      return _orderRequestsForUser;
    }
    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      return _orderRequestError as OrderRequestError;
    }
    OrderRequestError orderRequestError = OrderRequestError(
      code: (response as Failure).code,
      message: response.errorResponse,
    );
    setOrderRequestError(orderRequestError);
    return _orderRequestError as OrderError;
  }

  Future<Object> getRequestedItemBook(
      Session loggedInSession, String bookId) async {
    var response =
        await OrderRequestApi.getRequestedItemBook(loggedInSession, bookId);
    if (response is Success) {
      // List<Book> responseList = response.response as List<Book>;
      return response.response as Book;
    }
    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      return _orderRequestError as OrderRequestError;
    }

    OrderRequestError orderRequestError = OrderRequestError(
      code: (response as OrderRequestError).code,
      message: (response).message,
    );
    setOrderRequestError(orderRequestError);
    return _orderRequestError as OrderRequestError;
  }

  Future<bool> updateRequestPrice(
      String requestId, double newRequestPrice) async {
    var response =
        await OrderRequestApi.updateRequestPrice(requestId, newRequestPrice);
    // print(response);

    if (response is Success) {
      final postIndex =
          _orderRequestsByUser.indexWhere((element) => element.id == requestId);

      OrderRequest updatedRequest = response.response as OrderRequest;
      _orderRequestsByUser[postIndex] = updatedRequest;
      notifyListeners();
      return true;
    }

    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<bool> updateSellerOfferPrice(
      String requestId, double newRequestPrice) async {
    var response = await OrderRequestApi.updateSellerOfferPrice(
        requestId, newRequestPrice);

    // print(response);

    if (response is Success) {
      // If user updates the offer by using the route of notification, _orderRequestsForUser might be empty so i am populating orderRequestsForUser here
      if (_orderRequestsForUser.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String access = prefs.getString('accessToken') as String;
        String refresh = prefs.getString('refreshToken') as String;
        await getRequestsForUser(
            Session(accessToken: access, refreshToken: refresh));
      }
      final postIndex = _orderRequestsForUser
          .indexWhere((element) => element.id == requestId);

      OrderRequest updatedRequest = response.response as OrderRequest;
      _orderRequestsForUser[postIndex] = updatedRequest;
      notifyListeners();
      return true;
    }

    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<bool> deleteOrderRequest(
      Session loggedInSession, String orderRequestId) async {
    setLoading(true);
    var response = await OrderRequestApi.deleteOrderRequest(
        loggedInSession, orderRequestId);
    // print(response);
    if (response is Success) {
      // _orderRequestsByUser.add(response.response as OrderRequest);
      // setLoading(false);
      // notifyListeners();
      return true;
    } else if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
          code: response.code, message: response.errorResponse);
      setOrderRequestError(orderRequestError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  // // OrderItem getOrderItemById(int id) {
  // //   return _orderItems.firstWhere((element) => element.id == id);
  // // }

  // // Future<bool> getUserOrders(Session loggedInSession, User loggedInUser) async {
  // getUserOrders(Session loggedInSession) async {
  //   setLoading(true);
  //   var response = await OrderApi.getUserOrders(loggedInSession);
  //   // print(response);
  //   if (response is Success) {
  //     setOrders(response.response as List<Order>);
  //     // setOrder(response.response as Order);
  //   }
  //   if (response is Failure) {
  //     OrderError orderError = OrderError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setOrderError(orderError);
  //   }
  //   setLoading(false);
  //   // notifyListeners();
  // }

  // Future<bool> addOrderItem(OrderItem item, Order order) async {
  //   setLoading(true);
  //   var response = await OrderApi.addOrderItem(order, item);
  //   // print(response);
  //   if (response is Success) {
  //     // _orderItems.add(response.response as OrderItem);
  //     setLoading(false);
  //     notifyListeners();
  //     return true;
  //   } else if (response is Failure) {
  //     OrderItemError orderItemError =
  //         OrderItemError(code: response.code, message: response.errorResponse);
  //     setOrderItemError(orderItemError);
  //     setLoading(false);
  //     notifyListeners();
  //   }
  //   return false;
  // }

  // Future<bool> updatePaymentStatus(
  //     Session currentSession, String orderId, String status) async {
  //   setLoading(true);
  //   var response = await OrderApi.updateOrder(currentSession, orderId, status);
  //   // print(response);
  //   if (response is Success) {
  //     final postIndex = _orders.indexWhere((element) => element.id == orderId);

  //     if (postIndex != -1) {
  //       _orders[postIndex] = response.response as Order;
  //     }

  //     notifyListeners();
  //     return true;
  //   }

  //   if (response is Failure) {
  //     OrderError orderError = OrderError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setOrderError(orderError);
  //     notifyListeners();
  //     return false;
  //   }

  //   return false;
  // }

  bool orderRequestsByUserContains(int bookId) {
    return _orderRequestsByUser.any((element) => element.product.id == bookId);
  }
}
