import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  MyDatePicker({Key key}) : super(key: key);

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  Duration duration = Duration(seconds: 0);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CupertinoTimerPicker(
        initialTimerDuration: duration,
        mode: CupertinoTimerPickerMode.hms,
        onTimerDurationChanged: (val) {
          setState(() {
            this.duration = val;
          });
        },
      ),
    );
  }
}
