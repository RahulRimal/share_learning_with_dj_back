// ! Name is PostCategory instead of Category because it clash with the framework Category class

import 'dart:convert';

import 'package:share_learning/models/book.dart';

PostCategory categoryFromJson(String str) =>
    PostCategory.fromJson(json.decode(str));

List<PostCategory> categoriesFromJson(String str) => List<PostCategory>.from(
    json.decode(str).map((x) => PostCategory.fromJson(x)));

String categoryToJson(PostCategory data) => json.encode(data.toJson());

class PostCategory {
  PostCategory({
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
      other is PostCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          postsCount == other.postsCount &&
          featuredPost == other.featuredPost;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory PostCategory.fromJson(Map<String, dynamic> json) => PostCategory(
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
