import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/bottomnav_tab_model.dart';
import 'package:todoapp/model/navigationitem_model.dart';

import '../screen/components/image_listview_widget.dart';
import '../screen/components/task_listview_widget.dart';
import '../screen/components/text_textfield_widget.dart';
import '../screen/components/title_textfield_widget.dart';
import '../screen/components/voice_listview_widget.dart';
import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';

class BottomNavProvider with ChangeNotifier {
  int selectedTab = 0;

  List<BottomNavTab> tabs = [];

  List<Color> tabColors = [Color(0xffaa66cc), Color(0xFFff4444), Color(0xFFffbb33), Color(0xFF33b5e5), Color(0xFF00c851)];

  PageController pageController;

  List<NavigationItem> items;

  void initialSelectedTab() {
    selectedTab == null ? selectedTab = 0 : null;
  }

  void initialPage() {
    pageController = new PageController(initialPage: selectedTab, keepPage: true);
  }

  void newTabSelected(int index) {
    selectedTab = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  void newTabSelectedAnimation(int index) {
    selectedTab = index;
    pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.ease);
    notifyListeners();
  }

  Future<void> initialTabs(
    BuildContext context,
  ) async {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    tabColors.shuffle();
    items = [
      NavigationItem(Icon(Icons.text_fields), Text(AppLocalizations.of(context).translate('text')), tabColors[0]),
      NavigationItem(Icon(Icons.hourglass_empty), Text(AppLocalizations.of(context).translate('timer')), tabColors[1]),
      NavigationItem(Icon(Icons.image_outlined), Text(AppLocalizations.of(context).translate('image')), tabColors[2]),
      NavigationItem(Icon(Icons.voicemail), Text(AppLocalizations.of(context).translate('voice')), tabColors[3]),
      NavigationItem(Icon(Icons.check), Text(AppLocalizations.of(context).translate('task')), tabColors[4]),
    ];

    tabs = [
      BottomNavTab(
          'Text',
          [
            TitleTextField(),
            TextTextField(),
          ],
          items[0].color,
          [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: items[0].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.undo_rounded,
                    id: 'undo',
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.redo_rounded,
                    id: 'redo',
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.color_lens_outlined,
                    id: 'color',
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.vpn_key_rounded,
                    id: 'password',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: items[0].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          "Image",
          [ImageLisView()],
          items[2].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: items[2].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: items[2].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Voice',
          [VoiceListView(backGroundColor: items[3].color)],
          items[3].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: items[3].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: items[3].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  id: 'cancel',
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Task',
          [
            TaskListView(
              color: items[4].color,
            )
          ],
          items[4].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: items[4].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  id: 'save',
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: items[4].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
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
