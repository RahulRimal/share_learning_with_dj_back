// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistsFromJson(String str) =>
    List<Wishlist>.from(json.decode(str).map((x) {
      Wishlist wishlist = Wishlist.fromJson(x);

      return wishlist;
    }));

Wishlist wishlistFromJson(String str) => Wishlist.fromJson(json.decode(str));

String wishlistToJson(Wishlist data) => json.encode(data.toJson());

class Wishlist {
  Wishlist({
    required this.id,
    required this.post,
    required this.user,
    required this.wishlistedDate,
  });

  int id;
  int post;
  int user;
  DateTime wishlistedDate;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json["id"],
        post: json["post"],
        user: json["user"],
        wishlistedDate: DateTime.parse(json["wishlisted_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post": post,
        "user": user,
        "wishlisted_date": wishlistedDate.toIso8601String(),
      };
}

class WishlistError {
  int code;
  Object message;

  WishlistError({required this.code, required this.message});
}
