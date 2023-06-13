import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';

import '../../models/session.dart';
import '../../models/user.dart';
import '../book_filters_provider.dart';
import '../category_provider.dart';
import '../order_provider.dart';
import '../order_request_provider.dart';
import '../session_provider.dart';
import '../user_provider.dart';
import 'book_provider.dart';

// class BaseBookViewModel {
//   late UserProvider userProvider;
//   late Session authSession;
//   late BookFiltersProvider bookFiltersProvider;
//   late CategoryProvider categoryProvider;
//   late OrderProvider orderProvider;
//   late OrderRequestProvider  orderRequestProvider;



//   Map<String, String> billingInfo = {};
//   List<String> locationOptions = [
//     'Kathmandu',
//     'Bhaktapur',
//     'Lalitpur',
//     'Nepalgunj',
//   ];




//   // bindBaseProvider(BuildContext context);
//   // setBillingInfo();
//   // setBillingInfoLocationData(String value);
// }


mixin BaseBookViewModel {
  late UserProvider userProvider;
  late Session authSession;
  late BookFiltersProvider bookFiltersProvider;
  late CategoryProvider categoryProvider;
  late OrderProvider orderProvider;
  late OrderRequestProvider  orderRequestProvider;



  Map<String, String> billingInfo = {};
  List<String> locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];


  User user = new User(
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




  @override
  setBillingInfo() {
    if (user.firstName!.isNotEmpty) {
      billingInfo["first_name"] = user.firstName!;
    }
    if (user.lastName!.isNotEmpty) {
      billingInfo["last_name"] = user.lastName!;
    }
    if (user.email!.isNotEmpty) {
      billingInfo["email"] = user.email!;
    }
    if (user.phone != null) {
      if (user.phone!.isNotEmpty) {
        billingInfo["phone"] = user.phone!;
      }
    }
    billingInfo["convenient_location"] = locationOptions[0];
  }

  
  setBillingInfoLocationData(String value) {
    billingInfo["convenient_location"] = value;
    // notifyListeners();
  }



  bindBaseProvider(BuildContext context){
    authSession =
        Provider.of<SessionProvider>(context, listen: false).session as Session;
    userProvider = Provider.of(context, listen: false);
    bookFiltersProvider =
        Provider.of<BookFiltersProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    orderRequestProvider = Provider.of<OrderRequestProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }




  // bindBaseProvider(BuildContext context);
  // setBillingInfo();
  // setBillingInfoLocationData(String value);
}