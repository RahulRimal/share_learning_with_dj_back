import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/screens/login_signup_screen.dart';
import 'package:share_learning/templates/screens/onboarding_screen.dart';
import 'package:share_learning/templates/utils/internet_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // SharedPrefrencesHelper _sharedPrefrencesHelper = SharedPrefrencesHelper();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? _timer;

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    // Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
    if (await InternetConnectionChecker.checkInternetConnection())
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    // Navigator.pushReplacementNamed(context, LoginSignupScreen.routeName);
    // Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
    else {
      BotToast.showWidget(
          toastBuilder: (c) => Container(
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

  _getPreviousSession() async {
    SharedPreferences prefs = await _prefs;

    if (prefs.containsKey('accessToken')) {
      String accessToken = prefs.getString('accessToken') as String;
      String refreshToken = prefs.getString('refreshToken') as String;
      SessionProvider sessions =
          Provider.of<SessionProvider>(context, listen: false);
      Carts carts = Provider.of<Carts>(context, listen: false);

      sessions.setSession(
          new Session(accessToken: accessToken, refreshToken: refreshToken));

      if (prefs.containsKey('cartId')) {
        // print(prefs.getString('cartId'));
        await carts.getCartInfo(prefs.getString('cartId') as String);
        // await Provider.of<Carts>(context)
        //     .getCartInfo(prefs.getString('cartId') as String);

      } else {
        if (await Provider.of<Carts>(context, listen: false)
            .createCart(sessions.session as Session)) {
          prefs.setString('cartId', carts.cart!.id.toString());
          // print(Provider.of<Carts>(context, listen: false).cart!.id.toString());
        } else {
          print('here');
        }
      }
      Navigator.pushReplacementNamed(context, HomeScreen.routeName, arguments: {
        'authSession': sessions.session,
      });

      // sessions.getPreviousSession(accessToken).then((value) {
      //   if (sessions.session != null)
      //     Navigator.pushReplacementNamed(context, HomeScreen.routeName,
      //         arguments: {
      //           'authSession': sessions.session,
      //         });
      //   else
      //     _startDelay();
      // });

    } else
      _startDelay();
  }

  @override
  void initState() {
    _getPreviousSession();
    // _startDelay();
    // if (await InternetConnectionChecker.checkInternetConnection())

    // if (_sharedPrefrencesHelper.getStringFromPrefrences('accessToken') !=
    //     null) {
    //   _getPreviousSession();
    // if (_getPreviousSession() != null) {
    // Session loggedInSession = _getPreviousSession() as Session;

    // }
    super.initState();
    // if (InternetConnectionChecker.checkInternetConnection() as bool) {
    //   _startDelay();
    // } else {
    //   print('no internet');
    //   BotToast.showSimpleNotification(title: 'No Internet');
    // }
    // _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Image.network(
    //       'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
    // );
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
        //   child: Image.network(
        //       'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
        child: SvgPicture.asset(ImageAssets.onboardingLogo2),
      ),
      // body: FutureBuilder(
      //   future: InternetConnectionChecker.checkInternetConnection(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: ColorManager.primary,
      //         ),
      //       );
      //     } else {
      //       if (snapshot.hasError) {
      //         return Center(
      //           child: Text('Error'),
      //         );
      //       } else {
      //         if (snapshot.data as bool) {
      //           // return LoginScreen();
      //           _startDelay();
      //         } else {
      //           // BotToast.showSimpleNotification(title: "No Internet");
      //           BotToast.showWidget(
      //             toastBuilder: (c) => Container(
      //               width: MediaQuery.of(context).size.width,
      //               height: MediaQuery.of(context).size.height,
      //               // color: ColorManager.black,
      //               color: ColorManager.primaryColorWithOpacity,
      //               child: Center(
      //                 child: Container(
      //                   padding: EdgeInsets.all(10),
      //                   child: Text(
      //                     'No Internet',
      //                     style: TextStyle(
      //                       color: ColorManager.primary,
      //                       decoration: TextDecoration.none,
      //                     ),
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: ColorManager.white,
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // child: Center(
      //             //       child: Text('No Internet'),
      //             //     ),
      //           );
      //         }
      //         return Center(
      //           // child: Image.network(
      //           //     'https://cdn.pixabay.com/photo/2017/02/04/12/25/'),
      //           // child: Image.asset(ImageAssets.onboardingLogo1),
      //           child: SvgPicture.asset(ImageAssets.onboardingLogo1),
      //         );
      //       }
      //     }
      //   },
      //   // child: Center(
      //   //   child: Image.network(
      //   //       'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),
      //   // ),
      // ),
    );
  }
}
