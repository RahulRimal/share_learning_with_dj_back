import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class UserApi {
  static Future<Object> getUserFromToken(String accessToken) async {
    try {
      // var url = Uri.parse('http://localhost/apiforsharelearn/users/me');
      // var url = Uri.parse('http://10.0.2.2/apiforsharelearn/users');
      var url = Uri.parse(RemoteManager.BASE_URI + '/customers/me');

      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'SL ' + accessToken,
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        HttpHeaders.contentTypeHeader: "application/json",
      });

      // print(json.encode(json.decode(response.body)['data']['user'][0]));

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: userFromJson(
            //     json.encode(json.decode(response.body)['data']['user'][0])));
            response: userFromJson(
                json.encode(json.decode(response.body))));
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

  static Future<Object> getUserFromId(
      Session loggedInSession, String userId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/userP/' + userId);

      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: loggedInSession.accessToken,
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        HttpHeaders.contentTypeHeader: "application/json",
      });

      // print(json.encode(json.decode(response.body)['data']['user'][0]));

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: userFromJson(
            //     json.encode(json.decode(response.body)['data']['users'][0])));
            response: userFromJson(
                json.encode(json.decode(response.body)['data']['user'][0])));
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

  static Future<Object> createUser(User user, String password) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/users');

      // print(user.username.toString());

      Map<String, dynamic> postBody = {
        "username": user.username.toString(),
        "email": user.email.toString(),
        "password": password,
        "firstName": user.firstName.toString(),
        "lastName": user.lastName.toString(),
        "description": user.description.toString(),
        // "avatar": user.image as File,
        // "avatar": user.image == null ? null : user.image as File,
        // "picture": user.image == null ? null : user.image.toString(),
        "picture": user.image == null ? null : user.image.toString(),
        "class": user.userClass.toString(),
      };

      // Map<String, String> postHeaders = {
      // "Content-Type": "application/json; charset=utf-8",
      // "Content-Type": "application/json",
      // HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      // HttpHeaders.contentTypeHeader: "application/json",
      // };

      var response = await http.post(
        url,
        // headers: postHeaders,
        headers: {
          HttpHeaders.authorizationHeader:
              'ZjNlNTU5OGYyNTk4ZjMwMTQ1MTNkZDFlYzI5MGY3MzNiOTRjNzc1YmRkNTM2N2YxMzEzNjM1MzAzODM0MzczMTM5MzA=',
          // "Accept": "application/json",
          "Accept": "application/json; charset=utf-8",
          // "Accept": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          // "Content-Type": "application/json; charset=utf-8",
          // "Content-Type": "application/json; charset=utf-8",
          // "Content-Type": "application/json",
          // HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
          HttpHeaders.contentTypeHeader: "application/json",
          // HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
        },
        body: json.encode(postBody),
        // body: postBody,
      );

      // print(json.encode(json.decode(response.body)['data']['sessions']));
      // print(response.body);
      // print(json.encode(json.decode(response.body)['data']['sessions'][0]));
      // print(response.body);
      if (response.statusCode == ApiStatusCode.responseCreated) {
        return Success(
            code: response.statusCode,
            response: userFromJson(
                json.encode(json.decode(response.body)['data']['users'][0])));
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
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //     code: ApiStatusCode.unknownError,
      //     errorResponse: ApiStrings.unknownErrorString);
    }
  }

  static Future<Object> postUserPic(Session loggedinSession, User user) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/users/pic/' + user.id);

      var request = http.MultipartRequest("POST", url);
      var pic =
          await http.MultipartFile.fromPath("picture", user.image.toString());
      //add multipart to request
      request.files.add(pic);
      request.headers.addAll({
        HttpHeaders.authorizationHeader: loggedinSession.accessToken,

        "Accept": "application/json; charset=utf-8",
        // "Accept": "application/json; charset=UTF-8",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
      });
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseBody = String.fromCharCodes(responseData);
      // print(json.encode(json.decode(responseBody)['data']['user'][0]));

      print(responseBody);

      // if (response.statusCode == ApiStatusCode.responseCreated) {
      if (json.decode(responseBody)['statusCode'] ==
          ApiStatusCode.responseSuccess) {
        return Success(
          code: response.statusCode,
          response: userFromJson(
            json.encode(
              json.decode(responseBody)['data']['user'][0],
            ),
          ),
        );
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          // errorResponse: ApiStrings.invalidResponseString
          // errorResponse: response.body);
          errorResponse: response.stream.toString());
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
