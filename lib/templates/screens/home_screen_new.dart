import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_learning/models/post_category.dart';
import 'package:share_learning/view_models/providers/category_provider.dart';
import 'package:share_learning/view_models/providers/book_filters_provider.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'package:share_learning/templates/utils/system_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/book_filters.dart';
import 'package:share_learning/templates/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/widgets/post_new.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/session.dart';
import '../../models/user.dart';
import '../../view_models/providers/book_provider.dart';
import '../../view_models/providers/session_provider.dart';
import '../../view_models/providers/user_provider.dart';
import '../managers/routes_manager.dart';
import '../utils/user_helper.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  // static const routeName = '/home-new';

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew>
    with WidgetsBindingObserver {
  final _form = GlobalKey<FormState>();
  BookProvider? bookProvider;

  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);

    bookProvider!.bindHomeScreenNew(context);

    // Register this object as an observer
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookProvider!.getBooksAnnonimusly(
          Provider.of<SessionProvider>(context, listen: false).session
              as Session);
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
    bookProvider!.unBindHomeScreenNew();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();

    _bookProvider.setBillingInfo();

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
                          onPressed: () => Navigator.pushNamed(context,
                              RoutesManager.userProfileEditScreenRoute),
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
                          // key: _bookProvider.homeScreenNewSearchFormKey,
                          key: _form,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: TextFormField(
                                controller: _bookProvider
                                    .homeScreenNewSearchTextController,
                                focusNode:
                                    _bookProvider.homeScreenNewSearchFocusNode,
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
                                          .homeScreenNewEnableClearSearch
                                      ? IconButton(
                                          icon: Icon(Icons.cancel_outlined),
                                          onPressed: () {
                                            _bookProvider
                                                .homeScreenNewSearchTextController
                                                .text = '';
                                            _bookProvider
                                                .homeScreenNewSetEnableClearSearch(
                                                    false);

                                            // Call get Post to reload the view and also to set the next url to generic next url rather than next url of search query
                                            _bookProvider.getBooksAnnonimusly(
                                                _bookProvider.sessionProvider
                                                    .session as Session);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            _bookProvider
                                                .homeScreenNewGetSearchResult(
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
                                  _bookProvider
                                      .homeScreenNewGetSearchResult(_form);
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
                          width: _bookProvider.homeScreenNewShowFilterButton
                              ? AppHeight.h60
                              : 0, // Define the desired height when visible or hidden
                          child: CircleAvatar(
                            backgroundColor: ColorManager.black,
                            radius: 20,
                            child: !_bookProvider.homeScreenNewShowFilterButton
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
                                                booksToFilter:
                                                    _bookProvider.books),
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

        body: _bookProvider.loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                // controller: _bookProvider.scrollController,
                controller: _bookProvider.homeScreenNewGetScrollController(),
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
                            itemCount:
                                _bookProvider.homeScreenNewCategories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: FilterChip(
                                  label: Text(
                                    _bookProvider
                                        .homeScreenNewCategories[index].name,
                                    style: _bookProvider
                                                .homeScreenNewSelectedCategoryIndex ==
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
                                  selected: _bookProvider
                                          .homeScreenNewSelectedCategoryIndex ==
                                      index,
                                  onSelected: (bool isSelected) async {
                                    if (_bookProvider
                                            .homeScreenNewSelectedCategoryIndex !=
                                        index) {
                                      _bookProvider
                                              .homeScreenNewSelectedCategoryIndex =
                                          index;
                                      if (_bookProvider
                                              .homeScreenNewCategories[_bookProvider
                                                  .homeScreenNewSelectedCategoryIndex]
                                              .name
                                              .toLowerCase() !=
                                          'all') {
                                        _bookProvider.getBooksByCategory(
                                            _bookProvider.sessionProvider
                                                .session as Session,
                                            _bookProvider
                                                .categoryProvider
                                                .categories[_bookProvider
                                                        .homeScreenNewSelectedCategoryIndex -
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
                      if (_bookProvider.bookFiltersProvider.showFilteredResult)
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
                      else if (_bookProvider.homeScreenNewSearchTextController
                              .text.isNotEmpty &&
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
        // drawer: AppDrawer(authenticatedSession, null),
        drawer: AppDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 0,
        ),
      ),
    );
  }
}




















// class HomeScreenNew extends StatefulWidget {
//   const HomeScreenNew({Key? key}) : super(key: key);

//   static const routeName = '/home_new';

//   @override
//   State<HomeScreenNew> createState() => _HomeScreenNewState();
// }

// class _HomeScreenNewState extends State<HomeScreenNew> {
//   final _form = GlobalKey<FormState>();
//   // final _filterForm = GlobalKey<FormState>();
//   late int _selectedCategoryIndex;

//   final _searchTextController = TextEditingController();
//   late FocusNode _searchFocusNode;
//   final _scrollController = ScrollController();
//   ValueNotifier<bool> _loadingMorePosts = ValueNotifier<bool>(false);

//   // This flag will be used to render either send button or clear button on search bar. I need to use this because i can't clear the search bar if searchtext is not empty because the search will not work on text change but on button click. So the search might not have been completed even if the text is not empty
//   bool _enableClearSearch = false;

//   User _user = new User(
//       id: "temp",
//       firstName: 'firstName',
//       lastName: 'lastName',
//       username: 'username',
//       email: 'email',
//       phone: 'phone',
//       image: null,
//       description: 'description',
//       userClass: 'userClass',
//       followers: 'followers',
//       createdDate: DateTime.now());

//   void _scrollListener() async {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       BookProvider books = Provider.of<BookProvider>(context, listen: false);
//       if (books.nextPageUrl != null) {
//         _loadingMorePosts.value = true;
//         await books
//             .getMoreBooks(Provider.of<BookProvider>(context, listen: false)
//                 .nextPageUrl as String)
//             .then((_) => _loadingMorePosts.value = false);
//       }
//     }
//   }

//   @override
//   void initState() {
//     _selectedCategoryIndex = 0;
//     _searchFocusNode = FocusNode();
//     _scrollController.addListener(_scrollListener);
//     super.initState();
//   }

//   _getSearchResult(Session authSession) async {
//     final _isValid = _form.currentState!.validate();
//     if (!_isValid) {
//       return false;
//     }
//     _form.currentState!.save();

//     _searchFocusNode.unfocus();
//     _selectedCategoryIndex = 0;
//     setState(() {
//       _enableClearSearch = true;
//     });
//   }

//   @override
//   void dispose() {
//     _searchTextController.dispose();
//     _searchFocusNode.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Session authenticatedSession =
//         Provider.of<SessionProvider>(context).session as Session;

//     // Registering FMC Device sarts here
//     FCMDeviceHelper.registerDeviceToFCM(authenticatedSession);
//     // Registering FMC Device ends here

//     UserProvider _users = context.watch<UserProvider>();
//     if (_users.user == null) {
//       _users.getUserByToken(authenticatedSession.accessToken);
//     } else {
//       _user = _users.user as User;
//     }
//     // Books _books = context.watch<Books>();
//     BookProvider _books = Provider.of<BookProvider>(context, listen: false);
//     // Orders _orders = context.watch<Orders>();

//     CategoryProvider _categoryProvider =
//         Provider.of<CategoryProvider>(context, listen: false);

//     List<PostCategory> _categories = _categoryProvider.categories;
//     _categories.insert(
//       0,
//       PostCategory(id: 0, name: 'All', postsCount: _books.books.length),
//     );

//     BookFiltersProvider _bookFilters = context.watch<BookFiltersProvider>();

//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.transparent,
//             // toolbarHeight: MediaQuery.of(context).size.height * 0.15,
//             toolbarHeight: 15.h,

//             flexibleSpace: Stack(
//               children: [
//                 Container(
//                   height: 12.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25),
//                     ),
//                     color: ColorManager.primary,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: ColorManager.black,
//                             radius: 20,
//                             child: Builder(
//                               builder: (context) {
//                                 return IconButton(
//                                   icon: Icon(
//                                     Icons.menu,
//                                     size: AppSize.s22,
//                                   ),
//                                   onPressed: () =>
//                                       Scaffold.of(context).openDrawer(),
//                                   color: ColorManager.white,
//                                 );
//                               },
//                             ),
//                           ),
//                           IconButton(
//                             padding: const EdgeInsets.only(
//                               right: AppPadding.p20,
//                               top: AppPadding.p4,
//                               bottom: AppPadding.p4,
//                             ),
//                             iconSize: AppSize.s40,
//                             onPressed: () => Navigator.pushNamed(
//                                 context, RoutesManager.userProfileEditScreenRoute),
//                             // icon: _user.id != "temp"
//                             //     ?

//                             //     _user.image == null
//                             //         ? CircleAvatar(
//                             //             // radius: AppRadius.r24,
//                             //             backgroundImage:
//                             //                 AssetImage(ImageAssets.noProfile),
//                             //           )
//                             //         : CircleAvatar(
//                             //             backgroundImage: NetworkImage(
//                             //                 UserHelper.userProfileImage(_user)),
//                             //           )
//                             //     : FutureBuilder(
//                             icon: FutureBuilder(
//                               future: _users.getUserByToken(
//                                   authenticatedSession.accessToken),
//                               builder: (ctx, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return CircularProgressIndicator(
//                                     color: ColorManager.secondary,
//                                   );
//                                 } else {
//                                   if (snapshot.hasError) {
//                                     return CircleAvatar(
//                                       backgroundImage:
//                                           AssetImage(ImageAssets.noProfile),
//                                     );
//                                   } else {
//                                     if (snapshot.data is UserError) {
//                                       UserError error =
//                                           snapshot.data as UserError;
//                                       return Text(error.message as String);
//                                     } else {
//                                       _user = snapshot.data as User;
//                                       return _user.image == null
//                                           ? CircleAvatar(
//                                               backgroundImage: AssetImage(
//                                                   ImageAssets.noProfile),
//                                             )
//                                           : CircleAvatar(
//                                               backgroundImage: NetworkImage(
//                                                   // _user.image == null
//                                                   //     ? RemoteManager.IMAGE_PLACEHOLDER
//                                                   //     :
//                                                   UserHelper.userProfileImage(
//                                                       _user)),
//                                             );
//                                     }
//                                   }
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: AppHeight.h20,
//                       ),
//                       Row(
//                         children: [
//                           Form(
//                             key: _form,
//                             child: Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 12),
//                                 child: TextFormField(
//                                   controller: _searchTextController,
//                                   focusNode: _searchFocusNode,
//                                   cursorColor: ColorManager.primary,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: ColorManager.primary,
//                                       ),
//                                     ),
//                                     prefixIcon: Icon(Icons.search),
//                                     prefixIconColor: ColorManager.primary,
//                                     suffixIcon: _enableClearSearch
//                                         ? IconButton(
//                                             icon: Icon(Icons.cancel_outlined),
//                                             onPressed: () {
//                                               setState(() {
//                                                 _searchTextController.text = '';
//                                                 _enableClearSearch = false;
//                                               });
//                                             },
//                                           )
//                                         : IconButton(
//                                             icon: Icon(Icons.send),
//                                             onPressed: () {
//                                               _getSearchResult(
//                                                   authenticatedSession);
//                                             },
//                                           ),
//                                     suffixIconColor: ColorManager.primary,
//                                     fillColor: ColorManager
//                                         .white, // Change the background color
//                                     filled: true,
//                                     focusColor: ColorManager
//                                         .grey, // Change the background color
//                                     labelText: 'Search',
//                                     floatingLabelBehavior:
//                                         FloatingLabelBehavior.never,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors
//                                             .red, // Change the border color if needed
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors
//                                             .red, // Change the border color if needed
//                                       ),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                   textInputAction: TextInputAction.done,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please provide the bookName';
//                                     }
//                                     return null;
//                                   },
//                                   onFieldSubmitted: (_) {
//                                     _getSearchResult(authenticatedSession);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           AnimatedContainer(
//                             duration: const Duration(
//                                 milliseconds:
//                                     700), // Adjust the duration as needed
//                             curve:
//                                 Curves.easeInOut, // Adjust the curve as desired
//                             width: _enableClearSearch
//                                 ? AppHeight.h60
//                                 : 0, // Define the desired height when visible or hidden
//                             child: CircleAvatar(
//                               backgroundColor: ColorManager.black,
//                               radius: 20,
//                               child: !_enableClearSearch
//                                   ? null
//                                   : IconButton(
//                                       onPressed: () {
//                                         showModalBottomSheet(
//                                           barrierColor:
//                                               ColorManager.blackWithLowOpacity,
//                                           isScrollControlled: true,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(
//                                                       AppRadius.r20),
//                                                   topRight: Radius.circular(
//                                                       AppRadius.r20))),
//                                           context: context,
//                                           builder: (context) {
//                                             return Container(
//                                               // height: MediaQuery.of(context)
//                                               //         .size
//                                               //         .height *
//                                               //     0.9,
//                                               height: 9.h,
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: AppPadding.p20,
//                                               ),
//                                               child: BookFiltersWidget(),
//                                             );
//                                           },
//                                         );
//                                       },
//                                       icon: Icon(Icons.settings),
//                                       color: ColorManager.white,
//                                     ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: SingleChildScrollView(
//             controller: _scrollController,
//             child: Container(
//               padding: EdgeInsets.only(
//                 bottom: AppPadding.p12,
//               ),
//               // color: ColorManager.lighterGrey,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: AppHeight.h75,
//                     child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _categories.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 6),
//                             child: FilterChip(
//                               label: Text(
//                                 _categories[index].name,
//                                 style: _selectedCategoryIndex == index
//                                     ? getBoldStyle(
//                                         // color: ColorManager.black,
//                                         color: ColorManager.white,
//                                       )
//                                     : getMediumStyle(
//                                         color: ColorManager.black,
//                                       ),
//                               ),
//                               selectedColor: ColorManager.primary,
//                               showCheckmark: false,
//                               selected: _selectedCategoryIndex == index,
//                               onSelected: (bool isSelected) async {
//                                 setState(() {
//                                   _selectedCategoryIndex = index;
//                                 });
//                               },
//                             ),
//                           );
//                         }),
//                   ),
//                   if (_bookFilters.showFilteredResult)
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
//                               authSession: authenticatedSession,
//                             ),
//                           );
//                         }
//                       },
//                     )
//                   else
//                     FutureBuilder(
//                       future: _searchTextController.text.isNotEmpty
//                           ? _books.searchBooks(
//                               authenticatedSession, _searchTextController.text)
//                           : _categories[_selectedCategoryIndex]
//                                       .name
//                                       .toLowerCase() ==
//                                   'all'
//                               ? _books.getBooksAnnonimusly(authenticatedSession)
//                               : _books.getBooksByCategory(
//                                   authenticatedSession,
//                                   _categories[_selectedCategoryIndex]
//                                       .id
//                                       .toString()),
//                       builder: (ctx, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(
//                               color: ColorManager.primary,
//                             ),
//                           );
//                         } else {
//                           if (snapshot.hasError) {
//                             return Center(
//                               child: Text('Error'),
//                             );
//                           } else {
//                             return Consumer<BookProvider>(
//                               builder: (ctx, books, child) {
//                                 return books.books.length <= 0
//                                     ? Center(
//                                         child: Text(
//                                           'No books found',
//                                           style: getBoldStyle(
//                                               fontSize: FontSize.s20,
//                                               color: ColorManager.primary),
//                                         ),
//                                       )
//                                     : MasonryGridView.builder(
//                                         // controller: _scrollController,
//                                         physics: NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         crossAxisSpacing: 12,
//                                         mainAxisSpacing: 12,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: AppPadding.p8,
//                                         ),
//                                         gridDelegate:
//                                             SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                                                 crossAxisCount: 2),
//                                         itemCount: books.books.length,
//                                         itemBuilder: (ctx, idx) => PostNew(
//                                           book: books.books[idx],
//                                           authSession: authenticatedSession,
//                                         ),
//                                       );
//                               },
//                             );
//                           }
//                         }
//                       },
//                     ),
//                   ValueListenableBuilder(
//                       valueListenable: _loadingMorePosts,
//                       builder: (BuildContext context, bool loadingMorePosts,
//                           Widget? child) {
//                         return loadingMorePosts
//                             ? Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: AppPadding.p18,
//                                 ),
//                                 child: CircularProgressIndicator(
//                                   color: Colors.red,
//                                 ),
//                               )
//                             : Container();
//                       }),
//                 ],
//               ),
//             ),
//           ),
//           // drawer: AppDrawer(authenticatedSession, null),
//           drawer: AppDrawer(authenticatedSession),
//           bottomNavigationBar: CustomBottomNavigationBar(
//             index: 0,
//           )),
//     );

//     }
// }
