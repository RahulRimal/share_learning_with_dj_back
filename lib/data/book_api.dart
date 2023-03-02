import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class BookApi {
  static Future<Object> getBooks(Session loggedInUser) async {
    try {
      var url =
          // Uri.parse(RemoteManager.BASE_URI + '/posts/u/' + loggedInUser.userId);
          Uri.parse(RemoteManager.BASE_URI + '/posts/u/');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken
        },
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

  static Future<Object> getAnnonimusPosts(Session loggedInUser) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken,
        },
      );
      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // print(json.encode(json.decode(response.body)['data']['posts']));

        return Success(
          code: response.statusCode,
          response: booksFromJson(
            json.encode(json.decode(response.body)),
          ),
        );
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
      print(e.toString());
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //   code: ApiStatusCode.unknownError,
      //   errorResponse: ApiStrings.unknownErrorString,
      // );
    }
  }

  static Future<Object> getBookById(Session loggedInUser, String id) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/' + id + '/');

      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedInUser.accessToken,
        },
      );
      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseSuccess) {
        // print(json.encode(json.decode(response.body)['data']['posts']));

        return Success(
          code: response.statusCode,
          response: bookFromJson(
            json.encode(json.decode(response.body)),
          ),
        );
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
      print(e.toString());
      return Failure(code: 103, errorResponse: e.toString());
      // return Failure(
      //   code: ApiStatusCode.unknownError,
      //   errorResponse: ApiStrings.unknownErrorString,
      // );
    }
  }

  static Future<Object> updatePost(
      Session currentSession, Book updatedPost) async {
    try {
      Map<String, String> postBody = {
        "userId": updatedPost.userId,
        "bookName": updatedPost.bookName,
        "author": updatedPost.author,
        "description": updatedPost.description,
        "boughtDate": updatedPost.boughtDate.toIso8601String(),
        "price": updatedPost.price.toString(),
        "bookCount": updatedPost.bookCount.toString(),
        "wishlisted": updatedPost.wishlisted.toString(),
        "postType": updatedPost.postType,
        "postRating": updatedPost.postRating,
        // "postedOn": updatedPost.postedOn.toIso8601String()
      };
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/posts/p/' + updatedPost.id);
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
      // print(response.body);
      // print(json.encode(json.decode(response.body)['data']['posts'][0]));
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(code: response.statusCode, response: bookFromJson(
            // json.encode(json.decode(response.body)['data']['posts'][0])));
            json.encode(json.decode(response.body)['data']['posts'])));
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

  static Future<Object> createPost(Session currentSession, Book newPost) async {
    try {
      Map<String, dynamic> postBody = {
        "user_id": int.parse(newPost.userId),
        "book_name": newPost.bookName,
        "author": newPost.author,
        "description": newPost.description,
        // "bought_date": newPost.boughtDate.toIso8601String(),
        "bought_date": DateFormat('yyyy-MM-dd').format(newPost.boughtDate),
        "unit_price": newPost.price.toString(),
        "book_count": int.parse(newPost.bookCount.toString()),
        // "wishlisted": newPost.wishlisted ? '2' : '1',
        "wishlisted": newPost.wishlisted,
        "post_type": newPost.postType,
        "post_rating": double.parse(newPost.postRating),
        // "postedOn": newPost.postedOn.toIso8601String()
      };
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/');

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

      // print(response.body);

      // print(json.encode(json.decode(response.body)['data']['posts'][0]));
      if (response.statusCode == ApiStatusCode.responseCreated) {
        return Success(
          code: response.statusCode,
          response: bookFromJson(
            json.encode(json.decode(response.body)),
          ),
        );
        // response: bookFromJson(
        //     json.encode(json.decode(response.body)['data']['posts'][0])));
        // response: sessionFromJson(
        //     json.encode(json.decode(response.body)['data']['posts'][0])));
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

  static Future<Object> deletePost(
      Session currentSession, String postId) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/p/' + postId);

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

      // print(json.encode(json.decode(response.body)['data']['posts'][0]));
      // print(response.body);
      if (response.statusCode == ApiStatusCode.responseSuccess) {
        return Success(
            code: response.statusCode,
            // response: sessionFromJson(
            //     json.encode(json.decode(response.body)['data']['posts'][0])));
            response: "Post deleted successfully");
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

  static Future<Object> postPictures(Session loggedinSession, Book book) async {
    try {
      var url =
          Uri.parse(RemoteManager.BASE_URI + '/posts/' + book.id + '/images/');

      var request = http.MultipartRequest("POST", url);

      // var pics = [];

      // for (var i = 0; i < book.pictures!.length; i++) {
      //   var pic = await http.MultipartFile.fromPath(
      //     ('image ${i + 1}'),
      //     // book.pictures![i].image.toString(),
      //     // book.pictures![i].image.path,
      //     // book.pictures![i].toString(),
      //     book.pictures![i],
      //     // book.pictures![i].image..toString(),
      //     // (book.pictures![i] as XFile).name,
      //     // (book.pictures![i].toString()).split('/').last);
      //     // filename: book.pictures![i].image.path.split('/').last);
      //   );
      //   pics.add(pic);
      // }

      // // request.files.addAll(pics.map((e) => e));
      // request.files.add(pics[0]);

      // request.headers.addAll({
      //   HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,
      //   // HttpHeaders.contentTypeHeader: "multipart/form-data",
      //   "Content-Type": "multipart/form-data",
      //   "Accept": "application/json; charset=utf-8",
      //   // "Accept": "application/json; charset=UTF-8",
      //   "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      //   "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
      // });
      // var response = await request.send();

      for (var i = 0; i < book.pictures!.length; i++) {
        var pic = await http.MultipartFile.fromPath(
          'images',
          // 'image ${i + 1}',
          book.pictures![i],
        );
        request.files.add(pic);
      }

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

      if (response.statusCode == ApiStatusCode.responseCreated) {
        var bookData = await getBookById(loggedinSession, book.id);
        // print(bookData);
        return bookData;
        // return Success(
        //   code: response.statusCode,
        //   response: bookFromJson(
        //     json.encode(
        //       json.decode(responseBody)['data']['posts'],
        //       // json.encode(
        //       //   json.decode(responseBody)['data']['posts'][0],
        //     ),
        //   ),
        // );
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

  // static Future<Object> deletePictures(
  //     Session loggedinSession, Book book) async {
  //   try {
  //     var url = Uri.parse(RemoteManager.BASE_URI + '/posts/delPics/' + book.id);

  //     var request = http.MultipartRequest("POST", url);

  //     var pics = [];

  //     for (var i = 0; i < book.pictures!.length; i++) {
  //       var pic = await http.MultipartFile.fromPath(
  //         ('pics ${i + 1}'),
  //         // book.pictures![i].image.toString(),
  //         // book.pictures![i].image.path,
  //         // book.pictures![i].image..toString(),
  //         book.pictures![i],
  //       );
  //       // filename: book.pictures![i].image.path.split('/').last);
  //       pics.add(pic);
  //     }

  //     request.files.addAll(pics.map((e) => e));

  //     request.headers.addAll({
  //       HttpHeaders.authorizationHeader: loggedinSession.accessToken,

  //       "Accept": "application/json; charset=utf-8",
  //       // "Accept": "application/json; charset=UTF-8",
  //       "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  //       "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  //     });
  //     var response = await request.send();

  //     //Get the response from the server
  //     var responseData = await response.stream.toBytes();
  //     var responseBody = String.fromCharCodes(responseData);
  //     // print(json.encode(json.decode(responseBody)['data']['user'][0]));

  //     print(responseBody);

  //     // if (response.statusCode == ApiStatusCode.responseCreated) {
  //     if (json.decode(responseBody)['statusCode'] ==
  //         ApiStatusCode.responseSuccess) {
  //       return Success(
  //         code: response.statusCode,
  //         response: bookFromJson(
  //           json.encode(
  //             json.decode(responseBody)['data']['posts'],
  //             // json.encode(
  //             //   json.decode(responseBody)['data']['posts'][0],
  //           ),
  //         ),
  //       );
  //     }
  //     return Failure(
  //         code: ApiStatusCode.invalidResponse,
  //         // errorResponse: ApiStrings.invalidResponseString
  //         // errorResponse: response.body);
  //         errorResponse: response.stream.toString());
  //   } on HttpException {
  //     return Failure(
  //         code: ApiStatusCode.httpError,
  //         errorResponse: ApiStrings.noInternetString);
  //   } on FormatException {
  //     return Failure(
  //         code: ApiStatusCode.invalidResponse,
  //         errorResponse: ApiStrings.invalidFormatString);
  //   } catch (e) {
  //     return Failure(code: 103, errorResponse: e.toString());
  //     // return Failure(
  //     //     code: ApiStatusCode.unknownError,
  //     //     errorResponse: ApiStrings.unknownErrorString);
  //   }
  // }

  static Future<Object> deletePictures(
      Session loggedinSession, Book book) async {
    try {
      var url = Uri.parse(RemoteManager.BASE_URI + '/posts/delPics/' + book.id);

      Map<String, List<String>> pics = {};

      List<String> pictures = [];

      for (var i = 0; i < book.pictures!.length; i++) {
        // pics["pics ${i + 1}"] = (book.pictures![i]).split('/').last;
        pictures.add((book.pictures![i]).split('/').last);
      }

      pics["pics"] = pictures;

      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: "SL " + loggedinSession.accessToken,

          "Accept": "application/json; charset=utf-8",
          // "Accept": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
        },
        body: json.encode(pics),
      );

      // print(response.body);

      if (response.statusCode == ApiStatusCode.responseCreated) {
        // if (json.decode(responseBody)['statusCode'] ==
        // ApiStatusCode.responseSuccess) {
        return Success(
          code: response.statusCode,
          response: bookFromJson(
            json.encode(
              json.decode(response.body)['data']['posts'],
              // json.encode(
              //   json.decode(responseBody)['data']['posts'][0],
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
