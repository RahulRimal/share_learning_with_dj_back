import 'dart:convert';
import 'dart:io';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:share_learning/data/session_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static Future<Object> getUserFromToken(String accessToken) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/customers/me');

      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'SL ' + accessToken,
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        HttpHeaders.contentTypeHeader: "application/json",
      });
      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: userFromJson(json.encode(json.decode(response.body))));
      }

      return Failure(
          // code: ApiStatusCode.invalidResponse,
          code: response.statusCode,
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

  static Future<Object> getUserFromId(String userId) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    try {
      String accessToken = prefs.getString('accessToken').toString();

      var url = Uri.parse(RemoteManager.BASE_URI + '/customers/' + userId);
      // var url = Uri.parse(RemoteManager.BASE_URI + '/users/' + userId);

      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'SL ' + accessToken,
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        HttpHeaders.contentTypeHeader: "application/json",
      });

      // print(response);

      // print(json.encode(json.decode(response.body)['data']['user'][0]));

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: userFromJson(
            //     json.encode(json.decode(response.body)['data']['users'][0])));
            response: userFromJson(json.encode(json.decode(response.body))));
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
      var url = Uri.parse(RemoteManager.BASE_URI + '/auth/users/');

      Map<String, dynamic> postBody = {
        "username": user.username.toString(),
        "email": user.email.toString(),
        "password": password,
        // "firstName": user.firstName.toString(),
        // "lastName": user.lastName.toString(),
        // "description": user.description.toString(),
        // "avatar": user.image as File,
        // "avatar": user.image == null ? null : user.image as File,
        // "picture": user.image == null ? null : user.image.toString(),
        // "picture": user.image == null ? null : user.image.toString(),
        // "class": user.userClass.toString(),
      };

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
      );
      if (response.statusCode == ApiStatusCode.responseCreated) {
        var getTokenToCreateCustomer =
            await SessionApi.postSession(user.email.toString(), password);

        // var userData = await getUserFromToken(
        //     ((getTokenToCreateCustomer as Success).response as Session)
        //         .accessToken);

        await getUserFromToken(
            ((getTokenToCreateCustomer as Success).response as Session)
                .accessToken);

        return Success(
            code: response.statusCode,
            response: userFromJson(json.encode(json.decode(response.body))));
      }
      // dynamic errorData = json.decode(response.body);
      // print(errorData);
      return Failure(
          code: ApiStatusCode.invalidResponse,
          // errorResponse: ApiStrings.invalidResponseString
          // errorResponse: response.body);
          errorResponse: json.decode(response.body));
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

  static Future<Object> deleteUser(Session userSession, String password) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/auth/users/me/');
      Map<String, String> postBody = {
        "current_password": password,
      };
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
        body: postBody,
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

// This seems like an old function
  static Future<Object> postUserPic(Session loggedinSession, User user) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/users/pic/' + user.id);

      var request = http.MultipartRequest("POST", url);
      var pic =
          await http.MultipartFile.fromPath("picture", user.image.toString());
      //add multipart to request
      request.files.add(pic);
      request.headers.addAll({
        HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,

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
      // print(responseBody);
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

  static Future<Object> updateCoreUserInfo(
      Session currentSession, Map<String, dynamic> edittedInfo) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/auth/users/me/');
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
        body: json.encode(edittedInfo),
        // body: json.encode(updatedPost),
      );
      // print(response.body);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
          code: response.statusCode,
          // response: userFromJson(json.encode(json.decode(response.body)))
          response: json.decode(response.body),
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

  static Future<Object> updateUserInfo(
      Session currentSession, Map<String, dynamic> edittedInfo) async {
    Map<String, dynamic> coreInfo = {};
    if (edittedInfo.containsKey('username')) {
      coreInfo['username'] = edittedInfo['username'];
      edittedInfo.remove('username');
    }
    if (edittedInfo.containsKey('email')) {
      coreInfo['email'] = edittedInfo['email'];
      edittedInfo.remove('email');
    }
    if (edittedInfo.containsKey('first_name')) {
      coreInfo['first_name'] = edittedInfo['first_name'];
      edittedInfo.remove('first_name');
    }
    if (edittedInfo.containsKey('last_name')) {
      coreInfo['last_name'] = edittedInfo['last_name'];
      edittedInfo.remove('last_name');
    }
    if (coreInfo.isNotEmpty) {
      var coreInfoUpdation = await updateCoreUserInfo(currentSession, coreInfo);
      if (coreInfoUpdation is Failure) return coreInfoUpdation;
    }
    try {
      var url = Uri.parse(
          RemoteManager.BASE_URI + '/customers/' + edittedInfo['id'] + '/');
      edittedInfo.remove('id');
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
        body: json.encode(edittedInfo),
        // body: json.encode(updatedPost),
      );
      // print(response.body);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            response: userFromJson(json.encode(json.decode(response.body))));
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

  static Future<Object> updateUserData(
      String userId, String key, List<String> value) async {
    try {
      var url = Uri.parse(
        RemoteManager.BASE_URI +
            '/user_data/?user_id=' +
            userId +
            '&name=' +
            key,
      );
      var response = await http.get(url);
      // print(response.body);
      // print(response.body.length);

      if (response.body.length <= 2) {
        url = Uri.parse(RemoteManager.BASE_URI + '/user_data/');

        var postBody = {
          "user": userId,
          "name": key,
          "item_list": value,
        };

        response = await http.post(
          url,
          headers: {
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
              // response: userFromJson(json.encode(json.decode(response.body))));
              response: "Thank you for the selection");
        }
        return Failure(
            code: ApiStatusCode.invalidResponse,
            errorResponse: ApiStrings.invalidResponseString);
      } else {
        var id = json.decode(response.body)[0]['id'];

        url = Uri.parse(
            RemoteManager.BASE_URI + '/user_data/' + id.toString() + '/');

        var postBody = {
          "user": userId,
          "name": key,
          "item_list": value,
        };

        response = await http.patch(
          url,
          headers: {
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
          // return Success(
          //     code: response.statusCode,
          //     response: userFromJson(json.encode(json.decode(response.body))));
          return Success(
              code: response.statusCode,
              response: "Thank you for the selection");
        }
        return Failure(
            code: ApiStatusCode.invalidResponse,
            errorResponse: ApiStrings.invalidResponseString);
      }
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

  static Future<Object> haveProvidedData(String userId) async {
    try {
      var url = Uri.parse(
        RemoteManager.BASE_URI + '/user_data/?user_id=' + userId,
      );
      var response = await http.get(url);
      // print(response.body);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // print(response.body.length);
        // if (json.decode(response.body).length > 2) {
        if (response.body.length > 2) {
          return Success(
              code: response.statusCode, response: json.decode(response.body));
        }
      }
      //   return Success(
      //       code: response.statusCode, response: json.decode(response.body));
      // }
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

  static Future<Object> postUserPicture(
      Session loggedinSession, String userId, XFile image) async {
    try {
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/customers/' + userId + '/');

      // var request = http.MultipartRequest("POST", url);
      var request = http.MultipartRequest("PATCH", url);

      var pic = await http.MultipartFile.fromPath("image", image.path);

      request.files.add(pic);

      request.headers.addAll({
        HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,
        "Accept": "application/json; charset=utf-8",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
      });

      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseBody = String.fromCharCodes(responseData);

      // print(responseBody);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
          code: response.statusCode,
          response: userFromJson(
            json.encode(
              json.decode(responseBody),
            ),
          ),
        );
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
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
    }
  }

  static Future<Object> googleSignIn() async {
    final _googleSignIn = GoogleSignIn(
        clientId:
            '117721238163-makqi8gtb0gvt4v374dsd1hl732lu6ud.apps.googleusercontent.com');
    // '117721238163-618v173cte10mqjurff1u01kgimp8kg1.apps.googleusercontent.com');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final String idToken = googleAuth.idToken!;
      // send the ID token to your Django backend

      var url = Uri.parse(RemoteManager.BASE_URI + '/social-auth/google/');
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode({
          "auth_token": idToken,
        }),
      );
      // print(response);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        var respBody = json.decode(response.body);

        Session userSession = Session.fromMap(respBody['tokens']);

        var userData = await getUserFromToken(respBody['tokens']['access']);
        // ((userData as Success).response as User).image = googleUser.photoUrl;

        Map<String, dynamic> data = {
          "session": userSession,
          "user": (userData as Success).response,
        };
        return Success(code: response.statusCode, response: data);
      }
      return Failure(
          code: ApiStatusCode.invalidResponse,
          errorResponse: json.decode(response.body));
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
    }
  }
}
