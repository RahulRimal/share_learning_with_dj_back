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
import '../../view_models/providers/book_filters_provider.dart';
import '../../view_models/providers/category_provider.dart';
import '../managers/assets_manager.dart';
import '../managers/font_manager.dart';
import '../managers/routes_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import '../widgets/book_filters.dart';
import '../widgets/post_new.dart';

// class UserPostsScreen extends StatefulWidget {
//   // static const routeName = '/user-posts';
//   @override
//   State<UserPostsScreen> createState() => _UserPostsScreenState();
// }
// class _UserPostsScreenState extends State<UserPostsScreen> {
//   final _form = GlobalKey<FormState>();
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<BookProvider>(context, listen: false)
//         .bindUserPostsScreenViewModel(context);
//   }
//   @override
//   void dispose() {
//     Provider.of<BookProvider>(context, listen: false)
//         .unBindUserPostsScreenViewModel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     BookProvider _bookProvider = context.watch<BookProvider>();
//     return SafeArea(
//       child: Scaffold(
//         drawer: AppDrawer(),
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           toolbarHeight: 15.h,
//           //   children: [
//           //     // Background container with rounded corners
//           //     Container(
//           //       decoration: BoxDecoration(
//           //         borderRadius: BorderRadius.only(
//           //           bottomLeft: Radius.circular(25),
//           //           bottomRight: Radius.circular(25),
//           //         ),
//           //         color: ColorManager.primary,
//           //       ),
//           //     ),
//           //     Container(
//           //       padding: EdgeInsets.symmetric(horizontal: 16),
//           //       child: Column(
//           //         mainAxisAlignment: MainAxisAlignment.center,
//           //         children: [
//           //           Row(
//           //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //             children: [
//           //               CircleAvatar(
//           //                 backgroundColor: ColorManager.black,
//           //                 radius: 20,
//           //                 child: Builder(
//           //                   builder: (context) {
//           //                     return IconButton(
//           //                       icon: Icon(
//           //                         Icons.menu,
//           //                         size: AppSize.s22,
//           //                       ),
//           //                       onPressed: () =>
//           //                           Scaffold.of(context).openDrawer(),
//           //                       color: ColorManager.white,
//           //                     );
//           //                   },
//           //                 ),
//           //               ),
//           //               _bookProvider.userProvider.user!.id != null
//           //                   ? FutureBuilder(
//           //                       future: _bookProvider.userProvider.getUserById(_bookProvider.userProvider.user!.id),
//           //                       builder: (context, snapshot) {
//           //                         if (snapshot.connectionState ==
//           //                             ConnectionState.waiting) {
//           //                           return CircularProgressIndicator(
//           //                             color: ColorManager.secondary,
//           //                           );
//           //                         } else {
//           //                           if (snapshot.hasError) {
//           //                             return Container();
//           //                           } else {
//           //                             User user = snapshot.data as User;
//           //                             return Text(
//           //                               "${user.firstName}'s Posts",
//           //                               style: getBoldStyle(
//           //                                 color: ColorManager.white,
//           //                                 fontSize: FontSize.s16,
//           //                               ),
//           //                             );
//           //                           }
//           //                         }
//           //                       },
//           //                     )
//           //                   : Text(
//           //                       'Your Posts',
//           //                       style: getBoldStyle(
//           //                         color: ColorManager.white,
//           //                         fontSize: FontSize.s16,
//           //                       ),
//           //                     ),
//           //               Padding(
//           //                 padding: const EdgeInsets.all(8.0),
//           //                 child: _bookProvider.userProvider.user != null
//           //                     ? CircleAvatar(
//           //                         backgroundImage: NetworkImage(
//           //                           UserHelper.userProfileImage(
//           //                               _bookProvider.userProvider.user as User),
//           //                         ),
//           //                       )
//           //                     : FutureBuilder(
//           //                         // future: _bookProvider.userProvider.getUserByIdAndSession(
//           //                         future: _bookProvider.userProvider.getUserById(
//           //                             // loggedInUserSession, loggedInUserSession.userId),
//           //                             '1'),
//           //                         builder: (ctx, snapshot) {
//           //                           // if (snapshot.data != null)
//           //                           // user = snapshot.data as User;
//           //                           if (snapshot.connectionState ==
//           //                               ConnectionState.waiting) {
//           //                             return CircularProgressIndicator(
//           //                               color: ColorManager.secondary,
//           //                             );
//           //                           } else {
//           //                             if (snapshot.hasError) {
//           //                               return CircleAvatar(
//           //                                 backgroundImage: NetworkImage(
//           //                                     'https://ojasfilms.org/assets/img/ojas-logo.png'),
//           //                               );
//           //                             } else {
//           //                               // user = snapshot.data as User;
//           //                               return CircleAvatar(
//           //                                 backgroundImage: NetworkImage(
//           //                                   // ((snapshot.data as User).image) as String),
//           //                                   (UserHelper.userProfileImage(
//           //                                       snapshot.data as User)),
//           //                                 ),
//           //                               );
//           //                             }
//           //                           }
//           //                         },
//           //                       ),
//           //               ),
//           //             ],
//           //           ),
//           //           SizedBox(
//           //             height: AppHeight.h8,
//           //           ),
//           //           Form(
//           //             key: _form,
//           //             child: Padding(
//           //               padding: const EdgeInsets.only(right: 12),
//           //               child: TextFormField(
//           //                 controller: _bookProvider.userPostsScreenViewModelSearchTextController,
//           //                 focusNode: _bookProvider.userPostsScreenViewModelSearchFocusNode,
//           //                 cursorColor: ColorManager.primary,
//           //                 decoration: InputDecoration(
//           //                   prefixIcon: Icon(Icons.search),
//           //                   prefixIconColor: ColorManager.primary,
//           //                   suffixIcon: _bookProvider.userPostsScreenViewModelSelectedFilteredBooks == null
//           //                       ? IconButton(
//           //                           icon: Icon(
//           //                             Icons.send,
//           //                           ),
//           //                           onPressed: () =>
//           //                               _bookProvider._bookProvider.userPostsScreenViewModelSearchUserBooks(_form))
//           //                       : IconButton(
//           //                           icon: Icon(
//           //                             Icons.cancel_outlined,
//           //                           ),
//           //                           onPressed: () {
//           //                             setState(() {
//           //                               _bookProvider.userPostsScreenViewModelSelectedFilteredBooks = null;
//           //                               _bookProvider.userPostsScreenViewModelSearchTextController.text = '';
//           //                             });
//           //                           },
//           //                         ),
//           //                   suffixIconColor: ColorManager.primary,
//           //                   fillColor: ColorManager.white,
//           //                   filled: true,
//           //                   focusColor: ColorManager.white,
//           //                   labelText: 'Search your posts',
//           //                   floatingLabelBehavior: FloatingLabelBehavior.never,
//           //                   enabledBorder: OutlineInputBorder(
//           //                     borderSide: BorderSide(
//           //                       color: ColorManager.white,
//           //                     ),
//           //                     borderRadius: BorderRadius.circular(20),
//           //                   ),
//           //                   focusedBorder: OutlineInputBorder(
//           //                     borderSide: BorderSide(
//           //                       color: ColorManager.white,
//           //                     ),
//           //                     borderRadius: BorderRadius.circular(20),
//           //                   ),
//           //                 ),
//           //                 textInputAction: TextInputAction.done,
//           //                 validator: (value) {
//           //                   if (value!.isEmpty) {
//           //                     return 'Please provide the bookName';
//           //                   }
//           //                   return null;
//           //                 },
//           //                 onFieldSubmitted: (_) {
//           //                   _bookProvider._bookProvider.userPostsScreenViewModelSearchUserBooks(_form);
//           //                 },
//           //               ),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           flexibleSpace: Stack(
//             children: [
//               Container(
//                 height: 12.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(25),
//                     bottomRight: Radius.circular(25),
//                   ),
//                   color: ColorManager.primary,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: ColorManager.black,
//                           radius: 20,
//                           child: Builder(
//                             builder: (context) {
//                               return IconButton(
//                                 icon: Icon(
//                                   Icons.menu,
//                                   size: AppSize.s22,
//                                 ),
//                                 onPressed: () =>
//                                     Scaffold.of(context).openDrawer(),
//                                 color: ColorManager.white,
//                               );
//                             },
//                           ),
//                         ),
//                         // if (_bookProvider.userProvider.user!.id != null) FutureBuilder(
//                         if (_bookProvider
//                                     .userPostsScreenViewModelSelectedUserId !=
//                                 null &&
//                             _bookProvider.userProvider.user!.id !=
//                                 _bookProvider
//                                     .userPostsScreenViewModelSelectedUserId
//                                     .toString())
//                           FutureBuilder(
//                             future: _bookProvider.userProvider.getUserById(
//                                 // _bookProvider.userProvider.user!.id),
//                                 _bookProvider
//                                     .userPostsScreenViewModelSelectedUserId
//                                     .toString()),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return CircularProgressIndicator(
//                                   color: ColorManager.secondary,
//                                 );
//                               } else {
//                                 if (snapshot.hasError) {
//                                   return Container();
//                                 } else {
//                                   User user = snapshot.data as User;
//                                   return Text(
//                                     "${user.firstName}'s Posts",
//                                     style: getBoldStyle(
//                                       color: ColorManager.white,
//                                       fontSize: FontSize.s16,
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                           )
//                         else
//                           Text(
//                             'Your Posts',
//                             style: getBoldStyle(
//                               color: ColorManager.white,
//                               fontSize: FontSize.s16,
//                             ),
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: _bookProvider.userProvider.user != null
//                               ? CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                     UserHelper.userProfileImage(_bookProvider
//                                         .userProvider.user as User),
//                                   ),
//                                 )
//                               : FutureBuilder(
//                                   // future: _bookProvider.userProvider.getUserByIdAndSession(
//                                   future: _bookProvider.userProvider.getUserById(
//                                       // loggedInUserSession, loggedInUserSession.userId),
//                                       '1'),
//                                   builder: (ctx, snapshot) {
//                                     // if (snapshot.data != null)
//                                     // user = snapshot.data as User;
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator(
//                                         color: ColorManager.secondary,
//                                       );
//                                     } else {
//                                       if (snapshot.hasError) {
//                                         return CircleAvatar(
//                                           backgroundImage: NetworkImage(
//                                               'https://ojasfilms.org/assets/img/ojas-logo.png'),
//                                         );
//                                       } else {
//                                         // user = snapshot.data as User;
//                                         return CircleAvatar(
//                                           backgroundImage: NetworkImage(
//                                             // ((snapshot.data as User).image) as String),
//                                             (UserHelper.userProfileImage(
//                                                 snapshot.data as User)),
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   },
//                                 ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: AppHeight.h20,
//                     ),
//                     Form(
//                       key: _form,
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: TextFormField(
//                           controller: _bookProvider
//                               .userPostsScreenViewModelSearchTextController,
//                           focusNode: _bookProvider
//                               .userPostsScreenViewModelSearchFocusNode,
//                           cursorColor: ColorManager.primary,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: ColorManager.primary,
//                               ),
//                             ),
//                             prefixIcon: Icon(Icons.search),
//                             prefixIconColor: ColorManager.primary,
//                             suffixIcon: _bookProvider
//                                         .userPostsScreenViewModelSelectedFilteredBooks ==
//                                     null
//                                 ? IconButton(
//                                     icon: Icon(
//                                       Icons.send,
//                                     ),
//                                     onPressed: () => _bookProvider
//                                         .userPostsScreenViewModelSearchUserBooks(
//                                             _form))
//                                 : IconButton(
//                                     icon: Icon(
//                                       Icons.cancel_outlined,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _bookProvider
//                                                 .userPostsScreenViewModelSelectedFilteredBooks =
//                                             null;
//                                         _bookProvider
//                                             .userPostsScreenViewModelSearchTextController
//                                             .text = '';
//                                       });
//                                     },
//                                   ),
//                             suffixIconColor: ColorManager.primary,
//                             fillColor: ColorManager
//                                 .white, // Change the background color
//                             filled: true,
//                             focusColor: ColorManager
//                                 .grey, // Change the background color
//                             labelText: 'Search your posts',
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors
//                                     .red, // Change the border color if needed
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors
//                                     .red, // Change the border color if needed
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           textInputAction: TextInputAction.done,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please provide the bookName';
//                             }
//                             return null;
//                           },
//                           onFieldSubmitted: (_) {
//                             _bookProvider
//                                 .userPostsScreenViewModelSearchUserBooks(_form);
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: AppHeight.h20,
//               ),
//               if (_bookProvider.userPostsScreenViewModelSelectedFilteredBooks !=
//                       null &&
//                   _bookProvider.userPostsScreenViewModelSelectedFilteredBooks!
//                           .length <=
//                       0)
//                 Center(
//                   child: Text(
//                     'No books found',
//                     style: getBoldStyle(
//                         fontSize: FontSize.s20, color: ColorManager.primary),
//                   ),
//                 ),
//               if (_bookProvider.userPostsScreenViewModelSelectedFilteredBooks !=
//                   null)
//                 MasonryGridView.builder(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppPadding.p8,
//                   ),
//                   gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2),
//                   itemCount: _bookProvider
//                       .userPostsScreenViewModelSelectedFilteredBooks!.length,
//                   itemBuilder: (ctx, idx) => PostNew(
//                     book: _bookProvider
//                         .userPostsScreenViewModelSelectedFilteredBooks![idx],
//                     // authSession: loggedInUserSession,
//                   ),
//                 )
//               else
//                 FutureBuilder(
//                   future: _bookProvider
//                               .categoryProvider
//                               .categories[_bookProvider
//                                   .userPostsScreenViewModelSelectedCategoryIndex]
//                               .name
//                               .toLowerCase() ==
//                           'all'
//                       ? _bookProvider.getUserBooks(_bookProvider
//                                   .userPostsScreenViewModelSelectedUserId !=
//                               null
//                           ? _bookProvider.userPostsScreenViewModelSelectedUserId
//                               .toString()
//                           : _bookProvider.userProvider.user!.id)
//                       : _bookProvider.getBooksByCategory(
//                           _bookProvider.sessionProvider.session as Session,
//                           _bookProvider
//                               .categoryProvider
//                               .categories[_bookProvider
//                                   .userPostsScreenViewModelSelectedCategoryIndex]
//                               .id
//                               .toString()),
//                   builder: (ctx, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: ColorManager.primary,
//                         ),
//                       );
//                     } else {
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error'),
//                         );
//                       } else {
//                         if (snapshot.data is BookError) {
//                           return Center(
//                             child: Text((snapshot.data as BookError)
//                                 .message
//                                 .toString()),
//                           );
//                         } else {
//                           _bookProvider.userPostsScreenViewModelUserBooks =
//                               (snapshot.data as Map)['books'] as List<Book>;
//                           return _bookProvider.userPostsScreenViewModelUserBooks
//                                       .length <=
//                                   0
//                               ? Center(
//                                   child: Text(
//                                     'No books found',
//                                     style: getBoldStyle(
//                                         fontSize: FontSize.s20,
//                                         color: ColorManager.primary),
//                                   ),
//                                 )
//                               : MasonryGridView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   crossAxisSpacing: 12,
//                                   mainAxisSpacing: 12,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: AppPadding.p8,
//                                   ),
//                                   gridDelegate:
//                                       SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2),
//                                   itemCount: _bookProvider
//                                       .userPostsScreenViewModelUserBooks.length,
//                                   itemBuilder: (ctx, idx) => PostNew(
//                                     book: _bookProvider
//                                         .userPostsScreenViewModelUserBooks[idx],
//                                     // authSession: loggedInUserSession,
//                                   ),
//                                 );
//                         }
//                       }
//                     }
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class UserPostsScreen extends StatefulWidget {
  // static const routeName = '/user-posts';
  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen>
    with WidgetsBindingObserver {
  final _form = GlobalKey<FormState>();
  BookProvider? bookProvider;

  // @override
  // void initState() {
  //   super.initState();
  //   bookProvider = Provider.of<BookProvider>(context, listen: false);
  //   bookProvider!.bindUserPostsScreenViewModel(context);
  //   // Register this object as an observer
  //   WidgetsBinding.instance.addObserver(this);

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     bookProvider!.getUserBooks(
  //         (Provider.of<UserProvider>(context, listen: false).user as User).id);
  //   });
  // }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Added this line to save the reference of provider so it doesn't throw an exception on dispose
  //   bookProvider = Provider.of<BookProvider>(context, listen: false);
  // }
  // @override
  // void dispose() {
  //   bookProvider!.unBindUserPostsScreenViewModel();
  //   // Unregister this object as an observer
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   BookProvider _bookProvider = context.watch<BookProvider>();

  //   return SafeArea(
  //     child: Scaffold(
  //       drawer: AppDrawer(),
  //       appBar: AppBar(
  //         automaticallyImplyLeading: false,
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //         toolbarHeight: 15.h,
  //         flexibleSpace: Stack(
  //           children: [
  //             Container(
  //               height: 12.h,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(25),
  //                   bottomRight: Radius.circular(25),
  //                 ),
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 16),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CircleAvatar(
  //                         backgroundColor: ColorManager.black,
  //                         radius: 20,
  //                         child: Builder(
  //                           builder: (context) {
  //                             return IconButton(
  //                               icon: Icon(
  //                                 Icons.menu,
  //                                 size: AppSize.s22,
  //                               ),
  //                               onPressed: () =>
  //                                   Scaffold.of(context).openDrawer(),
  //                               color: ColorManager.white,
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                       // if (_bookProvider.userProvider.user!.id != null) FutureBuilder(
  //                       if (_bookProvider
  //                                   .userPostsScreenViewModelSelectedUserId !=
  //                               null &&
  //                           _bookProvider.userProvider.user!.id !=
  //                               _bookProvider
  //                                   .userPostsScreenViewModelSelectedUserId
  //                                   .toString())
  //                         FutureBuilder(
  //                           future: _bookProvider.userProvider.getUserById(
  //                               // _bookProvider.userProvider.user!.id),
  //                               _bookProvider
  //                                   .userPostsScreenViewModelSelectedUserId
  //                                   .toString()),
  //                           builder: (context, snapshot) {
  //                             if (snapshot.connectionState ==
  //                                 ConnectionState.waiting) {
  //                               return CircularProgressIndicator(
  //                                 color: ColorManager.secondary,
  //                               );
  //                             } else {
  //                               if (snapshot.hasError) {
  //                                 return Container();
  //                               } else {
  //                                 User user = snapshot.data as User;
  //                                 return Text(
  //                                   "${user.firstName}'s Posts",
  //                                   style: getBoldStyle(
  //                                     color: ColorManager.white,
  //                                     fontSize: FontSize.s16,
  //                                   ),
  //                                 );
  //                               }
  //                             }
  //                           },
  //                         )
  //                       else
  //                         Text(
  //                           'Your Posts',
  //                           style: getBoldStyle(
  //                             color: ColorManager.white,
  //                             fontSize: FontSize.s16,
  //                           ),
  //                         ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: _bookProvider.userProvider.user != null
  //                             ? CircleAvatar(
  //                                 backgroundImage: NetworkImage(
  //                                   UserHelper.userProfileImage(_bookProvider
  //                                       .userProvider.user as User),
  //                                 ),
  //                               )
  //                             : FutureBuilder(
  //                                 // future: _bookProvider.userProvider.getUserByIdAndSession(
  //                                 future: _bookProvider.userProvider.getUserById(
  //                                     // loggedInUserSession, loggedInUserSession.userId),
  //                                     '1'),
  //                                 builder: (ctx, snapshot) {
  //                                   // if (snapshot.data != null)
  //                                   // user = snapshot.data as User;
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.waiting) {
  //                                     return CircularProgressIndicator(
  //                                       color: ColorManager.secondary,
  //                                     );
  //                                   } else {
  //                                     if (snapshot.hasError) {
  //                                       return CircleAvatar(
  //                                         backgroundImage: NetworkImage(
  //                                             'https://ojasfilms.org/assets/img/ojas-logo.png'),
  //                                       );
  //                                     } else {
  //                                       // user = snapshot.data as User;
  //                                       return CircleAvatar(
  //                                         backgroundImage: NetworkImage(
  //                                           // ((snapshot.data as User).image) as String),
  //                                           (UserHelper.userProfileImage(
  //                                               snapshot.data as User)),
  //                                         ),
  //                                       );
  //                                     }
  //                                   }
  //                                 },
  //                               ),
  //                       ),
  //                     ],
  //                   ),
  //                   Form(
  //                     key: _form,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(right: 12),
  //                       child: TextFormField(
  //                         controller: _bookProvider
  //                             .userPostsScreenViewModelSearchTextController,
  //                         focusNode: _bookProvider
  //                             .userPostsScreenViewModelSearchFocusNode,
  //                         cursorColor: ColorManager.primary,
  //                         decoration: InputDecoration(
  //                           prefixIcon: Icon(Icons.search),
  //                           prefixIconColor: ColorManager.primary,
  //                           suffixIcon: _bookProvider
  //                                       .userPostsScreenViewModelSelectedFilteredBooks ==
  //                                   null
  //                               ? IconButton(
  //                                   icon: Icon(
  //                                     Icons.send,
  //                                   ),
  //                                   onPressed: () => _bookProvider
  //                                       .userPostsScreenViewModelSearchUserBooks(
  //                                           _form))
  //                               : IconButton(
  //                                   icon: Icon(
  //                                     Icons.cancel_outlined,
  //                                   ),
  //                                   onPressed: () {
  //                                     // setState(() {
  //                                     _bookProvider
  //                                             .userPostsScreenViewModelSelectedFilteredBooks =
  //                                         null;
  //                                     _bookProvider
  //                                         .userPostsScreenViewModelSearchTextController
  //                                         .text = '';
  //                                   },
  //                                 ),
  //                           labelText: 'Search your posts',
  //                           floatingLabelBehavior: FloatingLabelBehavior.never,
  //                         ),
  //                         textInputAction: TextInputAction.done,
  //                         validator: (value) {
  //                           if (value!.isEmpty) {
  //                             return 'Please provide the bookName';
  //                           }
  //                           return null;
  //                         },
  //                         onFieldSubmitted: (_) {
  //                           _bookProvider
  //                               .userPostsScreenViewModelSearchUserBooks(_form);
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       body: _bookProvider.loading == true
  //           ? Center(
  //               child: CircularProgressIndicator(),
  //             )
  //           : SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Consumer<CategoryProvider>(
  //                     builder: (context, categoryProvider, child) => SizedBox(
  //                       height: AppHeight.h75,
  //                       child: ListView.builder(
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount: categoryProvider.categories.length,
  //                           itemBuilder: (context, index) {
  //                             return Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 6),
  //                               child: FilterChip(
  //                                 label: Text(
  //                                   categoryProvider.categories[index].name,
  //                                   style: _bookProvider
  //                                               .userPostsScreenViewModelSelectedCategoryIndex ==
  //                                           index
  //                                       ? getBoldStyle(
  //                                           color: ColorManager.white,
  //                                         )
  //                                       : getMediumStyle(
  //                                           color: ColorManager.black,
  //                                         ),
  //                                 ),
  //                                 showCheckmark: false,
  //                                 selected: _bookProvider
  //                                         .userPostsScreenViewModelSelectedCategoryIndex ==
  //                                     index,
  //                                 onSelected: (bool isSelected) async {
  //                                   if (_bookProvider
  //                                           .userPostsScreenViewModelSelectedCategoryIndex !=
  //                                       index) {
  //                                     _bookProvider
  //                                             .userPostsScreenViewModelSelectedCategoryIndex =
  //                                         index;
  //                                     if (categoryProvider
  //                                             .categories[_bookProvider
  //                                                 .userPostsScreenViewModelSelectedCategoryIndex]
  //                                             .name
  //                                             .toLowerCase() !=
  //                                         'all') {
  //                                       _bookProvider.getUserBooksByCategory(
  //                                           (_bookProvider.userProvider.user
  //                                                   as User)
  //                                               .id,
  //                                           _bookProvider
  //                                               .categoryProvider
  //                                               .categories[_bookProvider
  //                                                   .userPostsScreenViewModelSelectedCategoryIndex]
  //                                               .id
  //                                               .toString());
  //                                     } else
  //                                       _bookProvider.getUserBooks(
  //                                           (_bookProvider.userProvider.user
  //                                                   as User)
  //                                               .id);
  //                                   }
  //                                 },
  //                               ),
  //                             );
  //                           }),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: AppHeight.h20,
  //                   ),
  //                   if (_bookProvider.bookFiltersProvider.showFilteredResult)
  //                     Consumer<BookFiltersProvider>(
  //                       builder: (ctx, books, child) {
  //                         if (books.filteredBooks.length <= 0) {
  //                           return Center(
  //                             child: Text(
  //                               'No books found',
  //                               style: getBoldStyle(
  //                                   fontSize: FontSize.s20,
  //                                   color: ColorManager.primary),
  //                             ),
  //                           );
  //                         } else {
  //                           return MasonryGridView.builder(
  //                             physics: NeverScrollableScrollPhysics(),
  //                             shrinkWrap: true,
  //                             crossAxisSpacing: 12,
  //                             mainAxisSpacing: 12,
  //                             padding: EdgeInsets.symmetric(
  //                               horizontal: AppPadding.p8,
  //                             ),
  //                             gridDelegate:
  //                                 SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //                                     crossAxisCount: 2),
  //                             itemCount: books.filteredBooks.length,
  //                             itemBuilder: (ctx, idx) => PostNew(
  //                               book: books.filteredBooks[idx],
  //                             ),
  //                           );
  //                         }
  //                       },
  //                     )
  //                   else if (
  //                   // Here i have used filtered books to check the lenght becuase after search, the books are added to filtered books list. This is because i don't have to introduce new variable to store search results
  //                   _bookProvider.userPostsScreenViewModelSearchTextController
  //                           .text.isNotEmpty &&
  //                       _bookProvider.books.isEmpty)
  //                     Center(
  //                       child: Text(
  //                         'No books found',
  //                         style: getBoldStyle(
  //                             fontSize: FontSize.s20,
  //                             color: ColorManager.primary),
  //                       ),
  //                     )
  //                   else if (_bookProvider.books.isNotEmpty)
  //                     MasonryGridView.builder(
  //                       physics: NeverScrollableScrollPhysics(),
  //                       shrinkWrap: true,
  //                       crossAxisSpacing: 12,
  //                       mainAxisSpacing: 12,
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: AppPadding.p8,
  //                       ),
  //                       gridDelegate:
  //                           SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //                               crossAxisCount: 2),
  //                       itemCount: _bookProvider.books.length,
  //                       itemBuilder: (ctx, idx) => PostNew(
  //                         book: _bookProvider.books[idx],
  //                       ),
  //                     )
  //                   else
  //                     Center(
  //                       child: Text(
  //                         'No books found',
  //                         style: getBoldStyle(
  //                             fontSize: FontSize.s20,
  //                             color: ColorManager.primary),
  //                       ),
  //                     ),
  //                   _bookProvider.homeScreenNewLoadingMorePosts
  //                       ? Padding(
  //                           padding: const EdgeInsets.symmetric(
  //                             vertical: AppPadding.p18,
  //                           ),
  //                           child: CircularProgressIndicator(
  //                             color: Colors.red,
  //                           ),
  //                         )
  //                       : Container(),
  //                 ],
  //               ),
  //             ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider!.binduserPostsScreenViewModel(context);

    // Register this object as an observer
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookProvider!.getUserBooks(
          (Provider.of<UserProvider>(context, listen: false).user as User).id);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Added this line to save the reference of provider so it doesn't throw an exception on dispose
    bookProvider = Provider.of<BookProvider>(context, listen: false);
  }

  @override
  void dispose() {
    bookProvider!.unBinduserPostsScreenViewModel();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();

    return GestureDetector(
      onTap: () {
        // Unfocus the TextFormField when the user taps outside
        _bookProvider.userPostsScreenSearchFocusNode.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 15.h,
            flexibleSpace: Stack(
              children: [
                Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Theme.of(context).primaryColor,
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
                          IconButton(
                            padding: const EdgeInsets.only(
                              right: AppPadding.p20,
                              top: AppPadding.p4,
                              bottom: AppPadding.p4,
                            ),
                            iconSize: AppSize.s40,
                            onPressed: () => Navigator.pushNamed(
                                context, RoutesManager.userProfileScreenRoute),
                            icon: _bookProvider.userProvider.user != null
                                ? (_bookProvider.userProvider.user as User)
                                            .image ==
                                        null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            AssetImage(ImageAssets.noProfile),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            UserHelper.userProfileImage(
                                                _bookProvider.userProvider.user
                                                    as User)),
                                      )
                                : Container(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppHeight.h20,
                      ),
                      Row(
                        children: [
                          Form(
                            key: _form,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: TextFormField(
                                  controller: _bookProvider
                                      .userPostsScreenSearchTextController,
                                  focusNode: _bookProvider
                                      .userPostsScreenSearchFocusNode,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    prefixIconColor: ColorManager.primary,
                                    suffixIcon: _bookProvider
                                            .userPostsScreenEnableClearSearch
                                        ? IconButton(
                                            icon: Icon(Icons.cancel_outlined),
                                            onPressed: () {
                                              _bookProvider
                                                  .userPostsScreenSearchTextController
                                                  .text = '';
                                              _bookProvider
                                                  .userPostsScreenSetEnableClearSearch(
                                                      false);

                                              // Call get Post to reload the view and also to set the next url to generic next url rather than next url of search query
                                              _bookProvider.getUserBooks(
                                                  (_bookProvider.userProvider
                                                          .user as User)
                                                      .id);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {
                                              _bookProvider
                                                  .userPostsScreenGetSearchResult(
                                                      _form);
                                            },
                                          ),
                                    suffixIconColor:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? ColorManager.primary
                                            : ColorManager.grey,
                                    labelText: 'Search',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                                        .userPostsScreenGetSearchResult(_form);
                                  },
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(
                                milliseconds:
                                    700), // Adjust the duration as needed
                            curve:
                                Curves.easeInOut, // Adjust the curve as desired
                            width: _bookProvider.userPostsScreenShowFilterButton
                                ? AppHeight.h60
                                : 0, // Define the desired height when visible or hidden
                            child: CircleAvatar(
                              backgroundColor: ColorManager.black,
                              radius: 20,
                              child: !_bookProvider
                                      .userPostsScreenShowFilterButton
                                  ? null
                                  : IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          barrierColor:
                                              ColorManager.blackWithLowOpacity,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      AppRadius.r20),
                                                  topRight: Radius.circular(
                                                      AppRadius.r20))),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppPadding.p20,
                                              ),
                                              child: BookFiltersWidget(
                                                  booksToFilter:
                                                      _bookProvider.books),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.settings),
                                      color: ColorManager.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: _bookProvider.loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  controller:
                      _bookProvider.userPostsScreenGetScrollController(),
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: AppPadding.p12,
                    ),
                    child: Column(
                      children: [
                        Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) =>
                              SizedBox(
                            height: AppHeight.h75,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryProvider.categories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: FilterChip(
                                      label: Text(
                                        categoryProvider.categories[index].name,
                                        style: _bookProvider
                                                    .userPostsScreenSelectedCategoryIndex ==
                                                index
                                            ? getBoldStyle(
                                                // color: ColorManager.black,
                                                color: ColorManager.white,
                                              )
                                            : getMediumStyle(
                                                color: ColorManager.black,
                                              ),
                                      ),
                                      showCheckmark: false,
                                      selected: _bookProvider
                                              .userPostsScreenSelectedCategoryIndex ==
                                          index,
                                      onSelected: (bool isSelected) async {
                                        if (_bookProvider
                                                .userPostsScreenSelectedCategoryIndex !=
                                            index) {
                                          _bookProvider
                                                  .userPostsScreenSelectedCategoryIndex =
                                              index;
                                          if (categoryProvider
                                                  .categories[_bookProvider
                                                      .userPostsScreenSelectedCategoryIndex]
                                                  .name
                                                  .toLowerCase() !=
                                              'all') {
                                            _bookProvider.getBooksByCategory(
                                                _bookProvider.sessionProvider
                                                    .session as Session,
                                                _bookProvider
                                                    .categoryProvider
                                                    .categories[_bookProvider
                                                            .userPostsScreenSelectedCategoryIndex -
                                                        1]
                                                    .id
                                                    .toString());
                                          } else
                                            _bookProvider.getBooksAnnonimusly(
                                                _bookProvider.sessionProvider
                                                    .session as Session);
                                        }
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ),
                        if (_bookProvider
                            .bookFiltersProvider.showFilteredResult)
                          Consumer<BookFiltersProvider>(
                            builder: (ctx, books, child) {
                              if (books.filteredBooks.length <= 0) {
                                return Center(
                                  child: Text(
                                    'No books found',
                                    style: getBoldStyle(
                                        fontSize: FontSize.s20,
                                        color: ColorManager.primary),
                                  ),
                                );
                              } else {
                                return MasonryGridView.builder(
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
                                  itemCount: books.filteredBooks.length,
                                  itemBuilder: (ctx, idx) => PostNew(
                                    book: books.filteredBooks[idx],
                                  ),
                                );
                              }
                            },
                          )
                        else if (_bookProvider
                                .userPostsScreenSearchTextController
                                .text
                                .isNotEmpty &&
                            _bookProvider.books.isEmpty)
                          Center(
                            child: Text(
                              'No books found',
                              style: getBoldStyle(
                                  fontSize: FontSize.s20,
                                  color: ColorManager.primary),
                            ),
                          )
                        else if (_bookProvider.books.isNotEmpty)
                          MasonryGridView.builder(
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
                            itemCount: _bookProvider.books.length,
                            itemBuilder: (ctx, idx) => PostNew(
                              book: _bookProvider.books[idx],
                            ),
                          )
                        else
                          Center(
                            child: Text(
                              'No books found',
                              style: getBoldStyle(
                                  fontSize: FontSize.s20,
                                  color: ColorManager.primary),
                            ),
                          ),
                        _bookProvider.homeScreenNewLoadingMorePosts
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p18,
                                ),
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
          drawer: AppDrawer(),
        ),
      ),
    );
  }
}
