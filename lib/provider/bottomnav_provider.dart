import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/bottomnav_tab_model.dart';
import 'package:todoapp/model/navigationitem_model.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class BottomNavProvider with ChangeNotifier{
  int selectedTab = 0;


  List<BottomNavTab> tabs = [];


  List<Color> tabColors = [
    Color(0xffaa66cc),
    Color(0xFFff4444),
    Color(0xFFffbb33),
    Color(0xFF33b5e5),
    Color(0xFF00c851)
  ];


  PageController pageController;


  List<NavigationItem> items;


    void initialSelectedTab(){
      selectedTab == null ? selectedTab = 0 : null;
    }


    void initialPage(){
          pageController =
        new PageController(initialPage: selectedTab, keepPage: true);
    }


  void newTabSelected(int index) {
    selectedTab = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  void newTabSelectedAnimation(int index) {
    selectedTab = index;
    pageController.animateToPage(index,
        duration: Duration(seconds: 1), curve: Curves.ease);
    notifyListeners();
  }

  
  void initialTabs(BuildContext context ,) async {

    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;

    tabColors.shuffle();
    items = [
      NavigationItem(
          Icon(Icons.text_fields),
          Text(uiKit.AppLocalizations.of(context).translate('text')),
          tabColors[0]),
      NavigationItem(
          Icon(Icons.hourglass_empty),
          Text(uiKit.AppLocalizations.of(context).translate('timer')),
          tabColors[1]),
      NavigationItem(
          Icon(Icons.image_outlined),
          Text(uiKit.AppLocalizations.of(context).translate('image')),
          tabColors[2]),
      NavigationItem(
          Icon(Icons.voicemail),
          Text(uiKit.AppLocalizations.of(context).translate('voice')),
          tabColors[3]),
      NavigationItem(
          Icon(Icons.check),
          Text(uiKit.AppLocalizations.of(context).translate('task')),
          tabColors[4]),
    ];

    tabs = [
      BottomNavTab(
          'Text',
          [
            uiKit.titleTextField(),
            uiKit.textTextField(),
          ],
          items[0].color,
          [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: uiKit.MyButton(
                  backgroundColor: items[0].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  uiKit.MyButton(
                    backgroundColor: items[0].color,
                    sizePU: SizeXSizeY * 0.00017,
                    sizePD: SizeXSizeY * 0.00018,
                    iconSize: SizeX * SizeY * 0.00008,
                    iconData: Icons.undo_rounded,
                    id: 'undo',
                  ),
                  uiKit.MyButton(
                    backgroundColor: items[0].color,
                    sizePU: SizeXSizeY * 0.00017,
                    sizePD: SizeXSizeY * 0.00018,
                    iconSize: SizeX * SizeY * 0.00008,
                    iconData: Icons.redo_rounded,
                    id: 'redo',
                  ),
                  uiKit.MyButton(
                    backgroundColor: items[0].color,
                    sizePU: SizeXSizeY * 0.00017,
                    sizePD: SizeXSizeY * 0.00018,
                    iconSize: SizeX * SizeY * 0.00008,
                    iconData: Icons.color_lens_outlined,
                    id: 'color',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: uiKit.MyButton(
                  backgroundColor: items[0].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          "Timer",
          [uiKit.TimerWidget()],
          items[1].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: uiKit.MyButton(
                  backgroundColor: items[1].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: uiKit.MyButton(
                backgroundColor: items[1].color,
                sizePU: SizeXSizeY * 0.00017,
                sizePD: SizeXSizeY * 0.00018,
                iconSize: SizeX * SizeY * 0.00008,
                iconData: Icons.hourglass_empty,
                id: 'timer',
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: uiKit.MyButton(
                  backgroundColor: items[1].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          "Image",
          [uiKit.ImageLisView()],
          items[2].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: uiKit.MyButton(
                  backgroundColor: items[2].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: uiKit.MyButton(
                  backgroundColor: items[2].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Voice',
          [uiKit.voiceListView(backGroundColor: items[3].color)],
          items[3].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: uiKit.MyButton(
                  backgroundColor: items[3].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: uiKit.MyButton(
                  backgroundColor: items[3].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Task',
          [
            uiKit.taskListView(
              color: items[4].color,
            )
          ],
          items[4].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: uiKit.MyButton(
                  backgroundColor: items[4].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: uiKit.MyButton(
                  backgroundColor: items[4].color,
                  sizePU: SizeXSizeY * 0.00017,
                  sizePD: SizeXSizeY * 0.00018,
                  iconSize: SizeX * SizeY * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ])
    ];

    notifyListeners();
  }
}