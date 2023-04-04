import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';
import 'package:todoapp/app/settings/logic/drive_provider.dart';

import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialog.dart';
import '../../logic/connection_provider.dart';
import '../logic/signin_provider.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _themeProvider.mainColor,
      body: SafeArea(
        child: Container(
          height: h,
          width: w,
          child: Column(
            children: [
              Container(
                height: h * 0.05,
                width: double.maxFinite,
                margin: EdgeInsets.only(top: h * 0.02),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonWidget(
                      backgroundColor: _themeProvider.textColor,
                      sizePU: h * w * 0.00017,
                      sizePD: h * w * 0.00018,
                      iconSize: h * w * 0.00008,
                      iconData: Icons.arrow_back_ios,
                      function: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(h * w * 0.00008),
                child: Column(
                  children: [
                    Container(
                        height: h * w * 0.00025,
                        width: h * w * 0.0006,
                        decoration:
                            BoxDecoration(color: _themeProvider.textColor.withOpacity(0.1), borderRadius: BorderRadius.circular(h * w * 0.0001)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('googleBackup'),
                            style: TextStyle(color: _themeProvider.textColor, fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00007),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.all(h * 0.035),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(h * w * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: ButtonWidget(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: h * w * 0.00012,
                              sizePD: h * w * 0.00013,
                              iconSize: h * w * 0.00006,
                              iconData: FontAwesome.download,
                              function: () {
                                DriveLogic.login(false, context);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(h * w * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: ButtonWidget(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: h * w * 0.00012,
                              sizePD: h * w * 0.00013,
                              iconSize: h * w * 0.00006,
                              iconData: FontAwesome.upload,
                              function: () {
                                DriveLogic.login(true, context);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(h * w * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: ButtonWidget(
                              backgroundColor: _themeProvider.textColor,
                              sizePU: h * w * 0.00012,
                              sizePD: h * w * 0.00013,
                              function: () {
                                if (Provider.of<ConnectionProvider>(context, listen: false).is_conn) {
                                  Provider.of<SignInProvider>(context, listen: false).signInToAccount();
                                } else {
                                  showAlertDialog(context,title: AppLocalizations.of(context).translate('noInternet'),okButtonText: AppLocalizations.of(context).translate('ok'),cancelButtonText: AppLocalizations.of(context).translate('cancel'));
                                }
                              },
                              child: Icon(
                                FontAwesome.google,
                                size: h * w * 0.00006 * 0.8,
                                color: Provider.of<SignInProvider>(context, listen: false).isSignedin ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: h * w * 0.00025,
                  width: h * w * 0.0004,
                  decoration: BoxDecoration(color: _themeProvider.textColor.withOpacity(0.1), borderRadius: BorderRadius.circular(h * w * 0.0001)),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate('theme'),
                      style: TextStyle(color: _themeProvider.textColor, fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00007),
                    ),
                  )),
              Container(
                margin: EdgeInsets.all(h * 0.035),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonWidget(
                        backgroundColor: _themeProvider.textColor,
                        sizePU: h * w * 0.00017,
                        sizePD: h * w * 0.00018,
                        iconSize: h * w * 0.0001,
                        iconData: FontAwesome.language,
                        function: () {
                          _themeProvider.changeLan();
                        },
                      ),
                      ButtonWidget(
                        backgroundColor: _themeProvider.textColor,
                        sizePU: h * w * 0.00017,
                        sizePD: h * w * 0.00018,
                        iconSize: h * w * 0.0001,
                        iconData: FontAwesome.lightbulb_o,
                        function: () {
                          _themeProvider.changeBrightness();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
