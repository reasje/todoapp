import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/theme/theme_logic.dart';

import '../../../main.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/no_glow_behavior.dart';
import '../../note_screen/logic/bottomnav_logic.dart';
import '../../note_screen/logic/note_logic.dart';
import '../../note_screen/logic/notecolor_logic.dart';
import '../../note_screen/logic/noteimage_logic.dart';
import '../../note_screen/logic/notepassword_logic.dart';
import '../../note_screen/logic/notetask_logic.dart';
import '../../note_screen/logic/notetitletext_logic.dart';
import '../../note_screen/logic/notevoice_player_logic.dart';
import '../../note_screen/logic/notevoice_recorder_provider.dart';
import '../logic.dart';
import 'components/empty_notes.dart';
import 'components/fab_widget.dart';
import 'components/loadingcard_widget.dart';
import 'components/reorderable_buttons_widget.dart';
import 'components/reorderablecard_widget.dart';

class NotesScreen extends StatefulWidget {
  NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _logic = Get.put(NotesLogic());

  final _noteLogic = Get.put(NoteLogic());
  final _noteColorLogic = Get.put(NoteColorLogic());
  final _noteImageLogic = Get.put(NoteImageLogic());
  final _noteTaskLogic = Get.put(NoteTaskLogic());
  final _noteVoicePlayerLogic = Get.put(NoteVoicePlayerLogic());
  final _noteVoiceRecorderLogic = Get.put(NoteVoiceRecorderLogic());
  final _noteTitleTextLogic = Get.put(NoteTitleTextLogic());
  final _notePasswordLogic = Get.put(NotePasswordLogic());
  final _bottomNavLogic = Get.put(BottomNavLogic());


  final _state = Get.find<NotesLogic>().state;
  final _themeState = Get.find<ThemeLogic>().state;
  @override
  Widget build(BuildContext context) {
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _themeState.mainColor,
      body: Container(
          padding: EdgeInsets.only(top: h * w * 0.00008),
          width: w,
          child: ValueListenableBuilder(
              valueListenable: noteBox.listenable(),
              builder: (context, LazyBox<Note> notes, _) {
                List<int> keys = notes.keys.cast<int>().toList();
                return Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                    height: h,
                    width: w,
                    child: Column(
                      children: [
                        ReOrderableListButtonsWidget(),
                        if (noteBox.isEmpty)
                          EmptyNotes()
                        else
                          Align(
                            child: Container(
                                height: h * 0.84,
                                child: ScrollConfiguration(
                                  behavior: NoGlowBehavior(),
                                  child: AnimationLimiter(
                                    child: ReorderableListView(
                                      // physics:
                                      //     NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(bottom: h * 0.1, top: h * 0.01),
                                      children: [
                                        for (int index = 0; index < notes.length; index++)
                                          FutureBuilder(
                                              key: UniqueKey(),
                                              future: notes.get(keys[index]),
                                              builder: (context, snapShot) {
                                                if (snapShot.hasData) {
                                                  return ReOrderableCardWidget(
                                                    index: index,
                                                    notes: notes,
                                                    snapShot: snapShot,
                                                  );
                                                } else {
                                                  return LoadingCardWidget();
                                                }
                                              }),
                                      ],
                                      onReorder: (int oldIndex, int newIndex) async {
                                        _logic.reorderNoteList(oldIndex, newIndex);
                                        // if oldIndex < newIndex the flutter asumes the
                                        // newIndex is newIndex+1 for example new index yopu think is
                                        // 1 and old index is 0 but the realaity is  that new index is
                                        // 2 !
                                      },
                                    ),
                                  ),
                                )),
                          ),
                        Obx(() {
                          return Visibility(visible: _state.isLoading, child: LoadingWidget());
                        })
                      ],
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
