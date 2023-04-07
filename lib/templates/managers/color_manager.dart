import 'package:flutter/material.dart';

class ColorManager {
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color primary = HexColor.fromHex("#ff5252");
  static Color secondary = HexColor.fromHex("#2196f3");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color lighterGrey = HexColor.fromHex("#CFCFCF");

  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");

  // new colors
  static Color darkPrimary = HexColor.fromHex("#c50e29");
  static Color darkSecondary = HexColor.fromHex("#0069c0");
  static Color lightPrimary = HexColor.fromHex("#ff867f");
  static Color lightSecondary = HexColor.fromHex("#6ec6ff");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#000000");
  static Color error = HexColor.fromHex("#e61f34"); // red color

  // static Color primaryColorWithOpacity = Color.fromRGBO(255, 82, 82, 0.7);

  static Color primaryColorWithOpacity = Color.fromARGB(89, 229, 99, 999);
  static Color blackWithOpacity = Color.fromARGB(89, 0, 0, 0);
  static Color blackWithLowOpacity = Color.fromARGB(100, 0, 0, 0);
  static Color whiteWithOpacity = Color.fromARGB(89, 255, 255, 255);
  static Color greyWithOpacity = Color.fromARGB(89, 70, 70, 70);
  static Color grey2WithOpacity = Color.fromARGB(89, 79, 79, 79);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
