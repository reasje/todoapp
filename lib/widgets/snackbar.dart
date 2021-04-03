import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
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

Widget MySnackBar(String text, bool isAction,
    [BuildContext context,
    Box<Note> noteBox,
    Note note,
    List<int> keys,
    int index]) {
  return SnackBar(
    elevation: 6.0,
    backgroundColor: uiKit.Colors.lightBlue,
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(color: uiKit.Colors.darkBlue, fontFamily: 'Iransans'),
    ),
    action: isAction
        ? SnackBarAction(
            textColor: uiKit.Colors.whiteSmoke,
            label: uiKit.AppLocalizations.of(context).translate('undo'),
            onPressed: () {
              noteBox.put(keys[index], note);
            },
          )
        : null,
  );
}
