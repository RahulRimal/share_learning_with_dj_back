import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../models/comment.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin PostCommentsNewViewModel on BaseViewModel {
  bool commentEditted = false;

  User commentUser = new User(
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

  late TextEditingController commentController;

  late FocusNode commentFocusNode;

  Comment edittedComment = Comment(
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
    commentController = new TextEditingController();
    commentFocusNode = FocusNode();
    commentUser = userProvider.user as User;
  }

  unBindPostCommentsNewViewSet(BuildContext context) {
    commentFocusNode.dispose();
  }

  bool shouldFlexCommentUserName(String testString) {
    if (testString.length > 11) return true;
    return false;
  }

  Future<bool> addPostComment() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    edittedComment.postId = int.parse(bookProvider.selectedBook.id);
    edittedComment.userId = int.parse(commentUser.id);

    commentFocusNode.unfocus();
    commentEditted = false;
    commentController.text = '';
    if (await commentProvider.addComment(
        sessionProvider.session as Session, edittedComment)) {
      AlertHelper.showToastAlert('Replied to the post');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }

  Future<bool> updatePostComment() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    commentEditted = false;
    commentFocusNode.unfocus();
    commentController.text = '';

    if (await commentProvider.updateComment(
        sessionProvider.session as Session, edittedComment)) {
      AlertHelper.showToastAlert('Reply updated successfully');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }

  Future<bool> deletePostComment() async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    form.currentState!.save();

    edittedComment.postId = int.parse(bookProvider.selectedBook.id);

    commentEditted = false;
    commentFocusNode.unfocus();
    commentController.text = '';
    if (await commentProvider.deleteComment(
        sessionProvider.session as Session, edittedComment)) {
      AlertHelper.showToastAlert('Your reply has been deleted');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong');

    return false;
  }
}
