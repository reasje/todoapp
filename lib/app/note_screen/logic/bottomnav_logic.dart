import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/app/note_screen/state/note_color_state.dart';
import 'package:todoapp/model/bottomnav_tab_model.dart';
import 'package:todoapp/model/navigationitem_model.dart';

import '../../../widgets/dialog.dart';
import '../../../theme/theme_logic.dart';
import '../screen/components/image_listview_widget.dart';
import '../screen/components/task_listview_widget.dart';
import '../screen/components/text_textfield_widget.dart';
import '../screen/components/title_textfield_widget.dart';
import '../screen/components/voice_listview_widget.dart';
import '../../../applocalizations.dart';
import '../../../widgets/buttons.dart';
import '../state/bottim_navigation_state.dart';
import 'note_logic.dart';
import 'notecolor_logic.dart';
import 'notepassword_logic.dart';
import 'notetitletext_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';

class BottomNavLogic extends GetxController {
  BottomNavState state = BottomNavState();

  @override
  void onInit() {
    initialTabs();
    super.onInit();
  }

  void initialPage() {
    state.pageController = new PageController(initialPage: state.selectedTab, keepPage: true);
  }

  void newTabSelected(int index) {
    state.selectedTab = index;
    state.pageController!.jumpToPage(index);
  }

  void newTabSelectedAnimation(int index) {
    state.selectedTab = index;
    state.pageController!.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  Future<void> initialTabs(
  ) async {
    double h = Get.height;
    double w = Get.width;

    state.tabColors.shuffle();
    state.items.addAll([
      NavigationItem(Icon(Icons.text_fields), Text(locale.text.tr), state.tabColors[0]),
      NavigationItem(Icon(Icons.image_outlined), Text(locale.image.tr), state.tabColors[2]),
      NavigationItem(Icon(Icons.voicemail), Text(locale.voice.tr), state.tabColors[3]),
      NavigationItem(Icon(Icons.check), Text(locale.task.tr), state.tabColors[4]),
    ]);

    state.tabs.addAll([
      BottomNavTab(
          'Text',
          [
            TitleTextField(),
            TextTextField(),
          ],
          state.items[0].color,
          [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: state.items[0].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  function: () {
                    Get.find<NoteLogic>().doneClicked();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  ButtonWidget(
                    backgroundColor: state.items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.undo_rounded,
                    function: () {
                      final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();
                      _noteTitleTextLogic.state.canUndo ? _noteTitleTextLogic.changesUndo() : null;
                    },
                  ),
                  ButtonWidget(
                    backgroundColor: state.items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.redo_rounded,
                    function: () {
                      final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();
                      _noteTitleTextLogic.state.canRedo ? _noteTitleTextLogic.changesRedo() : null;
                    },
                  ),
                  ButtonWidget(
                    backgroundColor: state.items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.color_lens_outlined,
                    function: () {
                      List<Color> colors = NoteColorState.noteColors;
                      showModalBottomSheet(
                          context: Get.context!,
                          builder: (context) {
                            return Container(
                              color: Color(0xFF737373),
                              height: h * 0.1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Get.find<ThemeLogic>().state.mainColor,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                child: GridView(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: h * 0.05, crossAxisSpacing: h * 0.06, crossAxisCount: 5),
                                  padding: EdgeInsets.all(h * 0.01),
                                  children: colors
                                      .map((color) => InkWell(
                                            onTap: () {
                                              Get.find<NoteColorLogic>().noteColorSelected(color);
                                              Get.back();
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
                    backgroundColor: state.items[0].color,
                    sizePU: h * w * 0.00017,
                    sizePD: h * w * 0.00018,
                    iconSize: h * w * 0.00008,
                    iconData: Icons.vpn_key_rounded,
                    function: () {
                      TextEditingController dialogController = TextEditingController(text: '');
                      final _notePasswordLogic = Get.find<NotePasswordLogic>();
                      dialogController.text = _notePasswordLogic.state.password!;
                      showAlertDialog(
                          title: locale.setPassword.tr,
                          hastTextField: true,
                          dialogController: dialogController,
                          textFieldhintText: locale.passwordHint.tr,
                          textInputType: TextInputType.number,
                          okButtonText: locale.ok.tr,
                          cancelButtonText: locale.cancel.tr,
                          okButtonFunction: () {
                            _notePasswordLogic.setPassword(dialogController.text);
                          });
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
                  backgroundColor: state.items[0].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  function: () {
                    Get.find<NoteLogic>().cancelClicked();
                  },
                ),
              ),
            ),
          ]),
      BottomNavTab(
          "Image",
          [ImageLisView()],
          state.items[1].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: state.items[1].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  function: () {
                    Get.find<NoteLogic>().doneClicked();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: state.items[1].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  function: () {
                    Get.find<NoteLogic>().cancelClicked();
                  },
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Voice',
          [VoiceListView(backGroundColor: state.items[2].color)],
          state.items[2].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: state.items[2].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  function: () {
                    Get.find<NoteLogic>().doneClicked();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: state.items[2].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  function: () {
                    Get.find<NoteLogic>().cancelClicked();
                  },
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Task',
          [
            TaskListView(
              color: state.items[3].color,
            )
          ],
          state.items[3].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: state.items[3].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.arrow_back_ios_new_rounded,
                  function: () {
                    Get.find<NoteLogic>().doneClicked();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: ButtonWidget(
                  backgroundColor: state.items[3].color,
                  sizePU: h * w * 0.00017,
                  sizePD: h * w * 0.00018,
                  iconSize: h * w * 0.00008,
                  iconData: Icons.close_rounded,
                  function: () {
                    Get.find<NoteLogic>().cancelClicked();
                  },
                ),
              ),
            ),
          ])
    ]);
  }
}
