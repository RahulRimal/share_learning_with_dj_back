import 'package:flutter/cupertino.dart';
import 'package:share_learning/data/order_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';

import '../models/order.dart';
import '../models/order_item.dart';
import '../models/user.dart';

class Orders with ChangeNotifier {
  // Order? _order;
  List<Order> _orders = [];

  // List<OrderItem> _orderItems = [];

  bool _loading = false;

  OrderError? _orderError;

  OrderItemError? _orderItemError;

  // Order? get order => _order;
  List<Order> get orders => [..._orders];
  // List<OrderItem> get orderItems => [..._orderItems];
  bool get loading => _loading;
  OrderError? get orderError => _orderError;
  OrderItemError? get orderItemError => _orderItemError;

  // setOrder(Order order) {
  //   _order = order;
  // }

  setOrders(List<Order> orders) {
    _orders = orders;
  }

  // setOrderItems(List<OrderItem> orderItems) {
  //   _orderItems = orderItems;
  // }

  setLoading(bool loading) {
    _loading = loading;
  }

  setOrderError(OrderError orderError) {
    _orderError = orderError;
  }

  setOrderItemError(OrderItemError orderItemError) {
    _orderItemError = orderItemError;
  }

  Future<bool> placeOrder(
      Session loggedInSession, Map<String, dynamic> billingInfo) async {
    setLoading(true);
    var response = await OrderApi.placeOrder(loggedInSession, billingInfo);
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

  // OrderItem getOrderItemById(int id) {
  //   return _orderItems.firstWhere((element) => element.id == id);
  // }

  Future<bool> getUserOrders(Session loggedInSession, User loggedInUser) async {
    setLoading(true);
    var response = await OrderApi.getUserOrders(loggedInSession, loggedInUser);
    print(response);
    if (response is Success) {
      // setOrder(response.response as Order);
      setLoading(false);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      OrderError orderError = OrderError(
        code: response.code,
        message: response.errorResponse,
      );
      setOrderError(orderError);
      setLoading(false);
      notifyListeners();
    }
    return false;
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

  // bool orderItemsContains(int bookId) {
  //   return _orderItems.any((element) => element.productId == bookId);
  // }
}