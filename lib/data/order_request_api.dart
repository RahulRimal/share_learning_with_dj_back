import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/order.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/models/order_request.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';

class OrderRequestApi {
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

  static Future<Object> getUserOrderRequests(Session userSession) async {
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + "/order_requests/requests_by_user/");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
      });
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: ApiStatusCode.responseSuccess,
            response:
                orderRequestsFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> getOrderRequestsForUser(Session userSession) async {
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + "/order_requests/requests_for_user/");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
      });
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: ApiStatusCode.responseSuccess,
            response:
                orderRequestsFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> getOrderRequestInfo(String orderRequestId) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      String accessToken = prefs.getString('accessToken') as String;
      var url = Uri.parse(
          RemoteManager.BASE_URI + "/order_requests/" + orderRequestId + "/");
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + accessToken,
        },
      );
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: ApiStatusCode.responseSuccess,
            response:
                orderRequestFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> getRequestedItemBook(
      Session loggedInUser, String bookId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/' + bookId + "/");

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken
        },
      );
      // print(response);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: bookFromJson(json.encode(json.decode(response.body))));
            response: bookFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> updateRequestPrice(
      String orderRequestId, double newRequestPrice) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      String accessToken = prefs.getString('accessToken') as String;
      Map<String, String> postBody = {
        "requested_price": newRequestPrice.toString(),
        "changed_by_seller": 'false'
      };
      var url = Uri.parse(
          RemoteManager.BASE_URI + '/order_requests/' + orderRequestId + '/');

      var response = await http.patch(
        url,
        headers: {
          // HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
          HttpHeaders.authorizationHeader: "SL " + accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return await getOrderRequestInfo(orderRequestId);
        // return Success(
        //   code: response.statusCode,
        //   response: cartFromJson(
        //     json.encode(json.decode(response.body)['data']['carts']),
        //   ),
        // );
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

  static Future<Object> updateSellerOfferPrice(
      String orderRequestId, double newRequestPrice) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      String accessToken = prefs.getString('accessToken') as String;
      Map<String, String> postBody = {
        "seller_offer_price": newRequestPrice.toString(),
        "changed_by_seller": 'true',
      };
      var url = Uri.parse(
          RemoteManager.BASE_URI + '/order_requests/' + orderRequestId + '/');

      var response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return await getOrderRequestInfo(orderRequestId);
        // return Success(
        //   code: response.statusCode,
        //   response: cartFromJson(
        //     json.encode(json.decode(response.body)['data']['carts']),
        //   ),
        // );
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

  //  -------------------------- Create order requests using the cart starts here ---------------------------

  // static Future<Object> placeOrderRequest(Session currentSession) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String _cartId = prefs.getString('cartId') as String;
  //   try {
  //     var url = Uri.parse(RemoteManager.BASE_URI + '/order_requests/');
  //     Map<String, dynamic> postBody = {"cart_id": _cartId};
  //     var response = await http.post(url,
  //         headers: {
  //           HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
  //           "Accept": "application/json; charset=utf-8",
  //           "Access-Control-Allow-Origin":
  //               "*", // Required for CORS support to work
  //           "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         },
  //         body: json.encode(postBody));

  //     print(response.body);

  //     if (response.statusCode == ApiStatusCode.responseSuccess) {
  //       return Success(
  //           code: response.statusCode,
  //           response:
  //               orderRequestFromJson(json.encode(json.decode(response.body))));
  //     }
  //     return Failure(
  //         code: ApiStatusCode.invalidResponse,
  //         errorResponse: ApiStrings.invalidResponseString);
  //   } on HttpException {
  //     return Failure(
  //         code: ApiStatusCode.httpError,
  //         errorResponse: ApiStrings.noInternetString);
  //   } on FormatException {
  //     return Failure(
  //         code: ApiStatusCode.invalidResponse,
  //         errorResponse: ApiStrings.invalidFormatString);
  //   } catch (e) {
  //     // return Failure(code: 103, errorResponse: e.toString());
  //     return Failure(
  //         code: ApiStatusCode.unknownError,
  //         errorResponse: ApiStrings.unknownErrorString);
  //   }
  // }
  //  -------------------------- Create order requests using the cart ends here ---------------------------

  static Future<Object> placeOrderRequest(
      Session currentSession, Map<String, dynamic> requestInfo) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/order_requests/');

      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(requestInfo));

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response:
                orderRequestFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> deleteOrderRequest(
      Session currentSession, String orderRequestId) async {
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + '/order_requests/' + orderRequestId + '/');

      var response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      // print(response.body);
      if (response.statusCode == ApiStatusCode.noContent) {
        return Success(
            code: response.statusCode,
            response: "Order request deleted successfully");
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
