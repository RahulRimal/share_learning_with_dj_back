import 'package:flutter/material.dart';

import '../models/session.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin OrderRequestScreenViewModel on BaseViewModel {
  final orderRequestScreenSearchController = TextEditingController();

  bindOrderRequestViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unBindOrderRequestViewModel() {
    orderRequestScreenSearchController.dispose();
  }

  Future<bool> orderRequestScreenRemoveOrderRequest(
      String orderRequestId) async {
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
