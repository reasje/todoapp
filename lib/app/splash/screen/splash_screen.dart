import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/on_boarding/screen/onboarding_screen.dart';
import 'package:todoapp/app/settings/settings_logic.dart';
import 'package:splashscreen/splashscreen.dart' as splashScreenPackage;
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/app/splash/uncheck_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../applocalizations.dart';
import '../connection_logic.dart';
import '../../notes list/screen/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _connectionLogic = Get.put(ConnectionLogic());
  final _unCheckLogic = Get.put(UnCheckLogic());

  Future<Widget> loadHome() async {
    // TODO: check logic
    final _themeState = Provider.of<ThemeLogic>(Get.overlayContext, listen: false);
    // Timer.periodic(Duration(seconds: 60), (timer) {
    // check for if the day is changed
    // if changed will handle the
    // check box uncheck duty for
    // new day .
    UnCheckLogic.checkDayChange();
    // });
    await _themeState.initialColorsAndLan();
    await Future.delayed(Duration(seconds: 2));
    return Future.value(Get.find<ThemeLogic>().state.isFirstTime ? OnBoardingScreen() : NotesScreen());
  }

  @override
  Widget build(BuildContext context) {
    final _themeState = Get.find<ThemeLogic>().state;
    return Theme(
      data: Theme.of(context).copyWith(brightness: _themeState.brightness),
      child: new splashScreenPackage.SplashScreen(
        navigateAfterFuture: loadHome(),
        image: Image.asset(_themeState.splashImage ?? 'assets/images/SplashScreenWhite.gif'),
        loaderColor: _themeState.textColor,
        backgroundColor: _themeState.mainColor,
        photoSize: 100,
        loadingText: Text(
          locale.patient.tr,
          style: TextStyle(color: _themeState.textColor),
        ),
      ),
    );
  }
}
