import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/on_boarding/screen/onboarding_screen.dart';
import 'package:todoapp/app/settings/logic/signin_provider.dart';
import 'package:splashscreen/splashscreen.dart' as splashScreenPackage;
import 'package:todoapp/app/logic/theme_provider.dart';
import 'package:todoapp/app/logic/uncheck_provider.dart';

import '../../../applocalizations.dart';
import '../../logic/connection_provider.dart';
import '../../notes list/screen/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Widget> loadHome() async {
    // TODO: check logic
    final _connState = Provider.of<ConnectionProvider>(Get.overlayContext, listen: false);
    final _signInProvider = Provider.of<SignInProvider>(Get.overlayContext, listen: false);
    final _themeProvider = Provider.of<ThemeProvider>(Get.overlayContext, listen: false);
    final _unCheckProvider = Provider.of<UnCheckProvider>(Get.overlayContext, listen: false);
    await _connState.connSub();
    await _connState.checkConn();
    await _unCheckProvider.checkDayChange();
    await _themeProvider.initialColorsAndLan();
    await _signInProvider.checkSignIn();
    await Future.delayed(Duration(seconds: 2));
    return Future.value(_themeProvider.isFirstTime ? OnBoardingScreen() : NotesScreen());
  }

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(brightness: _themeProvider.brightness),
      child: new splashScreenPackage.SplashScreen(
        navigateAfterFuture: loadHome(),
        image: Image.asset(_themeProvider.splashImage ?? 'assets/images/SplashScreenWhite.gif'),
        loaderColor: _themeProvider.textColor,
        backgroundColor: _themeProvider.mainColor,
        photoSize: 100,
        loadingText: Text(
          AppLocalizations.of(context).translate('patient'),
          style: TextStyle(color: _themeProvider.textColor),
        ),
      ),
    );
  }
}
