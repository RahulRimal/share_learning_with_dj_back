import 'package:flutter/cupertino.dart';
import 'package:share_learning/data/order_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';

import '../data/order_request_api.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_request.dart';
import '../models/user.dart';

class OrderRequests with ChangeNotifier {
  List<OrderRequest> _orderRequests = [];

  bool _loading = false;

  OrderRequestError? _orderRequestError;

  List<OrderRequest> get orderRequests => [..._orderRequests];
  bool get loading => _loading;
  OrderRequestError? get orderRequestError => _orderRequestError;

  setOrderRequests(List<OrderRequest> orderRequests) {
    _orderRequests = orderRequests;
  }

  setLoading(bool loading) {
    _loading = loading;
  }

  setOrderRequestError(OrderRequestError orderRequestError) {
    _orderRequestError = orderRequestError;
  }

  Future<bool> createOrderRequest(Session loggedInSession) async {
    setLoading(true);
    var response = await OrderRequestApi.placeOrderRequest(loggedInSession);
    // print(response);
    if (response is Success) {
      _orderRequests.add(response.response as OrderRequest);
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

  Future<Object> getOrderRequests(Session loggedInSession) async {
    var response = await OrderRequestApi.getUserOrderRequests(loggedInSession);
    // print(response);

    if (response is Success) {
      setOrderRequests(response.response as List<OrderRequest>);
      // return response.response;
      return _orderRequests;
    }
    if (response is Failure) {
      OrderRequestError orderRequestError = OrderRequestError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderRequestError(orderRequestError);
      return _orderRequestError as OrderError;
    }
    OrderRequestError orderRequestError = OrderRequestError(
      code: (response as Failure).code,
      message: response.errorResponse,
    );
    setOrderRequestError(orderRequestError);
    return _orderRequestError as OrderError;
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
}
