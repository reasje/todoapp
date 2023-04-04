import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/model/bottomnav_tab_model.dart';
import 'package:todoapp/model/navigationitem_model.dart';
import 'package:provider/provider.dart';
import '../../../widgets/dialog.dart';
import '../../logic/theme_provider.dart';
import '../screen/components/image_listview_widget.dart';
import '../screen/components/task_listview_widget.dart';
import '../screen/components/text_textfield_widget.dart';
import '../screen/components/title_textfield_widget.dart';
import '../screen/components/voice_listview_widget.dart';
import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';
import 'note_provider.dart';
import 'notecolor_provider.dart';
import 'notepassword_provider.dart';
import 'notetitletext_provider.dart';

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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
                  },
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
                    function: () {
                      final _noteTitleTextProvider = Provider.of<NoteTitleTextProvider>(context, listen: false);
                      _noteTitleTextProvider.canUndo ? _noteTitleTextProvider.changesUndo() : null;
                    },
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.redo_rounded,
                    function: () {
                      final _noteTitleTextProvider = Provider.of<NoteTitleTextProvider>(context, listen: false);
                      _noteTitleTextProvider.canRedo ? _noteTitleTextProvider.changesRedo() : null;
                    },
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.color_lens_outlined,
                    function: () {
                      List<Color> colors = Provider.of<ThemeProvider>(context, listen: false).getNoteColors();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Color(0xFF737373),
                              height: h * 0.1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Provider.of<ThemeProvider>(context, listen: false).mainColor,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                child: GridView(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: h * 0.05, crossAxisSpacing: h * 0.06, crossAxisCount: 5),
                                  padding: EdgeInsets.all(h * 0.01),
                                  children: colors
                                      .map((color) => InkWell(
                                            onTap: () {
                                              Provider.of<NoteColorProvider>(context, listen: false).noteColorSelected(color);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: h * 0.05,
                                              width: h * 0.05,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: color),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  ButtonWidget(
                    backgroundColor: items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.vpn_key_rounded,
                    function: () {
                      TextEditingController dialogController = TextEditingController(text: '');
                      final _notePasswordProvider = Provider.of<NotePasswordProvider>(Get.overlayContext, listen: false);
                      dialogController.text = _notePasswordProvider.password;
                      showAlertDialog(context,
                          title: AppLocalizations.of(context).translate('setPassword'),
                          hastTextField: true,
                          dialogController: dialogController,
                          textFieldHintText: AppLocalizations.of(Get.overlayContext).translate('passwordHint'),
                          textInputType: TextInputType.number,
                          okButtonText: AppLocalizations.of(context).translate('ok'),cancelButtonText: AppLocalizations.of(context).translate('cancel'),okButtonFunction: (){_notePasswordProvider.setPassword(dialogController.text);});
                    },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
                  },
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
                  function: () {
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
                ),
              ),
            ),
          ])
    ];

    notifyListeners();
  }
}
