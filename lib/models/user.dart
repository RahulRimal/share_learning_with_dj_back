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
  String? firstName;
  String? lastName;
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

  DateTime? createdDate;

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
        createdDate: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        // createdDate: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName.toString(),
        "last_name": lastName.toString(),
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "description": description == null ? null : description,
        "user_class": userClass == null ? null : userClass,
        // "followers": followers == null ? null : followers,
        "created_at":
            createdDate == null ? null : createdDate!.toIso8601String(),
      };
  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName.toString(),
        "last_name": lastName.toString(),
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "description": description == null ? null : description,
        "user_class": userClass == null ? null : userClass,
        "followers": followers == null ? null : followers,
        "created_at":
            createdDate == null ? null : createdDate!.toIso8601String(),
      };

  factory User.withProperty(User user, Map<String, dynamic> property) {
    return User(
      id: user.id,
      firstName: property["firstName"] == null
          ? user.firstName
          : property["firstName"],
      lastName:
          property["lastName"] == null ? user.lastName : property["lastName"],
      username:
          property["username"] == null ? user.username : property["username"],
      email: property["email"] == null ? user.email : property["email"],
      phone: property["phone"] == null ? user.phone : property["phone"],
      image: property["image"] == null ? user.image : property["image"],
      description: property["description"] == null
          ? user.description
          : property["description"],
      userClass: property["userClass"] == null
          ? user.userClass
          : property["userClass"],
      followers: property["followers"] == null
          ? user.followers
          : property["followers"],
      createdDate: property["createdDate"] == null
          ? user.createdDate
          : DateTime.parse(property["createdDate"]),
    );
  }
}

class UserError {
  int code;
  Object message;

  UserError({required this.code, required this.message});
}
