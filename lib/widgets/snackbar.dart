import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_provider.dart';
import 'package:todoapp/app/note_screen/logic/notetask_provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import 'package:flutter/material.dart';

import '../applocalizations.dart';

Widget MySnackBar(
  String text,
  String id,
  bool isAction, {
  BuildContext context,
  int index,
  LazyBox<Note> noteBox,
  Note note,
  List<int> keys,
  bool isWhite,
}) {
  final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final _noteImageProvider = Provider.of<NoteImageProvider>(context, listen: false);
  final _noteVoiceRecorderProvider = Provider.of<NoteVoiceRecorderProvider>(context, listen: false);
  final _noteTaskProvider = Provider.of<NoteTaskProvider>(context, listen: false);
  isWhite = _themeProvider.checkIsWhite();
  return SnackBar(
    elevation: 0,
    backgroundColor: isWhite ? _themeProvider.blackMainColor.withOpacity(0.3) : _themeProvider.whiteMainColor.withOpacity(0.3),
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(
        color: isWhite ? _themeProvider.blackTitleColor : _themeProvider.whiteTitleColor,
      ),
    ),
    action: isAction
        ? SnackBarAction(
            textColor: _themeProvider.swachColor,
            label: AppLocalizations.of(context).translate('undo'),
            onPressed: () {
              if (id == 'undoVoice') {
                _noteVoiceRecorderProvider.voiceRecover(index);
              } else if (id == 'undoTask') {
                _noteTaskProvider.taskRecover(index);
              } else if (noteBox == null) {
                _noteImageProvider.imageRecover(index);
              } else {
                noteBox.put(keys[index], note);
              }
            },
          )
        : null,
  );
}
