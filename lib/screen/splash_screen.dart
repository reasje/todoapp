import 'package:flutter/material.dart';
import 'package:todoapp/screen/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:todoapp/uikit.dart' as uiKit;

class MySplashScreen extends StatefulWidget {
  MySplashScreen({Key key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
return new SplashScreen(
      seconds: 1,
      image: Image.asset('assets/todoapplogo.png'),
      navigateAfterSeconds: Home(),
      loaderColor: uiKit.Colors.whiteSmoke,
      backgroundColor: uiKit.Colors.darkBlue,
      photoSize: 100,
      loadingText: Text(
        uiKit.AppLocalizations.of(context).translate('patient'),
        style: TextStyle(
            color: uiKit.Colors.whiteSmoke, fontFamily: 'Iransans'),
      ),
    );
  }
}