import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_learning/models/post_category.dart';
import 'package:share_learning/view_models/category_provider.dart';
import 'package:share_learning/view_models/wishlist_provider.dart';

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
import '../../view_models/book_provider.dart';
import '../../view_models/session_provider.dart';
import '../../view_models/user_provider.dart';
import '../managers/api_values_manager.dart';
import '../utils/user_helper.dart';

class WishlistedBooksScreen extends StatefulWidget {
  const WishlistedBooksScreen({Key? key}) : super(key: key);

  static const routeName = '/wishlists';

  @override
  State<WishlistedBooksScreen> createState() => _WishlistedBooksScreenState();
}

class _WishlistedBooksScreenState extends State<WishlistedBooksScreen> {
  final _form = GlobalKey<FormState>();
  // final _filterForm = GlobalKey<FormState>();
  late int _selectedCategoryIndex;

  final _searchTextController = TextEditingController();
  final _searchFocusNode = FocusNode();

  User _user = new User(
      id: "temp",
      firstName: 'firstName',
      lastName: 'lastName',
      username: 'username',
      email: 'email',
      phone: 'phone',
      image: null,
      description: 'description',
      userClass: 'userClass',
      followers: 'followers',
      createdDate: DateTime.now());

  // List<PostCategory> _categories = [];

  // ScrollController _scrollController = ScrollController();

  // double _appBarHeight = 75.0;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(_scrollListener);
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_scrollListener);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // void _scrollListener() {
  //   setState(() {
  //     if (_scrollController.offset > 0 && _scrollController.offset < 30) {
  //       _appBarHeight = 75.0 - _scrollController.offset;
  //     } else if (_scrollController.offset >= 30) {
  //       _appBarHeight = 50.0;
  //     } else {
  //       _appBarHeight = 75.0;
  //     }
  //   });
  // }

  @override
  void initState() {
    _selectedCategoryIndex = 0;
    super.initState();
  }

  _getSearchResult(Session authSession) async {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    _form.currentState!.save();
    _searchFocusNode.unfocus();
    _selectedCategoryIndex = 0;
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Session authenticatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    UserProvider _users = context.watch<UserProvider>();
    if (_users.user == null) {
      _users.getUserByToken(authenticatedSession.accessToken);
    } else {
      _user = _users.user as User;
    }
    // Books _books = context.watch<Books>();
    BookProvider _books = Provider.of<BookProvider>(context, listen: false);
    WishlistProvider _wishlists =
        Provider.of<WishlistProvider>(context, listen: false);
    // Orders _orders = context.watch<Orders>();

    CategoryProvider _categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    List<PostCategory> _categories = _categoryProvider.categories;
    _categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: _books.books.length),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: _appBarHeight,
          elevation: 0.0,

          leading: Padding(
            padding: const EdgeInsets.only(left: AppPadding.p20),
            child: CircleAvatar(
              backgroundColor: ColorManager.black,
              radius: 30,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: AppSize.s22,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    color: ColorManager.white,
                  );
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p20,
                top: AppPadding.p4,
                bottom: AppPadding.p4,
              ),
              child: _user.id != "temp"
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        (UserHelper.userProfileImage(_user)),
                      ),
                    )
                  : FutureBuilder(
                      future: _users
                          .getUserByToken(authenticatedSession.accessToken),
                      builder: (ctx, snapshot) {
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
                            if (snapshot.data is UserError) {
                              UserError error = snapshot.data as UserError;
                              return Text(error.message as String);
                            } else {
                              _user = snapshot.data as User;
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _user.image == null
                                        ? RemoteManager.IMAGE_PLACEHOLDER
                                        : UserHelper.userProfileImage(_user)),
                              );
                            }
                          }
                        }
                      },
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          // controller: _scrollController,
          child: Container(
            padding: EdgeInsets.only(
              bottom: AppPadding.p12,
            ),
            color: ColorManager.lighterGrey,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -10,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Form(
                              key: _form,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextFormField(
                                    controller: _searchTextController,
                                    focusNode: _searchFocusNode,
                                    cursorColor: ColorManager.primary,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      prefixIconColor: ColorManager.primary,
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                          ),
                                          onPressed: () {
                                            _getSearchResult(
                                                authenticatedSession);
                                          }),
                                      suffixIconColor: ColorManager.primary,
                                      fillColor: ColorManager.white,
                                      filled: true,
                                      focusColor: ColorManager.white,
                                      labelText: 'Search',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
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
                                      _getSearchResult(authenticatedSession);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: ColorManager.black,
                              radius: 25,
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    barrierColor:
                                        ColorManager.blackWithLowOpacity,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(AppRadius.r20),
                                            topRight: Radius.circular(
                                                AppRadius.r20))),
                                    context: context,
                                    builder: (context) {
                                      // return SingleChildScrollView(
                                      //   child: Container(
                                      //     height: 300,
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: AppPadding.p20,
                                      //     ),
                                      //     child: Form(
                                      //       key: _filterForm,
                                      //       child: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           ListTile(
                                      //             title: Column(
                                      //               children: [
                                      //                 Row(
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment
                                      //                           .spaceBetween,
                                      //                   children: [
                                      //                     Text(
                                      //                       'Filters',
                                      //                       style: getBoldStyle(
                                      //                         fontSize:
                                      //                             AppSize.s24,
                                      //                         color:
                                      //                             ColorManager
                                      //                                 .black,
                                      //                       ),
                                      //                     ),
                                      //                     IconButton(
                                      //                       onPressed: () {},
                                      //                       icon: Icon(
                                      //                         Icons.cancel,
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           ListTile(
                                      //             title: Column(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .start,
                                      //               children: [
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets
                                      //                           .only(
                                      //                     bottom: AppPadding.p4,
                                      //                   ),
                                      //                   child: Text(
                                      //                     'Price Range',
                                      //                     style: getBoldStyle(
                                      //                       fontSize:
                                      //                           AppSize.s16,
                                      //                       color: ColorManager
                                      //                           .black,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Row(
                                      //                   children: [
                                      //                     Flexible(
                                      //                       child:
                                      //                           TextFormField(
                                      //                         keyboardType:
                                      //                             TextInputType
                                      //                                 .number,
                                      //                         decoration:
                                      //                             InputDecoration(
                                      //                           fillColor:
                                      //                               ColorManager
                                      //                                   .lighterGrey,
                                      //                           filled: true,
                                      //                           prefix:
                                      //                               Text('Rs.'),
                                      //                           label: Text(
                                      //                             'min',
                                      //                             style:
                                      //                                 TextStyle(
                                      //                               color: ColorManager
                                      //                                   .lighterGrey,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                     SizedBox(
                                      //                       width:
                                      //                           AppMargin.m20,
                                      //                     ),
                                      //                     Flexible(
                                      //                       child:
                                      //                           TextFormField(
                                      //                         keyboardType:
                                      //                             TextInputType
                                      //                                 .number,
                                      //                         decoration:
                                      //                             InputDecoration(
                                      //                           prefix:
                                      //                               Text('Rs.'),
                                      //                           label: Text(
                                      //                             'max',
                                      //                             style:
                                      //                                 TextStyle(
                                      //                               color: Colors
                                      //                                       .grey[
                                      //                                   400],
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets
                                      //                           .only(
                                      //                     top: AppPadding.p12,
                                      //                   ),
                                      //                   child: Divider(
                                      //                     height: 2,
                                      //                     thickness: 2,
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           ListTile(
                                      //             title: Column(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .start,
                                      //               children: [
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets
                                      //                           .only(
                                      //                     bottom: AppPadding.p4,
                                      //                   ),
                                      //                   child: Text(
                                      //                     'Location',
                                      //                     style: getBoldStyle(
                                      //                       fontSize:
                                      //                           AppSize.s16,
                                      //                       color: ColorManager
                                      //                           .black,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Container(
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                           border:
                                      //                               Border.all(
                                      //                     color: Colors.grey,
                                      //                     width: 1.0,
                                      //                     style:
                                      //                         BorderStyle.solid,
                                      //                   )),
                                      //                   child:
                                      //                       DropdownButtonHideUnderline(
                                      //                     child: DropdownButton(
                                      //                         isExpanded: true,
                                      //                         value:
                                      //                             locationOptions[
                                      //                                 0],
                                      //                         items:
                                      //                             locationOptions
                                      //                                 .map((option) =>
                                      //                                     DropdownMenuItem(
                                      //                                       child:
                                      //                                           Text(
                                      //                                         option,
                                      //                                         // style:
                                      //                                         //     getMediumStyle(
                                      //                                         //   color: ColorManager
                                      //                                         //       .black,
                                      //                                         // ),
                                      //                                       ),
                                      //                                       value:
                                      //                                           option,
                                      //                                     ))
                                      //                                 .toList(),
                                      //                         onChanged:
                                      //                             (value) {}),
                                      //                   ),
                                      //                 ),
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets
                                      //                           .only(
                                      //                     top: AppPadding.p12,
                                      //                   ),
                                      //                   child: Divider(
                                      //                     height: 2,
                                      //                     thickness: 2,
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // );
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.p20,
                                        ),
                                        child: BookFiltersWidget(
                                            booksToFilter:
                                                _wishlists.wishlistedBooks),
                                        // child: BookFiltersWidget(),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.settings),
                                color: ColorManager.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: FilterChip(
                            label: Text(_categories[index].name),
                            selectedColor: ColorManager.primary,
                            // selectedColor: _searchTextController.text.isEmpty ? ColorManager.primary: ColorManager.lightGrey,
                            showCheckmark: false,
                            selected: _selectedCategoryIndex == index,
                            onSelected: (bool isSelected) async {
                              setState(() {
                                _searchTextController.text = '';
                                _selectedCategoryIndex = index;
                              });
                            },
                          ),
                        );
                      }),
                ),
                FutureBuilder(
                  future: _searchTextController.text.isNotEmpty
                      ? _wishlists.searchBooks(
                          authenticatedSession, _searchTextController.text)
                      : _categories[_selectedCategoryIndex]
                                  .name
                                  .toLowerCase() ==
                              'all'
                          ? _wishlists.getWishlistedBooks(authenticatedSession)
                          : _wishlists.getWishlistsByBookCategory(
                              authenticatedSession,
                              _categories[_selectedCategoryIndex]
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
                        return Consumer<WishlistProvider>(
                          builder: (ctx, wishlists, child) {
                            return wishlists.wishlists.length <= 0
                                ? Center(
                                    child: Text(
                                      'No book has been wishlisted',
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
                                    itemCount: _wishlists.wishlists.length,
                                    itemBuilder: (ctx, idx) => FutureBuilder(
                                        future: Provider.of<BookProvider>(
                                                context,
                                                listen: false)
                                            .getBookByIdFromServer(
                                                authenticatedSession,
                                                _wishlists.wishlists[idx].post
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
                                              // authSession: authenticatedSession,
                                            );
                                          }
                                        }),
                                  );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        // drawer: AppDrawer(authenticatedSession, null),
        drawer: AppDrawer(authenticatedSession),
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