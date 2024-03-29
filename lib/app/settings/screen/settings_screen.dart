import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/app/settings/drive_logic.dart';

import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialog.dart';
import '../../splash/connection_logic.dart';
import '../settings_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  final logic = Get.put(SettingsLogic());
  final state = Get.find<SettingsLogic>().state;
  @override
  Widget build(BuildContext context) {
    final _themeLogic = Get.find<ThemeLogic>();
    final _themeState = _themeLogic.state;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _themeState.mainColor,
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
                      backgroundColor: _themeState.textColor,
                      sizePU: h * w * 0.00017,
                      sizePD: h * w * 0.00018,
                      iconSize: h * w * 0.00008,
                      iconData: Icons.arrow_back_ios,
                      function: () {
                        Get.back();
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
                            BoxDecoration(color: _themeState.textColor!.withOpacity(0.1), borderRadius: BorderRadius.circular(h * w * 0.0001)),
                        child: Center(
                          child: Text(
                            locale.googleBackup.tr,
                            style: TextStyle(color: _themeState.textColor, fontSize: _themeState.isEn! ? h * w * 0.00008 : h * w * 0.00007),
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
                              backgroundColor: _themeState.textColor,
                              sizePU: h * w * 0.00012,
                              sizePD: h * w * 0.00013,
                              iconSize: h * w * 0.00006,
                              iconData: Icons.download,
                              function: () {
                                DriveLogic.login(false, context);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(h * w * 0.00004),
                            alignment: Alignment.centerLeft,
                            child: ButtonWidget(
                              backgroundColor: _themeState.textColor,
                              sizePU: h * w * 0.00012,
                              sizePD: h * w * 0.00013,
                              iconSize: h * w * 0.00006,
                              iconData: Icons.upload,
                              function: () {
                                DriveLogic.login(true, context);
                              },
                            ),
                          ),
                          Obx(() {
                            return Container(
                              padding: EdgeInsets.all(h * w * 0.00004),
                              alignment: Alignment.centerLeft,
                              child: ButtonWidget(
                                backgroundColor: _themeState.textColor,
                                sizePU: h * w * 0.00012,
                                sizePD: h * w * 0.00013,
                                function: () {
                                  final connectionState = Get.find<ConnectionLogic>().state;
                                  if (connectionState.isConnected) {
                                    logic.signInToAccount();
                                  } else {
                                    showAlertDialog(title: locale.noInternet.tr, okButtonText: locale.ok.tr, cancelButtonText: locale.cancel.tr);
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.google,
                                  size: h * w * 0.00006 * 0.8,
                                  color: logic.state.isSignedIn ? Colors.green : Colors.red,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: h * w * 0.00025,
                  width: h * w * 0.0004,
                  decoration: BoxDecoration(color: _themeState.textColor!.withOpacity(0.1), borderRadius: BorderRadius.circular(h * w * 0.0001)),
                  child: Center(
                    child: Text(
                      locale.theme.tr,
                      style: TextStyle(color: _themeState.textColor, fontSize: _themeState.isEn! ? h * w * 0.00008 : h * w * 0.00007),
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
                        backgroundColor: _themeState.textColor,
                        sizePU: h * w * 0.00017,
                        sizePD: h * w * 0.00018,
                        iconSize: h * w * 0.0001,
                        iconData: Icons.language,
                        function: () {
                          _themeLogic.changeLan();
                        },
                      ),
                      ButtonWidget(
                        backgroundColor: _themeState.textColor,
                        sizePU: h * w * 0.00017,
                        sizePD: h * w * 0.00018,
                        iconSize: h * w * 0.0001,
                        iconData: FontAwesomeIcons.lightbulb,
                        function: () {
                          _themeLogic.changeBrightness();
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
