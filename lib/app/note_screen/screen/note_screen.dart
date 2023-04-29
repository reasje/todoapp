import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/notecolor_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/note_screen/logic/notepassword_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetask_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetitletext_logic.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_player_logic.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';

import '../../../main.dart';
import 'components/bottomnav_widget.dart';
import 'components/fab_widget.dart';
import 'components/tabview_widget.dart';

final GlobalKey<ScaffoldState> noteEditingScaffoldKey = new GlobalKey<ScaffoldState>();

// TODO moving and reordering list view effect
class NoteScreen extends StatefulWidget {
  NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _bottomNavLogic = Get.put(BottomNavLogic());
  final _noteLogic = Get.put(NoteLogic());
  final _noteColorLogic = Get.put(NoteColorLogic());
  final _noteImageLogic = Get.put(NoteImageLogic());
  final _noteTaskLogic = Get.put(NoteTaskLogic());
  final _noteVoicePlayerLogic = Get.put(NoteVoicePlayerLogic());
  final _noteVoiceRecorderLogic = Get.put(NoteVoiceRecorderLogic());
  final _noteTitleTextLogic = Get.put(NoteTitleTextLogic());
  final _notePasswordLogic = Get.put(NotePasswordLogic());

  @override
  Widget build(BuildContext context) {
    final _noteLogic = Provider.of<NoteLogic>(context);
    final _themeState = Get.find<ThemeLogic>().state;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      key: noteEditingScaffoldKey,
      //resizeToAvoidBottomInset: false,
      backgroundColor: _themeState.mainColor,
      bottomNavigationBar: BottomNavWidget(),
      body: WillPopScope(
        onWillPop: () {
          _noteLogic.doneClicked();
          return;
        } as Future<bool> Function()?,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Container(
              height: h,
              width: isLandscape ? w * 0.8 : w,
              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Obx(
                () {
                  return PageView(
                    onPageChanged: (value) {
                      _bottomNavLogic.newTabSelectedAnimation(value);
                    },
                    controller: _bottomNavLogic.state.pageController,
                    children: [
                      TabView(
                        index: 0,
                      ),
                      TabView(
                        index: 1,
                      ),
                      TabView(
                        index: 2,
                      ),
                      TabView(
                        index: 3,
                      ),
                      TabView(
                        index: 4,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: NoteEditingFloatingActionButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
