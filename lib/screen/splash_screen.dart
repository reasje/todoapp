import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
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
    final _myprovider = Provider.of<myProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        brightness: _myprovider.brightness),
        
      child: new SplashScreen(
        seconds: 2,
        image: Image.asset(_myprovider.splashImage ?? 'assets/images/SplashScreenWhite.gif'),
        navigateAfterSeconds: Home(),
        loaderColor: _myprovider.textColor,
        backgroundColor: _myprovider.mainColor,
        photoSize: 100,
        loadingText: Text(
          uiKit.AppLocalizations.of(context).translate('patient'),
          style: TextStyle(color: _myprovider.textColor),
        ),
      ),
    );
  }
}
