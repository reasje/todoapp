import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

import '../main.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    Key key,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
    final _timerState = Provider.of<TimerState>(context);
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
    Widget _clock;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var timerIndex = _timerState.index ?? _timerState.newIndex;
    var providerIndex = _myProvider.providerIndex ?? noteBox.length;
    bool areAlldown =
        !(_timerState.isRunning.any((element) => element == true));
    bool condition = areAlldown || timerIndex == providerIndex;
    print(condition);
    return Container(
        height: isLandscape ? SizeY : SizeX * 0.9,
        child: _myProvider.note_duration != Duration()
            ? condition
                ? _clock = FutureBuilder(
                    future: _myProvider.getNoteEditStack(
                        _timerState.keys, _timerState.index),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var hour_section = ((snapshot.data == null
                                    ? 0
                                    : snapshot.data / 3600) %
                                60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        //hour_section = null ? hour_section = '0' : hour_section;
                        var second_section =
                            (snapshot.data == null ? 0 : snapshot.data % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                        //second_section = null ? second_section = '0' : second_section;
                        var minute_section =
                            ((snapshot.data == null ? 0 : snapshot.data / 60) %
                                    60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                        print('object ${_timerState.newIndex}');
                        return Column(
                          children: [
                            Container(
                              height: SizeY * 0.85,
                              width: SizeY * 0.85,
                              margin: EdgeInsets.only(top: SizeX * 0.05),
                              padding: EdgeInsets.all(SizeX * 0.03),
                              decoration: BoxDecoration(
                                  color: _timerState.isOver[_timerState.index ??
                                          _timerState.newIndex]
                                      ? _myProvider.items[3].color
                                          .withOpacity(0.1)
                                      : _timerState.isPaused[
                                              _timerState.index ??
                                                  _timerState.newIndex]
                                          ? _myProvider.items[1].color
                                              .withOpacity(0.1)
                                          : _timerState.isRunning.any(
                                                  (element) => element == true)
                                              ? _myProvider.items[4].color
                                                  .withOpacity(0.1)
                                              : null,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(isLandscape
                                          ? SizeY * 0.4
                                          : SizeX * 0.3))),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(isLandscape
                                          ? SizeY * 0.4
                                          : SizeX * 0.3)),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        hour_section,
                                        style: TextStyle(
                                            color: _timerState.isOver[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _myProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _myProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _myProvider
                                                            .items[4].color
                                                        : null,
                                            fontSize: SizeX * SizeY * 0.00015,
                                            fontFamily: "Ubuntu Condensed"),
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
                                            color: _timerState.isOver[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _myProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _myProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _myProvider
                                                            .items[4].color
                                                        : null,
                                            fontSize: SizeX * SizeY * 0.00015,
                                            fontFamily: "Ubuntu Condensed"),
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
                                            color: _timerState.isOver[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _myProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _myProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _myProvider
                                                            .items[4].color
                                                        : null,
                                            fontSize: SizeX * SizeY * 0.00015,
                                            fontFamily: "Ubuntu Condensed"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(SizeXSizeY * 0.0002),
                              child: _timerState.isRunning
                                          .any((element) => element == true) ==
                                      true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        uiKit.MyButton(
                                          backgroundColor: _timerState.isOver[
                                                  _timerState.index ??
                                                      _timerState.newIndex]
                                              ? _myProvider.items[3].color
                                              : _timerState.isPaused[
                                                      _timerState.index ??
                                                          _timerState.newIndex]
                                                  ? _myProvider.items[1].color
                                                  : _timerState.isRunning.any(
                                                          (element) =>
                                                              element == true)
                                                      ? _myProvider
                                                          .items[4].color
                                                      : null,
                                          sizePU: SizeXSizeY * 0.00024,
                                          sizePD: SizeXSizeY * 0.00025,
                                          iconSize: SizeXSizeY * 0.00014,
                                          iconData: FontAwesome.refresh,
                                          id: 'reset',
                                        ),
                                        uiKit.MyButton(
                                          backgroundColor: _timerState.isOver[
                                                  _timerState.index ??
                                                      _timerState.newIndex]
                                              ? _myProvider.items[3].color
                                              : _timerState.isPaused[
                                                      _timerState.index ??
                                                          _timerState.newIndex]
                                                  ? _myProvider.items[1].color
                                                  : _timerState.isRunning.any(
                                                          (element) =>
                                                              element == true)
                                                      ? _myProvider
                                                          .items[4].color
                                                      : null,
                                          sizePU: SizeXSizeY * 0.00024,
                                          sizePD: SizeXSizeY * 0.00025,
                                          iconSize: SizeX * SizeY * 0.00014,
                                          iconData: FontAwesome.stop,
                                          id: 'stop',
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: uiKit.MyButton(
                                        backgroundColor: _timerState.isOver[
                                                _timerState.index ??
                                                    _timerState.newIndex]
                                            ? _myProvider.items[3].color
                                            : _timerState.isPaused[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _myProvider.items[1].color
                                                : _timerState.isRunning.any(
                                                        (element) =>
                                                            element == true)
                                                    ? _myProvider.items[4].color
                                                    : null,
                                        sizePU: SizeXSizeY * 0.00024,
                                        sizePD: SizeXSizeY * 0.00025,
                                        iconSize: SizeX * SizeY * 0.00014,
                                        iconData: FontAwesome.play,
                                        id: 'start',
                                        timerContext: context,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : Center(
                    child: Text(
                      uiKit.AppLocalizations.of(context).translate('timerOn'),
                      style: TextStyle(
                          color: _myProvider.tabColors[_myProvider.selectedTab],
                          fontSize: _themeProvider.isEn
                              ? SizeX * SizeY * 0.00008
                              : SizeX * SizeY * 0.00006,
                          fontWeight: FontWeight.w400),
                    ),
                  )
            : Container());
  }
}
