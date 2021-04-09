import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/notes_provider.dart';
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
    int index,
    bool isWhite,]) {
  final _myProvider = Provider.of<myProvider>(context , listen: false);
  bool isWhite = _myProvider.isWhite();
  print('isWhite ${isWhite}');
  return SnackBar(
    elevation: 0,
    backgroundColor:
        isWhite ? _myProvider.blackMainColor : _myProvider.whiteMainColor,
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(
        color:
            isWhite ? _myProvider.blackTitleColor : _myProvider.whiteTitleColor,
      ),
    ),
    action: isAction
        ? SnackBarAction(
            textColor: _myProvider.swachColor,
            label: uiKit.AppLocalizations.of(context).translate('undo'),
            onPressed: () {
              noteBox.put(keys[index], note);
            },
          )
        : null,
  );
}
