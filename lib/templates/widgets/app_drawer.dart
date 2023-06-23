import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/comment_provider.dart';
import 'package:share_learning/view_models/providers/theme_provider.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
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
import '../managers/routes_manager.dart';
import '../screens/order_request_screen.dart';
import '../screens/order_requests_screen_for_seller.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with WidgetsBindingObserver {
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // Register this object as an observer
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addObserver(this);

    userProvider!.bindAppDrawerViewModel(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Added this line to save the reference of provider so it doesn't throw an exception on dispose
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    userProvider!.unbindAppDrawerViewModel();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget getDrawerItem(BuildContext context, DrawerItem item) {
    UserProvider _userProvider = context.watch<UserProvider>();
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
            if (item.route == RoutesManager.homeScreenRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.addPostScreenRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.userPostsScreenRoute)
              // Set selected user to null so current user books will be fetched, otherwise books of selected user will be fetched
              _userProvider
                  .bookProvider.userPostsScreenViewModelSelectedUserId = null;
            Navigator.pushNamed(
                context,
                // item.route,
                RoutesManager.userPostsScreenRoute);
            if (item.route == RoutesManager.userProfileEditScreenRoute) {
              Navigator.pushNamed(
                context,
                item.route,
              );
            }
            if (item.route == RoutesManager.cartScreenRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.orderRequestScreenRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.orderRequestsScreenForSellerRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.ordersScreenNewRoute)
              Navigator.pushNamed(
                context,
                item.route,
              );
            if (item.route == RoutesManager.userInterestsScreenRoute) {
              Navigator.pushNamed(
                context,
                item.route,
              );
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = context.watch<UserProvider>();

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
            gradient: Provider.of<ThemeProvider>(context).isDarkMode
                ? LinearGradient(colors: [
                    ColorManager.grey,
                    ColorManager.darkGrey,
                  ])
                : LinearGradient(
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
          child: Container(
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
                        //     UserHelper.userProfileImage((_userProvider.user as User)),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context,
                              RoutesManager.userProfileEditScreenRoute),
                          child: (_userProvider.user as User).image == null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage(ImageAssets.noProfile),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                      UserHelper.userProfileImage(
                                          (_userProvider.user as User))),
                                ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          (_userProvider.user as User).firstName.toString(),
                          style: getBoldStyle(
                              fontSize: FontSize.s18,
                              color: ColorManager.white),
                          // style: Theme.of(context).textTheme.headlineLarge,
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
                        return getDrawerItem(context,
                            _userProvider.appDrawerViewModelDrawerItems[index]);
                      },
                      itemCount:
                          _userProvider.appDrawerViewModelDrawerItems.length),
                ),

                // Spacer(),

                ListTile(
                  tileColor: ColorManager.transparent,
                  leading: Icon(
                    Icons.logout,
                    color: Provider.of<ThemeProvider>(context).isDarkMode
                        ? ColorManager.whiteWithOpacity
                        : ColorManager.white,
                  ),
                  title: Text(
                    'Log out',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () async {
                    _userProvider.AppDrawerViewModelLogOut(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  String route;
  DrawerItem({required this.title, required this.icon, required this.route});
}
