import 'package:flutter/material.dart';
import 'package:share_learning/templates/screens/order_details_screen.dart';
import 'package:share_learning/templates/screens/splash_screen.dart';

import '../screens/add_post_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_post_screen.dart';
import '../screens/home_screen.dart';
import '../screens/home_screen_new.dart';
import '../screens/login_screen.dart';
import '../screens/login_signup_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/order_request_details_screen.dart';
import '../screens/order_request_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/orders_screen_new.dart';
import '../screens/post_details_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/single_post_screen.dart';
import '../screens/user_interests_screen.dart';
import '../screens/user_posts_screen.dart';
import '../screens/user_profile_edit_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/wishlisted_books_screen.dart';

class RoutesManager {
  // static const String splashScreenRoute = '/splash';
  static const String splashScreenRoute = '/';
  static const String singlePostScreenRoute = '/post-details';
  static const String userPostsScreenRoute = '/user-posts';
  static const String addPostScreenRoute = '/add-post';
  static const String editPostScreenRoute = '/edit-post';
  static const String wishlistedBooksScreenRoute = '/wishlists';
  static const String homeScreenRoute = '/home';
  static const String postDetailsScreenRoute = '/post-details-screen';

  static const String homeScreenNewRoute = '/home-new';
  static const String onBoardingScreenRoute = '/on-board';
  static const String loginScreenRoute = '/login';
  static const String signUpScreenRoute = '/signup';
  static const String loginSignupScreenRoute = '/login-signup';
  static const String userProfileScreenRoute = '/user-profile';
  static const String userProfileEditScreenRoute = '/user-profile-edit';
  static const String cartScreenRoute = '/cart-list';
  static const String orderRequestScreenRoute = '/order-request-list';
  static const String orderRequestDetailsScreenRoute = 'order-request-details';
  static const String orderRequestsScreenForSellerRoute =
      'order-request-details';

  static const String orderRequestForSellerDetailsScreenRoute =
      'order-request-for-user-details-screen';
  static const String orderScreenRoute = '/order-list';
  static const String ordersScreenNewRoute = '/orders-list-new';
  static const String orderDetailsScreenRoute = 'order-details';
  static const String userInterestsScreenRoute = '/user-interests';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesManager.splashScreenRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RoutesManager.singlePostScreenRoute:
        return MaterialPageRoute(builder: (_) => SinglePostScreen());
      case RoutesManager.postDetailsScreenRoute:
        return MaterialPageRoute(builder: (_) => PostDetailsScreen());
      case RoutesManager.userPostsScreenRoute:
        return MaterialPageRoute(builder: (_) => UserPostsScreen());
      case RoutesManager.addPostScreenRoute:
        return MaterialPageRoute(builder: (_) => AddPostScreen());
      case RoutesManager.editPostScreenRoute:
        return MaterialPageRoute(builder: (_) => EditPostScreen());
      case RoutesManager.wishlistedBooksScreenRoute:
        return MaterialPageRoute(builder: (_) => WishlistedBooksScreen());
      case RoutesManager.homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutesManager.homeScreenNewRoute:
        return MaterialPageRoute(builder: (_) => HomeScreenNew());
      case RoutesManager.onBoardingScreenRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case RoutesManager.loginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutesManager.loginSignupScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginSignupScreen());
      case RoutesManager.signUpScreenRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RoutesManager.userProfileScreenRoute:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());
      case RoutesManager.userProfileEditScreenRoute:
        return MaterialPageRoute(builder: (_) => UserProfileEditScreen());
      case RoutesManager.cartScreenRoute:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case RoutesManager.orderRequestScreenRoute:
        return MaterialPageRoute(builder: (_) => OrderRequestScreen());
      case RoutesManager.orderRequestDetailsScreenRoute:
        return MaterialPageRoute(builder: (_) => OrderRequestDetailsScreen());
      case RoutesManager.orderScreenRoute:
        return MaterialPageRoute(builder: (_) => OrderScreen());
      case RoutesManager.ordersScreenNewRoute:
        return MaterialPageRoute(builder: (_) => OrdersScreenNew());
      case RoutesManager.orderDetailsScreenRoute:
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen());
      case RoutesManager.userInterestsScreenRoute:
        return MaterialPageRoute(builder: (_) => UserInterestsScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Undefined Route'),
        ),
        body: Center(
          child: Text('Undefined Route'),
        ),
      ),
    );
  }
}
