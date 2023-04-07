import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/app/note_screen/state/note_color_state.dart';
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
import '../state/bottim_navigation_state.dart';
import 'note_provider.dart';
import 'notecolor_logic.dart';
import 'notepassword_logic.dart';
import 'notetitletext_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';

class BottomNavLogic extends GetxController {
  BottomNavState state = BottomNavState();

  void initialSelectedTab() {
    state.selectedTab == null ? state.selectedTab = 0 : null;
  }

  void initialPage() {
    state.pageController = new PageController(initialPage: state.selectedTab, keepPage: true);
  }

  void newTabSelected(int index) {
    state.selectedTab = index;
    state.pageController.jumpToPage(index);
  }

  void newTabSelectedAnimation(int index) {
    state.selectedTab = index;
    state.pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  Future<void> initialTabs(
    BuildContext context,
  ) async {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    state.tabColors.shuffle();
    state.items.addAll([
      NavigationItem(Icon(Icons.text_fields), Text( locale.text.tr), state.tabColors[0]),
      NavigationItem(Icon(Icons.hourglass_empty), Text( locale.timer.tr), state.tabColors[1]),
      NavigationItem(Icon(Icons.image_outlined), Text( locale.image.tr), state.tabColors[2]),
      NavigationItem(Icon(Icons.voicemail), Text( locale.voice.tr), state.tabColors[3]),
      NavigationItem(Icon(Icons.check), Text( locale.task.tr), state.tabColors[4]),
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
                                              Provider.of<NoteColorLogic>(context, listen: false).noteColorSelected(color);
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
                      final _notePasswordLogic = Provider.of<NotePasswordLogic>(Get.overlayContext, listen: false);
                      dialogController.text = _notePasswordLogic.state.password;
                      showAlertDialog(context,
                          title:  locale.setPassword.tr,
                          hastTextField: true,
                          dialogController: dialogController,
                          textFieldhintText:  locale.passwordHint.tr,
                          textInputType: TextInputType.number,
                          okButtonText:  locale.ok.tr,
                          cancelButtonText:  locale.cancel.tr, okButtonFunction: () {
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
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
                ),
              ),
            ),
          ]),
      BottomNavTab(
          "Image",
          [ImageLisView()],
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
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
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
                    Provider.of<NoteProvider>(context, listen: false).cancelClicked(context);
                  },
                ),
              ),
            ),
          ]),
      BottomNavTab(
          'Voice',
          [VoiceListView(backGroundColor: state.items[3].color)],
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
                    Provider.of<NoteProvider>(context, listen: false).doneClicked(context);
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
              color: state.items[4].color,
            )
          ],
          state.items[4].color,
          [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(
                  backgroundColor: state.items[4].color,
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
                  backgroundColor: state.items[4].color,
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
    ]);
  }
}
