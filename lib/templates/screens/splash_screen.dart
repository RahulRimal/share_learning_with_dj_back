import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';

import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SessionProvider sessionProvider;

  @override
  void initState() {
    super.initState();
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    sessionProvider.bindSplashScreenViewModel(context);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    sessionProvider = Provider.of<SessionProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    sessionProvider.unBindSplashScreenViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Stack(children: [
        Center(
          //   child: Image.network(
          //       'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg'),

          child: SvgPicture.asset(ImageAssets.onboardingLogo2),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.2,
          left: 0,
          right: 0,
          child: Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: ColorManager.primary,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}
