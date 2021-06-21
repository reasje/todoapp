import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
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
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double SizeXSizeY = SizeX * SizeY;
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
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
              child: ListView(
                children: [
                  Container(
                    height: SizeX * 0.05,
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: SizeX * 0.02),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ..._myProvider.tabs[_myProvider.selectedTab].buttons,
                      ],
                    ),
                  ),
                  ..._myProvider.tabs[_myProvider.selectedTab].tabs
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _myProvider.tabs[_myProvider.selectedTab].title ==
              "Image"
          ? FloatingActionButton(
              focusColor: Colors.transparent,
              highlightElevation: 0,
              elevation: 0,
              onPressed: () {},
              backgroundColor: _myProvider.tabs[_myProvider.selectedTab].color
                  .withOpacity(0.3),
              child: uiKit.MyButton(
                backgroundColor:
                    _myProvider.tabs[_myProvider.selectedTab].color,
                sizePU: SizeXSizeY * 0.00017,
                sizePD: SizeXSizeY * 0.00018,
                iconSize: SizeX * SizeY * 0.00006,
                iconData: FontAwesome.plus,
                id: 'newpic',
              ),
            )
          : _myProvider.tabs[_myProvider.selectedTab].title == "Voice"
              ? _myProvider.flutterSoundRecorder.isStopped
                  ? FloatingActionButton(
                      highlightElevation: 0,
                      elevation: 0,
                      onPressed: () {},
                      backgroundColor: _myProvider
                          .tabs[_myProvider.selectedTab].color
                          .withOpacity(0.3),
                      child: uiKit.MyButton(
                        backgroundColor:
                            _myProvider.tabs[_myProvider.selectedTab].color,
                        sizePU: SizeXSizeY * 0.00017,
                        sizePD: SizeXSizeY * 0.00018,
                        iconSize: SizeX * SizeY * 0.00006,
                        iconData: FontAwesome.microphone,
                        id: 'newvoice',
                      ))
                  : _myProvider.flutterSoundRecorder.isRecording
                      ? Container(
                          width: SizeY * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _myProvider
                                    .tabs[_myProvider.selectedTab].color
                                    .withOpacity(0.3),
                                child: uiKit.MyButton(
                                  backgroundColor: _myProvider
                                      .tabs[_myProvider.selectedTab].color,
                                  sizePU: SizeXSizeY * 0.00012,
                                  sizePD: SizeXSizeY * 0.00013,
                                  iconSize: SizeX * SizeY * 0.00006,
                                  iconData: FontAwesome.pause,
                                  id: 'pausevoice',
                                ),
                              ),
                              Container(
                                width: SizeY * 0.4,
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeY * 0.04,
                                    horizontal: SizeY * 0.04),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${((_myProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                    Text(
                                      '${((_myProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _myProvider
                                    .tabs[_myProvider.selectedTab].color
                                    .withOpacity(0.3),
                                child: uiKit.MyButton(
                                  backgroundColor: _myProvider
                                      .tabs[_myProvider.selectedTab].color,
                                  sizePU: SizeXSizeY * 0.00012,
                                  sizePD: SizeXSizeY * 0.00013,
                                  iconSize: SizeX * SizeY * 0.00006,
                                  iconData: FontAwesome.stop,
                                  id: 'stopvoice',
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: SizeY * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _myProvider
                                    .tabs[_myProvider.selectedTab].color
                                    .withOpacity(0.3),
                                child: uiKit.MyButton(
                                  backgroundColor: _myProvider
                                      .tabs[_myProvider.selectedTab].color,
                                  sizePU: SizeX * 0.05,
                                  sizePD: SizeX * 0.06,
                                  iconSize: SizeX * SizeY * 0.00006,
                                  iconData: FontAwesome.play,
                                  id: 'resumevoice',
                                ),
                              ),
                              Container(
                                width: SizeY * 0.4,
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeY * 0.02,
                                    horizontal: SizeY * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${((_myProvider.recorderDuration.inSeconds / 60) % 60).floor().toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                    Text(
                                      '${((_myProvider.recorderDuration.inSeconds) % 60).floor().toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          color: _themeProvider.blueMaterial,
                                          fontSize: SizeX * SizeY * 0.0001),
                                    ),
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                highlightElevation: 0,
                                elevation: 0,
                                onPressed: () {},
                                backgroundColor: _myProvider
                                    .tabs[_myProvider.selectedTab].color
                                    .withOpacity(0.3),
                                child: uiKit.MyButton(
                                  backgroundColor: _myProvider
                                      .tabs[_myProvider.selectedTab].color,
                                  sizePU: SizeX * 0.05,
                                  sizePD: SizeX * 0.06,
                                  iconSize: SizeX * SizeY * 0.00006,
                                  iconData: FontAwesome.stop,
                                  id: 'stopvoice',
                                ),
                              ),
                            ],
                          ),
                        )
              : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
