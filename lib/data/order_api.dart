import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/order.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../models/user.dart';

class OrderApi {
  static Future<Object> getOrderById(Session loggedInUser, String id) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + "/orders/" + id + '/');

      var response = await http.get(
        url,
        // headers: {HttpHeaders.authorizationHeader: loggedInUser.accessToken},
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      // print(response);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: orderFromJson(json.encode(json.decode(response.body))));
      }

      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
      );
    } on HttpException {
      return Failure(
        code: ApiStatusCode.httpError,
        errorResponse: ApiStrings.noInternetString,
      );
    } on FormatException {
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidFormatString,
      );
    } catch (e) {
      // return Failure(code: 103, errorResponse: e.toString());
      return Failure(
        code: ApiStatusCode.unknownError,
        errorResponse: ApiStrings.unknownErrorString,
      );
    }
  }

  // static Future<Object> getUserOrder(
  //     Session userSession, User loggedInUser) async {
  //   try {
  //     var url = Uri.parse(
  //         RemoteManager.BASE_URI + "/orders/?customer_id=" + loggedInUser.id);
  //     var response = await http.get(url);
  //     if (response.statusCode == ApiStatusCode.responseSuccess) {
  //       if (response.body.length <= 2) {
  //         url = Uri.parse(RemoteManager.BASE_URI + "/orders/");
  //         Map<String, dynamic> postBody = {
  //           "payment_status": "P",
  //           // "customer_id": int.parse(loggedInUser.id),
  //         };
  //         response = await http.post(url,
  //             headers: {
  //               HttpHeaders.authorizationHeader:
  //                   "SL " + userSession.accessToken,
  //               "Accept": "application/json; charset=utf-8",
  //               "Access-Control-Allow-Origin":
  //                   "*", // Required for CORS support to work
  //               "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  //               HttpHeaders.contentTypeHeader: "application/json",
  //             },
  //             body: json.encode(postBody));
  //         if (response.statusCode == ApiStatusCode.responseCreated) {
  //           Map jsonData = json.decode(response.body);
  //           return await getOrderInfo(jsonData['id']);
  //         }
  //       } else {
  //         List<String> temp = response.body.split("");
  //         temp.removeLast();
  //         temp.removeAt(0);
  //         String data = temp.join();
  //         Map jsonData = json.decode(data);
  //         return await getOrderInfo(jsonData['id']);
  //       }
  //     }
  //     return Failure(
  //       code: ApiStatusCode.invalidResponse,
  //       errorResponse: ApiStrings.invalidResponseString,
  //     );
  //   } on HttpException {
  //     return Failure(
  //       code: ApiStatusCode.httpError,
  //       errorResponse: ApiStrings.noInternetString,
  //     );
  //   } on FormatException {
  //     return Failure(
  //       code: ApiStatusCode.invalidResponse,
  //       errorResponse: ApiStrings.invalidFormatString,
  //     );
  //   } catch (e) {
  //     return Failure(
  //       code: ApiStatusCode.unknownError,
  //       errorResponse: ApiStrings.unknownErrorString,
  //     );
  //   }
  // }

  static Future<Object> getUserOrders(Session userSession) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + "/orders/");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
      });
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: ApiStatusCode.responseSuccess,
            response: ordersFromJson(json.encode(json.decode(response.body))));
        // response: orderFromJson(json.encode(response.body)));
      }
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
      );
    } on HttpException {
      return Failure(
        code: ApiStatusCode.httpError,
        errorResponse: ApiStrings.noInternetString,
      );
    } on FormatException {
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidFormatString,
      );
    } catch (e) {
      return Failure(
        code: ApiStatusCode.unknownError,
        errorResponse: ApiStrings.unknownErrorString,
      );
    }
  }

  static Future<Object> getOrderInfo(int orderId) async {
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + "/orders/" + orderId.toString() + "/");
      var response = await http.get(
        url,
        // headers: {
        //   HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
        // }
      );
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: ApiStatusCode.responseSuccess,
            response: orderFromJson(json.encode(json.decode(response.body))));
        // response: orderFromJson(json.encode(response.body)));
      }
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
      );
    } on HttpException {
      return Failure(
        code: ApiStatusCode.httpError,
        errorResponse: ApiStrings.noInternetString,
      );
    } on FormatException {
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidFormatString,
      );
    } catch (e) {
      return Failure(
        code: ApiStatusCode.unknownError,
        errorResponse: ApiStrings.unknownErrorString,
      );
    }
  }

  static Future<Object> addOrderItem(Order order, OrderItem item) async {
    // static Future<void> addOrderItem(Order order, OrderItem item) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/orders/' +
          order.id.toString() +
          '/items/');
      Map<String, dynamic> postBody = {
        "product_id": item.productId,
        "quantity": item.quantity
      };
      var response = await http.post(url,
          headers: {
            // HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(postBody));

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseCreated) {
        return Success(
            code: response.statusCode,
            response:
                orderItemFromJson(json.encode(json.decode(response.body))));
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString);
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      // return Failure(code: 103, errorResponse: e.toString());
      return Failure(
          code: ApiStatusCode.unknownError,
          errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> placeOrder(Session currentSession,
      Map<String, dynamic> billingInfo, String paymentMethod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _cartId = prefs.getString('cartId') as String;
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/orders/');
      Map<String, dynamic> postBody = {
        "cart_id": _cartId,
        "payment_method": paymentMethod,
        "billing_info": billingInfo,
      };
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(postBody));

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: orderFromJson(json.encode(json.decode(response.body))));
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString);
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      // return Failure(code: 103, errorResponse: e.toString());
      return Failure(
          code: ApiStatusCode.unknownError,
          errorResponse: ApiStrings.unknownErrorString);
    }
  }

  // ------------------ This function is for placing direct order without involiving the preexisting cart
  static Future<Object> placeDirectOrder(Session currentSession, String cartId,
      Map<String, dynamic> billingInfo, String paymentMethod) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/orders/');
      Map<String, dynamic> postBody = {
        "cart_id": cartId,
        "payment_method": paymentMethod,
        "billing_info": billingInfo,
      };
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(postBody));

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: orderFromJson(json.encode(json.decode(response.body))));
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString);
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      // return Failure(code: 103, errorResponse: e.toString());
      return Failure(
          code: ApiStatusCode.unknownError,
          errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> updateOrder(
      Session currentSession, String orderId, String status) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/orders/' + orderId + '/');
      Map<String, dynamic> postBody = {
        "payment_status": status,
      };
      var response = await http.patch(url,
          headers: {
            HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(postBody));

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        var order = await getOrderById(currentSession, orderId);

        return Success(
          code: response.statusCode,
          response: (order as Success).response,
          // response: orderFromJson(
          //   json.encode(
          //     json.decode(response.body),
          //   ),
          // ),
        );
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString);
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      // return Failure(code: 103, errorResponse: e.toString());
      return Failure(
          code: ApiStatusCode.unknownError,
          errorResponse: ApiStrings.unknownErrorString);
    }
  }
}
