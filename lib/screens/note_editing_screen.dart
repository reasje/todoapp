import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

import '../main.dart';

// TODO moving and reordering list view effect
class MyNotesEditing extends StatefulWidget {
  MyNotesEditing({Key key}) : super(key: key);

  @override
  _MyNotesEditingState createState() => _MyNotesEditingState();
}

class _MyNotesEditingState extends State<MyNotesEditing> {
  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    var timerIndex = _timerState.index ?? _timerState.newIndex;
    var providerIndex = _myProvider.providerIndex ?? timerIndex + 1;
    bool areAlldown =
        !(_timerState.isRunning.any((element) => element == true));
    bool condition = areAlldown || timerIndex == providerIndex;
    return Scaffold(
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
              child: PageView(
                onPageChanged: (value) {
                  _bottomNavProvider.newTabSelectedAnimation(value);
                },
                controller: _bottomNavProvider.pageController,
                children: [
                  TabView(
                    index: 0,
                  ),
                  condition
                      ? TabView(
                          index: 1,
                        )
                      : TabView(index: 1, timerOn: true),
                  TabView(
                    index: 2,
                  ),
                  TabView(
                    index: 3,
                  ),
                  TabView(
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: NoteEditingFloatingActionButtonWidget(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



class TabView extends StatefulWidget {
  final index;
  final timerOn;
  TabView({
    Key key,
    this.index,
    this.timerOn,
  }) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    bool timerOn = widget.timerOn ?? false;
    final _bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);
    double SizeX = MediaQuery.of(context).size.height;
    final _themeProvider = Provider.of<ThemeProvider>(context);
    double SizeY = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          height: SizeX * 0.05,
          width: double.maxFinite,
          margin: EdgeInsets.only(top: SizeX * 0.02),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!timerOn)
                ..._bottomNavProvider.tabs[index].buttons
              else
                _bottomNavProvider.tabs[index].buttons[0]
            ],
          ),
        ),
        if (!timerOn)
          ..._bottomNavProvider.tabs[index].tabs
        else
          Center(
            child: Text(
              uiKit.AppLocalizations.of(context).translate('timerOn'),
              style: TextStyle(
                  color: _bottomNavProvider
                      .tabColors[_bottomNavProvider.selectedTab],
                  fontSize: _themeProvider.isEn
                      ? SizeX * SizeY * 0.00008
                      : SizeX * SizeY * 0.00006,
                  fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}
