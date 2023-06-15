import 'package:flutter/material.dart';

import '../models/session.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin OrderRequestViewModel on BaseViewModel {
  // late final form ;
  // late final searchController;
  final searchController = TextEditingController();

  bindOrderRequestViewModel(BuildContext context) {
    bindBaseViewModal(context);
    // form = GlobalKey<FormState>();
    // searchController = TextEditingController();
  }

  unBindOrderRequestViewModel() {
    searchController.dispose();
  }

  Future<bool> removeOrderRequest(String orderRequestId) async {
    if (await orderRequestProvider.deleteOrderRequest(
      orderRequestProvider.sessionProvider.session as Session,
      orderRequestId,
    )) {
      AlertHelper.showToastAlert('Book deleted from the cart');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong, Please try again!');
    return false;
  }
}
