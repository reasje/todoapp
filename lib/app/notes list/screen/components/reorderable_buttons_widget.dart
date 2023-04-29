import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/app/settings/screen/settings_screen.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../../applocalizations.dart';
import '../../../../widgets/buttons.dart';
import '../../../donate/screen/donate_screen.dart';
import '../../../splash/connection_logic.dart';

class ReOrderableListButtonsWidget extends StatelessWidget {
  const ReOrderableListButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _connectionState = Get.find<ConnectionLogic>().state;
    final _themeState = Get.find<ThemeLogic>().state;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: h * 0.03, bottom: h * 0.03, left: h * 0.03),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        locale.notesApp.tr,
                        style: TextStyle(color: _themeState.titleColor!.withOpacity(0.6), fontSize: _themeState.isEn! ? w * 0.09 : w * 0.07),
                      )),
                  Container(
                    child: Icon(
                      Icons.circle_outlined,
                      size: h * w * 0.00005,
                      color: _connectionState.isConnected ? Colors.green.withOpacity(0.6) : Colors.red.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                    backgroundColor: _themeState.textColor,
                    iconData: Icons.settings,
                    iconSize: h * w * 0.00005,
                    sizePD: w * 0.1,
                    sizePU: w * 0.1,
                    function: () {
                      Get.to(SettingsScreen(), transition: Transition.rightToLeft);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(h * w * 0.00004),
                    alignment: Alignment.centerLeft,
                    child: ButtonWidget(
                      backgroundColor: _themeState.textColor,
                      sizePD: w * 0.1,
                      sizePU: w * 0.1,
                      iconSize: h * w * 0.00006,
                      iconData: Icons.code,
                      function: () {
                        Get.to(DonateScreen(), transition: Transition.rightToLeft);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
