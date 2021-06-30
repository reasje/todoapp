import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/navigationitem_model.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';

class BottomNavWidget extends StatefulWidget {
  BottomNavWidget({Key key}) : super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  // Color backgroundColor = Colors.white;

  Widget _buildItem(
      NavigationItem item, bool isSelected, BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _themeProvider = Provider.of<ThemeProvider>(context , listen: false);
    return AnimatedContainer(
      duration: Duration(milliseconds: 450),
      height: double.maxFinite,
      width: isSelected ? SizeY * 0.25 : SizeY * 0.1,
      padding: isSelected
          ? EdgeInsets.only(left: SizeY * 0.03, right: SizeY * 0.02)
          : null,
      decoration: isSelected
          ? BoxDecoration(
              color: item.color.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              IconTheme(
                  data: IconThemeData(
                      size: 18,
                      color:
                          isSelected ? item.color : _themeProvider.textColor),
                  child: item.icon),
              Padding(
                padding: EdgeInsets.only(left: SizeY * 0.03),
                child: isSelected
                    ? DefaultTextStyle.merge(
                        style: TextStyle(
                            color: isSelected
                                ? item.color
                                : _themeProvider.textColor),
                        child: item.title)
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
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeX * 0.08,
      padding: EdgeInsets.symmetric(
          vertical: SizeX * 0.006, horizontal: SizeY * 0.01),
      decoration: BoxDecoration(
        color: _themeProvider.mainColor,
      ),

        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _bottomNavProvider.items.map((item) {
            var itemIndex = _bottomNavProvider.items.indexOf(item);
            return GestureDetector(
              child: _buildItem(
                  item, _bottomNavProvider.selectedTab == itemIndex, context),
              onTap: () {
                _bottomNavProvider.newTabSelected(itemIndex);
              },
            );
          }).toList(),
        )
      
    );
  }
}


