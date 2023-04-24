import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/wishlist.dart';

import '../models/api_status.dart';
import '../models/book.dart';
import '../models/session.dart';
import '../templates/managers/api_values_manager.dart';
import '../templates/managers/strings_manager.dart';
import '../templates/managers/values_manager.dart';
import 'book_api.dart';
import 'package:http/http.dart' as http;

class WishlistApi {
  static Future<Object> wishlistedBooks(Session loggedinSession) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/wishlist/');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,

          "Accept": "application/json; charset=utf-8",
          // "Accept": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        },
        // body: json.encode(),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // List<Map<String, dynamic>> postsList = [];
        // for (var post in json.decode(response.body)) {
        //   postsList.add(post['post']);
        // }
        return Success(
            code: response.statusCode,
            response: wishlistsFromJson(
              json.encode(
                (json.decode(response.body)),
              ),
            ));
      }
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
        // errorResponse: response.body,
      );
      // errorResponse: response.stream.toString());
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //     code: ApiStatusCode.unknownError,
      //     errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> removeBookFromWishlist(
      Session loggedinSession, String wishlistId) async {
    try {
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/wishlist/' + wishlistId + '/');

      var response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,

          "Accept": "application/json; charset=utf-8",
          // "Accept": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        },
        // body: json.encode(),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.noContent) {
        return Success(
          code: response.statusCode,
          response: "Book removed from wishlist successfully",
        );
      }
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
        // errorResponse: response.body,
      );
      // errorResponse: response.stream.toString());
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //     code: ApiStatusCode.unknownError,
      //     errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> addBookToWishlist(
      Session loggedinSession, String bookId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/wishlist/');
      Map<String, dynamic> postBody = {
        "post": int.parse(bookId),
      };
      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,

          "Accept": "application/json; charset=utf-8",
          // "Accept": "application/json; charset=UTF-8",
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
          response: wishlistFromJson(
            json.encode(
              (json.decode(response.body)),
            ),
          ),
        );
      }
      return Failure(
        code: ApiStatusCode.invalidResponse,
        errorResponse: ApiStrings.invalidResponseString,
        // errorResponse: response.body,
      );
      // errorResponse: response.stream.toString());
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //     code: ApiStatusCode.unknownError,
      //     errorResponse: ApiStrings.unknownErrorString);
    }
  }
}
