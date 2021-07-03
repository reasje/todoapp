import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

import '../main.dart';
final GlobalKey<ScaffoldState> noteEditingScaffoldKey = new GlobalKey<ScaffoldState>();
// TODO moving and reordering list view effect
class MyNotesEditing extends StatefulWidget {
  MyNotesEditing({Key key}) : super(key: key);

  @override
  _MyNotesEditingState createState() => _MyNotesEditingState();
}

class _MyNotesEditingState extends State<MyNotesEditing> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context , listen: false);
    final _themeProvider = Provider.of<ThemeProvider>(context , listen: false);
    final _timerState = Provider.of<TimerProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    var timerIndex = _timerState.index ?? _timerState.newIndex;
    var providerIndex = _myProvider.providerIndex ?? timerIndex + 1;
    bool areAlldown =
        !(_timerState.isRunning.any((element) => element == true));
    bool condition = areAlldown || timerIndex == providerIndex;
    return Scaffold(
      key: noteEditingScaffoldKey,
      //resizeToAvoidBottomInset: false,
      backgroundColor: _themeProvider.mainColor,
      bottomNavigationBar: uiKit.BottomNavWidget(),
      body: WillPopScope(
        onWillPop: () {
          _myProvider.doneClicked(context);
          return;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Container(
              height: SizeX,
              width: isLandscape ? SizeY * 0.8 : SizeY,
              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Consumer<BottomNavProvider>(
                builder: (ctx, _bottomNavProvider, _) {
                  return PageView(
                    onPageChanged: (value) {
                      _bottomNavProvider.newTabSelectedAnimation(value);
                    },
                    controller: _bottomNavProvider.pageController,
                    children: [
                      uiKit.TabView(
                        index: 0,
                      ),
                      condition
                          ? uiKit.TabView(
                              index: 1,
                            )
                          : uiKit.TabView(index: 1, timerOn: true),
                      uiKit.TabView(
                        index: 2,
                      ),
                      uiKit.TabView(
                        index: 3,
                      ),
                      uiKit.TabView(
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
      floatingActionButton: uiKit.NoteEditingFloatingActionButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
