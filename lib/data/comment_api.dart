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
  static Future<Object> getPostComments(
      String postId, Session userSession) async {
    try {
      // var url = Uri.parse(RemoteManager.BASE_URI + '/replies/p/' + postId);
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/posts/' + postId + '/comments');

      var response = await http.get(
        url,
      );

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: commentFromJson(
            //     json.encode(json.decode(response.body)['data']['replies'])));
            response: commentFromJson(json.encode(json.decode(response.body))));
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
      // Map<String, String> postBody = {
      // Map<String, dynamic> postBody = {
      //   "id": newComment.id,
      //   "postId": newComment.postId,
      //   "body": newComment.commentBody,
      //   "createdDate": newComment.createdDate.toIso8601String(),
      // };
      Map<String, String> postBody = {
        "user_id": newComment.userId.toString(),
        "comment_body": newComment.commentBody,
      };
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/posts/' +
          newComment.postId.toString() +
          '/comments/');
      // var url = Uri.parse(RemoteManager.BASE_URI + '/replies');

      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );
      // print(response);

      if (response.statusCode == ApiStatusCode.responseCreated) {
        return Success(code: response.statusCode, response: commentFromJson(
            // json.encode(json.decode(response.body)['data']['replies'])));
            json.encode(json.decode(response.body))));
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
      // Map<String, String> postBody = {
      Map<String, dynamic> postBody = {
        "id": updatedComment.id,
        "user_id": updatedComment.userId,
        "post_id": updatedComment.postId,
        "comment_body": updatedComment.commentBody,
        "created_date": updatedComment.createdDate.toIso8601String(),
      };
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/posts/' +
          updatedComment.postId.toString() +
          '/comments/' +
          updatedComment.id.toString() +
          '/');

      var response = await http.patch(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + currentSession.accessToken,
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(postBody),
      );

      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(code: response.statusCode, response: commentFromJson(
            // json.encode(json.decode(response.body)['data']['replies'])));
            json.encode(json.decode(response.body))));
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
      var url = Uri.parse(RemoteManager.BASE_URI +
          '/posts/' +
          comment.postId.toString() +
          '/comments/' +
          comment.id.toString() +
          '/');

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
        // body: json.encode(postBody),
      );

      // print(response);

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
