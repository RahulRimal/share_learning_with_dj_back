import 'dart:convert';
import 'dart:io';

import 'package:share_learning/models/post_category.dart';

import '../models/api_status.dart';
import '../models/session.dart';
import '../templates/managers/api_values_manager.dart';
import 'package:http/http.dart' as http;

import '../templates/managers/strings_manager.dart';
import '../templates/managers/values_manager.dart';

class CategoryApi {
  static Future<Object> getCategories(Session loggedInUser) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/categories/');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken
        },
      );

      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // return Success(
        //     code: response.statusCode,
        //     response:
        //         categoriesFromJson(json.encode(json.decode(response.body))));
        return Success(code: response.statusCode, response: {
          'categories': categoriesFromJson(
            json.encode((json.decode(response.body))['results']),
          ),
          'next': (json.decode(response.body))['next'],
          'previous': (json.decode(response.body))['previous']
        });
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

  static Future<Object> getCategoryById(
      Session loggedInUser, int categoryId) async {
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + '/categories/' + categoryId.toString());

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
            response:
                categoryFromJson(json.encode(json.decode(response.body))));
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
}
