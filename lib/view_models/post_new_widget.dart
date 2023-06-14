import 'package:flutter/material.dart';

import 'base_view_model.dart';

mixin PostNewWidgetViewModel on BaseViewModel{
  bindPostNewWidget(BuildContext context) {
    bindBaseViewModal(context);
  }

  // @override
  // didChangeDependencyPostNewWidget(BuildContext context) {
  //   wishlistProvider = Provider.of<WishlistProvider>(context);
  // }

  
  unBindPostNewWidget() {}
  
  // bindPostNewWidget(BuildContext context);
  // didChangeDependencyPostNewWidget(BuildContext context);
  // unBindPostNewWidget();
}
