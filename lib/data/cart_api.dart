import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class CartApi {
  static Future<Object> getCartItemBook(
      Session loggedInUser, String bookId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/p/' + bookId);

      var response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: loggedInUser.accessToken},
      );
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: bookFromJson(
                json.encode(json.decode(response.body)['data']['posts'])));
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

  static Future<Object> getUserCart(Session loggedInUser) async {
    try {
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/carts/u/' + loggedInUser.userId);

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: loggedInUser.accessToken,
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
            response: cartFromJson(
                json.encode(json.decode(response.body)['data']['carts'])));
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

  static Future<Object> postCartItem(Session userSession, Cart cartItem) async {
    try {
      Map<String, String> postBody = {
        "bookId": cartItem.bookId,
        "sellingUserId": cartItem.sellingUserId,
        "buyingUserId": cartItem.buyingUserId,
        "bookCount": cartItem.bookCount.toString(),
        "pricePerPiece": cartItem.pricePerPiece.toString(),
        "wishlisted": cartItem.wishlisted ? "1" : "2",
        "postType": cartItem.postType.toString(),
      };
      var url = Uri.parse(RemoteManager.BASE_URI + '/carts');

      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: userSession.accessToken,
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
        return Success(
          code: response.statusCode,
          response: cartFromJson(
            json.encode(json.decode(response.body)['data']['cart']),
          ),
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

  static Future<Object> updateCartItem(
      Session userSession, Cart edittedItem) async {
    try {
      Map<String, String> postBody = {
        "bookId": edittedItem.bookId,
        "sellingUserId": edittedItem.sellingUserId,
        "buyingUserId": edittedItem.buyingUserId,
        "bookCount": edittedItem.bookCount.toString(),
        "pricePerPiece": edittedItem.pricePerPiece.toString(),
        "wishlisted": edittedItem.wishlisted ? "1" : "2",
        "postType": edittedItem.postType.toString(),
      };
      var url = Uri.parse(RemoteManager.BASE_URI + '/carts/' + edittedItem.id);

      var response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: userSession.accessToken,
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
        return Success(
          code: response.statusCode,
          response: cartFromJson(
            json.encode(json.decode(response.body)['data']['carts']),
          ),
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

  static Future<Object> deleteCartItem(
      Session userSession, String cartId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/carts/' + cartId);

      var response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: userSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
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
