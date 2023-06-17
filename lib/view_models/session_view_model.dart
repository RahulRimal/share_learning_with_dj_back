import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_learning/view_models/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../models/user.dart';
import '../templates/managers/color_manager.dart';
import '../templates/managers/values_manager.dart';
import '../templates/screens/home_screen_new.dart';
import '../templates/screens/login_screen.dart';
import '../templates/utils/alert_helper.dart';
import '../templates/utils/internet_connection.dart';

mixin SplashScreenViewModel on BaseViewModel {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? _timer;

  get splashScreenViewModelTimer => _timer;

  bindSplashScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    splashScreenViewModelGetPreviousSession(context);
  }

  unBindSplashScreenViewModel() {
    _timer?.cancel();
  }

  splashScreenViewModelStartDelay(BuildContext context) {
    _timer =
        Timer(Duration(seconds: 2), () => splashScreenViewModelGoNext(context));
  }

  splashScreenViewModelGoNext(BuildContext context) async {
    // ! Just for development purpose when internet is absent fix it
    if (await InternetConnectionChecker.checkInternetConnection())
      // if (true)
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    else {
      AlertHelper.showWidgetAlert(Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: ColorManager.black,
        color: ColorManager.blackWithOpacity,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'No Internet',
              style: TextStyle(
                color: ColorManager.primary,
                decoration: TextDecoration.none,
              ),
            ),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ));
    }
  }

  splashScreenViewModelGetPreviousSession(BuildContext context) async {
    SharedPreferences prefs = await _prefs;

    if (prefs.containsKey('accessToken')) {
      String accessToken = prefs.getString('accessToken') as String;
      String refreshToken = prefs.getString('refreshToken') as String;

      sessionProvider.setSession(
          new Session(accessToken: accessToken, refreshToken: refreshToken));

      var user = await userProvider.getUserByToken(accessToken);

      if (user is UserError && user.code == ApiStatusCode.unauthorized) {
        if (!await sessionProvider.refreshSession(refreshToken)) {
          if (sessionProvider.sessionError!.code ==
              ApiStatusCode.unauthorized) {
            print('here');
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            return;
          }
        }
      }

      if (prefs.containsKey('cartId')) {
        await cartProvider.getCartInfo(prefs.getString('cartId') as String);
      } else {
        if (await cartProvider.createCart(sessionProvider.session as Session)) {
          prefs.setString('cartId', cartProvider.cart!.id.toString());
        } else {
          print('here in Splash screen view model');
        }
      }

      await wishlistProvider
          .getWishlistedBooks(sessionProvider.session as Session);
      await categoryProvider.getCategories(sessionProvider.session as Session);
      await orderRequestProvider
          .getOrderRequestsByUser(sessionProvider.session as Session);
      Navigator.pushReplacementNamed(context, HomeScreenNew.routeName,
          arguments: {
            'authSession': sessionProvider.session,
          });
    } else
      splashScreenViewModelStartDelay(context);
  }
}
