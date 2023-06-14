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
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

import '../../models/comment.dart';

// class PostCommentsNew extends StatelessWidget {
//   final Session loggedInSession;
//   final User loggedInUser;
//   // final Comments comments;
//   final String bookId;
//   // PostComments(this.loggedInUser, this.comments, this.bookId);
//   PostCommentsNew(this.loggedInSession, this.loggedInUser, this.bookId);
//   bool _shouldFlex(String testString) {
//     if (testString.length > 11) return true;
//     return false;
//   }
//   bool _commentEditted = false;
//   User _commentUser = new User(
//     id: '0',
//     firstName: 'temp',
//     lastName: 'Name',
//     email: '',
//     phone: null,
//     image: null,
//     username: 'temp',
//     description: '',
//     userClass: '',
//     followers: '',
//     createdDate: DateTime(2050),
//   );
//   final _form = GlobalKey<FormState>();
//   TextEditingController commentController = new TextEditingController();
//   final _commentFocusNode = FocusNode();
//   Comment _edittedComment = Comment(
//     // id: '',
//     id: 0,
//     userId: 0,
//     postId: 0,
//     commentBody: '',
//     createdDate: NepaliDateTime.now(),
//   );
//   bool _addComment(
//       BuildContext context, Session loggedInUserSession, Comment comment) {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return false;
//     }
//     _form.currentState!.save();
//     _edittedComment.postId = int.parse(bookId);
//     _edittedComment.userId = int.parse(_commentUser.id);
//     Provider.of<Comments>(context, listen: false)
//         .addComment(loggedInUserSession, _edittedComment);
//     // Navigator.of(context, rootNavigator: true).pop();
//     commentController.text = '';
//     _commentFocusNode.unfocus();
//     BotToast.showSimpleNotification(
//       title: 'Replied to the post',
//       duration: Duration(seconds: 3),
//       backgroundColor: ColorManager.primary,
//       titleStyle: getBoldStyle(color: ColorManager.white),
//       align: Alignment(1, 1),
//     );
//     return true;
//   }
//   bool _updateComment(
//       BuildContext context, Session loggedInUserSession, Comment comment) {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return false;
//     }
//     _form.currentState!.save();
//     Provider.of<Comments>(context, listen: false)
//         .updateComment(loggedInUserSession, _edittedComment);
//     // Navigator.of(context, rootNavigator: true).pop();
//     BotToast.showSimpleNotification(
//       title: 'Reply updated successfully',
//       duration: Duration(seconds: 3),
//       backgroundColor: ColorManager.primary,
//       titleStyle: getBoldStyle(color: ColorManager.white),
//       align: Alignment(1, 1),
//     );
//     return true;
//   }
//   bool _deleteComment(
//       BuildContext context, Session loggedInUserSession, Comment comment) {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return false;
//     }
//     _form.currentState!.save();
//     _edittedComment.postId = int.parse(bookId);
//     Provider.of<Comments>(context, listen: false)
//         .deleteComment(loggedInUserSession, _edittedComment);
//     // Navigator.of(context, rootNavigator: true).pop();
//     // setState(() {
//     //   // This setState is here to rebuild the widgets so the deleted comment gets removed from the screen.
//     // });
//     BotToast.showSimpleNotification(
//       title: 'Your reply has been deleted',
//       duration: Duration(seconds: 3),
//       backgroundColor: ColorManager.primary,
//       titleStyle: getBoldStyle(color: ColorManager.white),
//       align: Alignment(1, 1),
//     );
//     return true;
//   }
//   @override
//   Widget build(BuildContext context) {
//     Users users = context.watch<Users>();
//     // Users users = Provider.of<Users>(context, listen: false);
//     Comments comments = context.watch<Comments>();
//     if (users.user != null) {
//       _commentUser = users.user!;
//     }
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             constraints: BoxConstraints(
//               maxHeight: 200,
//             ),
//             // height: 200,
//             child: FutureBuilder(
//               future: comments.getPostComments(bookId, loggedInSession),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: ColorManager.primary,
//                     ),
//                   );
//                 } else {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error fetching data please restart the app'),
//                       // child: Text(snapshot.error.toString()),
//                     );
//                   } else {
//                     if (comments.comments.isEmpty)
//                       return Container(
//                         child: Text(
//                           'No Comments Yet',
//                           style: getBoldStyle(
//                               fontSize: FontSize.s17, color: Colors.black),
//                         ),
//                       );
//                     return ListView.builder(
//                       itemCount: comments.comments.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               FutureBuilder(
//                                 future: users.getCommentUser(
//                                     comments.comments[index].userId.toString()),
//                                 builder: (ctx, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                       child: CircularProgressIndicator(
//                                         color: ColorManager.primary,
//                                       ),
//                                     );
//                                   } else {
//                                     if (snapshot.hasError) {
//                                       return Center(
//                                         child: Text('Error'),
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       _commentUser = snapshot.data as User;
//                                       User _currentUser;
//                                       if (users.user != null) {
//                                         _currentUser = users.user as User;
//                                       } else {
//                                         _currentUser = loggedInUser;
//                                       }
//                                       _edittedComment.userId =
//                                           int.parse(_currentUser.id);
//                                       return Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           color: Colors.white,
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Flexible(
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       // _commentUser = snapshot.data as User;
//                                                       if (Provider.of<Books>(
//                                                         context,
//                                                         listen: false,
//                                                       ).hasPostByUser(
//                                                           _commentUser.id)) {
//                                                         Navigator.of(context)
//                                                             .pushNamed(
//                                                           UserPostsScreen
//                                                               .routeName,
//                                                           arguments: {
//                                                             'uId':
//                                                                 _commentUser.id,
//                                                             'loggedInUserSession':
//                                                                 loggedInSession,
//                                                           },
//                                                         );
//                                                       } else {
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .hideCurrentSnackBar();
//                                                         final snackBar =
//                                                             SnackBar(
//                                                           content: Text(
//                                                             'No posts by ${_commentUser.firstName}',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                             ),
//                                                           ),
//                                                           // action: SnackBarAction(
//                                                           //   label: 'Close',
//                                                           //   textColor: Theme.of(context).primaryColor,
//                                                           //   onPressed: () => print('Pressed'),
//                                                           // ),
//                                                         );
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                                 snackBar);
//                                                       }
//                                                     },
//                                                     child: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         CircleAvatar(
//                                                           backgroundImage:
//                                                               NetworkImage(
//                                                             UserHelper
//                                                                 .userProfileImage(
//                                                                     _commentUser),
//                                                           ),
//                                                         ),
//                                                         _shouldFlex(
//                                                                 '${_commentUser.firstName}')
//                                                             ? Flexible(
//                                                                 child:
//                                                                     Container(
//                                                                   width: 100,
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .all(
//                                                                               10),
//                                                                   child: Text(
//                                                                     UserHelper
//                                                                         .userDisplayName(
//                                                                             _commentUser),
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w600,
//                                                                       fontStyle:
//                                                                           FontStyle
//                                                                               .italic,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             : Container(
//                                                                 width: 100,
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(
//                                                                             10),
//                                                                 child: Text(
//                                                                   // '${_commentUser.firstName}',
//                                                                   UserHelper
//                                                                       .userDisplayName(
//                                                                           _commentUser),
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     fontStyle:
//                                                                         FontStyle
//                                                                             .italic,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     child: Flexible(
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                           top: 5,
//                                                           bottom: 20,
//                                                         ),
//                                                         child: Text(
//                                                           comments
//                                                               .comments[index]
//                                                               .commentBody,
//                                                           textAlign:
//                                                               TextAlign.left,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             // _commentUser.id ==
//                                             //         loggedInUser.userId
//                                             _commentUser.id == _currentUser.id
//                                                 ? Row(
//                                                     children: [
//                                                       IconButton(
//                                                         onPressed: () {
//                                                           _commentEditted =
//                                                               true;
//                                                           _edittedComment =
//                                                               comments.comments[
//                                                                   index];
//                                                           commentController
//                                                                   .text =
//                                                               comments
//                                                                   .comments[
//                                                                       index]
//                                                                   .commentBody;
//                                                           FocusScope.of(context)
//                                                               .requestFocus(
//                                                                   _commentFocusNode);
//                                                         },
//                                                         icon: Icon(Icons.edit),
//                                                       ),
//                                                       IconButton(
//                                                         onPressed: () {
//                                                           _edittedComment =
//                                                               comments.comments[
//                                                                   index];
//                                                           _deleteComment(
//                                                               context,
//                                                               loggedInSession,
//                                                               _edittedComment);
//                                                         },
//                                                         icon:
//                                                             Icon(Icons.delete),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 : Container(),
//                                           ],
//                                         ),
//                                       );
//                                     } else if (snapshot.connectionState ==
//                                         ConnectionState.done) {
//                                       return Container();
//                                     } else {
//                                       // print(snapshot);
//                                       return Container(
//                                         child: Text('No data'),
//                                       );
//                                     }
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 }
//               },
//             ),
//           ),
//           // Add your comment starts here !!
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 5,
//               vertical: 15,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Add Your Comment',
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Form(
//                       key: _form,
//                       child: Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: TextFormField(
//                             focusNode: _commentFocusNode,
//                             controller: commentController,
//                             cursorColor: Theme.of(context).primaryColor,
//                             onSaved: (value) {
//                               _edittedComment.commentBody = value.toString();
//                             },
//                             decoration: InputDecoration(
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   _commentEditted == true
//                                       ? _updateComment(context, loggedInSession,
//                                           _edittedComment)
//                                       : _addComment(context, loggedInSession,
//                                           _edittedComment);
//                                 },
//                                 icon: Icon(
//                                   Icons.send,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Add your comment ends here !!
//         ],
//       ),
//     );
//   }
// }

class PostCommentsNew extends StatefulWidget {
  const PostCommentsNew({Key? key}) : super(key: key);

  @override
  State<PostCommentsNew> createState() => _PostCommentsNewState();
}

class _PostCommentsNewState extends State<PostCommentsNew>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    CommentProvider commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    commentProvider.bindPostCommentsNewViewSet(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentProvider.getPostComments(
          commentProvider.bookProvider.selectedBook.id,
          commentProvider.sessionProvider.session as Session);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Provider.of<CommentProvider>(context, listen: false)
    //     .unBindPostCommentsNewViewSet(context);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    CommentProvider _commentProvider = context.watch<CommentProvider>();
    return _commentProvider.loading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _commentProvider.commentError != null
            ? Center(
                child: Text('Error'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                      ),
                      // child: FutureBuilder(
                      //   future: _commentProvider.getPostComments(
                      //       _commentProvider.bookProvider.selectedBook.id , _commentProvider.sessionProvider.session as Session),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Center(
                      //         child: CircularProgressIndicator(
                      //           color: ColorManager.primary,
                      //         ),
                      //       );
                      //     } else {
                      //       if (snapshot.hasError) {
                      //         return Center(
                      //           child: Text('Error fetching data please restart the app'),
                      //           // child: Text(snapshot.error.toString()),
                      //         );
                      //       } else {
                      //         if (_commentProvider.comments.isEmpty)
                      //           return Container(
                      //             child: Text(
                      //               'No Comments Yet',
                      //               style: getBoldStyle(
                      //                   fontSize: FontSize.s17, color: Colors.black),
                      //             ),
                      //           );
                      //         return ListView.builder(
                      //           itemCount: _commentProvider.comments.length,
                      //           itemBuilder: (context, index) {
                      //             return Container(
                      //               padding: EdgeInsets.all(10),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.grey[100],
                      //               ),
                      //               child: Column(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   FutureBuilder(
                      //                     future: _commentProvider.userProvider.getCommentUser(
                      //                         _commentProvider.comments[index].userId.toString()),
                      //                     builder: (ctx, snapshot) {
                      //                       if (snapshot.connectionState ==
                      //                           ConnectionState.waiting) {
                      //                         return Center(
                      //                           child: CircularProgressIndicator(
                      //                             color: ColorManager.primary,
                      //                           ),
                      //                         );
                      //                       } else {
                      //                         if (snapshot.hasError) {
                      //                           return Center(
                      //                             child: Text('Error'),
                      //                           );
                      //                         } else if (snapshot.hasData) {
                      //                           _commentProvider.commentUser = snapshot.data as User;
                      //                           User _currentUser;
                      //                           if (_commentProvider.userProvider.user != null) {
                      //                             _currentUser = _commentProvider.userProvider.user as User;
                      //                           } else {
                      //                             _currentUser = _commentProvider.userProvider.user as User;
                      //                           }
                      //                           _commentProvider.edittedComment.userId =
                      //                               int.parse(_currentUser.id);
                      //                           return Container(
                      //                             decoration: BoxDecoration(
                      //                               borderRadius:
                      //                                   BorderRadius.circular(20),
                      //                               color: Colors.white,
                      //                             ),
                      //                             child: Row(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment.spaceBetween,
                      //                               children: [
                      //                                 Flexible(
                      //                                   child: Row(
                      //                                     mainAxisAlignment:
                      //                                         MainAxisAlignment.start,
                      //                                     children: [
                      //                                       GestureDetector(
                      //                                         onTap: () {
                      //                                           // _commentUser = snapshot.data as User;
                      //                                           if (Provider.of<
                      //                                               BookProvider>(
                      //                                             context,
                      //                                             listen: false,
                      //                                           ).hasPostByUser(
                      //                                               _commentProvider.commentUser.id)) {
                      //                                             Navigator.of(context)
                      //                                                 .pushNamed(
                      //                                               UserPostsScreen
                      //                                                   .routeName,
                      //                                               arguments: {
                      //                                                 'userId':
                      //                                                     _commentProvider.commentUser.id,
                      //                                               },
                      //                                             );
                      //                                           } else {
                      //                                             ScaffoldMessenger.of(
                      //                                                     context)
                      //                                                 .hideCurrentSnackBar();
                      //                                             final snackBar =
                      //                                                 SnackBar(
                      //                                               content: Text(
                      //                                                 'No posts by ${_commentProvider.commentUser.firstName}',
                      //                                                 textAlign: TextAlign
                      //                                                     .center,
                      //                                                 style: TextStyle(
                      //                                                   fontSize: 13,
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .bold,
                      //                                                 ),
                      //                                               ),
                      //                                               // action: SnackBarAction(
                      //                                               //   label: 'Close',
                      //                                               //   textColor: Theme.of(context).primaryColor,
                      //                                               //   onPressed: () => print('Pressed'),
                      //                                               // ),
                      //                                             );
                      //                                             ScaffoldMessenger.of(
                      //                                                     context)
                      //                                                 .showSnackBar(
                      //                                                     snackBar);
                      //                                           }
                      //                                         },
                      //                                         child: Column(
                      //                                           mainAxisSize:
                      //                                               MainAxisSize.min,
                      //                                           children: [
                      //                                             CircleAvatar(
                      //                                               backgroundImage:
                      //                                                   NetworkImage(
                      //                                                 UserHelper
                      //                                                     .userProfileImage(
                      //                                                         _commentProvider.commentUser),
                      //                                               ),
                      //                                             ),
                      //                                             _commentProvider.shouldFlexCommentUserName(
                      //                                                     '${_commentProvider.commentUser.firstName}')
                      //                                                 ? Flexible(
                      //                                                     child:
                      //                                                         Container(
                      //                                                       width: 100,
                      //                                                       padding:
                      //                                                           EdgeInsets
                      //                                                               .all(
                      //                                                                   10),
                      //                                                       child: Text(
                      //                                                         UserHelper
                      //                                                             .userDisplayName(
                      //                                                                 _commentProvider.commentUser),
                      //                                                         textAlign:
                      //                                                             TextAlign
                      //                                                                 .center,
                      //                                                         style:
                      //                                                             TextStyle(
                      //                                                           color: Colors
                      //                                                               .black,
                      //                                                           fontWeight:
                      //                                                               FontWeight
                      //                                                                   .w600,
                      //                                                           fontStyle:
                      //                                                               FontStyle
                      //                                                                   .italic,
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                   )
                      //                                                 : Container(
                      //                                                     width: 100,
                      //                                                     padding:
                      //                                                         EdgeInsets
                      //                                                             .all(
                      //                                                                 10),
                      //                                                     child: Text(
                      //                                                       // '${_commentUser.firstName}',
                      //                                                       UserHelper
                      //                                                           .userDisplayName(
                      //                                                               _commentProvider.commentUser),
                      //                                                       textAlign:
                      //                                                           TextAlign
                      //                                                               .center,
                      //                                                       style:
                      //                                                           TextStyle(
                      //                                                         color: Colors
                      //                                                             .black,
                      //                                                         fontWeight:
                      //                                                             FontWeight
                      //                                                                 .w600,
                      //                                                         fontStyle:
                      //                                                             FontStyle
                      //                                                                 .italic,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                       Container(
                      //                                         child: Flexible(
                      //                                           child: Padding(
                      //                                             padding:
                      //                                                 const EdgeInsets
                      //                                                     .only(
                      //                                               top: 5,
                      //                                               bottom: 20,
                      //                                             ),
                      //                                             child: Text(
                      //                                               _commentProvider
                      //                                                   .comments[index]
                      //                                                   .commentBody,
                      //                                               textAlign:
                      //                                                   TextAlign.left,
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ],
                      //                                   ),
                      //                                 ),
                      //                                 // _commentUser.id ==
                      //                                 //         loggedInUser.userId
                      //                                 _commentProvider.commentUser.id == _currentUser.id
                      //                                     ? Row(
                      //                                         children: [
                      //                                           IconButton(
                      //                                             onPressed: () {
                      //                                               _commentProvider.commentEditted =
                      //                                                   true;
                      //                                               _commentProvider.edittedComment =
                      //                                                   _commentProvider.comments[
                      //                                                       index];
                      //                                               _commentProvider.commentController
                      //                                                       .text =
                      //                                                   _commentProvider
                      //                                                       .comments[
                      //                                                           index]
                      //                                                       .commentBody;
                      //                                               FocusScope.of(context)
                      //                                                   .requestFocus(
                      //                                                       _commentProvider.commentFocusNode);
                      //                                             },
                      //                                             icon: Icon(Icons.edit),
                      //                                           ),
                      //                                           IconButton(
                      //                                             onPressed: () {
                      //                                               _commentProvider.edittedComment =
                      //                                                   _commentProvider.comments[
                      //                                                       index];
                      //                                               _commentProvider.deletePostComment(
                      //                                                   );
                      //                                             },
                      //                                             icon:
                      //                                                 Icon(Icons.delete),
                      //                                           ),
                      //                                         ],
                      //                                       )
                      //                                     : Container(),
                      //                               ],
                      //                             ),
                      //                           );
                      //                         } else if (snapshot.connectionState ==
                      //                             ConnectionState.done) {
                      //                           return Container();
                      //                         } else {
                      //                           // print(snapshot);
                      //                           return Container(
                      //                             child: Text('No data'),
                      //                           );
                      //                         }
                      //                       }
                      //                     },
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         );
                      //       }
                      //     }
                      //   },
                      // ),

                      child: _commentProvider.comments.isEmpty
                          ? Container(
                              child: Text(
                                'No Comments Yet',
                                style: getBoldStyle(
                                    fontSize: FontSize.s17,
                                    color: Colors.black),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _commentProvider.comments.length,
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
                                        future: _commentProvider.userProvider
                                            .getCommentUser(_commentProvider
                                                .comments[index].userId
                                                .toString()),
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
                                              _commentProvider.commentUser =
                                                  snapshot.data as User;

                                              User _currentUser;
                                              if (_commentProvider
                                                      .userProvider.user !=
                                                  null) {
                                                _currentUser = _commentProvider
                                                    .userProvider.user as User;
                                              } else {
                                                _currentUser = _commentProvider
                                                    .userProvider.user as User;
                                              }
                                              _commentProvider
                                                      .edittedComment.userId =
                                                  int.parse(_currentUser.id);
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              // _commentUser = snapshot.data as User;
                                                              if (Provider.of<
                                                                  BookProvider>(
                                                                context,
                                                                listen: false,
                                                              ).hasPostByUser(
                                                                  _commentProvider
                                                                      .commentUser
                                                                      .id)) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                  UserPostsScreen
                                                                      .routeName,
                                                                  arguments: {
                                                                    'userId':
                                                                        _commentProvider
                                                                            .commentUser
                                                                            .id,
                                                                  },
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentSnackBar();
                                                                final snackBar =
                                                                    SnackBar(
                                                                  content: Text(
                                                                    'No posts by ${_commentProvider.commentUser.firstName}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
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
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                    UserHelper.userProfileImage(
                                                                        _commentProvider
                                                                            .commentUser),
                                                                  ),
                                                                ),
                                                                _commentProvider
                                                                        .shouldFlexCommentUserName(
                                                                            '${_commentProvider.commentUser.firstName}')
                                                                    ? Flexible(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          padding:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              Text(
                                                                            UserHelper.userDisplayName(_commentProvider.commentUser),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        width:
                                                                            100,
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child:
                                                                            Text(
                                                                          // '${_commentUser.firstName}',
                                                                          UserHelper.userDisplayName(
                                                                              _commentProvider.commentUser),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FontStyle.italic,
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
                                                                  _commentProvider
                                                                      .comments[
                                                                          index]
                                                                      .commentBody,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // _commentUser.id ==
                                                    //         loggedInUser.userId
                                                    _commentProvider.commentUser
                                                                .id ==
                                                            _currentUser.id
                                                        ? Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  _commentProvider
                                                                          .commentEditted =
                                                                      true;

                                                                  _commentProvider
                                                                          .edittedComment =
                                                                      _commentProvider
                                                                              .comments[
                                                                          index];

                                                                  _commentProvider
                                                                          .commentController
                                                                          .text =
                                                                      _commentProvider
                                                                          .comments[
                                                                              index]
                                                                          .commentBody;

                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _commentProvider
                                                                              .commentFocusNode);
                                                                },
                                                                icon: Icon(
                                                                    Icons.edit),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  _commentProvider
                                                                          .edittedComment =
                                                                      _commentProvider
                                                                              .comments[
                                                                          index];
                                                                  _commentProvider
                                                                      .deletePostComment();
                                                                },
                                                                icon: Icon(Icons
                                                                    .delete),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot
                                                    .connectionState ==
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
                                key: _commentProvider.form,
                                child: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: TextFormField(
                                      focusNode:
                                          _commentProvider.commentFocusNode,
                                      controller:
                                          _commentProvider.commentController,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      onChanged: (value) {
                                        _commentProvider.edittedComment
                                            .commentBody = value.toString();
                                      },
                                      // onSaved: (_) {
                                      // Using tempProvider with listen false because notifying listners was triggering multiple rebuilds while using _commentProvider

                                      // if (_commentProvider.commentEditted ==
                                      //     true) {
                                      //   _commentProvider.updatePostComment();
                                      // } else
                                      //   _commentProvider.addPostComment();
                                      // },
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            if (_commentProvider
                                                    .commentEditted ==
                                                true) {
                                              _commentProvider
                                                  .updatePostComment();
                                            } else
                                              _commentProvider.addPostComment();
                                          },
                                          icon: Icon(
                                            Icons.send,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
