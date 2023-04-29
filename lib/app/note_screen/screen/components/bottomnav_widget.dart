import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todoapp/model/navigationitem_model.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';

class BottomNavWidget extends StatefulWidget {
  BottomNavWidget({Key? key}) : super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  // Color backgroundColor = Colors.white;

  Widget _buildItem(NavigationItem item, bool isSelected, BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final _themeState = Get.find<ThemeLogic>().state;
    return AnimatedContainer(
      duration: Duration(milliseconds: 450),
      height: double.maxFinite,
      width: isSelected ? w * 0.25 : w * 0.1,
      padding: isSelected ? EdgeInsets.only(left: w * 0.03, right: w * 0.02) : null,
      decoration: isSelected ? BoxDecoration(color: item.color.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(50))) : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              IconTheme(data: IconThemeData(size: 18, color: isSelected ? item.color : _themeState.textColor), child: item.icon),
              Padding(
                padding: EdgeInsets.only(left: w * 0.03),
                child: isSelected
                    ? DefaultTextStyle.merge(style: TextStyle(color: isSelected ? item.color : _themeState.textColor), child: item.title)
                    : Container(),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final _themeState = Get.find<ThemeLogic>().state;
    final _bottomNavLogic = Get.find<BottomNavLogic>();
    return Container(
        width: MediaQuery.of(context).size.width,
        height: h * 0.08,
        padding: EdgeInsets.symmetric(vertical: h * 0.006, horizontal: w * 0.01),
        decoration: BoxDecoration(
          color: _themeState.mainColor,
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _bottomNavLogic.state.items.map((item) {
            var itemIndex = _bottomNavLogic.state.items.indexOf(item);
            return GestureDetector(
              child: _buildItem(item, _bottomNavLogic.state.selectedTab == itemIndex, context),
              onTap: () {
                _bottomNavLogic.newTabSelected(itemIndex);
              },
            );
          }).toList(),
        ));
  }
}
