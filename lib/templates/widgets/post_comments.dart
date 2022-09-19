import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/comment.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

class PostComments extends StatelessWidget {
  final Session loggedInUser;

  final Comments comments;
  final String bookId;

  PostComments(this.loggedInUser, this.comments, this.bookId);

  bool _shouldFlex(String testString) {
    if (testString.length > 11) return true;
    return false;
  }

  bool _commentEditted = false;

  User _commentUser = new User(
    id: '0',
    firstName: 'temp',
    lastName: 'Name',
    email: '',
    image: null,
    username: 'temp',
    description: '',
    userClass: '',
    followers: '',
    createdDate: DateTime(2050),
  );

  final _form = GlobalKey<FormState>();
  TextEditingController commentController = new TextEditingController();
  final _commentFocusNode = FocusNode();

  Comment _edittedComment = Comment(
    id: '',
    userId: '',
    postId: '',
    commentBody: '',
    createdDate: NepaliDateTime.now(),
  );

  bool _addComment(
      BuildContext context, Session loggedInUserSession, Comment comment) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    _edittedComment.postId = bookId;

    Provider.of<Comments>(context, listen: false)
        .addComment(loggedInUserSession, _edittedComment);

    Navigator.of(context).pop();

    BotToast.showSimpleNotification(
      title: 'Replied to the post',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );

    return true;
  }

  bool _updateComment(
      BuildContext context, Session loggedInUserSession, Comment comment) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    Provider.of<Comments>(context, listen: false)
        .updateComment(loggedInUserSession, _edittedComment);

    // Provider.of<Books>(context, listen: false)
    // .updatePost(_edittedBook.id, _edittedBook);
    //     .updatePost(loggedInUserSession, _edittedBook);
    Navigator.of(context).pop();

    BotToast.showSimpleNotification(
      title: 'Reply updated successfully',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );

    return true;
  }

  bool _deleteComment(
      BuildContext context, Session loggedInUserSession, Comment comment) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    _edittedComment.postId = bookId;

    Provider.of<Comments>(context, listen: false)
        .deleteComment(loggedInUserSession, _edittedComment);

    Navigator.of(context).pop();

    BotToast.showSimpleNotification(
      title: 'Your reply has been deleted',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );

    return true;
  }

  // void _showUpdateSnackbar(BuildContext context) {
  //   final snackBar = SnackBar(
  //     content: Text(
  //       'Reply Updated Successfully',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 13,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    Users users = context.watch<Users>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            child: FutureBuilder(
              future: comments.getPostComments(bookId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data please restart the app'),
                      // child: Text(snapshot.error.toString()),
                    );
                  } else {
                    if (comments.comments.isEmpty)
                      return Container(
                        child: Text(
                          'No Comments Yet',
                          style: getBoldStyle(
                              fontSize: FontSize.s17, color: Colors.black),
                        ),
                      );
                    return ListView.builder(
                      itemCount: comments.comments.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FutureBuilder(
                                future: users.getUserByIdAndSession(
                                    loggedInUser,
                                    comments.comments[index].userId),
                                builder: (ctx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: ColorManager.primary,
                                      ),
                                    );
                                  } else {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error'),
                                      );
                                    } else if (snapshot.hasData) {
                                      _commentUser = snapshot.data as User;
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // _commentUser = snapshot.data as User;
                                                      if (Provider.of<Books>(
                                                        context,
                                                        listen: false,
                                                      ).hasPostByUser(
                                                          _commentUser.id)) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                          UserPostsScreen
                                                              .routeName,
                                                          arguments: {
                                                            'uId':
                                                                _commentUser.id,
                                                            'loggedInUserSession':
                                                                loggedInUser,
                                                          },
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        final snackBar =
                                                            SnackBar(
                                                          content: Text(
                                                            'No posts by ${_commentUser.firstName}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // action: SnackBarAction(
                                                          //   label: 'Close',
                                                          //   textColor: Theme.of(context).primaryColor,
                                                          //   onPressed: () => print('Pressed'),
                                                          // ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      }
                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                            UserHelper
                                                                .userProfileImage(
                                                                    _commentUser),
                                                          ),
                                                        ),
                                                        _shouldFlex(
                                                                '${_commentUser.firstName}')
                                                            ? Flexible(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                    UserHelper
                                                                        .userDisplayName(
                                                                            _commentUser),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                width: 100,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Text(
                                                                  // '${_commentUser.firstName}',
                                                                  UserHelper
                                                                      .userDisplayName(
                                                                          _commentUser),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 5,
                                                          bottom: 20,
                                                        ),
                                                        child: Text(
                                                          comments
                                                              .comments[index]
                                                              .commentBody,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _commentUser.id ==
                                                    loggedInUser.userId
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          _commentEditted =
                                                              true;

                                                          _edittedComment =
                                                              comments.comments[
                                                                  index];

                                                          commentController
                                                                  .text =
                                                              comments
                                                                  .comments[
                                                                      index]
                                                                  .commentBody;

                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  _commentFocusNode);
                                                        },
                                                        icon: Icon(Icons.edit),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          _edittedComment =
                                                              comments.comments[
                                                                  index];
                                                          _deleteComment(
                                                              context,
                                                              loggedInUser,
                                                              _edittedComment);
                                                        },
                                                        icon:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Text('No data'),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          // Add your comment starts here !!

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Your Comment',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Form(
                      key: _form,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            focusNode: _commentFocusNode,
                            controller: commentController,
                            cursorColor: Theme.of(context).primaryColor,
                            onSaved: (value) {
                              _edittedComment.commentBody = value.toString();
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _commentEditted == true
                                      ? _updateComment(context, loggedInUser,
                                          _edittedComment)
                                      : _addComment(context, loggedInUser,
                                          _edittedComment);
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add your comment ends here !!
        ],
      ),
    );
  }
}
