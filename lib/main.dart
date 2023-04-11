import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/categories.dart';
import 'package:share_learning/providers/comment.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/orders.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/strings_manager.dart';
import 'package:share_learning/templates/managers/theme_manager.dart';
import 'package:share_learning/templates/screens/add_post_screen.dart';
import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:share_learning/templates/screens/login_signup_screen.dart';
import 'package:share_learning/templates/screens/onboarding_screen.dart';
import 'package:share_learning/templates/screens/cart_screen.dart';
import 'package:share_learning/templates/screens/order_screen.dart';
import 'package:share_learning/templates/screens/signup_screen.dart';
import 'package:share_learning/templates/screens/single_post_screen.dart';
import 'package:share_learning/templates/screens/single_post_screen_new.dart';
import 'package:share_learning/templates/screens/splash_screen.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/screens/user_interests_screen.dart';
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/screens/user_profile_edit_screen.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'templates/screens/edit_post_screen.dart';
import 'templates/screens/home_screen.dart';
import 'templates/screens/order_screen_new.dart';
import 'templates/screens/temp_home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionProvider(),
        ),
        // ChangeNotifierProvider.value(value: Books()),
        // ChangeNotifierProxyProvider<SessionProvider, Books>(
        //   // create: (_) => Books(),
        //   create: (_) => Books(),
        //   update: (ctx, session, previousSession) => Books(session.session),
        // ),

        ChangeNotifierProxyProvider<SessionProvider, Users>(
          create: (context) => Users(
            Session(
              // id: '0',
              // userId: '0',
              accessToken: 'abc',
              // accessTokenExpiry: DateTime(2050),
              refreshToken: 'abc',
              // refreshTokenExpiry: DateTime(2050),
            ),
          ),
          update: (context, session, previousUser) => Users(session.session),
        ),

        ChangeNotifierProvider(create: (_) => Carts()),
        ChangeNotifierProvider(create: (_) => Books()),
        ChangeNotifierProvider(create: (_) => Comments()),
        ChangeNotifierProvider(create: (_) => Orders()),
        ChangeNotifierProvider(create: (_) => Categories()),
      ],
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              theme: getCupertinoApplicationTheme(),
              // home: HomeScreen(),
              home: SplashScreen(),
              // home: OnBoardingScreen(),
              // home: AddPostScreen(),
              // home: LoginSignupScreen(),
              // home: LoginScreen(),
              // home: CartScreen(),
              // home: SignUpScreen(),
              routes: {
                SinglePostScreen.routeName: (context) => SinglePostScreen(),
                UserPostsScreen.routeName: (context) => UserPostsScreen(),
                AddPostScreen.routeName: (context) => AddPostScreen(),
                EditPostScreen.routeName: (context) => EditPostScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                HomeScreenNew.routeName: (context) => HomeScreenNew(),
                SplashScreen.routeName: (context) => SplashScreen(),
                OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
                LoginScreen.routeName: (context) => LoginScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                LoginSignupScreen.routeName: (context) => LoginSignupScreen(),
                UserProfileScreen.routeName: (context) => UserProfileScreen(),
                UserProfileEditScreen.routeName: (context) =>
                    UserProfileEditScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                OrderScreenNew.routeName: (context) => OrderScreenNew(),
                UserInterestsScreen.routeName: (context) =>
                    UserInterestsScreen(),
              },
            )
          : MaterialApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              title: AppStrings.appTitle,
              theme: getApplicationTheme(),
              // home: HomeScreen(),
              home: SplashScreen(),
              // home: OrderScreenNew(),
              // home: SinglePostScreenNew(),
              // home: HomeScreenNew(),
              // home: OnBoardingScreen(),
              // home: AddPostScreen(),
              // home: LoginSignupScreen(),
              // home: LoginScreen(),
              // home: OrderListScreen(),
              // home: SignUpScreen(),
              routes: {
                SinglePostScreen.routeName: (context) => SinglePostScreen(),
                SinglePostScreenNew.routeName: (context) =>
                    SinglePostScreenNew(),
                UserPostsScreen.routeName: (context) => UserPostsScreen(),
                AddPostScreen.routeName: (context) => AddPostScreen(),
                EditPostScreen.routeName: (context) => EditPostScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                HomeScreenNew.routeName: (context) => HomeScreenNew(),
                SplashScreen.routeName: (context) => SplashScreen(),
                OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
                LoginScreen.routeName: (context) => LoginScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                LoginSignupScreen.routeName: (context) => LoginSignupScreen(),
                UserProfileScreen.routeName: (context) => UserProfileScreen(),
                UserProfileEditScreen.routeName: (context) =>
                    UserProfileEditScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                OrderScreenNew.routeName: (context) => OrderScreenNew(),
                UserInterestsScreen.routeName: (context) =>
                    UserInterestsScreen(),
              },
            ),
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: OrderScreenNew(),
      // ),
    );
  }
}
