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
//   List<String>? images;

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
//     this.images,
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

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

List<Book> booksFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) {
      Book book = Book.fromJson(x);

      // if (book.images != null) {
      //   book.images = book.images!.map((e) {
      //     return "${RemoteManager.POST_POOL}/${book.id}/$e";
      //   }).toList();
      // }

      return book;
    }));

String booksToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    required this.id,
    required this.userId,
    required this.bookName,
    required this.author,
    required this.description,
    required this.category,
    required this.boughtDate,
    required this.price,
    required this.bookCount,
    required this.wishlisted,
    required this.postType,
    required this.postRating,
    required this.postedOn,
    this.images,
  });

  String id;
  String userId;
  String bookName;
  String author;
  String description;
  BookCategory? category;
  NepaliDateTime boughtDate;
  double price;
  int bookCount;
  bool wishlisted;
  String postType;
  double postRating;
  DateTime postedOn;

  List<dynamic>? images;
  // List<BookImage>? images;

  // imagesList(List<Map> maps) {
  //   Iterable<dynamic> tempp = maps.map((x) => x['image']);
  // }

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        // id: json["id"] == null ? null : json["id"],
        id: json["id"].toString(),
        // userId: json["userId"] == null ? null : json["userId"],
        userId: json["user"]["id"].toString(),
        // userId: json["userId"].toString(),
        bookName: json["book_name"] == null ? null : json["book_name"],
        author: json["author"] == null ? 'Unknown' : json["author"],
        category: json["category"] == null? null : BookCategory.fromJson(json["category"]),
        
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
        postRating: json["post_rating"] == null ? 0.0 : json["post_rating"],
        // images: json["images"] == null
        //     ? null
        //     : json["images"],
        images: json["images"] == null
            ? null
            : List<BookImage>.from(
                json["images"].map((x) => BookImage.fromJson(x))),

        postedOn: NepaliDateTime.parse(json["posted_on"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "bookName": bookName,
        "author": author,
        "category": category,
        "description": description,
        "boughtDate":
            "${boughtDate.year.toString().padLeft(4, '0')}-${boughtDate.month.toString().padLeft(2, '0')}-${boughtDate.day.toString().padLeft(2, '0')}",
        "price": price,
        "bookCount": bookCount,
        "wishlisted": wishlisted,
        "postType": postType,
        "postRating": postRating,
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.image)),
        "postedOn": postedOn.toIso8601String(),
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookName': bookName,
      'author': author,
      'description': description,
      'boughtDate': boughtDate,
      'price': price,
      'bookCount': bookCount,
      'wishlisted': wishlisted,
      'postType': postType,
      'postRating': postRating,
      'images': images,
      'postedOn': postedOn
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        id: map['id'],
        userId: map['userId'],
        bookName: map['bookName'],
        author: map['author'],
        category: map['category'],
        description: map['description'],
        boughtDate: map['boughtDate'],
        price: map['price'],
        bookCount: map['bookCount'],
        wishlisted: map['wishlisted'],
        postType: map['postType'],
        postRating: map['postRating'],
        images: map['images'],
        postedOn: map['postedOn']);
  }

  
  factory Book.withPoperty(Book book, Map<String, dynamic> property) {
    return Book(
        id: book.id,
        userId: property['userId'] == null ? book.userId : property['userId'],
        bookName: property['bookName'] == null ? book.bookName : property['bookName'],
        author: property['author'] == null? book.author : property['author'],
        category: property['category'] == null? book.category : property['category'],
        description: property['description'] == null? book.description : property['description'],
        boughtDate: property['boughtDate'] == null? book.boughtDate : property['boughtDate'],
        price: property['price'] == null? book.price : property['price'],
        bookCount: property['bookCount'] == null? book.bookCount : property['bookCount'],
        wishlisted: property['wishlisted'] == null? book.wishlisted : property['wishlisted'],
        postType: property['postType'] == null? book.postType : property['postType'],
        postRating: property['postRating'] == null? book.postRating : property['postRating'],
        images: property['images'] == null? book.images : property['images'],
        postedOn: property['postedOn'] == null? book.postedOn : property['postedOn'],);
    
  }

}

class BookImage {
  int? id;
  String image;

  BookImage({required this.id, required this.image});

  factory BookImage.fromJson(Map<String, dynamic> json) => BookImage(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class BookCategory{
  int id;
  String name;

  BookCategory({required this.id, required this.name});

  factory BookCategory.fromJson(Map<String, dynamic>json ) =>
  BookCategory(id: json['id'], name: json['name'],);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

}

class BookError {
  int code;
  Object message;

  BookError({required this.code, required this.message});
}
