import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;


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
    final _timerState = Provider.of<TimerProvider>(context);
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
    
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
        height: isLandscape ? SizeY : SizeX * 0.9,
        child: _timerState.note_duration != Duration()
                ? FutureBuilder(
                    future: _timerState.getTimeDuration(
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
                                      ? _bottomNavProvider.items[3].color
                                          .withOpacity(0.1)
                                      : _timerState.isPaused[
                                              _timerState.index ??
                                                  _timerState.newIndex]
                                          ? _bottomNavProvider.items[1].color
                                              .withOpacity(0.1)
                                          : _timerState.isRunning.any(
                                                  (element) => element == true)
                                              ? _bottomNavProvider.items[4].color
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
                                                ? _bottomNavProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _bottomNavProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _bottomNavProvider
                                                            .items[4].color
                                                        : null,
                                            fontSize: SizeX * SizeY * 0.00015,
                                            fontFamily: "Ubuntu Condensed"),
                                      ),
                                      Text(
                                        minute_section,
                                        style: TextStyle(
                                            color: _timerState.isOver[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _bottomNavProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _bottomNavProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _bottomNavProvider
                                                            .items[4].color
                                                        : null,
                                            fontSize: SizeX * SizeY * 0.00015,
                                            fontFamily: "Ubuntu Condensed"),
                                      ),
                                      Text(
                                        second_section,
                                        style: TextStyle(
                                            color: _timerState.isOver[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _bottomNavProvider.items[3].color
                                                : _timerState.isPaused[
                                                        _timerState.index ??
                                                            _timerState
                                                                .newIndex]
                                                    ? _bottomNavProvider.items[1].color
                                                    : _timerState.isRunning.any(
                                                            (element) =>
                                                                element == true)
                                                        ? _bottomNavProvider
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
                                              ? _bottomNavProvider.items[3].color
                                              : _timerState.isPaused[
                                                      _timerState.index ??
                                                          _timerState.newIndex]
                                                  ? _bottomNavProvider.items[1].color
                                                  : _timerState.isRunning.any(
                                                          (element) =>
                                                              element == true)
                                                      ? _bottomNavProvider
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
                                              ? _bottomNavProvider.items[3].color
                                              : _timerState.isPaused[
                                                      _timerState.index ??
                                                          _timerState.newIndex]
                                                  ? _bottomNavProvider.items[1].color
                                                  : _timerState.isRunning.any(
                                                          (element) =>
                                                              element == true)
                                                      ? _bottomNavProvider
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
                                            ? _bottomNavProvider.items[3].color
                                            : _timerState.isPaused[
                                                    _timerState.index ??
                                                        _timerState.newIndex]
                                                ? _bottomNavProvider.items[1].color
                                                : _timerState.isRunning.any(
                                                        (element) =>
                                                            element == true)
                                                    ? _bottomNavProvider.items[4].color
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
            : Container());
  }
}
