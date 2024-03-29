import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/comment_provider.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

import '../../models/comment.dart';
import '../managers/routes_manager.dart';
import '../utils/alert_helper.dart';

class PostComments extends StatefulWidget {
  final Session loggedInSession;
  final User loggedInUser;

  // final Comments comments;
  final String bookId;

  // PostComments(this.loggedInUser, this.comments, this.bookId);
  PostComments(this.loggedInSession, this.loggedInUser, this.bookId);

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
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
    phone: null,
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
    // id: '',
    id: 0,
    userId: 0,
    postId: 0,
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

    _edittedComment.postId = int.parse(widget.bookId);
    _edittedComment.userId = int.parse(_commentUser.id);

    Provider.of<CommentProvider>(context, listen: false)
        .addComment(loggedInUserSession, _edittedComment);

    // Navigator.of(context, rootNavigator: true).pop();
    _commentFocusNode.unfocus();
    AlertHelper.showToastAlert('Replied to the post');

    return true;
  }

  bool _updateComment(
      BuildContext context, Session loggedInUserSession, Comment comment) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    Provider.of<CommentProvider>(context, listen: false)
        .updateComment(loggedInUserSession, _edittedComment);

    // Navigator.of(context, rootNavigator: true).pop();
    _commentFocusNode.unfocus();
    AlertHelper.showToastAlert('Reply updated successfully');

    return true;
  }

  bool _deleteComment(
      BuildContext context, Session loggedInUserSession, Comment comment) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    _edittedComment.postId = int.parse(widget.bookId);

    Provider.of<CommentProvider>(context, listen: false)
        .deleteComment(loggedInUserSession, _edittedComment);

    // Navigator.of(context, rootNavigator: true).pop();
    setState(() {});
    AlertHelper.showToastAlert('Your reply has been deleted');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider users = context.watch<UserProvider>();
    // Users users = Provider.of<Users>(context, listen: false);

    CommentProvider comments = context.watch<CommentProvider>();

    if (users.user != null) {
      _commentUser = users.user!;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            // height: 200,
            child: FutureBuilder(
              future: comments.getPostComments(
                  widget.bookId, widget.loggedInSession),
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
                                future: users.getCommentUser(
                                    comments.comments[index].userId.toString()),
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

                                      User _currentUser;
                                      if (users.user != null) {
                                        _currentUser = users.user as User;
                                      } else {
                                        _currentUser = widget.loggedInUser;
                                      }
                                      _edittedComment.userId =
                                          int.parse(_currentUser.id);
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
                                                      if (Provider.of<
                                                          BookProvider>(
                                                        context,
                                                        listen: false,
                                                      ).hasPostByUser(
                                                          _commentUser.id)) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                          RoutesManager
                                                              .userPostsScreenRoute,
                                                          arguments: {
                                                            'uId':
                                                                _commentUser.id,
                                                            'loggedInUserSession':
                                                                widget
                                                                    .loggedInSession,
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
                                            // _commentUser.id ==
                                            //         loggedInUser.userId
                                            _commentUser.id == _currentUser.id
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
                                                              widget
                                                                  .loggedInSession,
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
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Container();
                                    } else {
                                      // print(snapshot);
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
                                      ? _updateComment(
                                          context,
                                          widget.loggedInSession,
                                          _edittedComment)
                                      : _addComment(
                                          context,
                                          widget.loggedInSession,
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
