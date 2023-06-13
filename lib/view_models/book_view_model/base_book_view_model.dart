import 'package:flutter/material.dart';
import 'package:share_learning/models/book.dart';

import '../../models/session.dart';
import '../book_filters_provider.dart';
import '../category_provider.dart';
import '../order_provider.dart';
import '../order_request_provider.dart';
import '../user_provider.dart';
import 'book_provider.dart';

class BaseBookViewModel {
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




  // bindBaseProvider(BuildContext context);
  // setBillingInfo();
  // setBillingInfoLocationData(String value);
}