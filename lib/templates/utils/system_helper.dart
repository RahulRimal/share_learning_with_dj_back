import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/api_values_manager.dart';

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
