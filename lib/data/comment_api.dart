import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/comment.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class CommentApi {
  static Future<Object> getPostComments(String postId) async {
    try {
      // var url = Uri.parse('http://localhost/apiforsharelearn/posts/u/1');
      // var url = Uri.parse('http://10.0.2.2/apiforsharelearn/posts/u/' + uId);
      var url = Uri.parse(RemoteManager.BASE_URI + '/replies/p/' + postId);

      var response = await http.get(
        url,
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: commentFromJson(
                json.encode(json.decode(response.body)['data']['replies'])));
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

  static Future<Object> addComment(
      Session currentSession, Comment newComment) async {
    try {
      Map<String, String> postBody = {
        "id": newComment.id,
        "userId": currentSession.userId,
        "postId": newComment.postId,
        "body": newComment.commentBody,
        "createdDate": newComment.createdDate.toIso8601String(),
      };
      var url = Uri.parse(RemoteManager.BASE_URI + '/replies');

      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: commentFromJson(
                json.encode(json.decode(response.body)['data']['replies'])));
        // response: commentFromJson(json
        //     .encode(json.decode(response.body)['data']['replies'][0])));
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

  static Future<Object> updateComment(
      Session currentSession, Comment updatedComment) async {
    try {
      Map<String, String> postBody = {
        "id": updatedComment.id,
        "userId": currentSession.userId,
        "postId": updatedComment.postId,
        "body": updatedComment.commentBody,
        "createdDate": updatedComment.createdDate.toIso8601String(),
      };
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/replies/' + updatedComment.id);

      var response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: commentFromJson(
                json.encode(json.decode(response.body)['data']['replies'])));
        // response: commentFromJson(json
        //     .encode(json.decode(response.body)['data']['sessions'][0])));
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

  static Future<Object> deleteComment(
      Session currentSession, Comment comment) async {
    try {
      // Map<String, String> postBody = {
      //   "id": comment.id,
      //   "userId": currentSession.userId,
      //   "postId": comment.postId,
      //   "body": comment.commentBody,
      //   "createdDate": comment.createdDate.toIso8601String(),
      // };
      var url = Uri.parse(RemoteManager.BASE_URI + '/replies/' + comment.id);

      var response = await http.delete(
        url,
        headers: {
          HttpHeaders.authorizationHeader: currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        // body: json.encode(postBody),
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: json.encode(json.decode(response.body)['message']));
        // response: commentFromJson(
        //     json.encode(json.decode(response.body)['data']['replies'])));
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
