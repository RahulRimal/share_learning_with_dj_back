// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:share_learning/models/book.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

List<Category> categoriesFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.id,
    required this.name,
    required this.postsCount,
    this.featuredPost,
  });

  int id;
  String name;
  int postsCount;
  Book? featuredPost;

  // These two overrides are used because list.remove() was not working properly for category class

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          postsCount == other.postsCount &&
          featuredPost == other.featuredPost;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        postsCount: json["posts_count"],
        featuredPost: json["featured_post"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "posts_count": postsCount,
        "featured_post": featuredPost,
      };
}

class CategoryError {
  int code;
  Object message;

  CategoryError({required this.code, required this.message});
}
