import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/conn_provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/signin_provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'onboarding_screen.dart';

class MySplashScreen extends StatefulWidget {
  MySplashScreen({Key key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  // Future<bool> init;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   final _connState = Provider.of<ConnState>(context, listen: false);
  //   init = _connState.connSub();
  // }
  Future<Widget> loadHome() async {
    final _myprovider = Provider.of<myProvider>(context);
    final _connState = Provider.of<ConnState>(context);
    final _signinState = Provider.of<SigninState>(context);
    await _connState.connSub();
    await _connState.checkConn();
    await _myprovider.checkDayChange();
    await _myprovider.initialColorsAndLan();
    await _signinState.checkSignin();
    await Future.delayed(Duration(seconds: 2));
    return Future.value(_myprovider.isFirstTime ? Onboarding() : uiKit.MyRorderable());
  }

  @override
  Widget build(BuildContext context) {
    final _myprovider = Provider.of<myProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(brightness: _myprovider.brightness),
      child: new SplashScreen(
        navigateAfterFuture: loadHome(),
        image: Image.asset(
            _myprovider.splashImage ?? 'assets/images/SplashScreenWhite.gif'),
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