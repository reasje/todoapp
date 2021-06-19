import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavWidget extends StatefulWidget {
  BottomNavWidget({Key key}) : super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int selectedIndex = 0;
  Color backgroundColor = Colors.white;
  List<NavigationItem> items = [
    NavigationItem(Icon(FontAwesome.file_text), Text('Text')),
    NavigationItem(Icon(FontAwesome.hourglass), Text("Timer")),
    NavigationItem(Icon(FontAwesome.image), Text("Image")),
    NavigationItem(Icon(FontAwesome.audio_description), Text('Voice')),
  ];

  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 450),
      height: double.maxFinite,
      width: isSelected ? 120 : 50,
      padding: isSelected ? EdgeInsets.only(left: 16, right: 16) : null,
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: Row(
        children: [
          IconTheme(
              data: IconThemeData(
                  size: 24, color: isSelected ? backgroundColor : Colors.black),
              child: item.icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: isSelected ? DefaultTextStyle.merge(style: TextStyle(color: backgroundColor) ,child: item.title) : Container(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeX * 0.09,
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          var itemIndex = items.indexOf(item);
          return GestureDetector(
            child: _buildItem(item, selectedIndex == itemIndex),
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
