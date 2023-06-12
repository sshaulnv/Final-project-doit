import 'package:doit_app/shared/constants/constants.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../screen_container.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/logo.png',
      ),
      logoWidth: 150,
      backgroundColor: kWhiteBackgroundColor,
      showLoader: true,
      loaderColor: kColorBlueText,
      loadingText: Text("Loading..."),
      navigator: ScreenContainer(),
      durationInSeconds: 3,
    );
  }
}
