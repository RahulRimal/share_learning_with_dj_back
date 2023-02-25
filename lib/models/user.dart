// class User {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String userName;
//   final String password;
//   final String image;

//   User({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.userName,
//     required this.password,
//     required this.image,
//   });
// }

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:share_learning/templates/managers/api_values_manager.dart';

// import 'dart:io';

// List<User> userFromJson(String str) =>
//     List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.username,
      required this.email,
      required this.phone,
      required this.description,
      required this.userClass,
      required this.followers,
      required this.createdDate,
      required this.image});

  String id;
  String firstName;
  String lastName;
  // String username;
  String? username;
  // String email;
  String? email;
  String? phone;
  // String description;
  String? description;

  String? image;
  // File? image;
  // String userClass;
  String? userClass;
  // String followers;
  String? followers;

  DateTime createdDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        // id: json["id"] == null ? null : json["id"],
        id: json["id"].toString(),
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        // image: json["image"] == null ? null : RemoteManager.BASE_URI + json["image"],
        image: json["image"] == null ? null : json["image"],
        description: json["description"] == null ? null : json["description"],
        userClass: json["user_class"] == null ? null : json["user_class"],
        followers: json["followers"] == null ? null : json["followers"],
        // createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        createdDate: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": firstName + lastName,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "description": description == null ? null : description,
        "class": userClass == null ? null : userClass,
        "followers": followers == null ? null : followers,
        "createdDate": createdDate.toIso8601String(),

        // "id": id == null ? null : id,
        // "name": (firstName == null && lastName == null)
        //     ? null
        //     : firstName + lastName,
        // "username": username == null ? null : username,
        // "email": email == null ? null : email,
        // "description": description == null ? null : description,
        // "class": userClass == null ? null : userClass,
        // "followers": followers == null ? null : followers,
        // "createdDate":
        //     createdDate == null ? null : createdDate.toIso8601String(),
      };
}

class UserError {
  int code;
  Object message;

  UserError({required this.code, required this.message});
}
