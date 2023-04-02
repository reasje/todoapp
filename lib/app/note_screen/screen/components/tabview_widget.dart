import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/no_glow_behavior.dart';

class TabView extends StatefulWidget {
  final index;
  final timerOn;
  TabView({
    Key key,
    this.index,
    this.timerOn,
  }) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    bool timerOn = widget.timerOn ?? false;
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context);
    double h = MediaQuery.of(context).size.height;
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: ListView(
        children: [
          Container(
            height: h * 0.05,
            width: double.maxFinite,
            margin: EdgeInsets.only(top: h * 0.02),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [if (!timerOn) ..._bottomNavProvider.tabs[index].buttons else _bottomNavProvider.tabs[index].buttons[0]],
            ),
          ),
          if (!timerOn)
            ..._bottomNavProvider.tabs[index].tabs
          else
            Center(
              child: Text(
                AppLocalizations.of(context).translate('timerOn'),
                style: TextStyle(
                    color: _bottomNavProvider.tabColors[_bottomNavProvider.selectedTab],
                    fontSize: _themeProvider.isEn ? h * w * 0.00008 : h * w * 0.00006,
                    fontWeight: FontWeight.w400),
              ),
            ),
        ],
      ),
    );
  }
}
