import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/widgets/buttons.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class ReorderableCardWidget extends StatelessWidget {
  const ReorderableCardWidget({Key key, this.snapShot, this.notes, this.index})
      : super(key: key);
  final snapShot;
  final notes;
  final index;
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    final _timerState = Provider.of<TimerState>(context, listen: false);
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    List<int> keys = notes.keys.cast<int>().toList();
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.only(
            left: SizeY * 0.1, bottom: SizeX * 0.01, right: SizeY * 0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          color: Colors.transparent,
        ),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete_sweep,
          size: SizeX * SizeY * 0.0002,
          color: _themeProvider.textColor,
        ),
      ),
      onDismissed: (direction) async {
        var bnote = await notes.get(keys[index]);
        Note note = Note(
            bnote.title,
            bnote.text,
            bnote.isChecked,
            bnote.time,
            bnote.color,
            bnote.leftTime,
            bnote.imageList,
            bnote.voiceList,
            bnote.taskList,
            bnote.resetCheckBoxs);
        notes.delete(keys[index]);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(uiKit.MySnackBar(
          uiKit.AppLocalizations.of(context).translate('undoNote'),
          'undoNote',
          true,
          context: context,
          index: index,
          noteBox: notes,
          note: note,
          keys: keys,
        ));
      },
      child: AnimationConfiguration.staggeredList(
        position: index,
        delay: Duration(milliseconds: 100),
        child: SlideAnimation(
          duration: Duration(milliseconds: 2500),
          curve: Curves.fastLinearToSlowEaseIn,
          horizontalOffset: 30,
          verticalOffset: 300.0,
          child: Center(
            child: FlipAnimation(
              duration: Duration(milliseconds: 4000),
              curve: Curves.fastLinearToSlowEaseIn,
              flipAxis: FlipAxis.y,
              child: Container(
                  width: SizeY * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeY * 0.009, vertical: SizeY * 0.04),
                  margin: EdgeInsets.only(
                      bottom: SizeX * 0.04,
                      top: isLandscape ? SizeY * 0.1 : SizeX * 0.01),
                  decoration: BoxDecoration(
                      color: Color(snapShot.data.color).withOpacity(0.5) ??
                          Colors.white,
                      //border: Border.all(width: 1, color: uiKit.Colors.whiteSmoke),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  //clipBehavior: Clip.antiAlias,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: _themeProvider.textColor,
                      ),
                      child: Column(
                        children: [
                          snapShot.data.time != 0
                              ? InkWell(
                                  onTap: () {
                                    if (!(_timerState.isRunning
                                        .any((element) => element == true))) {
                                      _timerState.loadTimer(
                                        keys,
                                        index,
                                        context,
                                      );
                                    }

                                    _myProvider.loadNote(context, keys, index).then((value) {
                                                                          Navigator.push(
                                        context,
                                        SliderTransition(
                                            uiKit.MyNotesEditing()));
                                    }
                                    );

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              ((snapShot.data.leftTime / 3600) %
                                                      60)
                                                  .floor()
                                                  .toString()
                                                  .padLeft(2, '0'),
                                              style: TextStyle(
                                                  color: _timerState
                                                          .isRunning[index]
                                                      ? _themeProvider
                                                          .swachColor
                                                      : _themeProvider
                                                          .textColor,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00012,
                                                  fontFamily:
                                                      "Ubuntu Condensed"),
                                            ),
                                            Text(
                                              ':',
                                              style: TextStyle(
                                                  color: _timerState
                                                          .isRunning[index]
                                                      ? _themeProvider
                                                          .swachColor
                                                      : _themeProvider
                                                          .textColor,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00012,
                                                  fontFamily:
                                                      "Ubuntu Condensed"),
                                            ),
                                            Text(
                                              ((snapShot.data.leftTime / 60) %
                                                      60)
                                                  .floor()
                                                  .toString()
                                                  .padLeft(2, '0'),
                                              style: TextStyle(
                                                  color: _timerState
                                                          .isRunning[index]
                                                      ? _themeProvider
                                                          .swachColor
                                                      : _themeProvider
                                                          .textColor,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00012,
                                                  fontFamily:
                                                      "Ubuntu Condensed"),
                                            ),
                                            Text(
                                              ':',
                                              style: TextStyle(
                                                  color: _timerState
                                                          .isRunning[index]
                                                      ? _themeProvider
                                                          .swachColor
                                                      : _themeProvider
                                                          .textColor,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00012,
                                                  fontFamily:
                                                      "Ubuntu Condensed"),
                                            ),
                                            Text(
                                              (snapShot.data.leftTime % 60)
                                                  .floor()
                                                  .toString()
                                                  .padLeft(2, '0'),
                                              style: TextStyle(
                                                  color: _timerState
                                                          .isRunning[index]
                                                      ? _themeProvider
                                                          .swachColor
                                                      : _themeProvider
                                                          .textColor,
                                                  fontSize:
                                                      SizeX * SizeY * 0.00012,
                                                  fontFamily:
                                                      "Ubuntu Condensed"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              // In this case the note doesnt have a
                              : Container(),
                          snapShot.data.time != 0
                              ? Container(
                                  width: double.infinity,
                                  height: SizeX * 0.02,
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: false,
                                // tried too hard to make the expanion color and
                                // collapsed color personalized but threre was  a problem
                                // Every widget when We call the notifier in the provider
                                // as I called one is ExpansionTile the Tile will be
                                // recreated so We have to defin this spesific listTile
                                // a key that the widget won't be changed !
                                title: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _myProvider
                                              .updateIsChecked(keys, index);
                                        },
                                        child: Container(
                                            height: SizeX * 0.04,
                                            width: SizeX * 0.04,
                                            decoration: BoxDecoration(
                                                
                                                border: Border.all(
                                                    color: _themeProvider.textColor,
                                                    width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                                color: snapShot.data.isChecked
                                                             ??
                                                        false
                                                    ? Color(snapShot.data.color).withOpacity(0.2)
                                                    : null),
                                            child: snapShot.data.isChecked
                                                        ??
                                                    false
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    size: SizeX * 0.03,
                                                    color: Colors.white,
                                                  )
                                                : Container()),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              snapShot.data.title.length >=
                                                      (SizeY * 0.08).round()
                                                  ? snapShot.data.title
                                                          .substring(
                                                              0,
                                                              (SizeY * 0.08)
                                                                  .round()) +
                                                      "..."
                                                  : snapShot.data.title,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: _themeProvider
                                                      .noteTitleColor[index],
                                                  fontSize: _themeProvider.isEn
                                                      ? SizeX * SizeY * 0.00011
                                                      : SizeX * SizeY * 0.00009,
                                                  fontWeight:
                                                      _themeProvider.isEn
                                                          ? FontWeight.w100
                                                          : FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (!(_timerState.isRunning
                                        .any((element) => element == true))) {
                                      _timerState.loadTimer(
                                        keys,
                                        index,
                                        context,
                                      );
                                    }
                                    _myProvider.loadNote(context, keys, index).then((value) {
                                                                          Navigator.push(
                                        context,
                                        SliderTransition(
                                            uiKit.MyNotesEditing()));
                                    });
                                  },
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(SizeY * 0.05),
                                    child: Text(
                                      snapShot.data.text,
                                      style: TextStyle(
                                        color: _themeProvider.textColor,
                                        fontSize: SizeX * SizeY * 0.00008,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
          ),
        ),
      ),
    );
  }
}
