// import 'package:intl/intl.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart';
// // import 'package:nepali_date_picker/nepali_date_picker.dart';

// class Book {
//   late final String id;
//   final String uId;
//   final String title;
//   final String description;
//   final String author;
//   // final DateTime boughtTime;
//   final NepaliDateTime boughtTime;
//   final double price;
//   final int bookCount;
//   final bool isWishlisted;
//   final bool selling;
//   List<String>? pictures;

//   Book({
//     required this.id,
//     required this.uId,
//     required this.title,
//     required this.description,
//     required this.author,
//     required this.boughtTime,
//     required this.price,
//     required this.bookCount,
//     required this.isWishlisted,
//     required this.selling,
//     this.pictures,
//   });

//   factory Book.fromJson(Map<String, dynamic> parsedJson) {
//     return Book(
//       id: parsedJson['id'].toString(),
//       uId: parsedJson['userId'].toString(),
//       title: parsedJson['bookName'].toString(),
//       description: parsedJson['description'].toString(),
//       author: parsedJson['author'].toString(),
//       // boughtTime: NepaliDateTime.parse(parsedJson['boughtTime'].toString()),
//       // boughtTime: NepaliDateTime.parse(parsedJson['boughtTime'].toString()),
//       //  ('yyyy-MM-dd').format(parsedJson['boughtTime'] as DateTime).toString();
//       // boughtTime: NepaliDateTime.fromDateTime(
//       //     DateTime.parse(parsedJson['boughtTime'].toString())),
//       boughtTime: NepaliDateTime.parse(parsedJson['boughtDate'].toString()),
//       price: parsedJson['price'],
//       bookCount: int.parse(parsedJson['bookCount']),
//       isWishlisted:
//           parsedJson['isWishlisted'].toString() == 'true' ? true : false,
//       selling: parsedJson['selling'].toString() == 'S' ? true : false,
//     );
//   }
// }

// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

// List<Book> bookFromJson(String str) =>
//     List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) {
      Book book = Book.fromJson(x);

      // if (book.pictures != null) {
      //   book.pictures = book.pictures!.map((e) {
      //     return "${RemoteManager.POST_POOL}/${book.id}/$e";
      //   }).toList();
      // }

      return book;
    }));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    required this.id,
    required this.userId,
    required this.bookName,
    required this.author,
    required this.description,
    required this.boughtDate,
    required this.price,
    required this.bookCount,
    required this.wishlisted,
    required this.postType,
    required this.postRating,
    required this.postedOn,
    this.pictures,
  });

  String id;
  String userId;
  String bookName;
  String author;
  String description;
  NepaliDateTime boughtDate;
  double price;
  int bookCount;
  bool wishlisted;
  String postType;
  String postRating;
  DateTime postedOn;

  List<dynamic>? pictures;
  // List<BookImage>? pictures;

  // List<String> imagesList (List<Map> maps)
  imagesList (List<Map> maps)
  {
    // List<String> images = 
    Iterable<dynamic> tempp =  maps.map((x) => x['image']);
        // .filter((x) => x) ;
        
  }

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        // id: json["id"] == null ? null : json["id"],
        id: json["id"].toString(),
        // userId: json["userId"] == null ? null : json["userId"],
        userId: json["userId"].toString(),
        bookName: json["book_name"] == null ? null : json["book_name"],
        author: json["author"] == null ? 'Unknown' : json["author"],
        description: json["description"] == null ? null : json["description"],
        // boughtDate: json["boughtDate"] == null
        //     ? null
        //     : DateTime.parse(json["boughtDate"]),
        boughtDate: NepaliDateTime.parse(json["bought_date"].toString()),
        // price: json["unit_price"] == null ? null : double.parse((json["unit_price"])),
        price: double.parse((json["unit_price"])),
        // bookCount: json["bookCount"] == null ? null : int.parse(json["bookCount"]),
        // bookCount: int.parse(json["bookCount"]),
        bookCount: json["book_count"],
        wishlisted: json["wishlisted"] == null ? null : json["wishlisted"],
        // wishlisted: json["wishlisted"] == '1' ? true : false,
        postType: json["post_type"] == null ? null : json["post_type"],
        // postRating: json["postRating"] == null ? '' : json["postRating"],
        postRating:
            json["post_rating"] == null ? '' : json["postRating"].toString(),
        pictures: json["images"] == null
            ? null
            // : List<XFile>.from(json["pictures"]),
            // : (List<dynamic>.from(json["pictures"])).isEmpty
            //     ? null
            : json["images"],
            // :json["images"].map((x)=> x['image']),
        // : ("${RemoteManager.POST_POOL}/$id$/${json['pictures'].toString()}"),
        // postedOn:
        //     json["postedOn"] == null ? null : DateTime.parse(json["postedOn"]),
        postedOn: NepaliDateTime.parse(json["posted_on"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "bookName": bookName,
        "author": author,
        "description": description,
        "boughtDate":
            "${boughtDate.year.toString().padLeft(4, '0')}-${boughtDate.month.toString().padLeft(2, '0')}-${boughtDate.day.toString().padLeft(2, '0')}",
        "price": price,
        "bookCount": bookCount,
        "wishlisted": wishlisted,
        "postType": postType,
        "postRating": postRating,
        "pictures": pictures == null
            ? null
            : List<dynamic>.from(pictures!.map((x) => x.path)),
        "postedOn": postedOn.toIso8601String(),
        // "id": id == null ? null : id,
        // "userId": userId == null ? null : userId,
        // "bookName": bookName == null ? null : bookName,
        // "author": author == null ? null : author,
        // "description": description == null ? null : description,
        // "boughtDate": boughtDate == null
        //     ? null
        //     : "${boughtDate.year.toString().padLeft(4, '0')}-${boughtDate.month.toString().padLeft(2, '0')}-${boughtDate.day.toString().padLeft(2, '0')}",
        // "price": price == null ? null : price,
        // "bookCount": bookCount == null ? null : bookCount,
        // "wishlisted": wishlisted == null ? null : wishlisted,
        // "postType": postType == null ? null : postType,
        // "postRating": postRating == null ? null : postRating,
        // "pictures": pictures == null
        //     ? null
        //     : List<dynamic>.from(pictures!.map((x) => x.path)),
        // "postedOn": postedOn == null ? null : postedOn.toIso8601String(),
      };
}

class BookImage{
  int id;
  String imageUrl;

  BookImage({required this.id, required this.imageUrl});

}

class BookError {
  int code;
  Object message;

  BookError({required this.code, required this.message});
}
