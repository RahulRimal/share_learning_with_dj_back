import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/post.dart';

import '../../models/post_category.dart';
import '../../providers/categories.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import '../widgets/book_filters.dart';
import '../widgets/post_new.dart';

class UserPostsScreen extends StatefulWidget {
  static const routeName = '/user-posts';

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  final _form = GlobalKey<FormState>();
  late int _selectedCategoryIndex;
  late List<Book> _userBooks;
  // Making it nullable because i can check it for empty and not empty to show no books found text if list is not null but is empty, if we initialize it with empty list then we can't check if search result is empty
  List<Book>? filteredBooks;

  final _searchTextController = TextEditingController();
  final _searchFocusNode = FocusNode();

  _searchUserBooks(List<Book> allBooks) {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    _form.currentState!.save();

    _searchFocusNode.unfocus();
    _selectedCategoryIndex = 0;

    String searchTerm = _searchTextController.text.toLowerCase();

    List<Book> _filteredBookList = [];

    for (Book book in allBooks) {
      if (book.bookName.toLowerCase().contains(searchTerm)) {
        _filteredBookList.add(book);
      }
    }

    setState(() {
      filteredBooks = _filteredBookList;
    });
  }

  @override
  void initState() {
    _selectedCategoryIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Object? args = ModalRoute.of(context)!.settings.arguments;
    String? _selectedUserId;
    if (args != null) {
      _selectedUserId = (args as Map)['userId'];
    }

    Users users = Provider.of<Users>(context);
    Session loggedInUserSession =
        Provider.of<SessionProvider>(context).session as Session;

    users.getUserByToken(loggedInUserSession.accessToken);

    List<Book> _allPosts =
        Provider.of<Books>(context).postsByUser(users.user!.id);

    Books _books = Provider.of<Books>(context, listen: false);
    Categories _categoryProvider =
        Provider.of<Categories>(context, listen: false);

    List<PostCategory> _categories = _categoryProvider.categories;
    _categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: _books.books.length),
    );

    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(loggedInUserSession),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: ColorManager.lightGrey,
          toolbarHeight: MediaQuery.of(context).size.height * 0.16,
          flexibleSpace: Stack(
            children: [
              // Background container with rounded corners
              Container(
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
                        _selectedUserId != null
                            ? FutureBuilder(
                                future: users.getUserById(_selectedUserId),
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
                            : Text(
                                'Your Posts',
                                style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: users.user != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    UserHelper.userProfileImage(
                                        users.user as User),
                                  ),
                                )
                              : FutureBuilder(
                                  // future: users.getUserByIdAndSession(
                                  future: users.getUserById(
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
                      height: AppHeight.h8,
                    ),
                    Form(
                      key: _form,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: TextFormField(
                          controller: _searchTextController,
                          focusNode: _searchFocusNode,
                          cursorColor: ColorManager.primary,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: ColorManager.primary,
                            suffixIcon: filteredBooks == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.send,
                                    ),
                                    onPressed: () =>
                                        _searchUserBooks(_allPosts))
                                : IconButton(
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        filteredBooks = null;
                                        _searchTextController.text = '';
                                      });
                                    },
                                  ),
                            suffixIconColor: ColorManager.primary,
                            fillColor: ColorManager.white,
                            filled: true,
                            focusColor: ColorManager.white,
                            labelText: 'Search your posts',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            _searchUserBooks(_allPosts);
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
              if (filteredBooks != null && filteredBooks!.length <= 0)
                Center(
                  child: Text(
                    'No books found',
                    style: getBoldStyle(
                        fontSize: FontSize.s20, color: ColorManager.primary),
                  ),
                ),
              if (filteredBooks != null)
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
                  itemCount: filteredBooks!.length,
                  itemBuilder: (ctx, idx) => PostNew(
                    book: filteredBooks![idx],
                    authSession: loggedInUserSession,
                  ),
                )
              else
                FutureBuilder(
                  future: _categories[_selectedCategoryIndex]
                              .name
                              .toLowerCase() ==
                          'all'
                      ? _books.getUserBooks(_selectedUserId != null
                          ? _selectedUserId
                          : Provider.of<Users>(context, listen: false).user!.id)
                      : _books.getBooksByCategory(loggedInUserSession,
                          _categories[_selectedCategoryIndex].id.toString()),
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
                          _userBooks =
                              (snapshot.data as Map)['books'] as List<Book>;
                          return _userBooks.length <= 0
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
                                  itemCount: _userBooks.length,
                                  itemBuilder: (ctx, idx) => PostNew(
                                    book: _userBooks[idx],
                                    authSession: loggedInUserSession,
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
