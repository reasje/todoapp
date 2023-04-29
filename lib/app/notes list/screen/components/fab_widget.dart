import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/notes%20list/logic.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';

import 'package:todoapp/widgets/buttons.dart';

import '../../../note_screen/screen/note_screen.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _noteLogic = Get.find<NoteLogic>();
    ;
    final _themeState = Get.find<ThemeLogic>().state;
    final _notesLogic = Provider.of<NotesLogic>(context, listen: false);
    return FloatingActionButton(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: _themeState.textColor!.withOpacity(0.1),
      child: Icon(
        Icons.add_rounded,
        color: _themeState.textColor,
      ),
      onPressed: () {
        _notesLogic.load();
        _noteLogic.newNoteClicked().then((value) {
          Get.to(NoteScreen(), transition: Transition.rightToLeft);
          _notesLogic.loadingOver();
        });
      },
    );
  }
}
