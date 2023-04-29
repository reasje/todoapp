import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';

class TabView extends StatefulWidget {
  final index;
  final timerOn;
  TabView({
    Key? key,
    this.index,
    this.timerOn,
  }) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    int? index = widget.index;
    bool timerOn = widget.timerOn ?? false;
    final _bottomNavLogic = Get.find<BottomNavLogic>();
    double h = MediaQuery.of(context).size.height;
    final _themeState = Get.find<ThemeLogic>().state;
    double w = MediaQuery.of(context).size.width;
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: Obx(() {
        return ListView(
          children: [
            Container(
              height: h * 0.05,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: h * 0.02),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [if (!timerOn) ..._bottomNavLogic.state.tabs[index!].buttons else _bottomNavLogic.state.tabs[index!].buttons[0]],
              ),
            ),
            if (!timerOn)
              ..._bottomNavLogic.state.tabs[index].tabs
            else
              Center(
                child: Text(
                  locale.timerOn.tr,
                  style: TextStyle(
                      color: _bottomNavLogic.state.tabColors[_bottomNavLogic.state.selectedTab],
                      fontSize: _themeState.isEn! ? h * w * 0.00008 : h * w * 0.00006,
                      fontWeight: FontWeight.w400),
                ),
              ),
          ],
        );
      }),
    );
  }
}
