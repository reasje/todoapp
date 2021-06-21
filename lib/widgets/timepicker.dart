import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';

Widget MyDatePicker(@required BuildContext context) {
  final _myprovider = Provider.of<NoteProvider>(context);
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
            _myprovider.timerDurationChange(value);
          },
          initialTimerDuration: _myprovider.note_duration ?? Duration(seconds: 0),
          mode: CupertinoTimerPickerMode.hms,
          minuteInterval: 1,
          secondInterval: 1,
        ),
      ),
    ),
  );
}
