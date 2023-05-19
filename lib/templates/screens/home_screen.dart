import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/post.dart';

import '../../providers/orders.dart';
import '../../providers/sessions.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AsyncMemoizer memoizer = AsyncMemoizer();

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

  _setUserValue(User user) {
    // this.user = user;
    _user = user;
  }

  // Future<User?> _getSessionUser(Users users, loggedInSession) async {
  //   await users.getUserByToken(loggedInSession.accessToken).then((value) {
  //     _user = users.user as User;
  //     return users.user;
  //   });
  //   if (users.user != null) {
  //     _user = users.user as User;
  //     return users.user;
  //   } else {
  //     await users.getUserByToken(loggedInSession.accessToken).then((value) {
  //       _user = users.user as User;
  //       return users.user;
  //     });
  //     _user = users.user as User;
  //     return users.user;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    Session authenticatedSession;
    if (args['authSession'] != null) {
      authenticatedSession = args['authSession'] as Session;
    } else {
      authenticatedSession =
          Provider.of<SessionProvider>(context).session as Session;
    }

    Users _users = context.watch<Users>();
    if (_users.user == null) {
      _users.getUserByToken(authenticatedSession.accessToken);
    } else {
      _user = _users.user as User;
    }
    Books _books = context.watch<Books>();

    Orders _orders = context.watch<Orders>();
    // _getSessionUser(_users, authenticatedSession);

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
                  future: _books.getBooksAnnonimusly(authenticatedSession),
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
                  child: _user.id != "temp"
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            // (UserHelper.userProfileImage(users.user as User)),
                            (UserHelper.userProfileImage(_user)),
                          ),
                        )
                      : FutureBuilder(
                          // future: _users.getUserByIdAndSession(
                          //     authenticatedSession,
                          //     // authenticatedSession.userId),
                          //     '1'),

                          future: _users
                              .getUserByToken(authenticatedSession.accessToken),
                          builder: (ctx, snapshot) {
                            // if (snapshot.data != null)
                            //   _user = snapshot.data as User;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: ColorManager.secondary,
                              );
                            } else {
                              if (snapshot.hasError) {
                                // AppBar().preferredSize.height;
                                // MediaQuery.of(context).viewPadding.top;
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
                                    // backgroundImage: NetworkImage(
                                    //   (UserHelper.userProfileImage(
                                    //       snapshot.data as User)),
                                    // ),
                                    backgroundImage: NetworkImage(_user.image ==
                                            null
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
            body: Container(
              child: Container(
                child: _books.books.length > 0
                    ? ListView.builder(
                        itemCount: _books.books.length,
                        itemBuilder: (ctx, index) {
                          return Post(
                            loggedInUserSession: authenticatedSession,
                            id: _books.books[index].id,
                            title: _books.books[index].bookName,
                            description: _books.books[index].description,
                            author: _books.books[index].author,
                            boughtTime: _books.books[index].boughtDate,
                            price: _books.books[index].price,
                            selling: _books.books[index].postType == 'S'
                                ? true
                                : false,
                            bookCount: _books.books[index].bookCount,
                          );
                        },
                      )
                    : FutureBuilder(
                        future:
                            _books.getBooksAnnonimusly(authenticatedSession),
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
            // drawer: _user.id == "temp"
            //     ? AppDrawer(authenticatedSession, null)
            //     : AppDrawer(authenticatedSession, _user),

            drawer: AppDrawer(authenticatedSession),
          );
  }
}
