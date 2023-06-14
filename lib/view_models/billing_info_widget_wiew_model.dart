

import 'package:flutter/material.dart';

import 'base_view_model.dart';

mixin BillingInfoWidgetViewModel on BaseViewModel{

  
  bindBillingInfoWidgetViewModel(BuildContext context) {
    bindBaseViewModal(context);
    setBillingInfo();

  }

  // bindBillingInfoWidgetViewModel(BuildContext context);


}