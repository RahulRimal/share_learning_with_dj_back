import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_learning/models/post_category.dart';
import 'package:share_learning/providers/categories.dart';
import 'package:share_learning/providers/wishlists.dart';

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
import '../../providers/books.dart';
import '../../providers/orders.dart';
import '../../providers/sessions.dart';
import '../../providers/users.dart';
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
  final _filterForm = GlobalKey<FormState>();
  int _selectedIndex = 0;

  List<PostCategory> _categories = [
    new PostCategory(
        id: 1, name: "Adventure", postsCount: 0, featuredPost: null),
    new PostCategory(id: 2, name: "Drama", postsCount: 0, featuredPost: null),
    new PostCategory(id: 3, name: "Comic", postsCount: 0, featuredPost: null),
    new PostCategory(
        id: 4, name: "Biography", postsCount: 0, featuredPost: null),
    new PostCategory(
        id: 5, name: "Scientific", postsCount: 0, featuredPost: null),
    new PostCategory(id: 6, name: "Food", postsCount: 0, featuredPost: null),
  ];

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

  @override
  Widget build(BuildContext context) {
    Session authenticatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    Users _users = context.watch<Users>();
    if (_users.user == null) {
      _users.getUserByToken(authenticatedSession.accessToken);
    } else {
      _user = _users.user as User;
    }
    // Wishlists _wishlists = context.watch<Wishlists>();
    Wishlists _wishlists = Provider.of<Wishlists>(context, listen: false);
    Orders _orders = context.watch<Orders>();

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
          child: Container(
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
                                    cursorColor: ColorManager.white,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      prefixIconColor: ColorManager.primary,
                                      fillColor: ColorManager.white,
                                      filled: true,
                                      focusColor: ColorManager.white,
                                      labelText: 'Search',
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
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please provide the bookName';
                                      }
                                      return null;
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
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.p20,
                                        ),
                                        child: BookFiltersWidget(),
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
                  child: FutureBuilder(
                    future: Provider.of<Categories>(context, listen: false)
                        .getCategories(authenticatedSession),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            _categories =
                                Provider.of<Categories>(context, listen: false)
                                    .categories;
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: FilterChip(
                                      label: Text(_categories[index].name),
                                      selectedColor: ColorManager.primary,
                                      showCheckmark: false,
                                      selected: _selectedIndex == index,
                                      onSelected: (bool isSelected) {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                      },
                                    ),
                                  );
                                });
                          }
                        }
                      }
                    },
                  ),
                ),
                FutureBuilder(
                  future: _wishlists.getWishlistedBooks(authenticatedSession),
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
                        return Consumer<Wishlists>(
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
                                        future: Provider.of<Books>(context,
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
                                              authSession: authenticatedSession,
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
        drawer: AppDrawer(authenticatedSession, null),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 1,
        ),
      ),
    );
  }
}
