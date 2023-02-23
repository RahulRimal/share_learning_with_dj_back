import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/cart_item.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class CartApi {
  static Future<Object> createCart(Session loggedInSession) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/carts/');
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader:
                "SL " + loggedInSession.accessToken,
            "Accept": "application/json; charset=utf-8",
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode({}));

      // print(response);

      if (response.statusCode == ApiStatusCode.responseCreated) {
        return Success(
            code: response.statusCode, response: cartFromJson(response.body));
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString);
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

  static Future<Object> getCartItems(String cartId) async {
    try {
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/carts/' + cartId + "/items/");

      var response = await http.get(
        url,
        // headers: {
        //   HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken
        // },
      );
      print(response);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response:
                cartItemFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> getCartItemBook(
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

  static Future<Object> getCartInfo(String cartId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/carts/' + cartId + '/');

      var response = await http.get(
        url,
        headers: {
          // HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken,
          "Accept": "application/json",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS, DELETE",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: cartFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> addItemToCart(Cart cart, CartItem cartItem) async {
    try {
      Map<String, String> postBody = {
        "product_id": cartItem.product.id.toString(),
        "quantity": cartItem.quantity.toString()
      };
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/carts/' + cart.id + '/items/');

      var response = await http.post(
        url,
        headers: {
          // HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseCreated) {
        return await getCartInfo(cart.id);
        // return Success(
        //   code: response.statusCode,
        //   response: cartFromJson(
        //     json.encode(json.decode(response.body)['data']['cart']),
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

  static Future<Object> getCartItem(String cartId, String cartItemId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/carts/' +
          cartId +
          '/items/' +
          cartItemId +
          '/');

      var response = await http.get(
        url,
        headers: {
          // HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken,
          "Accept": "application/json",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS, DELETE",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response:
                cartItemFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> updateCartItem(
      String cartId, CartItem updatedItem) async {
    try {
      Map<String, String> postBody = {
        "quantity": updatedItem.quantity.toString()
      };
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/carts/' +
          cartId +
          '/items/' +
          updatedItem.id.toString() +
          '/');

      var response = await http.patch(
        url,
        headers: {
          // HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
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
        return await getCartItem(cartId, updatedItem.id.toString());
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

  static Future<Object> deleteCartItem(
      Session userSession, String cartId, String cartItemId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/carts/' +
          cartId +
          '/items/' +
          cartItemId +
          '/');

      var response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + userSession.accessToken,
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
            response: "Cart Item deleted successfully");
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
