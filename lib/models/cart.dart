// import 'dart:convert';

// // import 'package:nepali_date_picker/nepali_date_picker.dart';

// List<Cart> cartFromJson(String str) =>
//     List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

// String cartToJson(List<Cart> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Cart {
//   Cart({
//     required this.id,
//     required this.bookId,
//     required this.sellingUserId,
//     required this.buyingUserId,
//     required this.bookCount,
//     required this.pricePerPiece,
//     // required this.totalPrice,
//     required this.wishlisted,
//     required this.postType,
//     // required this.postedOn,
//   });

//   String id;
//   String bookId;
//   // String postingUserId;
//   // String CartingUserId;
//   String sellingUserId;
//   String buyingUserId;
//   // int sellingUserId;
//   // int buyingUserId;
//   double pricePerPiece;
//   // double totalPrice;
//   int bookCount;
//   bool wishlisted;
//   String postType;
//   // DateTime postedOn;

//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//         // id: json["id"] == null ? null : json["id"],
//         id: json["id"].toString(),
//         // bookId: json["bookId"] == null ? null : json["bookId"],
//         bookId: json["bookId"].toString(),
//         // sellingUserId:
//         //     json["sellingUserId"] == null ? null : json["sellingUserId"],
//         // buyingUserId:
//         //     json["buyingUserId"] == null ? null : json["buyingUserId"],
//         sellingUserId: json["sellingUserId"].toString(),
//         buyingUserId: json["buyingUserId"].toString(),
//         // pricePerPiece:
//         //     json["pricePerPiece"] == null ? null : json["pricePerPiece"],
//         pricePerPiece: json["pricePerPiece"].toDouble(),
//         // pricePerPiece: json["pricePerPiece"] == null
//         //     ? null
//         //     : double.parse(json["pricePerPiece"]),

//         // boughtDate: json["boughtDate"] == null
//         //     ? null
//         //     : DateTime.parse(json["boughtDate"]),
//         // boughtDate: NepaliDateTime.parse(json["boughtDate"].toString()),
//         // totalPrice: json["price"] == null ? null : json["price"].toDouble(),
//         // bookCount: json["bookCount"] == null ? null : int.parse(json["bookCount"]),
//         bookCount: json["bookCount"],
//         // wishlisted: json["wishlisted"] == null ? null : json["wishlisted"],
//         wishlisted: json["wishlisted"] == '1' ? true : false,
//         postType: json["postType"] == null ? null : json["postType"],
//         // postedOn:
//         //     json["postedOn"] == null ? null : DateTime.parse(json["postedOn"]),
//         // postedOn: NepaliDateTime.parse(json["postedOn"].toString()),
//       );

//   Map<String, dynamic> toJson() => {
//         // "id": id == null ? null : id,
//         // "bookId": bookId == null ? null : bookId,
//         // "sellingUserId": sellingUserId == null ? null : sellingUserId,
//         // "buyingUserId": buyingUserId == null ? null : buyingUserId,
//         // "pricePerPiece": pricePerPiece == null ? null : pricePerPiece,
//         // "bookCount": bookCount == null ? null : bookCount,
//         // "wishlisted": wishlisted == null ? null : wishlisted,
//         // "postType": postType == null ? null : postType,
//         "id": id,
//         "bookId": bookId,
//         "sellingUserId": sellingUserId,
//         "buyingUserId": buyingUserId,
//         "pricePerPiece": pricePerPiece,
//         "bookCount": bookCount,
//         "wishlisted": wishlisted,
//         "postType": postType,
//       };
// }

// class CartError {
//   int code;
//   Object message;

//   CartError({required this.code, required this.message});
// }

// ------------------------------------------------------------------------------------------------

import 'dart:convert';

import 'package:share_learning/models/cart_item.dart';

// import 'package:nepali_date_picker/nepali_date_picker.dart';

// List<Cart> cartFromJson(String str) =>
// List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(List<Cart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  Cart({required this.id, required this.items, required this.totalPrice});

  String id;
  double totalPrice;
  List<CartItem>? items;

  // factory Cart.fromJson(dynamic json) => Cart(
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        items: json['items'] == null
            ? null
            : List<CartItem>.from(
                json["items"].map((x) => CartItem.fromJson(x))),
        totalPrice: double.parse(json["total_price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "total_price": totalPrice,
      };
}

class CartError {
  int code;
  Object message;

  CartError({required this.code, required this.message});
}
