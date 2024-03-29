import 'package:flutter/cupertino.dart';
import 'package:share_learning/data/order_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';

import '../../data/book_api.dart';
import '../../models/book.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../base_view_model.dart';
import '../order_view_model.dart';

class OrderProvider
    with
        ChangeNotifier,
        BaseViewModel,
        OrdersScreenViewModel,
        OrdersScreenNewViewModel,
        OrderDetailsScreenViewModel,
        OrdersItemWidgetViewModel {
  // Order? _order;
  List<Order> _orders = [];

  // List<OrderItem> _orderItems = [];

  bool _loading = false;

  OrderError? _orderError;

  OrderItemError? _orderItemError;

  List<Order> get orders => [..._orders];
  bool get loading => _loading;
  OrderError? get orderError => _orderError;
  OrderItemError? get orderItemError => _orderItemError;

  setOrders(List<Order> orders) {
    _orders = orders;
  }

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // set loading(value){
  //   _loading = value;
  //   notifyListeners();
  // }

  setOrderError(OrderError orderError) {
    _orderError = orderError;
  }

  setOrderItemError(OrderItemError orderItemError) {
    _orderItemError = orderItemError;
  }

//  -------------------- This function places direct order if cartId is given without affecting the pre existing cart otherwise creates an order using the preexisting cart ---------------------------
  Future<bool> placeOrder(
      {required Session loggedInSession,
      String? cartId,
      required Map<String, dynamic> billingInfo,
      required String paymentMethod}) async {
    var response;
    if (cartId != null) {
      response = await OrderApi.placeDirectOrder(
          loggedInSession, cartId, billingInfo, paymentMethod);
    } else {
      response = await OrderApi.placeOrder(
          loggedInSession, billingInfo, paymentMethod);
    }
    // print(response);
    if (response is Success) {
      _orders.add(response.response as Order);
      setLoading(false);
      notifyListeners();
      return true;
    } else if (response is Failure) {
      OrderItemError orderItemError =
          OrderItemError(code: response.code, message: response.errorResponse);
      setOrderItemError(orderItemError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  Future<bool> placeOrderForRequestingCustomer(
      {required Session loggedInSession,
      required String cartId,
      required String customerId,
      required Map<String, dynamic> billingInfo,
      required String paymentMethod}) async {
    setLoading(true);
    var response;
    response = await OrderApi.placeOrderForRequestingCustomer(
        loggedInSession, customerId, cartId, billingInfo, paymentMethod);

    // print(response);
    if (response is Success) {
      return true;
    } else if (response is Failure) {
      OrderItemError orderItemError =
          OrderItemError(code: response.code, message: response.errorResponse);
      setOrderItemError(orderItemError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  Future<Object> getOrderFromId(Session loggedInSession, int orderId) async {
    var response =
        await OrderApi.getOrderById(loggedInSession, orderId.toString());
    print(response);

    if (response is Success) {
      print('here');
      return response.response;
    }
    if (response is Failure) {
      OrderError orderError = OrderError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderError(orderError);
      return _orderError as OrderError;
    }
    // return null;
    OrderError orderError = OrderError(
      code: (response as OrderError).code,
      message: (response).message,
      // message: (response as CartError).message,
    );
    setOrderError(orderError);
    return _orderError as OrderError;
  }

  Future<dynamic> getOrderItemBookByIdFromServer(
      Session loggedInSession, String bookId) async {
    // setLoading(true);
    var response = await BookApi.getBookById(loggedInSession, bookId);
    // print(response);
    if (response is Success) {
      bookProvider.books.add(response.response as Book);
      // setLoading(false);
      return response.response as Book;
    }
    if (response is Failure) {
      OrderItemError error = new OrderItemError(
          code: response.code, message: response.errorResponse);
      // setLoading(false);
      return error;
    }
  }

  // OrderItem getOrderItemById(int id) {
  //   return _orderItems.firstWhere((element) => element.id == id);
  // }

  // Future<bool> getUserOrders(Session loggedInSession, User loggedInUser) async {
  getUserOrders(Session loggedInSession) async {
    setLoading(true);
    var response = await OrderApi.getUserOrders(loggedInSession);
    // print(response);
    if (response is Success) {
      setOrders(response.response as List<Order>);
      // setOrder(response.response as Order);
    }
    if (response is Failure) {
      OrderError orderError = OrderError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderError(orderError);
    }
    setLoading(false);
  }

  Future<bool> addOrderItem(OrderItem item, Order order) async {
    setLoading(true);
    var response = await OrderApi.addOrderItem(order, item);
    // print(response);
    if (response is Success) {
      // _orderItems.add(response.response as OrderItem);
      setLoading(false);
      notifyListeners();
      return true;
    } else if (response is Failure) {
      OrderItemError orderItemError =
          OrderItemError(code: response.code, message: response.errorResponse);
      setOrderItemError(orderItemError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  Future<bool> updatePaymentStatus(
      Session currentSession, String orderId, String status) async {
    setLoading(true);
    var response = await OrderApi.updateOrder(currentSession, orderId, status);
    // print(response);
    if (response is Success) {
      final postIndex =
          _orders.indexWhere((element) => element.id == int.parse(orderId));

      if (postIndex != -1) {
        _orders[postIndex] = response.response as Order;
      }

      notifyListeners();
      return true;
    }

    if (response is Failure) {
      OrderError orderError = OrderError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderError(orderError);
      notifyListeners();
      return false;
    }

    return false;
  }
}
