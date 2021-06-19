import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

// TODO moving and reordering list view effect
class MyNotesEditing extends StatefulWidget {
  final LazyBox<Note> noteBox;
  MyNotesEditing({@required this.noteBox, Key key}) : super(key: key);

  @override
  _MyNotesEditingState createState() => _MyNotesEditingState();
}

class _MyNotesEditingState extends State<MyNotesEditing> {
  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    final _myProvider = Provider.of<NoteProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    LazyBox<Note> noteBox = widget.noteBox;
    double SizeXSizeY = SizeX * SizeY;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: _themeProvider.mainColor,
      bottomNavigationBar: uiKit.BottomNavWidget(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Center(
            child: Container(
              height: SizeX,
              width: isLandscape ? SizeY * 0.8 : SizeY,
              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ScrollConfiguration(
                behavior: uiKit.NoGlowBehaviour(),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: SizeX * 0.03),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 22,
                            child: Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                uiKit.MyButton(
                                  sizePU: SizeXSizeY * 0.00017,
                                  sizePD: SizeXSizeY * 0.00018,
                                  iconSize: SizeX * SizeY * 0.0001,
                                  iconData: FontAwesome.undo,
                                  id: 'undo',
                                ),
                                uiKit.MyButton(
                                  sizePU: SizeXSizeY * 0.00017,
                                  sizePD: SizeXSizeY * 0.00018,
                                  iconSize: SizeX * SizeY * 0.0001,
                                  iconData: FontAwesome.rotate_right,
                                  id: 'redo',
                                ),
                                uiKit.MyButton(
                                  sizePU: SizeXSizeY * 0.00017,
                                  sizePD: SizeXSizeY * 0.00018,
                                  iconSize: SizeX * SizeY * 0.0001,
                                  iconData: FontAwesome.hourglass,
                                  id: 'timer',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                uiKit.MyButton(
                                  sizePU: SizeXSizeY * 0.00017,
                                  sizePD: SizeXSizeY * 0.00018,
                                  iconSize: SizeX * SizeY * 0.0001,
                                  iconData: FontAwesome.times,
                                  id: 'cancel',
                                ),
                                Container(
                                  child: uiKit.MyButton(
                                    sizePU: SizeXSizeY * 0.00017,
                                    sizePD: SizeXSizeY * 0.00018,
                                    iconSize: SizeX * SizeY * 0.0001,
                                    iconData: FontAwesome.check,
                                    id: 'save',
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    uiKit.titleTextField(isLandscape: isLandscape, SizeY: SizeY, SizeX: SizeX, themeProvider: _themeProvider, myProvider: _myProvider),
                    uiKit.textTextField(isLandscape: isLandscape, SizeY: SizeY, SizeX: SizeX, themeProvider: _themeProvider, myProvider: _myProvider),
                    uiKit.taskListView(isLandscape: isLandscape, SizeY: SizeY, SizeX: SizeX, myProvider: _myProvider, themeProvider: _themeProvider, SizeXSizeY: SizeXSizeY),
                    _myProvider.time_duration != Duration()
                        ? uiKit.TimerWidget(myProvider: _myProvider, themeProvider: _themeProvider , timerState: _timerState,)
                        : Container(),
                    uiKit.imageLisView(isLandscape: isLandscape, SizeY: SizeY, SizeX: SizeX, myProvider: _myProvider, SizeXSizeY: SizeXSizeY, themeProvider: _themeProvider),
                    uiKit.voiceListView(isLandscape: isLandscape, SizeY: SizeY, SizeX: SizeX, myProvider: _myProvider, SizeXSizeY: SizeXSizeY, themeProvider: _themeProvider),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}