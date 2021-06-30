import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
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
    final _bottomNavProvider =
        Provider.of<BottomNavProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeY = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          height: SizeX * 0.05,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: SizeX * 0.02),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!timerOn)
                ..._bottomNavProvider.tabs[index].buttons
              else
                _bottomNavProvider.tabs[index].buttons[0]
            ],
          ),
        ),
        if (!timerOn)
          ..._bottomNavProvider.tabs[index].tabs
        else
          Center(
            child: Text(
              uiKit.AppLocalizations.of(context).translate('timerOn'),
              style: TextStyle(
                  color: _bottomNavProvider
                      .tabColors[_bottomNavProvider.selectedTab],
                  fontSize: _themeProvider.isEn
                      ? SizeX * SizeY * 0.00008
                      : SizeX * SizeY * 0.00006,
                  fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}