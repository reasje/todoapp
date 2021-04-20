import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:hive_flutter/hive_flutter.dart';

class MyTimer extends StatefulWidget {
  double SizeX;
  double SizeY;
  final noteBox;
  MyTimer({
    Key key,
    @required this.SizeX,
    @required this.SizeY,
    @required this.noteBox,
  }) : super(key: key);
  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  @override
  Widget build(BuildContext context) {
    double SizeX = widget.SizeX;
    double SizeY = widget.SizeY;
    Box<Note> noteBox = widget.noteBox;
    final _myProvider = Provider.of<myProvider>(context);
    final _timerState = Provider.of<TimerState>(context);

    return ValueListenableBuilder(
        valueListenable: noteBox.listenable(),
        builder: (context, Box<Note> notes, _) {
          var hour_section =
              ((noteBox.get(_timerState.keys[_timerState.index])?.leftTime ==
                              null
                          ? 0
                          : noteBox
                                  .get(_timerState.keys[_timerState.index])
                                  .leftTime /
                              3600) %
                      60)
                  .floor()
                  .toString()
                  .padLeft(2, '0');
          //hour_section = null ? hour_section = '0' : hour_section;
          var second_section = (noteBox
                          .get(_timerState.keys[_timerState.index])
                          ?.leftTime ==
                      null
                  ? 0
                  : noteBox.get(_timerState.keys[_timerState.index]).leftTime %
                      60)
              .floor()
              .toString()
              .padLeft(2, '0');
          //second_section = null ? second_section = '0' : second_section;
          var minute_section =
              ((noteBox.get(_timerState.keys[_timerState.index])?.leftTime ==
                              null
                          ? 0
                          : noteBox
                                  .get(_timerState.keys[_timerState.index])
                                  .leftTime /
                              60) %
                      60)
                  .floor()
                  .toString()
                  .padLeft(2, '0');
          //minute_section = null ? minute_section = '0' : minute_section;
          return Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.all(30),
                  child: uiKit.MyButton(
                    sizePU: SizeX * 0.07,
                    sizePD: SizeX * 0.08,
                    iconSize: SizeX * SizeY * 0.0001,
                    iconData: FontAwesome.check,
                    id: 'menu',
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: SizeX * 0.5,
                        width: SizeY,
                        padding: EdgeInsets.all(SizeX * 0.03),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: _myProvider.lightShadowColor,
                                spreadRadius: 1.0,
                                blurRadius: 1.0,
                                offset: Offset(
                                    -1, -1), // changes position of shadow
                              ),
                              BoxShadow(
                                color:
                                    _myProvider.shadowColor.withOpacity(0.17),
                                spreadRadius: 1.0,
                                blurRadius: 2.0,
                                offset:
                                    Offset(3, 4), // changes position of shadow
                              ),
                            ],
                            color:  _timerState.isOver? _myProvider.overColor
                                          : _timerState.isPaused ? _myProvider.pausedColor :_timerState.isRunning
                                              .any((element) => element == true)
                                          ? _myProvider.runningColor : null ,
                            borderRadius:
                                BorderRadius.all(Radius.circular(SizeX * 0.3))),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(SizeX * 0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: _myProvider.lightShadowColor,
                                offset: Offset(2, 2),
                                blurRadius: 0.0,
                                // changes position of shadow
                              ),
                              BoxShadow(
                                color:
                                    _myProvider.shadowColor.withOpacity(0.14),
                                offset: Offset(-1, -1),
                              ),
                              BoxShadow(
                                color: _myProvider.mainColor,
                                offset: Offset(5, 8),
                                spreadRadius: -0.5,
                                blurRadius: 14.0,
                                // changes position of shadow
                              ),
                            ],
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  hour_section,
                                  style: TextStyle(
                                      color: _timerState.isRunning
                                              .any((element) => element == true)
                                          ? _myProvider.swachColor
                                          : _myProvider.textColor,
                                      fontSize: SizeX * SizeY * 0.00015),
                                ),
                                // Text(
                                //   ':',
                                //   style: TextStyle(
                                //       color: _timerState.isRunning
                                //               .any((element) => element == true)
                                //           ? _myProvider.swachColor
                                //           : _myProvider.textColor,
                                //       fontSize: SizeX * SizeY * 0.00015),
                                // ),
                                Text(
                                  minute_section,
                                  style: TextStyle(
                                      color: _timerState.isRunning
                                              .any((element) => element == true)
                                          ? _myProvider.swachColor
                                          : _myProvider.textColor,
                                      fontSize: SizeX * SizeY * 0.00015),
                                ),
                                // Text(
                                //   ':',
                                //   style: TextStyle(
                                //       color: _timerState.isRunning
                                //               .any((element) => element == true)
                                //           ? _myProvider.swachColor
                                //           : _myProvider.textColor,
                                //       fontSize: SizeX * SizeY * 0.00015),
                                // ),
                                Text(
                                  second_section,
                                  style: TextStyle(
                                      color: _timerState.isRunning
                                              .any((element) => element == true)
                                          ? _myProvider.swachColor
                                          : _myProvider.textColor,
                                      fontSize: SizeX * SizeY * 0.00015),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: _timerState.isRunning
                                    .any((element) => element == true) ==
                                true
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  uiKit.MyButton(
                                    sizePU: SizeX * 0.1,
                                    sizePD: SizeX * 0.1,
                                    iconSize: SizeX * SizeY * 0.00014,
                                    iconData: FontAwesome.refresh,
                                    id: 'reset',
                                  ),
                                  uiKit.MyButton(
                                    sizePU: SizeX * 0.1,
                                    sizePD: SizeX * 0.1,
                                    iconSize: SizeX * SizeY * 0.00014,
                                    iconData: FontAwesome.stop,
                                    id: 'stop',
                                  ),
                                ],
                              )
                            : Center(
                                child: uiKit.MyButton(
                                  sizePU: SizeX * 0.1,
                                  sizePD: SizeX * 0.1,
                                  iconSize: SizeX * SizeY * 0.00014,
                                  iconData: FontAwesome.play,
                                  id: 'start',
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
