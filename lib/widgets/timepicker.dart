import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';

Widget MyDatePicker( BuildContext context) {
  final _timerProvider = Provider.of<TimerProvider>(context);
  final _themeProvider = Provider.of<ThemeProvider>(context);
  return Container(
    color: _themeProvider.mainColor,
    height: 180,
    // tring to give the Cupertino time picker a default localization 
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoTheme(
        data: CupertinoThemeData(
            brightness: _themeProvider.brightness,
            textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle:
                    TextStyle(color: _themeProvider.textColor))),
        child: CupertinoTimerPicker(
          alignment: Alignment.center,
          backgroundColor: _themeProvider.mainColor,
          
          onTimerDurationChanged: (value) {
            _timerProvider.timerDurationChange(value);
          },
          initialTimerDuration: _timerProvider.note_duration ?? Duration(seconds: 0),
          mode: CupertinoTimerPickerMode.hms,
          minuteInterval: 1,
          secondInterval: 1,
        ),
      ),
    ),
  );
}
