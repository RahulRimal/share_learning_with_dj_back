import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/post.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AsyncMemoizer memoizer = AsyncMemoizer();

  User user = new User(
      id: "temp",
      firstName: 'firstName',
      lastName: 'lastName',
      username: 'username',
      email: 'email',
      image: null,
      description: 'description',
      userClass: 'userClass',
      followers: 'followers',
      createdDate: DateTime.now());

  _setUserValue(User user) {
    // this.user = user;
    user = user;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Session authenticatedSession = args['authSession'] as Session;

    Users users = context.watch<Users>();
    Books books = context.watch<Books>();

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
                  ),
                ),
              ]),
              middle: Text('Home',
                  style: getBoldStyle(color: ColorManager.primary)),
              backgroundColor: ColorManager.primary,
            ),
            child: Container(
              child: Container(
                child: FutureBuilder(
                  // future: books.getBooks(authenticatedSession),
                  future: books.getBooksAnnonimusly(authenticatedSession),
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
                        return Consumer<Books>(
                          builder: (ctx, books, child) {
                            return books.books.length <= 0
                                ? Center(
                                    child: Text(
                                      'No books found',
                                      style: getBoldStyle(
                                          fontSize: FontSize.s20,
                                          color: ColorManager.primary),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: books.books.length,
                                    itemBuilder: (ctx, index) {
                                      return Post(
                                        loggedInUserSession:
                                            authenticatedSession,
                                        id: books.books[index].id,
                                        title: books.books[index].bookName,
                                        description:
                                            books.books[index].description,
                                        author: books.books[index].author,
                                        boughtTime:
                                            books.books[index].boughtDate,
                                        price: books.books[index].price,
                                        selling:
                                            books.books[index].postType == 'S'
                                                ? true
                                                : false,
                                        bookCount: books.books[index].bookCount,
                                      );
                                    },
                                  );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: user.id != "temp"
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            // (UserHelper.userProfileImage(users.user as User)),
                            (UserHelper.userProfileImage(user)),
                          ),
                        )
                      : FutureBuilder(
                          future: users.getUserByIdAndSession(
                              authenticatedSession,
                              authenticatedSession.userId),
                          builder: (ctx, snapshot) {
                            if (snapshot.data != null)
                              user = snapshot.data as User;
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
                                user = snapshot.data as User;
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
            body: Container(
              child: Container(
                child: books.books.length > 0
                    ? ListView.builder(
                        itemCount: books.books.length,
                        itemBuilder: (ctx, index) {
                          return Post(
                            loggedInUserSession: authenticatedSession,
                            id: books.books[index].id,
                            title: books.books[index].bookName,
                            description: books.books[index].description,
                            author: books.books[index].author,
                            boughtTime: books.books[index].boughtDate,
                            price: books.books[index].price,
                            selling: books.books[index].postType == 'S'
                                ? true
                                : false,
                            bookCount: books.books[index].bookCount,
                          );
                        },
                      )
                    : FutureBuilder(
                        future: books.getBooksAnnonimusly(authenticatedSession),
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
                            } else {
                              return Consumer<Books>(
                                builder: (ctx, books, child) {
                                  return books.books.length <= 0
                                      ? Center(
                                          child: Text(
                                            'No books found',
                                            style: getBoldStyle(
                                                fontSize: FontSize.s20,
                                                color: ColorManager.primary),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: books.books.length,
                                          itemBuilder: (ctx, index) {
                                            return Post(
                                              loggedInUserSession:
                                                  authenticatedSession,
                                              id: books.books[index].id,
                                              title:
                                                  books.books[index].bookName,
                                              description: books
                                                  .books[index].description,
                                              author: books.books[index].author,
                                              boughtTime:
                                                  books.books[index].boughtDate,
                                              price: books.books[index].price,
                                              selling:
                                                  books.books[index].postType ==
                                                          'S'
                                                      ? true
                                                      : false,
                                              bookCount:
                                                  books.books[index].bookCount,
                                            );
                                          },
                                        );
                                },
                              );
                            }
                          }
                        },
                      ),
              ),
            ),
            drawer: user.id == "temp"
                ? AppDrawer(authenticatedSession, null)
                : AppDrawer(authenticatedSession, user),
          );
  }
}
