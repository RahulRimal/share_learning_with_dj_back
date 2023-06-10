import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

import '../../data/session_api.dart';
import '../../models/session.dart';

class SystemHelper {
  static String postImage(String bookId, String imageName) {
    return "${RemoteManager.POST_POOL}/$bookId/$imageName";
  }

  static Map<String, dynamic> convertKeysToSnakeCase(Map<String, dynamic> map) {
    final newMap = <String, dynamic>{};
    map.forEach((key, value) {
      final newKey = camelCaseToSnakeCase(key);
      newMap[newKey] = value;
    });
    return newMap;
  }

  static String camelCaseToSnakeCase(String input) {
    final pattern = RegExp(r'(?<=[a-z])[A-Z]');
    return input
        .replaceAllMapped(pattern, (match) => '_${match.group(0)}')
        .toLowerCase();
  }

  static Map<String, dynamic> getChangedValues(
      Map<String, dynamic> oldMap, Map<String, dynamic> newMap) {
    final changedValues = <String, dynamic>{};
    newMap.forEach((key, value) {
      if (oldMap[key] != value) {
        changedValues[key] = value;
      }
    });
    return changedValues;
  }
}

class FCMDeviceHelper {
  static Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name as String;
    }
    return deviceName;
  }

  static Future<String> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String androidId = androidInfo.id;
      String deviceModel = androidInfo.model;
      String deviceManufacturer = androidInfo.manufacturer;

      // Concatenate relevant device information
      String combinedInfo = androidId + deviceModel + deviceManufacturer;

      // Encode the combined information using base64
      List<int> encodedInfo = utf8.encode(combinedInfo);
      String base64EncodedInfo = base64.encode(encodedInfo);

      // Remove any characters that are not alphanumeric or underscores
      deviceId = base64EncodedInfo.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String identifierForVendor = iosInfo.identifierForVendor as String;
      String deviceModel = iosInfo.model as String;

      // Concatenate relevant device information
      String combinedInfo = identifierForVendor + deviceModel;

      // Encode the combined information using base64
      List<int> encodedInfo = utf8.encode(combinedInfo);
      String base64EncodedInfo = base64.encode(encodedInfo);

      // Remove any characters that are not alphanumeric or underscores
      deviceId = base64EncodedInfo.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    }

    return deviceId;
  }

  static registerDeviceToFCM(Session authSession) async {
    // Registering the device to fcm notifications starts here
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String deviceName = await _getDeviceName();
    String deviceId = await _getDeviceId();
    String fcmToken = await messaging.getToken() as String;

    Map<String, dynamic> deviceData = {
      'name': deviceName,
      'registration_id': fcmToken,
      'device_id': deviceId,
      'active': true,
      'type': Platform.isAndroid ? 'android' : 'ios',
    };

    await FCMDeviceApi.registerNewDevice(authSession, deviceData);

    // Registering the device to fcm notifications ends here
  }
}
