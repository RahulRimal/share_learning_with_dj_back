import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../models/user.dart';
import 'providers/book_filters_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/category_provider.dart';
import 'providers/comment_provider.dart';
import 'providers/order_provider.dart';
import 'providers/order_request_provider.dart';
import 'providers/session_provider.dart';
import 'providers/user_provider.dart';
import 'providers/book_provider.dart';
import 'providers/wishlist_provider.dart';

mixin BaseViewModel on ChangeNotifier {
  late UserProvider userProvider;
  late SessionProvider sessionProvider;
  late BookProvider bookProvider;
  late BookFiltersProvider bookFiltersProvider;
  late CartProvider cartProvider;
  late CategoryProvider categoryProvider;
  late OrderProvider orderProvider;
  late OrderRequestProvider orderRequestProvider;
  late WishlistProvider wishlistProvider;
  late CommentProvider commentProvider;

  Future<SharedPreferences> prefences = SharedPreferences.getInstance();

  Map<String, String> billingInfo = {};
  List<String> locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];

  // User user = new User(
  //     id: "temp",
  //     firstName: 'firstName',
  //     lastName: 'lastName',
  //     username: 'username',
  //     email: 'email',
  //     phone: 'phone',
  //     image: null,
  //     description: 'description',
  //     userClass: 'userClass',
  //     followers: 'followers',
  //     createdDate: DateTime.now());

  bindBaseViewModal(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    userProvider = Provider.of(context, listen: false);
    bookProvider = Provider.of(context, listen: false);
    commentProvider = Provider.of<CommentProvider>(context, listen: false);
    bookFiltersProvider =
        Provider.of<BookFiltersProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    orderRequestProvider =
        Provider.of<OrderRequestProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
  }

  unBindBaseViewModal() {}

  setBillingInfo() {
    if (userProvider.user != null) {
      if (userProvider.user!.firstName!.isNotEmpty) {
        billingInfo["first_name"] = userProvider.user!.firstName!;
      }
      if (userProvider.user!.lastName!.isNotEmpty) {
        billingInfo["last_name"] = userProvider.user!.lastName!;
      }
      if (userProvider.user!.email!.isNotEmpty) {
        billingInfo["email"] = userProvider.user!.email!;
      }
      if (userProvider.user!.phone != null) {
        if (userProvider.user!.phone!.isNotEmpty) {
          billingInfo["phone"] = userProvider.user!.phone!;
        }
      }
      billingInfo["convenient_location"] = locationOptions[0];
    }
  }

  setBillingInfoLocationData(String value) {
    billingInfo["convenient_location"] = value;
    notifyListeners();
  }
}
