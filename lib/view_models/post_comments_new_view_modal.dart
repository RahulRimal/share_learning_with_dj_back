import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../models/comment.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin PostCommentsNewViewModel on BaseViewModel {
  bool postCommentNewCommentEditted = false;

  User postCommentNewCommentUser = new User(
    id: '0',
    firstName: 'temp',
    lastName: 'Name',
    email: '',
    phone: null,
    image: null,
    username: 'temp',
    description: '',
    userClass: '',
    followers: '',
    createdDate: DateTime(2050),
  );

  late GlobalKey<FormState> form;

  late TextEditingController postCommentNewCommentController;

  late FocusNode postCommentNewCommentFocusNode;

  Comment postCommentNewEdittedComment = Comment(
    // id: '',
    id: 0,
    userId: 0,
    postId: 0,
    commentBody: '',
    createdDate: NepaliDateTime.now(),
  );

  bindPostCommentsNewViewSet(BuildContext context) {
    bindBaseViewModal(context);
    form = GlobalKey<FormState>();
    postCommentNewCommentController = new TextEditingController();
    postCommentNewCommentFocusNode = FocusNode();
    postCommentNewCommentUser = userProvider.user as User;
  }

  unBindPostCommentsNewViewSet(BuildContext context) {
    postCommentNewCommentFocusNode.dispose();
  }

  bool postCommentNewShouldFlexCommentUserName(String testString) {
    if (testString.length > 11) return true;
    return false;
  }

  Future<bool> postCommentNewAddPostComment() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    postCommentNewEdittedComment.postId =
        int.parse(bookProvider.postDetailsScreenSelectedBook.id);
    postCommentNewEdittedComment.userId =
        int.parse(postCommentNewCommentUser.id);

    postCommentNewCommentFocusNode.unfocus();
    postCommentNewCommentEditted = false;
    postCommentNewCommentController.text = '';
    if (await commentProvider.addComment(
        sessionProvider.session as Session, postCommentNewEdittedComment)) {
      AlertHelper.showToastAlert('Replied to the post');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }

  Future<bool> postCommentNewUpdatePostComment() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    postCommentNewCommentEditted = false;
    postCommentNewCommentFocusNode.unfocus();
    postCommentNewCommentController.text = '';

    if (await commentProvider.updateComment(
        sessionProvider.session as Session, postCommentNewEdittedComment)) {
      AlertHelper.showToastAlert('Reply updated successfully');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }

  Future<bool> postCommentNewDeletePostComment() async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    postCommentNewEdittedComment.postId =
        int.parse(bookProvider.postDetailsScreenSelectedBook.id);

    postCommentNewCommentEditted = false;
    postCommentNewCommentFocusNode.unfocus();
    postCommentNewCommentController.text = '';
    if (await commentProvider.deleteComment(
        sessionProvider.session as Session, postCommentNewEdittedComment)) {
      AlertHelper.showToastAlert('Your reply has been deleted');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }
}
