// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefrencesHelper {
//   void setStringInPrefrences(String key, String value) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.setString(key, value).then(
//     //       (value) => print(value),
//     //     );
//     await _prefs.setString(key, value);
//   }

//   void setIntInPrefrences(String key, int value) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.setInt("int", 1).then(
//     //       (value) => print(value),
//     //     );
//     await _prefs.setInt(key, value);
//   }

//   void setDoubleInPrefrennces(String key, double value) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.setDouble("double", 1.01).then(
//     //       (value) => print(value),
//     //     );
//     await _prefs.setDouble(key, value);
//   }

//   void setBoolInPrefrences(String key, bool value) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.setBool("bool", true).then(
//     //       (value) => print(value),
//     //     );
//     await _prefs.setBool(key, value);
//   }

//   void setListInPrefrences(String key, List<String> value) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.setStringList(
//     //   "list",
//     //   <String>["StringList1", "StringList2", "StringList3"],
//     // ).then(
//     //   (value) => print(value),
//     // );
//     await _prefs.setStringList(
//       key,
//       value,
//     );
//   }

//   Future<String> getStringFromPrefrences(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     String? value = _prefs.getString(key);
//     return value as String;
//     // print(value);
//   }

//   Future<int> getIntFromPrefrences(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     int? intValue = _prefs.getInt(key);

//     return intValue as int;

//     // print(intValue);
//   }

//   Future<double> getDoubleFromPrefrences(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     double? doubleValue = _prefs.getDouble(key);

//     return doubleValue as double;
//     // print(doubleValue);
//   }

//   Future<bool> getBoolFromPrefrences(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     bool? boolValue = _prefs.getBool(key);
//     return boolValue as bool;
//     // print(boolValue);
//   }

//   Future<List<String>> getListFromPrefrences(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     List<String>? list = _prefs.getStringList(key);
//     return list as List<String>;
//     // print(list);
//   }

//   void removeData(String key) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();

//     // await _prefs.remove(key).then((value) => print(value));
//     await _prefs.remove(key);
//   }
// }
