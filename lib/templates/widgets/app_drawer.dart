import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/comment.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/add_post_screen.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/screens/cart_screen.dart';
import 'package:share_learning/templates/screens/orders_screen_new.dart';
import 'package:share_learning/templates/screens/user_interests_screen.dart';
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../managers/assets_manager.dart';
import '../screens/order_request_screen.dart';
import '../screens/order_requests_for_user_screen.dart';

class AppDrawer extends StatelessWidget {
  // AppDrawer(this.loggedInSession, this.loggedInUser);
  AppDrawer(this.loggedInSession);

  // final String accessToken;
  final Session loggedInSession;
  // final User? loggedInUser;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Users? users;

  // AppDrawer({required this.user});

  // Future<User> _getSessionUser(context) async {
  //   User user = await Provider.of<Users>(context).getUserByToken(accessToken);
  //   return user;
  // }

  final Users users = new Users(
    // Session(
    //   id: '0',
    //   userId: '0',
    //   accessToken: 'abc',
    //   accessTokenExpiry: DateTime(2050),
    //   refreshToken: 'abc',
    //   refreshTokenExpiry: DateTime(2050),
    // ),
    null,
  );

  final List<DrawerItem> _drawerItems = [
    // DrawerItem(
    //   icon: Icons.home,
    //   title: 'Home',
    //   route: HomeScreen.routeName,
    // ),
    DrawerItem(
      icon: Icons.add_circle,
      title: 'Add Post',
      route: AddPostScreen.routeName,
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Your Posts',
      route: UserPostsScreen.routeName,
    ),
    DrawerItem(
      icon: Icons.person,
      title: 'Your Profile',
      route: UserProfileScreen.routeName,
    ),
    // DrawerItem(
    //     title: 'Your Orders',
    //     icon: Icons.shop_rounded,
    //     route: OrderScreen.routeName),
    DrawerItem(
      title: 'Your Cart',
      icon: Icons.shop_rounded,
      route: CartScreen.routeName,
    ),
    DrawerItem(
      title: 'Your Requests',
      icon: Icons.shop_rounded,
      route: OrderRequestScreen.routeName,
    ),
    DrawerItem(
      title: 'Requests for your books',
      icon: Icons.shop_rounded,
      route: OrderRequestsForUserScreen.routeName,
    ),

    DrawerItem(
        title: 'Your Orders',
        icon: Icons.carpenter,
        route: OrdersScreenNew.routeName),

    DrawerItem(
      title: 'Your Interests',
      icon: Icons.carpenter,
      route: UserInterestsScreen.routeName,
    ),
  ];

  Widget getDrawerItem(BuildContext context, DrawerItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
          title: Text(
            item.title,
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s18,
            ),
          ),
          leading: Icon(
            item.icon,
            color: Colors.white,
          ),
          onTap: () {
            if (item.route == HomeScreen.routeName)
              Navigator.pushNamed(
                context, item.route,
                // arguments: {'authSession': loggedInSession}
              );
            if (item.route == AddPostScreen.routeName)
              Navigator.pushNamed(
                context, item.route,
                // arguments: {
                //   'loggedInUserSession': loggedInSession,
                // }
              );
            if (item.route == UserPostsScreen.routeName)
              Navigator.pushNamed(
                context, item.route,
                // arguments: {
                //   // 'uId': loggedInSession.userId,
                //   'uId': '1',
                //   'loggedInUserSession': loggedInSession
                // }
              );
            if (item.route == UserProfileScreen.routeName) {
              Navigator.pushNamed(
                context,
                item.route,
                // arguments: {
                //   'loggedInUserSession': loggedInSession,
                //   // 'user': users.user,
                //   // 'user': loggedInUser,
                // },
              );
            }
            if (item.route == CartScreen.routeName)
              Navigator.pushNamed(
                context,
                item.route,
                // arguments: {
                //   // 'uId': loggedInSession.userId,
                //   'loggedInUserSession': loggedInSession
                // },
              );
            if (item.route == OrderRequestScreen.routeName)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == OrderRequestsForUserScreen.routeName)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == OrdersScreenNew.routeName)
              Navigator.pushNamed(
                context,
                item.route,
                // arguments: {'loggedInUserSession': loggedInSession},
              );
            if (item.route == UserInterestsScreen.routeName) {
              Navigator.pushNamed(
                context,
                item.route,
              );
            }
          }),
    );
  }

  // Future<User?> _getSessionUser() async {
  //   await users.getUserByToken(loggedInSession.accessToken).then((value) {
  //     return users.user;
  //   });
  //   if (users.user != null)
  //     return users.user;
  //   else {
  //     await users.getUserByToken(loggedInSession.accessToken).then((value) {
  //       return users.user;
  //     });
  //     return users.user;
  //   }
  // }

  _logOut(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    Provider.of<Books>(context, listen: false).setBooks([]);
    // Provider.of<Users>(context, listen: false).setUser(null);
    // users.logoutUser('1');

    Provider.of<Comments>(context, listen: false).setComments([]);

    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    prefs.remove('isFirstTime');
    // print('here');

    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<Users>(context, listen: false).getUserByToken(this.accessToken);
    User loggedInUser = Provider.of<Users>(context).user as User;
    return SafeArea(
      child: Drawer(
        elevation: 100.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.lightPrimary,
                ColorManager.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.only(top: 40),
          // color: ColorManager.lightPrimary,

          child:
              //loggedInUser == null
              // ? FutureBuilder(
              //     future: _getSessionUser(),
              //     // future: Provider.of<Users>(context, listen: false)
              //     //     .getUserByToken(this.accessToken),
              //     // future: users.getUserByToken(userSession.accessToken),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CircularProgressIndicator(
              //             color: ColorManager.primary,
              //           ),
              //         );
              //       } else {
              //         if (snapshot.hasError) {
              //           return Center(
              //             // child: Text('Error fetching data please restart the app'),
              //             child: Text(snapshot.error.toString()),
              //           );
              //         } else if (snapshot.hasData) {
              //           return Container(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsets.only(top: 20.0),
              //                   child: Center(
              //                     child: Column(
              //                       children: [
              //                         CircleAvatar(
              //                           radius: 70,
              //                           backgroundImage: NetworkImage(
              //                             UserHelper.userProfileImage(
              //                                 users.user as User),
              //                           ),
              //                         ),
              //                         SizedBox(height: 10),
              //                         Text(
              //                           users.user!.firstName.toString(),
              //                           style: getBoldStyle(
              //                               color: ColorManager.black,
              //                               fontSize: FontSize.s18),
              //                           // style: TextStyle(
              //                           //   color: Colors.white,
              //                           //   fontSize: FontSize.s18,
              //                           // ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 // SizedBox(
              //                 //   height: 40,
              //                 // ),
              //                 // ListTile(
              //                 //   leading: Icon(
              //                 //     Icons.account_circle,
              //                 //     color: Colors.white,
              //                 //   ),
              //                 //   title: Text(
              //                 //     'Profile',
              //                 //     style: TextStyle(
              //                 //       color: Colors.white,
              //                 //       fontSize: FontSize.s18,
              //                 //     ),
              //                 //   ),
              //                 //   onTap: () {
              //                 //     Navigator.pop(context);
              //                 //   },
              //                 // ),
              //                 // ListTile(
              //                 //   leading: Icon(
              //                 //     Icons.home,
              //                 //     color: Colors.white,
              //                 //   ),
              //                 //   title: Text(
              //                 //     'Your Posts',
              //                 //     style: TextStyle(
              //                 //       color: Colors.white,
              //                 //       fontSize: FontSize.s18,
              //                 //     ),
              //                 //   ),
              //                 //   // onTap: () {
              //                 //   //   Navigator.pop(context);
              //                 //   // },
              //                 //   onTap: () => Navigator.of(context).pushNamed(
              //                 //     UserPostsScreen.routeName,
              //                 //     arguments: {
              //                 //       'uId': loggedInSession.userId,
              //                 //       'loggedInUserSession': loggedInSession,
              //                 //     },
              //                 //   ),
              //                 // ),
              //                 // ListTile(
              //                 //   leading: Icon(
              //                 //     Icons.home,
              //                 //     color: Colors.white,
              //                 //   ),
              //                 //   title: Text(
              //                 //     'Home',
              //                 //     style: TextStyle(
              //                 //       color: Colors.white,
              //                 //       fontSize: FontSize.s18,
              //                 //     ),
              //                 //   ),
              //                 //   onTap: () {
              //                 //     Navigator.pop(context);
              //                 //   },
              //                 // ),
              //                 // ListTile(
              //                 //   leading: Icon(
              //                 //     Icons.logout,
              //                 //     color: Colors.white,
              //                 //   ),
              //                 //   title: Text(
              //                 //     'Log out',
              //                 //     style: TextStyle(
              //                 //       color: Colors.white,
              //                 //       fontSize: FontSize.s18,
              //                 //     ),
              //                 //   ),
              //                 //   onTap: () {
              //                 //     Provider.of<Books>(context, listen: false)
              //                 //         .setBooks([]);
              //                 //     users.logoutUser(loggedInSession.id);
              //                 //     Provider.of<Comments>(context, listen: false)
              //                 //         .setComments([]);
              //                 //     //     .logout(accessToken);
              //                 //     Navigator.pushReplacementNamed(
              //                 //         context, LoginScreen.routeName);
              //                 //   },
              //                 // ),
              //                 SizedBox(
              //                   height: 20,
              //                 ),
              //                 Expanded(
              //                   child: ListView.builder(
              //                       itemBuilder: (context, index) {
              //                         return getDrawerItem(
              //                             context, _drawerItems[index]);
              //                       },
              //                       itemCount: _drawerItems.length),
              //                 ),
              //                 // Spacer(),
              //                 ListTile(
              //                   // tileColor: ColorManager.white,
              //                   leading: Icon(
              //                     Icons.logout,
              //                     color: ColorManager.white,
              //                   ),
              //                   title: Text(
              //                     'Log out',
              //                     style: getBoldStyle(
              //                       // color: ColorManager.primary,
              //                       color: ColorManager.white,
              //                       fontSize: FontSize.s18,
              //                     ),
              //                   ),
              //                   onTap: () async {
              //                     // print('her');
              //                     await _logOut(context);
              //                     // SharedPreferences prefs = await _prefs;
              //                     // Provider.of<Books>(context, listen: false)
              //                     //     .setBooks([]);
              //                     // users.logoutUser(loggedInSession.id);
              //                     // Provider.of<Comments>(context, listen: false)
              //                     //     .setComments([]);
              //                     // prefs.remove('accessToken');
              //                     // Navigator.pushReplacementNamed(
              //                     //     context, LoginScreen.routeName);
              //                   },
              //                 )
              //               ],
              //             ),
              //           );
              //         } else {
              //           return Center(
              //             child: Text(
              //               // 'Error fetching data please restart the app',
              //               'Something went wrong',
              //               // snapshot.data.toString(),
              //               style: getBoldStyle(color: ColorManager.white),
              //             ),
              //           );
              //         }
              //       }
              //       // child: Container(
              //       //   child: Column(
              //       //     crossAxisAlignment: CrossAxisAlignment.start,
              //       //     children: [
              //       //       Center(
              //       //         child: Column(
              //       //           children: [
              //       //             CircleAvatar(
              //       //               radius: 70,
              //       //               backgroundImage: NetworkImage(
              //       //                   'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
              //       //             ),
              //       //             Text(
              //       //               // 'Rahul Rimal',
              //       //               user.firstName,
              //       //               style: TextStyle(
              //       //                 color: Colors.white,
              //       //                 fontSize: FontSize.s18,
              //       //               ),
              //       //             ),
              //       //           ],
              //       //         ),
              //       //       ),
              //       //       SizedBox(
              //       //         height: 40,
              //       //       ),
              //       //       ListTile(
              //       //         leading: Icon(
              //       //           Icons.account_circle,
              //       //           color: Colors.white,
              //       //         ),
              //       //         title: Text(
              //       //           'Profile',
              //       //           style: TextStyle(
              //       //             color: Colors.white,
              //       //             fontSize: FontSize.s18,
              //       //           ),
              //       //         ),
              //       //         onTap: () {
              //       //           Navigator.pop(context);
              //       //         },
              //       //       ),
              //       //       ListTile(
              //       //         leading: Icon(
              //       //           Icons.home,
              //       //           color: Colors.white,
              //       //         ),
              //       //         title: Text(
              //       //           'Profile',
              //       //           style: TextStyle(
              //       //             color: Colors.white,
              //       //             fontSize: FontSize.s18,
              //       //           ),
              //       //         ),
              //       //         onTap: () {
              //       //           Navigator.pop(context);
              //       //         },
              //       //       ),
              //       //       ListTile(
              //       //         leading: Icon(
              //       //           Icons.home,
              //       //           color: Colors.white,
              //       //         ),
              //       //         title: Text(
              //       //           'Home',
              //       //           style: TextStyle(
              //       //             color: Colors.white,
              //       //             fontSize: FontSize.s18,
              //       //           ),
              //       //         ),
              //       //         onTap: () {
              //       //           Navigator.pop(context);
              //       //         },
              //       //       ),
              //       //       ListTile(
              //       //         leading: Icon(
              //       //           Icons.logout,
              //       //           color: Colors.white,
              //       //         ),
              //       //         title: Text(
              //       //           'Log out',
              //       //           style: TextStyle(
              //       //             color: Colors.white,
              //       //             fontSize: FontSize.s18,
              //       //           ),
              //       //         ),
              //       //         onTap: () {
              //       //           // Navigator.pop(context);
              //       //           Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              //       //         },
              //       //       ),
              //       //       // ListTile(
              //       //       //   tileColor: Theme.of(context).primaryColor,
              //       //       //   leading: Text(
              //       //       //     'Rahul Rimal',
              //       //       //     style: TextStyle(
              //       //       //       color: Colors.white,
              //       //       //     ),
              //       //       //   ),
              //       //       //   trailing: CircleAvatar(
              //       //       //     backgroundImage: NetworkImage(
              //       //       //         'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
              //       //       //   ),
              //       //       // ),
              //       //       // ListTile(
              //       //       //   tileColor: Theme.of(context).accentColor,
              //       //       //   title: Text(
              //       //       //     'Create new Post',
              //       //       //     style: TextStyle(
              //       //       //       fontSize: 15,
              //       //       //       color: Colors.white,
              //       //       //     ),
              //       //       //     textAlign: TextAlign.center,
              //       //       //   ),
              //       //       //   onTap: () =>
              //       //       //       Navigator.of(context).pushNamed(AddPostScreen.routeName),
              //       //       // ),
              //       //       // ListTile(
              //       //       //   leading: Row(
              //       //       //     mainAxisSize: MainAxisSize.min,
              //       //       //     children: [
              //       //       //       Icon(Icons.bookmark),
              //       //       //       Text('Wishlist'),
              //       //       //     ],
              //       //       //   ),
              //       //       // ),
              //       //     ],
              //       //   ),
              //       // ),
              //     },
              //   )
              // : Container(
              Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Column(
                      children: [
                        // CircleAvatar(
                        //   radius: 70,
                        //   backgroundImage: NetworkImage(
                        //     // UserHelper.userProfileImage(users.user as User),
                        //     UserHelper.userProfileImage(loggedInUser),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, UserProfileScreen.routeName),
                          child: loggedInUser.image == null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage(ImageAssets.noProfile),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                      UserHelper.userProfileImage(
                                          loggedInUser)),
                                ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          // users.user!.firstName,
                          loggedInUser.firstName.toString(),
                          style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s18),
                          // style: TextStyle(
                          //   color: Colors.white,
                          //   fontSize: FontSize.s18,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return getDrawerItem(context, _drawerItems[index]);
                      },
                      itemCount: _drawerItems.length),
                ),

                // Spacer(),

                ListTile(
                  // tileColor: ColorManager.white,
                  leading: Icon(
                    Icons.logout,
                    color: ColorManager.white,
                  ),
                  title: Text(
                    'Log out',
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s18,
                    ),
                  ),
                  // onTap: () async {
                  //   SharedPreferences prefs = await _prefs;
                  //   Provider.of<Books>(context, listen: false)
                  //       .setBooks([]);
                  //   // users.logoutUser(loggedInSession.id);
                  //   users.logoutUser('1');

                  //   Provider.of<Comments>(context, listen: false)
                  //       .setComments([]);

                  //   prefs.remove('accessToken');

                  //   Navigator.pushReplacementNamed(
                  //       context, LoginScreen.routeName);
                  // },
                  onTap: () async {
                    _logOut(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
    // // double baseWidth = 375;
    // double baseWidth = 450;
    // double fem = MediaQuery.of(context).size.width / baseWidth;
    // double ffem = fem * 0.97;
    // return Drawer(
    //   child: Container(
    //     width: double.infinity,
    //     child: Container(
    //       // sidemenuY2C (13:2)
    //       padding:
    //           EdgeInsets.fromLTRB(21 * fem, 16 * fem, 0 * fem, 35.13 * fem),
    //       width: double.infinity,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(25 * fem),
    //         gradient: LinearGradient(
    //           begin: Alignment(0.027, -1),
    //           end: Alignment(0.027, 1),
    //           colors: <Color>[Color(0xfffc1c66), Color(0xfffaa63d)],
    //           stops: <double>[0, 1],
    //         ),
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             // ellipse55Jx (9:434)
    //             margin:
    //                 EdgeInsets.fromLTRB(98 * fem, 0 * fem, 119 * fem, 19 * fem),
    //             width: double.infinity,
    //             height: 137 * fem,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(68.5 * fem),
    //               image: DecorationImage(
    //                 fit: BoxFit.cover,
    //                 image: AssetImage(
    //                   'assets/page-1/images/ellipse-5-bg.png',
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Container(
    //             // autogroupuqpdMnG (XHtnemjTgGVSX4csRXuqPD)
    //             margin:
    //                 EdgeInsets.fromLTRB(78 * fem, 0 * fem, 86 * fem, 37 * fem),
    //             width: double.infinity,
    //             height: 48 * fem,
    //             child: Stack(
    //               children: [
    //                 Positioned(
    //                   // ashishchandUbz (103:139)
    //                   left: 21 * fem,
    //                   top: 0 * fem,
    //                   child: Align(
    //                     child: SizedBox(
    //                       width: 147 * fem,
    //                       height: 31 * fem,
    //                       child: Text(
    //                         'Ashish Chand ',
    //                         // style: SafeGoogleFont(
    //                         //   'Calibri',
    //                         //   fontSize: 24 * ffem,
    //                         //   fontWeight: FontWeight.w700,
    //                         //   height: 1.2575 * ffem / fem,
    //                         //   color: Color(0xffffffff),
    //                         // ),
    //                         style: TextStyle(
    //                           fontSize: 24 * ffem,
    //                           fontWeight: FontWeight.w700,
    //                           height: 1.2575 * ffem / fem,
    //                           color: Color(0xffffffff),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   // chandashish456gmailcomJb2 (104:152)
    //                   left: 0 * fem,
    //                   top: 29 * fem,
    //                   child: Align(
    //                     child: SizedBox(
    //                       width: 200 * fem,
    //                       height: 19 * fem,
    //                       child: Text(
    //                         'chandashish456@gmail.com',
    //                         // style: SafeGoogleFont(
    //                         //   'Calibri',
    //                         //   fontSize: 15 * ffem,
    //                         //   fontWeight: FontWeight.w700,
    //                         //   height: 1.2575 * ffem / fem,
    //                         //   color: Color(0xffffffff),
    //                         // ),
    //                         style: TextStyle(
    //                           fontSize: 15 * ffem,
    //                           fontWeight: FontWeight.w700,
    //                           height: 1.2575 * ffem / fem,
    //                           color: Color(0xffffffff),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             // group29P6g (13:15)
    //             margin:
    //                 EdgeInsets.fromLTRB(0 * fem, 0 * fem, 269 * fem, 24 * fem),
    //             width: double.infinity,
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Container(
    //                   // group21JUY (13:17)
    //                   margin: EdgeInsets.fromLTRB(
    //                       0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                   width: 30 * fem,
    //                   height: 30 * fem,
    //                   child: Image.asset(
    //                     'assets/page-1/images/group-21.png',
    //                     width: 30 * fem,
    //                     height: 30 * fem,
    //                   ),
    //                 ),
    //                 Text(
    //                   // homeR3N (13:16)
    //                   'Home',
    //                   // style: SafeGoogleFont(
    //                   //   'Calibri',
    //                   //   fontSize: 14 * ffem,
    //                   //   fontWeight: FontWeight.w700,
    //                   //   height: 1.2575 * ffem / fem,
    //                   //   color: Color(0xffffffff),
    //                   // ),
    //                   style: TextStyle(
    //                     fontSize: 14 * ffem,
    //                     fontWeight: FontWeight.w700,
    //                     height: 1.2575 * ffem / fem,
    //                     color: Color(0xffffffff),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             // autogroupuy2jjZr (XHtnp6oFTfPtyJVQpUUY2j)
    //             margin:
    //                 EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 24 * fem),
    //             width: 128 * fem,
    //             height: 246 * fem,
    //             child: Stack(
    //               children: [
    //                 Positioned(
    //                   // group384ME (102:13)
    //                   left: 0 * fem,
    //                   top: 0 * fem,
    //                   child: Container(
    //                     // width: 206 * fem,
    //                     height: 83 * fem,
    //                     child: Row(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Container(
    //                           // group21Av4 (102:15)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                           width: 30 * fem,
    //                           height: double.infinity,
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 // ellipse4Lxx (102:16)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 0 * fem, 0 * fem, 23 * fem),
    //                                 width: double.infinity,
    //                                 height: 30 * fem,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius:
    //                                       BorderRadius.circular(15 * fem),
    //                                   border:
    //                                       Border.all(color: Color(0x26ffffff)),
    //                                   color: Color(0x26ffffff),
    //                                 ),
    //                               ),
    //                               Container(
    //                                 // ellipse53cU (102:45)
    //                                 width: double.infinity,
    //                                 height: 30 * fem,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius:
    //                                       BorderRadius.circular(15 * fem),
    //                                   border:
    //                                       Border.all(color: Color(0x26ffffff)),
    //                                   color: Color(0x26ffffff),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         Container(
    //                           // autogroupjrckNek (XHtnzWfZw2JE8uehDVJRcK)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 6 * fem, 0 * fem, 5 * fem),
    //                           height: double.infinity,
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 // yourpostWFA (102:14)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 0 * fem, 0 * fem, 36 * fem),
    //                                 child: Text(
    //                                   'Your Post',
    //                                   // style: SafeGoogleFont(
    //                                   //   'Calibri',
    //                                   //   fontSize: 14 * ffem,
    //                                   //   fontWeight: FontWeight.w700,
    //                                   //   height: 1.2575 * ffem / fem,
    //                                   //   color: Color(0xffffffff),
    //                                   // ),
    //                                   style: TextStyle(
    //                                     fontSize: 14 * ffem,
    //                                     fontWeight: FontWeight.w700,
    //                                     height: 1.2575 * ffem / fem,
    //                                     color: Color(0xffffffff),
    //                                   ),
    //                                 ),
    //                               ),
    //                               Container(
    //                                 // addpostDQU (102:21)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 0 * fem, 2 * fem, 0 * fem),
    //                                 child: Text(
    //                                   'Add Post',
    //                                   // style: SafeGoogleFont(
    //                                   //   'Calibri',
    //                                   //   fontSize: 14 * ffem,
    //                                   //   fontWeight: FontWeight.w700,
    //                                   //   height: 1.2575 * ffem / fem,
    //                                   //   color: Color(0xffffffff),
    //                                   // ),
    //                                   style: TextStyle(
    //                                     fontSize: 14 * ffem,
    //                                     fontWeight: FontWeight.w700,
    //                                     height: 1.2575 * ffem / fem,
    //                                     color: Color(0xffffffff),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   // group27jdi (13:29)
    //                   left: 0 * fem,
    //                   top: 108 * fem,
    //                   child: Container(
    //                     width: 128 * fem,
    //                     height: 30 * fem,
    //                     child: Row(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Container(
    //                           // group23T3v (13:31)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                           width: 30 * fem,
    //                           height: 30 * fem,
    //                           child: Image.asset(
    //                             'assets/page-1/images/group-23.png',
    //                             width: 30 * fem,
    //                             height: 30 * fem,
    //                           ),
    //                         ),
    //                         Container(
    //                           // notificationsZck (13:30)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 4 * fem, 0 * fem, 0 * fem),
    //                           child: Text(
    //                             'Notifications',
    //                             // style: SafeGoogleFont(
    //                             //   'Calibri',
    //                             //   fontSize: 14 * ffem,
    //                             //   fontWeight: FontWeight.w700,
    //                             //   height: 1.2575 * ffem / fem,
    //                             //   color: Color(0xffffffff),
    //                             // ),
    //                             style: TextStyle(
    //                               fontSize: 14 * ffem,
    //                               fontWeight: FontWeight.w700,
    //                               height: 1.2575 * ffem / fem,
    //                               color: Color(0xffffffff),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   // group31Gn4 (13:47)
    //                   left: 0 * fem,
    //                   top: 162 * fem,
    //                   child: Container(
    //                     // width: 111 * fem,
    //                     height: 30 * fem,
    //                     child: Row(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Container(
    //                           // group25yRa (13:49)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                           width: 30 * fem,
    //                           height: 30 * fem,
    //                           child: Image.asset(
    //                             'assets/page-1/images/group-25.png',
    //                             width: 30 * fem,
    //                             height: 30 * fem,
    //                           ),
    //                         ),
    //                         Container(
    //                           // myprofileGfa (13:48)
    //                           margin: EdgeInsets.fromLTRB(
    //                               0 * fem, 6 * fem, 0 * fem, 0 * fem),
    //                           child: Text(
    //                             'My Profile',
    //                             // style: SafeGoogleFont(
    //                             //   'Calibri',
    //                             //   fontSize: 14 * ffem,
    //                             //   fontWeight: FontWeight.w700,
    //                             //   height: 1.2575 * ffem / fem,
    //                             //   color: Color(0xffffffff),
    //                             // ),
    //                             style: TextStyle(
    //                               fontSize: 14 * ffem,
    //                               fontWeight: FontWeight.w700,
    //                               height: 1.2575 * ffem / fem,
    //                               color: Color(0xffffffff),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   // group36kak (13:61)
    //                   left: 0 * fem,
    //                   top: 3 * fem,
    //                   child: Container(
    //                     width: 106 * fem,
    //                     height: 243 * fem,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Container(
    //                           // autogroupsjfdr7z (XHtoULCYiHnEJoNfZDsjFd)
    //                           padding: EdgeInsets.fromLTRB(
    //                               1 * fem, 0 * fem, 1 * fem, 133 * fem),
    //                           width: double.infinity,
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Container(
    //                                 // group33xRv (104:140)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 0 * fem, 0 * fem, 20 * fem),
    //                                 width: 30 * fem,
    //                                 height: 30 * fem,
    //                                 child: Image.asset(
    //                                   'assets/page-1/images/group-33.png',
    //                                   width: 30 * fem,
    //                                   height: 30 * fem,
    //                                 ),
    //                               ),
    //                               Container(
    //                                 // group34rXJ (104:146)
    //                                 width: 30 * fem,
    //                                 height: 30 * fem,
    //                                 child: Image.asset(
    //                                   'assets/page-1/images/group-34.png',
    //                                   width: 30 * fem,
    //                                   height: 30 * fem,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         Container(
    //                           // autogroupqqufAH6 (XHtoMAjpJpsXHJ5cARqQUF)
    //                           width: double.infinity,
    //                           child: Row(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 // group32i3i (13:67)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                                 width: 30 * fem,
    //                                 height: 30 * fem,
    //                                 child: Image.asset(
    //                                   'assets/page-1/images/group-32.png',
    //                                   width: 30 * fem,
    //                                   height: 30 * fem,
    //                                 ),
    //                               ),
    //                               Container(
    //                                 // yourcartcun (13:63)
    //                                 margin: EdgeInsets.fromLTRB(
    //                                     0 * fem, 6 * fem, 0 * fem, 0 * fem),
    //                                 child: Text(
    //                                   'Your Cart',
    //                                   // style: SafeGoogleFont(
    //                                   //   'Calibri',
    //                                   //   fontSize: 14 * ffem,
    //                                   //   fontWeight: FontWeight.w700,
    //                                   //   height: 1.2575 * ffem / fem,
    //                                   //   color: Color(0xffffffff),
    //                                   // ),
    //                                   style: TextStyle(
    //                                     fontSize: 14 * ffem,
    //                                     fontWeight: FontWeight.w700,
    //                                     height: 1.2575 * ffem / fem,
    //                                     color: Color(0xffffffff),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             // group40X1A (102:36)
    //             margin:
    //                 EdgeInsets.fromLTRB(0 * fem, 0 * fem, 239 * fem, 24 * fem),
    //             width: double.infinity,
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Container(
    //                   // group32T9i (102:39)
    //                   margin: EdgeInsets.fromLTRB(
    //                       0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                   width: 30 * fem,
    //                   height: 30 * fem,
    //                   child: Image.asset(
    //                     'assets/page-1/images/group-32-9Zr.png',
    //                     width: 30 * fem,
    //                     height: 30 * fem,
    //                   ),
    //                 ),
    //                 Container(
    //                   // yourorderyNx (102:38)
    //                   margin: EdgeInsets.fromLTRB(
    //                       0 * fem, 6 * fem, 0 * fem, 0 * fem),
    //                   child: Text(
    //                     'Your Order',
    //                     // style: SafeGoogleFont(
    //                     //   'Calibri',
    //                     //   fontSize: 14 * ffem,
    //                     //   fontWeight: FontWeight.w700,
    //                     //   height: 1.2575 * ffem / fem,
    //                     //   color: Color(0xffffffff),
    //                     // ),
    //                     style: TextStyle(
    //                       fontSize: 24 * ffem,
    //                       fontWeight: FontWeight.w700,
    //                       height: 1.2575 * ffem / fem,
    //                       color: Color(0xffffffff),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             // autogroup2rpmHuS (XHtoeVaHLGqWhAhUBc2RPM)
    //             width: double.infinity,
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   // group37dyJ (102:2)
    //                   // margin: EdgeInsets.fromLTRB(
    //                   //     0 * fem, 0 * fem, 26 * fem, 111.87 * fem),
    //                   child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       Container(
    //                         // group33mZi (102:4)
    //                         margin: EdgeInsets.fromLTRB(
    //                             0 * fem, 0 * fem, 18 * fem, 0 * fem),
    //                         width: 30 * fem,
    //                         height: 30 * fem,
    //                         child: Image.asset(
    //                           'assets/page-1/images/group-33-6Xa.png',
    //                           width: 30 * fem,
    //                           height: 30 * fem,
    //                         ),
    //                       ),
    //                       Container(
    //                         // logout66C (102:3)
    //                         margin: EdgeInsets.fromLTRB(
    //                             0 * fem, 6 * fem, 0 * fem, 0 * fem),
    //                         child: Text(
    //                           'Logout',
    //                           // style: SafeGoogleFont(
    //                           //   'Calibri',
    //                           //   fontSize: 14 * ffem,
    //                           //   fontWeight: FontWeight.w700,
    //                           //   height: 1.2575 * ffem / fem,
    //                           //   color: Color(0xffffffff),
    //                           // ),
    //                           style: TextStyle(
    //                             fontSize: 24 * ffem,
    //                             fontWeight: FontWeight.w700,
    //                             height: 1.2575 * ffem / fem,
    //                             color: Color(0xffffffff),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   // group2Dgc (3:62)
    //                   margin: EdgeInsets.fromLTRB(
    //                       0 * fem, 10 * fem, 0 * fem, 0 * fem),
    //                   width: 244 * fem,
    //                   height: 131.87 * fem,
    //                   child: Image.asset(
    //                     'assets/page-1/images/group-2.png',
    //                     width: 244 * fem,
    //                     height: 131.87 * fem,
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
  }
}

class DrawerItem {
  String title;
  IconData icon;
  String route;
  DrawerItem({required this.title, required this.icon, required this.route});
}
