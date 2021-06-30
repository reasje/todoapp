import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/noteimage_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uikit.dart' as uiKit;
import 'package:flutter/material.dart';

// class MySnackBar extends StatelessWidget implements SnackBar {
//   final String text;
//   final bool isAction;
//   MySnackBar({@required String this.text, bool this.isAction ,Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//       elevation: 6.0,
//       backgroundColor: uiKit.Colors.lightBlue,
//       behavior: SnackBarBehavior.floating,
//       content:Text(
//           text,
//           style: TextStyle(color: uiKit.Colors.darkBlue , fontFamily: 'Iransans'),
//         ),
//         //action: action? SnackBarAction(label: uiKit.AppLocalizations.of(context).translate('undo'), onPressed: onPressed): null ,
//     );
//   }

// }

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
  final _myProvider = Provider.of<NoteProvider>(context, listen: false);
  final _noteImageProvider = Provider.of<NoteImageProvider>(context, listen: false);
  isWhite = _themeProvider.checkIsWhite();
  return SnackBar(
    elevation: 0,
    backgroundColor:
        isWhite ? _themeProvider.blackMainColor.withOpacity(0.3) : _themeProvider.whiteMainColor.withOpacity(0.3),
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(
        color: isWhite
            ? _themeProvider.blackTitleColor
            : _themeProvider.whiteTitleColor,
      ),
    ),
    action: isAction
        ? SnackBarAction(
            textColor: _themeProvider.swachColor,
            label: uiKit.AppLocalizations.of(context).translate('undo'),
            onPressed: () {
              if (id == 'undoVoice') {
                _myProvider.voiceRecover(index);
              } else if (id == 'undoTask') {
                _myProvider.taskRecover(index);
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
