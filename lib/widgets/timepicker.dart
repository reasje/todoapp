import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';

Widget MyDatePicker(@required BuildContext context) {
  final _myprovider = Provider.of<myProvider>(context);
  return SizedBox(
    height: 180,
    child: CupertinoTimerPicker(
      onTimerDurationChanged: (value) {
        _myprovider.timerDurationChange(value);
      },
      initialTimerDuration: _myprovider.time_duration,
      mode: CupertinoTimerPickerMode.hms,
      minuteInterval: 1,
      secondInterval: 1,
    ),
  );
}
