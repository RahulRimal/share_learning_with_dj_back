import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'style_manager.dart';
import 'values_manager.dart';

// ThemeData getApplicationTheme(ThemeMode themeMode) {
// class ThemeManager {
//   static final lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: ColorManager.primary,
//     primaryColorLight: ColorManager.lightPrimary,
//     primaryColorDark: ColorManager.darkPrimary,
//     disabledColor: ColorManager.grey1,
//     splashColor: ColorManager.primaryOpacity70,
//     cardTheme: CardTheme(
//       color: ColorManager.white,
//       shadowColor: ColorManager.grey,
//       elevation: AppSize.s4,
//     ),
//     appBarTheme: AppBarTheme(
//       centerTitle: true,
//       color: ColorManager.primary,
//       elevation: AppSize.s4,
//       shadowColor: ColorManager.primaryOpacity70,
//       titleTextStyle: getRegularStyle(
//         color: ColorManager.white,
//         fontSize: FontSize.s16,
//       ),
//     ),
//     buttonTheme: ButtonThemeData(
//       shape: StadiumBorder(),
//       disabledColor: ColorManager.grey1,
//       buttonColor: ColorManager.primary,
//       splashColor: ColorManager.primaryOpacity70,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         textStyle: getRegularStyle(color: ColorManager.white),
//         backgroundColor: ColorManager.primary,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSize.s12),
//         ),
//       ),
//     ),
//     textTheme: TextTheme(
//       displayLarge: getSemiBoldStyle(
//         color: ColorManager.darkGrey,
//         fontSize: FontSize.s16,
//       ),
//       titleMedium: getMediumStyle(
//         color: ColorManager.lightGrey,
//         fontSize: FontSize.s14,
//       ),
//       titleSmall: getMediumStyle(
//         color: ColorManager.primary,
//         fontSize: FontSize.s14,
//       ),
//       bodySmall: getRegularStyle(color: ColorManager.grey1),
//       bodyLarge: getRegularStyle(color: ColorManager.grey),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: EdgeInsets.all(AppPadding.p8),
//       hintStyle: getRegularStyle(color: ColorManager.grey1),
//       labelStyle: getMediumStyle(color: ColorManager.darkGrey),
//       errorStyle: getRegularStyle(color: ColorManager.error),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.grey,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.error,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//     ),
//     colorScheme:
//         ColorScheme.fromSwatch().copyWith(secondary: ColorManager.grey),
//   );
//   static final darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: ColorManager.primary,
//     primaryColorLight: ColorManager.lightPrimary,
//     primaryColorDark: ColorManager.darkPrimary,
//     disabledColor: ColorManager.grey1,
//     splashColor: ColorManager.primaryOpacity70,
//     cardTheme: CardTheme(
//       color: ColorManager.white,
//       shadowColor: ColorManager.grey,
//       elevation: AppSize.s4,
//     ),
//     appBarTheme: AppBarTheme(
//       centerTitle: true,
//       color: ColorManager.primary,
//       elevation: AppSize.s4,
//       shadowColor: ColorManager.primaryOpacity70,
//       titleTextStyle: getRegularStyle(
//         color: ColorManager.white,
//         fontSize: FontSize.s16,
//       ),
//     ),
//     buttonTheme: ButtonThemeData(
//       shape: StadiumBorder(),
//       disabledColor: ColorManager.grey1,
//       buttonColor: ColorManager.primary,
//       splashColor: ColorManager.primaryOpacity70,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         textStyle: getRegularStyle(color: ColorManager.white),
//         backgroundColor: ColorManager.primary,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSize.s12),
//         ),
//       ),
//     ),
//     textTheme: TextTheme(
//       displayLarge: getSemiBoldStyle(
//         color: ColorManager.darkGrey,
//         fontSize: FontSize.s16,
//       ),
//       titleMedium: getMediumStyle(
//         color: ColorManager.lightGrey,
//         fontSize: FontSize.s14,
//       ),
//       titleSmall: getMediumStyle(
//         color: ColorManager.primary,
//         fontSize: FontSize.s14,
//       ),
//       bodySmall: getRegularStyle(color: ColorManager.grey1),
//       bodyLarge: getRegularStyle(color: ColorManager.grey),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: EdgeInsets.all(AppPadding.p8),
//       hintStyle: getRegularStyle(color: ColorManager.grey1),
//       labelStyle: getMediumStyle(color: ColorManager.darkGrey),
//       errorStyle: getRegularStyle(color: ColorManager.error),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.grey,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.error,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary,
//           width: AppSize.s1_5,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//       ),
//     ),
//     colorScheme: ColorScheme.dark(
//       secondary: ColorManager.grey,
//     ),
//   );
// }

class ThemeManager {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    splashColor: ColorManager.primaryOpacity70,
    scaffoldBackgroundColor: ColorManager.white,
    drawerTheme: DrawerThemeData(
      backgroundColor: ColorManager.primary,
    ),
    cardTheme: CardTheme(
      color: ColorManager.primary,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorManager.lighterGrey,
      selectedColor: ColorManager.primary,
      disabledColor: Colors.grey,
      labelStyle: TextStyle(color: Colors.black),
      brightness: Brightness.dark,
      shape: StadiumBorder(),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: ColorManager.black,
      textColor: ColorManager.black,
      tileColor: ColorManager.white,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.primaryOpacity70,
      titleTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s16,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
      disabledColor: ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.primaryOpacity70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: ColorManager.white),
        backgroundColor: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(ColorManager.white),
      foregroundColor: MaterialStateProperty.all(ColorManager.black),
      textStyle: MaterialStateProperty.all(
          getMediumStyle(fontSize: FontSize.s12, color: ColorManager.black)),
    )),
    textTheme: TextTheme(
      displayLarge: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s18,
      ),
      displayMedium: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s16,
      ),
      displaySmall: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s14,
      ),
      headlineLarge: getBoldStyle(
        fontSize: FontSize.s18,
        color: ColorManager.black,
      ),
      headlineMedium: getBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.black,
      ),
      headlineSmall: getBoldStyle(
        fontSize: FontSize.s14,
        color: ColorManager.black,
      ),
      titleLarge: getMediumStyle(
        color: ColorManager.black,
        fontSize: FontSize.s16,
      ),
      titleMedium: getMediumStyle(
        color: ColorManager.black,
        fontSize: FontSize.s14,
      ),
      titleSmall: getMediumStyle(
        color: ColorManager.black,
        fontSize: FontSize.s12,
      ),
      bodyLarge:
          getMediumStyle(fontSize: FontSize.s16, color: ColorManager.grey),
      bodyMedium:
          getMediumStyle(fontSize: FontSize.s14, color: ColorManager.grey),
      bodySmall:
          getMediumStyle(fontSize: FontSize.s12, color: ColorManager.grey),
      labelLarge:
          getRegularStyle(fontSize: FontSize.s16, color: ColorManager.black),
      labelMedium:
          getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),
      labelSmall:
          getRegularStyle(fontSize: FontSize.s12, color: ColorManager.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // contentPadding: EdgeInsets.all(AppPadding.p8),
      hintStyle: getRegularStyle(color: ColorManager.grey1),
      labelStyle: getMediumStyle(color: ColorManager.darkGrey),
      errorStyle: getRegularStyle(color: ColorManager.error),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.grey,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.white,
      selectedItemColor: ColorManager.primary,
      unselectedItemColor: ColorManager.lightGrey,
      selectedIconTheme: IconThemeData(color: ColorManager.primary),
      unselectedIconTheme: IconThemeData(color: ColorManager.lightGrey),
      selectedLabelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: ColorManager.primary),
      unselectedLabelStyle:
          TextStyle(fontWeight: FontWeight.normal, color: ColorManager.white),
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ColorManager.lightestGrey,
        modalBackgroundColor: ColorManager.white),
    colorScheme: ColorScheme(
      primary: ColorManager.primary,
      primaryContainer: ColorManager.lightPrimary,
      secondary: ColorManager.grey,
      secondaryContainer: ColorManager.grey,
      surface: ColorManager.white,
      background: ColorManager.white,
      // background: ColorManager.whiteWithOpacity,
      error: ColorManager.error,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.darkGrey,
      onBackground: ColorManager.darkGrey,
      onError: ColorManager.white,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: ColorManager.darkPrimary,
    primaryColor: ColorManager.grey,
    // primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    splashColor: ColorManager.primaryOpacity70,
    scaffoldBackgroundColor: ColorManager.darkGrey,
    drawerTheme: DrawerThemeData(
      backgroundColor: ColorManager.darkGrey,
    ),
    cardTheme: CardTheme(
      color: ColorManager.primary,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: ColorManager.lightestGrey,
      selectedColor: ColorManager.primary,
      disabledColor: Colors.grey,
      labelStyle: TextStyle(color: Colors.black),
      brightness: Brightness.dark,
      shape: StadiumBorder(),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: ColorManager.whiteWithOpacity,
      textColor: ColorManager.white,
      tileColor: ColorManager.darkGrey,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.grey,
      elevation: AppSize.s4,
      shadowColor: ColorManager.primaryOpacity70,
      titleTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s16,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
      disabledColor: ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.primaryOpacity70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: ColorManager.white),
        backgroundColor: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(ColorManager.darkGrey),
      foregroundColor: MaterialStateProperty.all(ColorManager.lighterGrey),
      textStyle: MaterialStateProperty.all(getMediumStyle(
          fontSize: FontSize.s12, color: ColorManager.lighterGrey)),
    )),
    // dropdownMenuTheme: DropdownMenuThemeData(
    //   inputDecorationTheme: InputDecorationTheme(
    //     fillColor: ColorManager.grey,
    //   ),
    //   textStyle: getBoldStyle(
    //     color: ColorManager.whiteWithOpacity,
    //   ),
    //   menuStyle: MenuStyle(
    //     backgroundColor: MaterialStateProperty.all(ColorManager.primary),
    //   ),
    // ),
    // popupMenuTheme: PopupMenuThemeData(
    //   color: ColorManager.primary, // Change the background color
    // ),
    textTheme: TextTheme(
      displayLarge: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s18,
      ),
      displayMedium: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s16,
      ),
      displaySmall: getBoldStyle(
        color: ColorManager.primary,
        fontSize: FontSize.s14,
      ),
      headlineLarge: getBoldStyle(
        fontSize: FontSize.s18,
        color: ColorManager.white,
      ),
      headlineMedium: getBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
      headlineSmall: getBoldStyle(
        fontSize: FontSize.s14,
        color: ColorManager.white,
      ),
      titleLarge: getMediumStyle(
        color: ColorManager.whiteWithOpacity,
        fontSize: FontSize.s16,
      ),
      titleMedium: getMediumStyle(
        color: ColorManager.whiteWithOpacity,
        fontSize: FontSize.s14,
      ),
      titleSmall: getMediumStyle(
        color: ColorManager.whiteWithOpacity,
        fontSize: FontSize.s12,
      ),
      bodyLarge: getMediumStyle(
          fontSize: FontSize.s16, color: ColorManager.lightestGrey),
      bodyMedium: getMediumStyle(
          fontSize: FontSize.s14, color: ColorManager.lightestGrey),
      bodySmall: getMediumStyle(
          fontSize: FontSize.s12, color: ColorManager.lightestGrey),
      labelLarge: getRegularStyle(
          fontSize: FontSize.s16, color: ColorManager.whiteWithOpacity),
      labelMedium: getRegularStyle(
          fontSize: FontSize.s14, color: ColorManager.whiteWithOpacity),
      labelSmall: getRegularStyle(
          fontSize: FontSize.s12, color: ColorManager.whiteWithOpacity),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorManager.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: getRegularStyle(color: ColorManager.lightestGrey),
      labelStyle: getMediumStyle(color: ColorManager.lighterGrey),
      errorStyle: getRegularStyle(color: ColorManager.white),
      focusColor: ColorManager.primary,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.whiteWithOpacity,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
    colorScheme: ColorScheme(
      primary: ColorManager.primary,
      primaryContainer: ColorManager.lightPrimary,
      secondary: ColorManager.grey,
      secondaryContainer: ColorManager.grey,
      surface: ColorManager.darkGrey,
      background: ColorManager.darkGrey,
      // background: ColorManager.grey,
      error: ColorManager.error,
      onPrimary: ColorManager.white,
      onSecondary: ColorManager.white,
      onSurface: ColorManager.white,
      onBackground: ColorManager.white,
      onError: ColorManager.white,
      brightness: Brightness.dark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorManager.darkGrey,
      selectedItemColor: ColorManager.primary,
      unselectedItemColor: ColorManager.lightGrey,
      selectedIconTheme: IconThemeData(color: ColorManager.primary),
      unselectedIconTheme: IconThemeData(color: ColorManager.whiteWithOpacity),
      selectedLabelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: ColorManager.primary),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal, color: ColorManager.darkGrey),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: ColorManager.grey),
  );
}

CupertinoThemeData getCupertinoApplicationTheme() {
  return CupertinoThemeData(
    primaryColor: ColorManager.primary,
    primaryContrastingColor: ColorManager.white,
    scaffoldBackgroundColor: ColorManager.white,
    barBackgroundColor: ColorManager.primary,
    textTheme: CupertinoTextThemeData(
      primaryColor: ColorManager.primary,
      textStyle: getRegularStyle(color: ColorManager.primary),
    ),
  );
}
