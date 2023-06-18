import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';

import '../../models/post_category.dart';
import '../../view_models/providers/category_provider.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import '../widgets/post_new.dart';

class UserPostsScreen extends StatefulWidget {
  // static const routeName = '/user-posts';

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false)
        .bindUserPostsScreenViewModel(context);
  }

  @override
  void dispose() {
    Provider.of<BookProvider>(context, listen: false)
        .unBindUserPostsScreenViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();

    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,

          backgroundColor: Colors.transparent,

          toolbarHeight: 15.h,

          //   children: [
          //     // Background container with rounded corners
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(25),
          //           bottomRight: Radius.circular(25),
          //         ),
          //         color: ColorManager.primary,
          //       ),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               CircleAvatar(
          //                 backgroundColor: ColorManager.black,
          //                 radius: 20,
          //                 child: Builder(
          //                   builder: (context) {
          //                     return IconButton(
          //                       icon: Icon(
          //                         Icons.menu,
          //                         size: AppSize.s22,
          //                       ),
          //                       onPressed: () =>
          //                           Scaffold.of(context).openDrawer(),
          //                       color: ColorManager.white,
          //                     );
          //                   },
          //                 ),
          //               ),
          //               _bookProvider.userProvider.user!.id != null
          //                   ? FutureBuilder(
          //                       future: _bookProvider.userProvider.getUserById(_bookProvider.userProvider.user!.id),
          //                       builder: (context, snapshot) {
          //                         if (snapshot.connectionState ==
          //                             ConnectionState.waiting) {
          //                           return CircularProgressIndicator(
          //                             color: ColorManager.secondary,
          //                           );
          //                         } else {
          //                           if (snapshot.hasError) {
          //                             return Container();
          //                           } else {
          //                             User user = snapshot.data as User;
          //                             return Text(
          //                               "${user.firstName}'s Posts",
          //                               style: getBoldStyle(
          //                                 color: ColorManager.white,
          //                                 fontSize: FontSize.s16,
          //                               ),
          //                             );
          //                           }
          //                         }
          //                       },
          //                     )
          //                   : Text(
          //                       'Your Posts',
          //                       style: getBoldStyle(
          //                         color: ColorManager.white,
          //                         fontSize: FontSize.s16,
          //                       ),
          //                     ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: _bookProvider.userProvider.user != null
          //                     ? CircleAvatar(
          //                         backgroundImage: NetworkImage(
          //                           UserHelper.userProfileImage(
          //                               _bookProvider.userProvider.user as User),
          //                         ),
          //                       )
          //                     : FutureBuilder(
          //                         // future: _bookProvider.userProvider.getUserByIdAndSession(
          //                         future: _bookProvider.userProvider.getUserById(
          //                             // loggedInUserSession, loggedInUserSession.userId),
          //                             '1'),
          //                         builder: (ctx, snapshot) {
          //                           // if (snapshot.data != null)
          //                           // user = snapshot.data as User;
          //                           if (snapshot.connectionState ==
          //                               ConnectionState.waiting) {
          //                             return CircularProgressIndicator(
          //                               color: ColorManager.secondary,
          //                             );
          //                           } else {
          //                             if (snapshot.hasError) {
          //                               return CircleAvatar(
          //                                 backgroundImage: NetworkImage(
          //                                     'https://ojasfilms.org/assets/img/ojas-logo.png'),
          //                               );
          //                             } else {
          //                               // user = snapshot.data as User;
          //                               return CircleAvatar(
          //                                 backgroundImage: NetworkImage(
          //                                   // ((snapshot.data as User).image) as String),
          //                                   (UserHelper.userProfileImage(
          //                                       snapshot.data as User)),
          //                                 ),
          //                               );
          //                             }
          //                           }
          //                         },
          //                       ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: AppHeight.h8,
          //           ),
          //           Form(
          //             key: _form,
          //             child: Padding(
          //               padding: const EdgeInsets.only(right: 12),
          //               child: TextFormField(
          //                 controller: _bookProvider.userPostsScreenViewModelSearchTextController,
          //                 focusNode: _bookProvider.userPostsScreenViewModelSearchFocusNode,
          //                 cursorColor: ColorManager.primary,
          //                 decoration: InputDecoration(
          //                   prefixIcon: Icon(Icons.search),
          //                   prefixIconColor: ColorManager.primary,
          //                   suffixIcon: _bookProvider.userPostsScreenViewModelSelectedFilteredBooks == null
          //                       ? IconButton(
          //                           icon: Icon(
          //                             Icons.send,
          //                           ),
          //                           onPressed: () =>
          //                               _bookProvider._bookProvider.userPostsScreenViewModelSearchUserBooks(_form))
          //                       : IconButton(
          //                           icon: Icon(
          //                             Icons.cancel_outlined,
          //                           ),
          //                           onPressed: () {
          //                             setState(() {
          //                               _bookProvider.userPostsScreenViewModelSelectedFilteredBooks = null;
          //                               _bookProvider.userPostsScreenViewModelSearchTextController.text = '';
          //                             });
          //                           },
          //                         ),
          //                   suffixIconColor: ColorManager.primary,
          //                   fillColor: ColorManager.white,
          //                   filled: true,
          //                   focusColor: ColorManager.white,
          //                   labelText: 'Search your posts',
          //                   floatingLabelBehavior: FloatingLabelBehavior.never,
          //                   enabledBorder: OutlineInputBorder(
          //                     borderSide: BorderSide(
          //                       color: ColorManager.white,
          //                     ),
          //                     borderRadius: BorderRadius.circular(20),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderSide: BorderSide(
          //                       color: ColorManager.white,
          //                     ),
          //                     borderRadius: BorderRadius.circular(20),
          //                   ),
          //                 ),
          //                 textInputAction: TextInputAction.done,
          //                 validator: (value) {
          //                   if (value!.isEmpty) {
          //                     return 'Please provide the bookName';
          //                   }
          //                   return null;
          //                 },
          //                 onFieldSubmitted: (_) {
          //                   _bookProvider._bookProvider.userPostsScreenViewModelSearchUserBooks(_form);
          //                 },
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          flexibleSpace: Stack(
            children: [
              Container(
                height: 12.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  color: ColorManager.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: ColorManager.black,
                          radius: 20,
                          child: Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  size: AppSize.s22,
                                ),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                                color: ColorManager.white,
                              );
                            },
                          ),
                        ),
                        // if (_bookProvider.userProvider.user!.id != null) FutureBuilder(
                        if (_bookProvider
                                    .userPostsScreenViewModelSelectedUserId !=
                                null &&
                            _bookProvider.userProvider.user!.id !=
                                _bookProvider
                                    .userPostsScreenViewModelSelectedUserId
                                    .toString())
                          FutureBuilder(
                            future: _bookProvider.userProvider.getUserById(
                                // _bookProvider.userProvider.user!.id),
                                _bookProvider
                                    .userPostsScreenViewModelSelectedUserId
                                    .toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: ColorManager.secondary,
                                );
                              } else {
                                if (snapshot.hasError) {
                                  return Container();
                                } else {
                                  User user = snapshot.data as User;
                                  return Text(
                                    "${user.firstName}'s Posts",
                                    style: getBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s16,
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        else
                          Text(
                            'Your Posts',
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s16,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _bookProvider.userProvider.user != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    UserHelper.userProfileImage(_bookProvider
                                        .userProvider.user as User),
                                  ),
                                )
                              : FutureBuilder(
                                  // future: _bookProvider.userProvider.getUserByIdAndSession(
                                  future: _bookProvider.userProvider.getUserById(
                                      // loggedInUserSession, loggedInUserSession.userId),
                                      '1'),
                                  builder: (ctx, snapshot) {
                                    // if (snapshot.data != null)
                                    // user = snapshot.data as User;
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: ColorManager.secondary,
                                      );
                                    } else {
                                      if (snapshot.hasError) {
                                        return CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://ojasfilms.org/assets/img/ojas-logo.png'),
                                        );
                                      } else {
                                        // user = snapshot.data as User;
                                        return CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            // ((snapshot.data as User).image) as String),
                                            (UserHelper.userProfileImage(
                                                snapshot.data as User)),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h20,
                    ),
                    Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: TextFormField(
                          controller: _bookProvider
                              .userPostsScreenViewModelSearchTextController,
                          focusNode: _bookProvider
                              .userPostsScreenViewModelSearchFocusNode,
                          cursorColor: ColorManager.primary,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorManager.primary,
                              ),
                            ),
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: ColorManager.primary,

                            suffixIcon: _bookProvider
                                        .userPostsScreenViewModelSelectedFilteredBooks ==
                                    null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.send,
                                    ),
                                    onPressed: () => _bookProvider
                                        .userPostsScreenViewModelSearchUserBooks(
                                            _form))
                                : IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _bookProvider
                                                .userPostsScreenViewModelSelectedFilteredBooks =
                                            null;
                                        _bookProvider
                                            .userPostsScreenViewModelSearchTextController
                                            .text = '';
                                      });
                                    },
                                  ),
                            suffixIconColor: ColorManager.primary,
                            fillColor: ColorManager
                                .white, // Change the background color
                            filled: true,
                            focusColor: ColorManager
                                .grey, // Change the background color
                            labelText: 'Search your posts',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors
                                    .red, // Change the border color if needed
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors
                                    .red, // Change the border color if needed
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide the bookName';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _bookProvider
                                .userPostsScreenViewModelSearchUserBooks(_form);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: AppHeight.h20,
              ),
              if (_bookProvider.userPostsScreenViewModelSelectedFilteredBooks !=
                      null &&
                  _bookProvider.userPostsScreenViewModelSelectedFilteredBooks!
                          .length <=
                      0)
                Center(
                  child: Text(
                    'No books found',
                    style: getBoldStyle(
                        fontSize: FontSize.s20, color: ColorManager.primary),
                  ),
                ),
              if (_bookProvider.userPostsScreenViewModelSelectedFilteredBooks !=
                  null)
                MasonryGridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p8,
                  ),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _bookProvider
                      .userPostsScreenViewModelSelectedFilteredBooks!.length,
                  itemBuilder: (ctx, idx) => PostNew(
                    book: _bookProvider
                        .userPostsScreenViewModelSelectedFilteredBooks![idx],
                    // authSession: loggedInUserSession,
                  ),
                )
              else
                FutureBuilder(
                  future: _bookProvider
                              .userPostsScreenViewModelCategories[_bookProvider
                                  .userPostsScreenViewModelSelectedCategoryIndex]
                              .name
                              .toLowerCase() ==
                          'all'
                      ? _bookProvider.getUserBooks(_bookProvider
                                  .userPostsScreenViewModelSelectedUserId !=
                              null
                          ? _bookProvider.userPostsScreenViewModelSelectedUserId
                              .toString()
                          : _bookProvider.userProvider.user!.id)
                      : _bookProvider.getBooksByCategory(
                          _bookProvider.sessionProvider.session as Session,
                          _bookProvider
                              .userPostsScreenViewModelCategories[_bookProvider
                                  .userPostsScreenViewModelSelectedCategoryIndex]
                              .id
                              .toString()),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                      } else {
                        if (snapshot.data is BookError) {
                          return Center(
                            child: Text((snapshot.data as BookError)
                                .message
                                .toString()),
                          );
                        } else {
                          _bookProvider.userPostsScreenViewModelUserBooks =
                              (snapshot.data as Map)['books'] as List<Book>;
                          return _bookProvider.userPostsScreenViewModelUserBooks
                                      .length <=
                                  0
                              ? Center(
                                  child: Text(
                                    'No books found',
                                    style: getBoldStyle(
                                        fontSize: FontSize.s20,
                                        color: ColorManager.primary),
                                  ),
                                )
                              : MasonryGridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppPadding.p8,
                                  ),
                                  gridDelegate:
                                      SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: _bookProvider
                                      .userPostsScreenViewModelUserBooks.length,
                                  itemBuilder: (ctx, idx) => PostNew(
                                    book: _bookProvider
                                        .userPostsScreenViewModelUserBooks[idx],
                                    // authSession: loggedInUserSession,
                                  ),
                                );
                        }
                      }
                    }
                  },
                ),
              // : Center(
              //     child: Text(
              //       'No Posts yet',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 20,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
