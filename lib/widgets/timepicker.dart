import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

Widget MyDatePicker(@required BuildContext context) {
  final _myprovider = Provider.of<myProvider>(context);
  return SizedBox(
    height: 180,
    child: CupertinoTheme(
      data: CupertinoThemeData(
        brightness: _myprovider.brightness,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: _myprovider.textColor
          )
        )
      ),
          child: CupertinoTimerPicker(
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
  );
}
