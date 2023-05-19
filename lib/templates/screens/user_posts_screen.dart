import 'package:flutter/material.dart';
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

class UserPostsScreen extends StatelessWidget {
  static const routeName = '/user-posts';

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // final String userId = args['uId'];
    // var loggedInUserSession = args['loggedInUserSession'] as Session;

    Users users = Provider.of<Users>(context);
    Session loggedInUserSession =
        Provider.of<SessionProvider>(context).session as Session;

    users.getUserByToken(loggedInUserSession.accessToken);

    List<Book> _allPosts =
        Provider.of<Books>(context).postsByUser(users.user!.id);

    return Scaffold(
      // drawer: users.user == null
      //     ? AppDrawer(loggedInUserSession, null)
      //     : AppDrawer(loggedInUserSession, users.user),
      drawer: AppDrawer(loggedInUserSession),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: users.user != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      // 'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
                      UserHelper.userProfileImage(users.user as User),
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
      body: _allPosts.isNotEmpty
          ? ListView.builder(
              itemCount: _allPosts.length,
              itemBuilder: (context, index) => Post(
                loggedInUserSession: loggedInUserSession,
                id: _allPosts[index].id,
                title: _allPosts[index].bookName,
                description: _allPosts[index].description,
                author: _allPosts[index].author,
                boughtTime: _allPosts[index].boughtDate,
                price: _allPosts[index].price,
                bookCount: _allPosts[index].bookCount,
                selling: _allPosts[index].postType == 'S' ? true : false,
              ),
            )
          : Center(
              child: Text(
                'No Posts yet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }
}
