import 'package:flutter/material.dart';


// class ColorManager {
//   static Color darkGrey = HexColor.fromHex("#525252");
//   static Color primary = HexColor.fromHex("#ff5252");
//   static Color secondary = HexColor.fromHex("#2196f3");
//   static Color grey = HexColor.fromHex("#737477");
//   static Color lightGrey = HexColor.fromHex("#9E9E9E");
//   static Color purple = HexColor.fromHex("#FFAA0BAD");
//   static Color lighterGrey = HexColor.fromHex("#CFCFCF");
//   static Color lightestGrey = HexColor.fromHex("#FFDADADA");

//   static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");

//   // new colors
//   static Color darkPrimary = HexColor.fromHex("#c50e29");
//   static Color darkSecondary = HexColor.fromHex("#0069c0");
//   static Color lightPrimary = HexColor.fromHex("#ff867f");
//   static Color lightSecondary = HexColor.fromHex("#6ec6ff");
//   static Color grey1 = HexColor.fromHex("#707070");
//   static Color grey2 = HexColor.fromHex("#797979");
//   static Color white = HexColor.fromHex("#FFFFFF");
//   static Color black = HexColor.fromHex("#000000");
//   static Color green = HexColor.fromHex("#FF008E0E");
//   static Color yellow = HexColor.fromHex("#FFD0B60F");

//   static Color error = HexColor.fromHex("#e61f34"); // red color

//   static Color primaryColorWithOpacity = Color.fromARGB(204, 229, 99, 99);

//   static Color blackWithOpacity = Color.fromARGB(204, 0, 0, 0);

//   static Color transparent = Color.fromARGB(0, 0, 0, 0);
//   static Color blackWithLowOpacity = Color.fromARGB(100, 0, 0, 0);
//   static Color whiteWithOpacity = Color.fromARGB(204, 255, 255, 255);
//   static Color greyWithOpacity = Color.fromARGB(204, 70, 70, 70);
//   static Color grey2WithOpacity = Color.fromARGB(204, 79, 79, 79);
// }

// extension HexColor on Color {
//   static Color fromHex(String hexColorString) {
//     hexColorString = hexColorString.replaceAll('#', '');
//     if (hexColorString.length == 6) {
//       hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
//     }
//     return Color(int.parse(hexColorString, radix: 16));
//   }
// }


class ColorManager {

// Light Theme Colors
  static Color primary = HexColor.fromHex("#ff5252");
  static Color secondary = HexColor.fromHex("#2196f3");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color lightPrimary = HexColor.fromHex("#ff867f");
  static Color lightSecondary = HexColor.fromHex("#6ec6ff");
  static Color white = HexColor.fromHex("#FFFFFF");

  // Dark Theme Colors
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color darkPrimary = HexColor.fromHex("#c50e29");
  static Color darkSecondary = HexColor.fromHex("#0069c0");
  static Color grey = HexColor.fromHex("#737477");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color black = HexColor.fromHex("#000000");

  

  // Shared Colors
  static Color purple = HexColor.fromHex("#FFAA0BAD");
  static Color lighterGrey = HexColor.fromHex("#CFCFCF");
  static Color lightestGrey = HexColor.fromHex("#FFDADADA");
  static Color green = HexColor.fromHex("#FF008E0E");
  static Color yellow = HexColor.fromHex("#FFD0B60F");
  static Color error = HexColor.fromHex("#e61f34"); // red color

  // Opacity Colors
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");
  static Color primaryColorWithOpacity = Color.fromARGB(204, 229, 99, 99);
  static Color blackWithOpacity = Color.fromARGB(204, 0, 0, 0);
  static Color transparent = Color.fromARGB(0, 0, 0, 0);
  static Color blackWithLowOpacity = Color.fromARGB(100, 0, 0, 0);
  static Color whiteWithOpacity = Color.fromARGB(204, 255, 255, 255);
  static Color greyWithOpacity = Color.fromARGB(204, 70, 70, 70);
  static Color grey2WithOpacity = Color.fromARGB(204, 79, 79, 79);
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