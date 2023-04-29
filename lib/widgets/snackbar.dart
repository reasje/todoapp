import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetask_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:todoapp/theme/colors_pallette.dart';
import 'package:todoapp/theme/theme_logic.dart';

import 'package:flutter/material.dart';

import '../app/note_screen/logic/notevoice_recorder_provider.dart';
import '../applocalizations.dart';

Widget MySnackBar(
  String text,
  String id,
  bool isAction, {
  required BuildContext context,
  int? index,
  LazyBox<Note?>? noteBox,
  Note? note,
  List<int>? keys,
  bool? isWhite,
}) {
  final _themeLogic = Get.find<ThemeLogic>();
  final _noteImageLogic = Get.find<NoteImageLogic>();
  final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();
  ;
  final _noteTaskLogic = Provider.of<NoteTaskLogic>(context, listen: false);
  isWhite = _themeLogic.checkIsWhite();
  return SnackBar(
    elevation: 0,
    backgroundColor: isWhite ? ColorsPallette.blackMainColor.withOpacity(0.3) : ColorsPallette.whiteMainColor.withOpacity(0.3),
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(
        color: isWhite ? ColorsPallette.blackTitleColor : ColorsPallette.whiteTitleColor,
      ),
    ),
    action: isAction
        ? SnackBarAction(
            textColor: _themeLogic.state.swashColor,
            label: locale.undo.tr,
            onPressed: () {
              if (id == 'undoVoice') {
                _noteVoiceRecorderLogic.voiceRecover(index);
              } else if (id == 'undoTask') {
                _noteTaskLogic.taskRecover(index!);
              } else if (noteBox == null) {
                _noteImageLogic.imageRecover(index);
              } else {
                noteBox.put(keys![index!], note);
              }
            },
          )
        : null,
  );
}
