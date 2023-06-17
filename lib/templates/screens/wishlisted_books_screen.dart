import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/models/post_category.dart';
import 'package:share_learning/view_models/providers/category_provider.dart';
import 'package:share_learning/view_models/providers/wishlist_provider.dart';

import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/book_filters.dart';
import 'package:share_learning/templates/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/widgets/post_new.dart';

import '../../models/book.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../view_models/providers/book_filters_provider.dart';
import '../../view_models/providers/book_provider.dart';
import '../../view_models/providers/session_provider.dart';
import '../../view_models/providers/user_provider.dart';
import '../managers/api_values_manager.dart';
import '../managers/assets_manager.dart';
import '../utils/user_helper.dart';
import 'user_profile_screen.dart';

class WishlistedBooksScreen extends StatefulWidget {
  const WishlistedBooksScreen({Key? key}) : super(key: key);

  static const routeName = '/wishlists';

  @override
  State<WishlistedBooksScreen> createState() => _WishlistedBooksScreenState();
}

class _WishlistedBooksScreenState extends State<WishlistedBooksScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<WishlistProvider>(context, listen: false)
        .bindWishlistScreenViewModel(context);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<WishlistProvider>(context, listen: false)
        .unbindWishlistScreenViewModel();
  }

  @override
  Widget build(BuildContext context) {
    WishlistProvider _wishlistProvider = context.watch<WishlistProvider>();

    return SafeArea(
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
                        IconButton(
                          padding: const EdgeInsets.only(
                            right: AppPadding.p20,
                            top: AppPadding.p4,
                            bottom: AppPadding.p4,
                          ),
                          iconSize: AppSize.s40,
                          onPressed: () => Navigator.pushNamed(
                              context, UserProfileScreen.routeName),
                          icon: (_wishlistProvider.userProvider.user as User)
                                      .image ==
                                  null
                              ? CircleAvatar(
                                  backgroundImage:
                                      AssetImage(ImageAssets.noProfile),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      UserHelper.userProfileImage(
                                          _wishlistProvider.userProvider.user
                                              as User)),
                                ),
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
                                controller: _wishlistProvider
                                    .wishlistScreenSearchTextController,
                                focusNode: _wishlistProvider
                                    .wishlistScreenSearchFocusNode,
                                cursorColor: ColorManager.primary,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: ColorManager.primary,
                                  suffixIcon: _wishlistProvider
                                          .wishlistScreenEnableClearSearch
                                      ? IconButton(
                                          icon: Icon(Icons.cancel_outlined),
                                          onPressed: () {
                                            _wishlistProvider
                                                .wishlistScreenSearchTextController
                                                .text = '';
                                            _wishlistProvider
                                                .wishlistScreenSetEnableClearSearch(
                                                    false);

                                            // Call get Post to reload the view and also to set the next url to generic next url rather than next url of search query
                                            _wishlistProvider
                                                .getWishlistedBooks(
                                                    _wishlistProvider
                                                        .sessionProvider
                                                        .session as Session);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            _wishlistProvider
                                                .wishlistScreenGetSearchResult(
                                                    _form);
                                          },
                                        ),
                                  suffixIconColor: ColorManager.primary,
                                  fillColor: ColorManager
                                      .white, // Change the background color
                                  filled: true,
                                  focusColor: ColorManager
                                      .grey, // Change the background color
                                  labelText: 'Search',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                                  _wishlistProvider
                                      .wishlistScreenGetSearchResult(_form);
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
                          width: _wishlistProvider
                                  .wishlistScreenShowFilterButton
                              ? AppHeight.h60
                              : 0, // Define the desired height when visible or hidden
                          child: CircleAvatar(
                            backgroundColor: ColorManager.black,
                            radius: 20,
                            child: !_wishlistProvider
                                    .wishlistScreenShowFilterButton
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
                                            // height: 9.h,
                                            // height: 300,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppPadding.p20,
                                            ),

                                            child: BookFiltersWidget(
                                                booksToFilter: _wishlistProvider
                                                    .wishlistedBooks),
                                            // child: BookFiltersWidget(),
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

        body: _wishlistProvider.loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                // controller: _wishlistProvider.scrollController,
                controller:
                    _wishlistProvider.wishlistScreenGetScrollController(),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: AppPadding.p12,
                  ),
                  // color: ColorManager.lighterGrey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppHeight.h75,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _wishlistProvider
                                .wishlistScreenCategories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: FilterChip(
                                  label: Text(
                                    _wishlistProvider
                                        .wishlistScreenCategories[index].name,
                                    style: _wishlistProvider
                                                .selectedCategoryIndex ==
                                            index
                                        ? getBoldStyle(
                                            // color: ColorManager.black,
                                            color: ColorManager.white,
                                          )
                                        : getMediumStyle(
                                            color: ColorManager.black,
                                          ),
                                  ),
                                  selectedColor: ColorManager.primary,
                                  showCheckmark: false,
                                  selected:
                                      _wishlistProvider.selectedCategoryIndex ==
                                          index,
                                  onSelected: (bool isSelected) async {
                                    if (_wishlistProvider
                                            .selectedCategoryIndex !=
                                        index) {
                                      _wishlistProvider.selectedCategoryIndex =
                                          index;
                                      if (_wishlistProvider
                                              .wishlistScreenCategories[
                                                  _wishlistProvider
                                                      .selectedCategoryIndex]
                                              .name
                                              .toLowerCase() !=
                                          'all') {
                                        _wishlistProvider.getWishlistsByBookCategory(
                                            _wishlistProvider.sessionProvider
                                                .session as Session,
                                            _wishlistProvider
                                                .categoryProvider
                                                .categories[_wishlistProvider
                                                        .selectedCategoryIndex -
                                                    1]
                                                .id
                                                .toString());
                                      } else
                                        _wishlistProvider.getWishlistedBooks(
                                            _wishlistProvider.sessionProvider
                                                .session as Session);
                                    }
                                  },
                                ),
                              );
                            }),
                      ),
                      if (_wishlistProvider
                          .bookFiltersProvider.showFilteredResult)
                        // if (_bookFiltesProvider.showFilteredResult)
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
                      else if (_wishlistProvider
                              .wishlistScreenSearchTextController
                              .text
                              .isNotEmpty &&
                          _wishlistProvider
                              .getWishlistedBooks(_wishlistProvider
                                  .sessionProvider.session as Session)
                              .isEmpty)
                        Center(
                          child: Text(
                            'No books found',
                            style: getBoldStyle(
                                fontSize: FontSize.s20,
                                color: ColorManager.primary),
                          ),
                        )
                      else if (_wishlistProvider.wishlists.isNotEmpty)
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
                          itemCount: _wishlistProvider.wishlists.length,
                          itemBuilder: (ctx, idx) => FutureBuilder(
                              future: _wishlistProvider.bookProvider
                                  .getBookByIdFromServer(
                                      _wishlistProvider.sessionProvider.session
                                          as Session,
                                      _wishlistProvider.wishlists[idx].post
                                          .toString()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: ColorManager.primary,
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Text(
                                    'Error',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s20,
                                      color: ColorManager.primary,
                                    ),
                                  );
                                } else {
                                  return PostNew(
                                    book: snapshot.data as Book,
                                  );
                                }
                              }),
                        )
                      else
                        Center(
                          child: Text(
                            'No books of ${_wishlistProvider.categoryProvider.categories[_wishlistProvider.selectedCategoryIndex - 1].name} category has been wishlisted',
                            style: getBoldStyle(
                                fontSize: FontSize.s16,
                                color: ColorManager.primary),
                          ),
                        ),
                      _wishlistProvider.wishlistScreenLoadingMorePosts
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
        // drawer: AppDrawer(authenticatedSession, null),
        drawer: AppDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 1,
        ),
      ),
    );
  }
}




// FutureBuilder(
//                   future: _wishlists.getWishlistedBooks(authenticatedSession),
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
//                         return Consumer<Wishlists>(
//                           builder: (ctx, wishlists, child) {
//                             return wishlists.wishlists.length <= 0
//                                 ? Center(
//                                     child: Text(
//                                       'No book has been wishlisted',
//                                       style: getBoldStyle(
//                                           fontSize: FontSize.s20,
//                                           color: ColorManager.primary),
//                                     ),
//                                   )
//                                 : MasonryGridView.builder(
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     crossAxisSpacing: 12,
//                                     mainAxisSpacing: 12,
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: AppPadding.p8,
//                                     ),
//                                     gridDelegate:
//                                         SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 2),
//                                     itemCount: _wishlists.wishlists.length,
//                                     itemBuilder: (ctx, idx) => FutureBuilder(
//                                         future: Provider.of<Books>(context,
//                                                 listen: false)
//                                             .getBookByIdFromServer(
//                                                 authenticatedSession,
//                                                 _wishlists.wishlists[idx].post
//                                                     .toString()),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.waiting) {
//                                             return Center(
//                                               child: CircularProgressIndicator(
//                                                 color: ColorManager.primary,
//                                               ),
//                                             );
//                                           }
//                                           if (snapshot.hasError) {
//                                             return Text(
//                                               'Error',
//                                               style: getBoldStyle(
//                                                 fontSize: FontSize.s20,
//                                                 color: ColorManager.primary,
//                                               ),
//                                             );
//                                           } else {
//                                             return PostNew(
//                                               book: snapshot.data as Book,
//                                               authSession: authenticatedSession,
//                                             );
//                                           }
//                                         }),
//                                   );
//                           },
//                         );
//                       }
//                     }
//                   },
//                 ),

// class WishlistedBooksScreen extends StatefulWidget {
//   const WishlistedBooksScreen({Key? key}) : super(key: key);

//   static const routeName = '/wishlists';

//   @override
//   State<WishlistedBooksScreen> createState() => _WishlistedBooksScreenState();
// }

// class _WishlistedBooksScreenState extends State<WishlistedBooksScreen> {
//   final _form = GlobalKey<FormState>();
  

  

//   @override
//   void initState() {
//     Provider.of<WishlistProvider>(context, listen: false).bindWishlistScreenViewModel(context);
//     super.initState();
//   }

  

//   @override
//   void dispose() {
//     Provider.of<WishlistProvider>(context, listen: false).unbindWishlistScreenViewModel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     WishlistProvider _wishlistProvider =
//         Provider.of<WishlistProvider>(context, listen: false);

    

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           // toolbarHeight: _appBarHeight,
//           elevation: 0.0,

//           leading: Padding(
//             padding: const EdgeInsets.only(left: AppPadding.p20),
//             child: CircleAvatar(
//               backgroundColor: ColorManager.black,
//               radius: 30,
//               child: Builder(
//                 builder: (context) {
//                   return IconButton(
//                     icon: Icon(
//                       Icons.menu,
//                       size: AppSize.s22,
//                     ),
//                     onPressed: () => Scaffold.of(context).openDrawer(),
//                     color: ColorManager.white,
//                   );
//                 },
//               ),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 right: AppPadding.p20,
//                 top: AppPadding.p4,
//                 bottom: AppPadding.p4,
//               ),
//               child: _wishlistProvider.userProvider.user! .id != "temp"
//                   ? CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         (UserHelper.userProfileImage(_wishlistProvider.userProvider.user!)),
//                       ),
//                     )
//                   : FutureBuilder(
//                       future: _wishlistProvider.userProvider.user!
//                           .getUserByToken(authenticatedSession.accessToken),
//                       builder: (ctx, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return CircularProgressIndicator(
//                             color: ColorManager.secondary,
//                           );
//                         } else {
//                           if (snapshot.hasError) {
//                             return CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                   'https://ojasfilms.org/assets/img/ojas-logo.png'),
//                             );
//                           } else {
//                             if (snapshot.data is UserError) {
//                               UserError error = snapshot.data as UserError;
//                               return Text(error.message as String);
//                             } else {
//                               _user = snapshot.data as User;
//                               return CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     _user.image == null
//                                         ? RemoteManager.IMAGE_PLACEHOLDER
//                                         : UserHelper.userProfileImage(_user)),
//                               );
//                             }
//                           }
//                         }
//                       },
//                     ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           // controller: _scrollController,
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: AppPadding.p12,
//             ),
//             color: ColorManager.lighterGrey,
//             child: Column(
//               children: [
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.1,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(25),
//                               bottomRight: Radius.circular(25),
//                             ),
//                             color: ColorManager.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       bottom: -10,
//                       left: 0,
//                       right: 0,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Row(
//                           children: [
//                             Form(
//                               key: _form,
//                               child: Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(right: 12),
//                                   child: TextFormField(
//                                     controller: _searchTextController,
//                                     focusNode: _searchFocusNode,
//                                     cursorColor: ColorManager.primary,
//                                     decoration: InputDecoration(
//                                       prefixIcon: Icon(Icons.search),
//                                       prefixIconColor: ColorManager.primary,
//                                       suffixIcon: IconButton(
//                                           icon: Icon(
//                                             Icons.send,
//                                           ),
//                                           onPressed: () {
//                                             _getSearchResult(
//                                                 authenticatedSession);
//                                           }),
//                                       suffixIconColor: ColorManager.primary,
//                                       fillColor: ColorManager.white,
//                                       filled: true,
//                                       focusColor: ColorManager.white,
//                                       labelText: 'Search',
//                                       floatingLabelBehavior:
//                                           FloatingLabelBehavior.never,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: ColorManager.white,
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: ColorManager.white,
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                     ),
//                                     textInputAction: TextInputAction.done,
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return 'Please provide the bookName';
//                                       }
//                                       return null;
//                                     },
//                                     onFieldSubmitted: (_) {
//                                       _getSearchResult(authenticatedSession);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CircleAvatar(
//                               backgroundColor: ColorManager.black,
//                               radius: 25,
//                               child: IconButton(
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                     barrierColor:
//                                         ColorManager.blackWithLowOpacity,
//                                     isScrollControlled: true,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                             topLeft:
//                                                 Radius.circular(AppRadius.r20),
//                                             topRight: Radius.circular(
//                                                 AppRadius.r20))),
//                                     context: context,
//                                     builder: (context) {
//                                       // return SingleChildScrollView(
//                                       //   child: Container(
//                                       //     height: 300,
//                                       //     padding: EdgeInsets.symmetric(
//                                       //       horizontal: AppPadding.p20,
//                                       //     ),
//                                       //     child: Form(
//                                       //       key: _filterForm,
//                                       //       child: Column(
//                                       //         crossAxisAlignment:
//                                       //             CrossAxisAlignment.start,
//                                       //         children: [
//                                       //           ListTile(
//                                       //             title: Column(
//                                       //               children: [
//                                       //                 Row(
//                                       //                   mainAxisAlignment:
//                                       //                       MainAxisAlignment
//                                       //                           .spaceBetween,
//                                       //                   children: [
//                                       //                     Text(
//                                       //                       'Filters',
//                                       //                       style: getBoldStyle(
//                                       //                         fontSize:
//                                       //                             AppSize.s24,
//                                       //                         color:
//                                       //                             ColorManager
//                                       //                                 .black,
//                                       //                       ),
//                                       //                     ),
//                                       //                     IconButton(
//                                       //                       onPressed: () {},
//                                       //                       icon: Icon(
//                                       //                         Icons.cancel,
//                                       //                       ),
//                                       //                     ),
//                                       //                   ],
//                                       //                 ),
//                                       //               ],
//                                       //             ),
//                                       //           ),
//                                       //           ListTile(
//                                       //             title: Column(
//                                       //               crossAxisAlignment:
//                                       //                   CrossAxisAlignment
//                                       //                       .start,
//                                       //               children: [
//                                       //                 Padding(
//                                       //                   padding:
//                                       //                       const EdgeInsets
//                                       //                           .only(
//                                       //                     bottom: AppPadding.p4,
//                                       //                   ),
//                                       //                   child: Text(
//                                       //                     'Price Range',
//                                       //                     style: getBoldStyle(
//                                       //                       fontSize:
//                                       //                           AppSize.s16,
//                                       //                       color: ColorManager
//                                       //                           .black,
//                                       //                     ),
//                                       //                   ),
//                                       //                 ),
//                                       //                 Row(
//                                       //                   children: [
//                                       //                     Flexible(
//                                       //                       child:
//                                       //                           TextFormField(
//                                       //                         keyboardType:
//                                       //                             TextInputType
//                                       //                                 .number,
//                                       //                         decoration:
//                                       //                             InputDecoration(
//                                       //                           fillColor:
//                                       //                               ColorManager
//                                       //                                   .lighterGrey,
//                                       //                           filled: true,
//                                       //                           prefix:
//                                       //                               Text('Rs.'),
//                                       //                           label: Text(
//                                       //                             'min',
//                                       //                             style:
//                                       //                                 TextStyle(
//                                       //                               color: ColorManager
//                                       //                                   .lighterGrey,
//                                       //                             ),
//                                       //                           ),
//                                       //                         ),
//                                       //                       ),
//                                       //                     ),
//                                       //                     SizedBox(
//                                       //                       width:
//                                       //                           AppMargin.m20,
//                                       //                     ),
//                                       //                     Flexible(
//                                       //                       child:
//                                       //                           TextFormField(
//                                       //                         keyboardType:
//                                       //                             TextInputType
//                                       //                                 .number,
//                                       //                         decoration:
//                                       //                             InputDecoration(
//                                       //                           prefix:
//                                       //                               Text('Rs.'),
//                                       //                           label: Text(
//                                       //                             'max',
//                                       //                             style:
//                                       //                                 TextStyle(
//                                       //                               color: Colors
//                                       //                                       .grey[
//                                       //                                   400],
//                                       //                             ),
//                                       //                           ),
//                                       //                         ),
//                                       //                       ),
//                                       //                     ),
//                                       //                   ],
//                                       //                 ),
//                                       //                 Padding(
//                                       //                   padding:
//                                       //                       const EdgeInsets
//                                       //                           .only(
//                                       //                     top: AppPadding.p12,
//                                       //                   ),
//                                       //                   child: Divider(
//                                       //                     height: 2,
//                                       //                     thickness: 2,
//                                       //                   ),
//                                       //                 ),
//                                       //               ],
//                                       //             ),
//                                       //           ),
//                                       //           ListTile(
//                                       //             title: Column(
//                                       //               crossAxisAlignment:
//                                       //                   CrossAxisAlignment
//                                       //                       .start,
//                                       //               children: [
//                                       //                 Padding(
//                                       //                   padding:
//                                       //                       const EdgeInsets
//                                       //                           .only(
//                                       //                     bottom: AppPadding.p4,
//                                       //                   ),
//                                       //                   child: Text(
//                                       //                     'Location',
//                                       //                     style: getBoldStyle(
//                                       //                       fontSize:
//                                       //                           AppSize.s16,
//                                       //                       color: ColorManager
//                                       //                           .black,
//                                       //                     ),
//                                       //                   ),
//                                       //                 ),
//                                       //                 Container(
//                                       //                   decoration:
//                                       //                       BoxDecoration(
//                                       //                           border:
//                                       //                               Border.all(
//                                       //                     color: Colors.grey,
//                                       //                     width: 1.0,
//                                       //                     style:
//                                       //                         BorderStyle.solid,
//                                       //                   )),
//                                       //                   child:
//                                       //                       DropdownButtonHideUnderline(
//                                       //                     child: DropdownButton(
//                                       //                         isExpanded: true,
//                                       //                         value:
//                                       //                             locationOptions[
//                                       //                                 0],
//                                       //                         items:
//                                       //                             locationOptions
//                                       //                                 .map((option) =>
//                                       //                                     DropdownMenuItem(
//                                       //                                       child:
//                                       //                                           Text(
//                                       //                                         option,
//                                       //                                         // style:
//                                       //                                         //     getMediumStyle(
//                                       //                                         //   color: ColorManager
//                                       //                                         //       .black,
//                                       //                                         // ),
//                                       //                                       ),
//                                       //                                       value:
//                                       //                                           option,
//                                       //                                     ))
//                                       //                                 .toList(),
//                                       //                         onChanged:
//                                       //                             (value) {}),
//                                       //                   ),
//                                       //                 ),
//                                       //                 Padding(
//                                       //                   padding:
//                                       //                       const EdgeInsets
//                                       //                           .only(
//                                       //                     top: AppPadding.p12,
//                                       //                   ),
//                                       //                   child: Divider(
//                                       //                     height: 2,
//                                       //                     thickness: 2,
//                                       //                   ),
//                                       //                 ),
//                                       //               ],
//                                       //             ),
//                                       //           ),
//                                       //         ],
//                                       //       ),
//                                       //     ),
//                                       //   ),
//                                       // );
//                                       return Container(
//                                         height:
//                                             MediaQuery.of(context).size.height *
//                                                 0.9,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: AppPadding.p20,
//                                         ),
//                                         child: BookFiltersWidget(
//                                             booksToFilter:
//                                                 _wishlists.wishlistedBooks),
//                                         // child: BookFiltersWidget(),
//                                       );
//                                     },
//                                   );
//                                 },
//                                 icon: Icon(Icons.settings),
//                                 color: ColorManager.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _categories.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 6),
//                           child: FilterChip(
//                             label: Text(_categories[index].name),
//                             selectedColor: ColorManager.primary,
//                             // selectedColor: _searchTextController.text.isEmpty ? ColorManager.primary: ColorManager.lightGrey,
//                             showCheckmark: false,
//                             selected: _selectedCategoryIndex == index,
//                             onSelected: (bool isSelected) async {
//                               setState(() {
//                                 _searchTextController.text = '';
//                                 _selectedCategoryIndex = index;
//                               });
//                             },
//                           ),
//                         );
//                       }),
//                 ),
//                 FutureBuilder(
//                   future: _searchTextController.text.isNotEmpty
//                       ? _wishlists.searchBooks(
//                           authenticatedSession, _searchTextController.text)
//                       : _categories[_selectedCategoryIndex]
//                                   .name
//                                   .toLowerCase() ==
//                               'all'
//                           ? _wishlists.getWishlistedBooks(authenticatedSession)
//                           : _wishlists.getWishlistsByBookCategory(
//                               authenticatedSession,
//                               _categories[_selectedCategoryIndex]
//                                   .id
//                                   .toString()),
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
//                         return Consumer<WishlistProvider>(
//                           builder: (ctx, wishlists, child) {
//                             return wishlists.wishlists.length <= 0
//                                 ? Center(
//                                     child: Text(
//                                       'No book has been wishlisted',
//                                       style: getBoldStyle(
//                                           fontSize: FontSize.s20,
//                                           color: ColorManager.primary),
//                                     ),
//                                   )
//                                 : MasonryGridView.builder(
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     crossAxisSpacing: 12,
//                                     mainAxisSpacing: 12,
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: AppPadding.p8,
//                                     ),
//                                     gridDelegate:
//                                         SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 2),
//                                     itemCount: _wishlists.wishlists.length,
//                                     itemBuilder: (ctx, idx) => FutureBuilder(
//                                         future: Provider.of<BookProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .getBookByIdFromServer(
//                                                 authenticatedSession,
//                                                 _wishlists.wishlists[idx].post
//                                                     .toString()),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.connectionState ==
//                                               ConnectionState.waiting) {
//                                             return Center(
//                                               child: CircularProgressIndicator(
//                                                 color: ColorManager.primary,
//                                               ),
//                                             );
//                                           }
//                                           if (snapshot.hasError) {
//                                             return Text(
//                                               'Error',
//                                               style: getBoldStyle(
//                                                 fontSize: FontSize.s20,
//                                                 color: ColorManager.primary,
//                                               ),
//                                             );
//                                           } else {
//                                             return PostNew(
//                                               book: snapshot.data as Book,
//                                               // authSession: authenticatedSession,
//                                             );
//                                           }
//                                         }),
//                                   );
//                           },
//                         );
//                       }
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // drawer: AppDrawer(authenticatedSession, null),
//         drawer: AppDrawer(authenticatedSession),
//         bottomNavigationBar: CustomBottomNavigationBar(
//           index: 1,
//         ),
//       ),
//     );
//   }
// }




// // FutureBuilder(
// //                   future: _wishlists.getWishlistedBooks(authenticatedSession),
// //                   builder: (ctx, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return Center(
// //                         child: CircularProgressIndicator(
// //                           color: ColorManager.primary,
// //                         ),
// //                       );
// //                     } else {
// //                       if (snapshot.hasError) {
// //                         return Center(
// //                           child: Text('Error'),
// //                         );
// //                       } else {
// //                         return Consumer<Wishlists>(
// //                           builder: (ctx, wishlists, child) {
// //                             return wishlists.wishlists.length <= 0
// //                                 ? Center(
// //                                     child: Text(
// //                                       'No book has been wishlisted',
// //                                       style: getBoldStyle(
// //                                           fontSize: FontSize.s20,
// //                                           color: ColorManager.primary),
// //                                     ),
// //                                   )
// //                                 : MasonryGridView.builder(
// //                                     physics: NeverScrollableScrollPhysics(),
// //                                     shrinkWrap: true,
// //                                     crossAxisSpacing: 12,
// //                                     mainAxisSpacing: 12,
// //                                     padding: EdgeInsets.symmetric(
// //                                       horizontal: AppPadding.p8,
// //                                     ),
// //                                     gridDelegate:
// //                                         SliverSimpleGridDelegateWithFixedCrossAxisCount(
// //                                             crossAxisCount: 2),
// //                                     itemCount: _wishlists.wishlists.length,
// //                                     itemBuilder: (ctx, idx) => FutureBuilder(
// //                                         future: Provider.of<Books>(context,
// //                                                 listen: false)
// //                                             .getBookByIdFromServer(
// //                                                 authenticatedSession,
// //                                                 _wishlists.wishlists[idx].post
// //                                                     .toString()),
// //                                         builder: (context, snapshot) {
// //                                           if (snapshot.connectionState ==
// //                                               ConnectionState.waiting) {
// //                                             return Center(
// //                                               child: CircularProgressIndicator(
// //                                                 color: ColorManager.primary,
// //                                               ),
// //                                             );
// //                                           }
// //                                           if (snapshot.hasError) {
// //                                             return Text(
// //                                               'Error',
// //                                               style: getBoldStyle(
// //                                                 fontSize: FontSize.s20,
// //                                                 color: ColorManager.primary,
// //                                               ),
// //                                             );
// //                                           } else {
// //                                             return PostNew(
// //                                               book: snapshot.data as Book,
// //                                               authSession: authenticatedSession,
// //                                             );
// //                                           }
// //                                         }),
// //                                   );
// //                           },
// //                         );
// //                       }
// //                     }
// //                   },
// //                 ),