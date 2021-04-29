import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';

Widget MyDatePicker(@required BuildContext context) {
  final _myprovider = Provider.of<myProvider>(context);
  return Container(
    color: _myprovider.mainColor,
    height: 180,
    // tring to give the Cupertino time picker a default localization 
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoTheme(
        data: CupertinoThemeData(
            brightness: _myprovider.brightness,
            textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle:
                    TextStyle(color: _myprovider.textColor))),
        child: CupertinoTimerPicker(
          alignment: Alignment.center,
          backgroundColor: _myprovider.mainColor,
          onTimerDurationChanged: (value) {
            _myprovider.timerDurationChange(value);
          },
          initialTimerDuration: _myprovider.time_duration,
          mode: CupertinoTimerPickerMode.hms,
          minuteInterval: 1,
          secondInterval: 1,
        ),
      ),
    ),
  );
}
