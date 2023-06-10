import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/view_models/user_provider.dart';

import 'firebase_options.dart';
import 'models/session.dart';
import 'templates/managers/strings_manager.dart';
import 'templates/managers/theme_manager.dart';
import 'templates/screens/add_post_screen.dart';
import 'templates/screens/cart_screen.dart';
import 'templates/screens/edit_post_screen.dart';
import 'templates/screens/home_screen.dart';
import 'templates/screens/home_screen_new.dart';
import 'templates/screens/login_screen.dart';
import 'templates/screens/login_signup_screen.dart';
import 'templates/screens/onboarding_screen.dart';
import 'templates/screens/order_details_screen.dart';
import 'templates/screens/order_request_details_screen.dart';
import 'templates/screens/order_request_screen.dart';
import 'templates/screens/order_requests_for_user_details_screen.dart';
import 'templates/screens/order_requests_for_user_screen.dart';
import 'templates/screens/order_screen.dart';
import 'templates/screens/orders_screen_new.dart';
import 'templates/screens/post_details_screen.dart';
import 'templates/screens/signup_screen.dart';
import 'templates/screens/single_post_screen.dart';
import 'templates/screens/splash_screen.dart';
import 'templates/screens/user_interests_screen.dart';
import 'templates/screens/user_posts_screen.dart';
import 'templates/screens/user_profile_edit_screen.dart';
import 'templates/screens/user_profile_screen.dart';
import 'templates/screens/wishlisted_books_screen.dart';
import 'templates/utils/notification_service.dart';
import 'view_models/book_filters_provider.dart';
import 'view_models/book_provider.dart';
import 'view_models/cart_provider.dart';
import 'view_models/category_provider.dart';
import 'view_models/comment_provider.dart';
import 'view_models/order_provider.dart';
import 'view_models/order_request_provider.dart';
import 'view_models/session_provider.dart';
import 'view_models/wishlist_provider.dart';

Future<void> _firebaseMessengingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  if (message.notification != null) {
    print("Message also contained a notification: ${message.notification}");
    NotificationService.showNotification(
      title: message.notification!.title as String,
      body: message.notification!.body as String,
      bigPicture: message.notification!.android?.imageUrl,
      largeIcon: message.notification!.android?.imageUrl,
      payload: message.data,
    );
  }
}

// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // print(await messaging.getToken());

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("Granted permissions:  ${settings.authorizationStatus}");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print("Message data ${message.data}");

    if (message.notification != null) {
      print("Message also contained a notification: ${message.notification}");
      NotificationService.showNotification(
        title: message.notification!.title as String,
        body: message.notification!.body as String,
        bigPicture: message.notification!.android?.imageUrl,
        largeIcon: message.notification!.android?.imageUrl,
        payload: message.data,
      );
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessengingBackgroundHandler);
  await NotificationService.initializeNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This key is defined for AwesomeNotification to navigate to particular route received from the data of notification
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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

        ChangeNotifierProxyProvider<SessionProvider, UserProvider>(
          create: (context) => UserProvider(
            Session(
              // id: '0',
              // userId: '0',
              accessToken: 'abc',
              // accessTokenExpiry: DateTime(2050),
              refreshToken: 'abc',
              // refreshTokenExpiry: DateTime(2050),
            ),
          ),
          update: (context, session, previousUser) =>
              UserProvider(session.session),
        ),

        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderRequestProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BookFiltersProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              theme: getCupertinoApplicationTheme(),
              // home: HomeScreen(),
              home: SplashScreen(),
              // home: TempScreen(),
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
                WishlistedBooksScreen.routeName: (context) =>
                    WishlistedBooksScreen(),
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
                OrderRequestScreen.routeName: (context) => OrderRequestScreen(),
                OrderRequestDetailsScreen.routeName: (context) =>
                    OrderRequestDetailsScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                OrdersScreenNew.routeName: (context) => OrdersScreenNew(),
                OrderDetailsScreen.routeName: (context) => OrderDetailsScreen(),
                UserInterestsScreen.routeName: (context) =>
                    UserInterestsScreen(),
              },
            )
          : KhaltiScope(
              publicKey: 'test_public_key_78965ea539884431b8e9172178d08e91',
              enabledDebugging: true,
              builder: (context, navKey) {
                MyApp.navigatorKey = navKey;
                return ResponsiveSizer(
                    builder: (context, orientation, screenType) {
                  return MaterialApp(
                    navigatorKey: navKey,
                    localizationsDelegates: const [
                      KhaltiLocalizations.delegate,
                    ],
                    builder: BotToastInit(),
                    navigatorObservers: [BotToastNavigatorObserver()],
                    debugShowCheckedModeBanner: false,
                    title: AppStrings.appTitle,
                    theme: getApplicationTheme(ThemeMode.light),

                    home: SplashScreen(),
                    // home: TempScreen(),
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
                      SinglePostScreen.routeName: (context) =>
                          SinglePostScreen(),
                      PostDetailsScreen.routeName: (context) =>
                          PostDetailsScreen(),
                      UserPostsScreen.routeName: (context) => UserPostsScreen(),
                      AddPostScreen.routeName: (context) => AddPostScreen(),
                      EditPostScreen.routeName: (context) => EditPostScreen(),
                      WishlistedBooksScreen.routeName: (context) =>
                          WishlistedBooksScreen(),
                      HomeScreen.routeName: (context) => HomeScreen(),
                      HomeScreenNew.routeName: (context) => HomeScreenNew(),
                      SplashScreen.routeName: (context) => SplashScreen(),
                      OnBoardingScreen.routeName: (context) =>
                          OnBoardingScreen(),
                      LoginScreen.routeName: (context) => LoginScreen(),
                      SignUpScreen.routeName: (context) => SignUpScreen(),
                      LoginSignupScreen.routeName: (context) =>
                          LoginSignupScreen(),
                      UserProfileScreen.routeName: (context) =>
                          UserProfileScreen(),
                      UserProfileEditScreen.routeName: (context) =>
                          UserProfileEditScreen(),
                      CartScreen.routeName: (context) => CartScreen(),
                      OrderRequestScreen.routeName: (context) =>
                          OrderRequestScreen(),
                      OrderRequestsForUserScreen.routeName: (context) =>
                          OrderRequestsForUserScreen(),
                      OrderRequestDetailsScreen.routeName: (context) =>
                          OrderRequestDetailsScreen(),
                      OrderRequestForUserDetailsScreen.routeName: (context) =>
                          OrderRequestForUserDetailsScreen(),
                      OrderScreen.routeName: (context) => OrderScreen(),
                      OrdersScreenNew.routeName: (context) => OrdersScreenNew(),
                      OrderDetailsScreen.routeName: (context) =>
                          OrderDetailsScreen(),
                      UserInterestsScreen.routeName: (context) =>
                          UserInterestsScreen(),
                    },
                  );
                });
              },
            ),
    );
  }
}
