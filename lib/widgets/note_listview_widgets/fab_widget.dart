import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/reorderable_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:todoapp/widgets/buttons.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    final _timerState = Provider.of<TimerProvider>(context, listen: false);
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final _reorderableProvider =
        Provider.of<ReorderableProvider>(context, listen: false);
    return FloatingActionButton(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: _themeProvider.textColor.withOpacity(0.1),
      child: Icon(
        FontAwesome.plus,
        color: _themeProvider.textColor,
      ),
      onPressed: () {
        if (!(_timerState.isRunning.any((element) => element == true))) {
          _reorderableProvider.load();
          
          _myProvider.newNoteClicked(context).then((value) {
            _timerState.clearControllers();
            _timerState.newNoteIndex();
            Navigator.push(context, SliderTransition(uiKit.MyNotesEditing()));
            _reorderableProvider.loadingOver();
          });
        } else {
          
          _reorderableProvider.load();
          _myProvider.newNoteClicked(context).then((value) {
            Navigator.push(context, SliderTransition(uiKit.MyNotesEditing()));
            _reorderableProvider.loadingOver();
          });
        }
      },
    );
  }
}
