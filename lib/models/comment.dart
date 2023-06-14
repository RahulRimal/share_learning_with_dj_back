

import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

List<Comment> commentsFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.commentBody,
    required this.createdDate,
  });

  // String id;
  // String userId;
  // String postId;
  int id;
  int userId;
  int postId;
  String commentBody;
  NepaliDateTime createdDate;

  // factory Comment.fromJson(Map<String, dynamic> json) => Comment(
  factory Comment.fromJson(dynamic json) => Comment(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        postId: json["post_id"] == null ? null : json["post_id"],
        commentBody: json["comment_body"] == null ? null : json["comment_body"],
        createdDate: NepaliDateTime.parse(json["created_date"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "postId": postId,
        "commentBody": commentBody,
        "createdDate": createdDate.toIso8601String(),
        // "boughtDate": boughtDate == null
        //     ? null
        //     : "${boughtDate.year.toString().padLeft(4, '0')}-${boughtDate.month.toString().padLeft(2, '0')}-${boughtDate.day.toString().padLeft(2, '0')}",

        // "id": id == null ? null : id,
        // "userId": userId == null ? null : userId,
        // "postId": postId == null ? null : postId,
        // "commentBody": commentBody == null ? null : commentBody,
        // "createdDate":
        //     createdDate == null ? null : createdDate.toIso8601String(),

        // // "boughtDate": boughtDate == null
        // //     ? null
        // //     : "${boughtDate.year.toString().padLeft(4, '0')}-${boughtDate.month.toString().padLeft(2, '0')}-${boughtDate.day.toString().padLeft(2, '0')}",
      };
}

class CommentError {
  int code;
  Object message;

  CommentError({required this.code, required this.message});
}
