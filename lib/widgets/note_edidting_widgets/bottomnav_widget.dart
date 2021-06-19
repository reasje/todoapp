import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';

class BottomNavWidget extends StatefulWidget {
  BottomNavWidget({Key key}) : super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int selectedIndex = 0;
  Color backgroundColor = Colors.white;
  List<NavigationItem> items = [
    NavigationItem(Icon(Icons.text_fields), Text('Text')),
    NavigationItem(Icon(FontAwesome.hourglass), Text("Timer")),
    NavigationItem(Icon(FontAwesome.image), Text("Image")),
    NavigationItem(Icon(FontAwesome.music), Text('Voice')),
  ];

  Widget _buildItem(
      NavigationItem item, bool isSelected, BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 450),
      height: double.maxFinite,
      width: isSelected ? SizeY*0.25 : SizeY*0.1,
      padding: isSelected ? EdgeInsets.only(left: SizeY*0.03, right: SizeY*0.02) : null,
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: Row(
        children: [
          IconTheme(
              data: IconThemeData(
                  size: 18, color: isSelected ? backgroundColor : Colors.black),
              child: item.icon),
          Padding(
            padding: EdgeInsets.only(left:SizeY*0.03),
            child: isSelected
                ? DefaultTextStyle.merge(
                    style: TextStyle(color: backgroundColor), child: item.title)
                : Container(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _myProvider = Provider.of<NoteProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeX * 0.08,
      padding: EdgeInsets.symmetric(
          vertical: SizeX * 0.006, horizontal: SizeY * 0.01),
      decoration: BoxDecoration(
        color: _themeProvider.mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          var itemIndex = items.indexOf(item);
          return GestureDetector(
            child: _buildItem(item, selectedIndex == itemIndex , context),
            onTap: () {
              setState(() {
                selectedIndex = itemIndex;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  NavigationItem(this.icon, this.title);
}
