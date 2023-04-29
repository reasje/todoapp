import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/app/on_boarding/screen/onboarding_screen.dart';
import 'package:todoapp/app/settings/settings_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/app/splash/uncheck_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../applocalizations.dart';
import '../connection_logic.dart';
import '../../notes list/screen/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _connectionLogic = Get.put(ConnectionLogic());
  final _unCheckLogic = Get.put(UnCheckLogic());

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        loadHome().then((value) => Get.to(() => value));
      },
    );
  }

  Future<Widget> loadHome() async {
    // TODO: check logic
    final _themeState = Get.find<ThemeLogic>();
    // Timer.periodic(Duration(seconds: 60), (timer) {
    // check for if the day is changed
    // if changed will handle the
    // check box uncheck duty for
    // new day .
    UnCheckLogic.checkDayChange();
    // });
    await _themeState.initialColorsAndLan();
    await Future.delayed(Duration(seconds: 2));
    return Future.value(Get.find<ThemeLogic>().state.isFirstTime! ? OnBoardingScreen() : NotesScreen());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final _themeState = Get.find<ThemeLogic>().state;
    return Scaffold(
      backgroundColor: _themeState.mainColor!,
      body: Column(
        children: [
          SizedBox(
            height: width * 0.25,
          ),
          Center(
            child: Container(
              height: width * 0.5,
              width: width * 0.5,
              decoration: BoxDecoration(color: _themeState.mainColor!, borderRadius: BorderRadius.circular(30)),
              child: Image.asset(_themeState.splashImage ?? 'assets/images/SplashScreenWhite.gif'),
            ),
          ),
          SizedBox(
            height: width * 0.13,
          ),
          Container(
            height: width * 0.225,
            width: width * 0.275,
            decoration: BoxDecoration(color: _themeState.mainColor!, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 6.0,color: _themeState.textColor!),
            ),
          ),
          SizedBox(
            height: width * 0.15,
          ),
          Text(
            locale.patient.tr,
            style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w400, color: _themeState.textColor),
          ),
        ],
      ),
    );
  }
}
