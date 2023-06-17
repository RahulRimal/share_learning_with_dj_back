import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:share_learning/data/book_api.dart';
import 'package:share_learning/templates/screens/order_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/api_status.dart';
import '../../models/order.dart';
import '../../models/order_request.dart';
import '../../models/session.dart';
import '../screens/order_requests_for_seller_details_screen.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // debugPrint('onActionReceivedMethod');
    // final payload = receivedAction.payload ?? {};
    // if (payload["navigate"] == "true") {
    //   MainApp.navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (_) => const SecondScreen(),
    //     ),
    //   );
    // }
    final Map<String, dynamic> payload = receivedAction.payload ?? {};

    // ---------------------------------------- Handle notification for order request object starts here----------------------------------------------------------------
    if (payload.containsKey('click_action') &&
        payload['click_action'] == 'GO_TO_ORDER_REQUEST_FOR_USER_SCREEN') {
      OrderRequest requestItem =
          orderRequestFromJson(convertToJsonParsable(payload['request_item']));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String access = prefs.getString('accessToken') as String;
      String refresh = prefs.getString('refreshToken') as String;

      var response = await BookApi.getBookById(
          Session(accessToken: access, refreshToken: refresh),
          requestItem.product.id.toString());

      if (response is Success) {
        MyApp.navigatorKey.currentState?.pushNamed(
            OrderRequestForSellerDetailsScreen.routeName,
            arguments: {
              'requestItem': requestItem,
              'requestedProduct': response.response,
            });
      }
    }

    // ---------------------------------------- Handle notification for order request object ends here----------------------------------------------------------------

    // ---------------------------------------- Handle notification for order object starts here----------------------------------------------------------------

    if (payload.containsKey('click_action') &&
        payload['click_action'] == 'GO_TO_ORDER_DETAILS_SCREEN') {
      Order order = orderFromJson(convertToJsonParsable(payload['order']));
      MyApp.navigatorKey.currentState?.pushNamed(OrderDetailsScreen.routeName,
          arguments: {'order': order});
    }

    // ---------------------------------------- Handle notification for order request object ends here----------------------------------------------------------------
  }

  static String convertToJsonParsable(String str) {
    return str.replaceAll("'", "\"");
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, dynamic>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.BigPicture,
    final NotificationCategory? category,
    final String? bigPicture,
    final String? largeIcon,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload != null ? payload.cast<String, String?>() : null,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        largeIcon: largeIcon,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
