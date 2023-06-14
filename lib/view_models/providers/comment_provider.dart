import 'package:flutter/material.dart';

import 'package:share_learning/data/comment_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import '../../models/comment.dart';
import '../base_view_model.dart';
import '../post_comments_new_view_modal.dart';

class CommentProvider
    with ChangeNotifier, BaseViewModel, PostCommentsNewViewModel {
  List<Comment> _comments = [];

  bool _loading = false;

  CommentError? _commentError;

  List<Comment> get comments {
    return [..._comments];
  }

  bool get loading => _loading;

  CommentError? get commentError => _commentError;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setComments(List<Comment> comments) {
    _comments = comments;
  }

  setCommentError(CommentError commentError) {
    _commentError = commentError;
  }

  Future<List<Comment>> getComments(String postId) async {
    return comments
        .where((comment) => comment.postId == int.parse(postId))
        .toList();
  }

  getPostComments(String postId, Session loggedInUser) async {
    setLoading(true);

    // setComments([]);

    var response = await CommentApi.getPostComments(postId, loggedInUser);

    if (response is Success) {
      setComments(response.response as List<Comment>);
    }
    if (response is Failure) {
      CommentError commentError = CommentError(
        code: response.code,
        message: response.errorResponse,
      );
      setCommentError(commentError);
    }
    setLoading(false);
  }

  Future<bool> addComment(
      Session currentSession, Comment edittedComment) async {
    var response = await CommentApi.addComment(currentSession, edittedComment);

    if (response is Success) {
      _comments.add(response.response as Comment);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateComment(
      Session currentSession, Comment edittedComment) async {
    var response =
        await CommentApi.updateComment(currentSession, edittedComment);

    if (response is Success) {
      final postIndex =
          _comments.indexWhere((element) => element.id == edittedComment.id);

      _comments[postIndex] = edittedComment;
      notifyListeners();

      return true;
    }

    return false;
  }

  Future<bool> deleteComment(
      Session currentSession, Comment edittedComment) async {
    var response =
        await CommentApi.deleteComment(currentSession, edittedComment);

    if (response is Success) {
      final postIndex =
          _comments.indexWhere((element) => element.id == edittedComment.id);

      _comments.removeAt(postIndex);
      notifyListeners();
      return true;
    }

    return false;
  }

  // ================================== Implementations for the output of PostNewWidget functions ends from here ===================================

  // @override
  // Future<bool> deletePostComment() async {
  //   bool value = await super.deletePostComment();
  //   notifyListeners();
  //   return value;
  // }

  // ================================== Implementations for the output of BillingInfoWidgetViewModel functions starts from here ===================================
}
