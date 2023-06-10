import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../managers/color_manager.dart';
import '../managers/style_manager.dart';

class AlertHelper {
  static showToastAlert(String msg) {
    BotToast.showSimpleNotification(
      title: msg,
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );
  }

  static showDismissableToastAlert(String msg) {
    BotToast.showSimpleNotification(
        title: msg,
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(1, -1),
        hideCloseButton: true,
        dismissDirections: [
          DismissDirection.horizontal,
          DismissDirection.vertical,
        ]);
  }

  static showWidgetAlert(Widget element) {
    BotToast.showWidget(toastBuilder: (c) => element);
  }

  static showLoading() {
    BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) => Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            // Colors.white,
            ColorManager.primary,
          ),
        ),
      ),
    );
  }
}
