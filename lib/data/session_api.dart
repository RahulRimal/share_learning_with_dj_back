import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class SessionApi {
  static Future<Object> getPreviousSession(String accessToken) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/sessions');

      var response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: "SL " + accessToken},
      );
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: sessionFromJson(
                json.encode(json.decode(response.body)['data']['session'])));
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

  static Future<Object> postSession(String userName, String password) async {
    try {
      Map<String, String> postBody = {"email": userName, "password": password};
      // var url = Uri.parse('http://localhost/apiforsharelearn/sessions');
      var url = Uri.parse(RemoteManager.BASE_URI + '/auth/jwt/create');

      // Map<String, String> postHeaders = {
      // "Content-Type": "application/json; charset=utf-8",
      // "Content-Type": "application/json",
      // HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      // HttpHeaders.contentTypeHeader: "application/json",
      // };

      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json; charset=utf-8",

          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
        // body: postBody,
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
          code: response.statusCode,
          // response: sessionFromJson(json
          //     .encode(json.decode(response.body)['data']['sessions'][0])));
          response: sessionFromJson(response.body),
        );
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          // errorResponse: ApiStrings.invalidResponseString
          errorResponse: response.body);
    } on HttpException {
      return Failure(
          code: ApiStatusCode.httpError,
          errorResponse: ApiStrings.noInternetString);
    } on FormatException {
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidFormatString);
    } catch (e) {
      print(e.toString());
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //     code: ApiStatusCode.unknownError,
      //     errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> deleteSession(String sessionId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/sessions/' + sessionId);

      var response = await http.delete(
        url,
        headers: {
          "Accept": "application/json; charset=utf-8",

          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS, DELETE",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // print(response.body);
        return Success(
          code: response.statusCode,
          response: response.body,
        );
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: ApiStrings.invalidResponseString
          // errorResponse: response.body
          );
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
        errorResponse: ApiStrings.unknownErrorString,
      );
    }
  }
}
