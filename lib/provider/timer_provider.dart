import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class TimerState extends ChangeNotifier {
  TimerState() {
    this.keys = [];
    this.keys.add(0);
    this.index = 0;
  }
  BuildContext context;
  List<bool> isRunning = List<bool>.filled(100, false);
  bool isOver = false;
  bool isPaused = true;
  Timer timer;
  int leftTime = 0;
  List<int> keys;
  int index;
  final noteBox = Hive.box<Note>(noteBoxName);
  void startTimer(BuildContext context) {
    this.context = context;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int leftTime = noteBox.get(keys[index]).leftTime;
      leftTime = leftTime - 1;
      if (leftTime == 0) {
        isOver = true;
        stopTimer();
        var ntitle = noteBox.get(keys[index]).title;
        var nttext = noteBox.get(keys[index]).text;
        var nttime = noteBox.get(keys[index]).time;
        var ntisChecked = noteBox.get(keys[index]).isChecked;
        var ntcolor = noteBox.get(keys[index]).color;
        var ntlefttime = leftTime;
        Note note =
            Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime);
        noteBox.put(keys[index], note);
        isRunning[index] = true;
        isOver = true;
        startAlarm();
        // Future.microtask(() {
        //   startAlarm();
        // });
        notifyListeners();
      } else if (leftTime == -1) {
        isPaused = true;
        isOver = false;
        var ntitle = noteBox.get(keys[index]).title;
        var nttext = noteBox.get(keys[index]).text;
        var nttime = noteBox.get(keys[index]).time;
        var ntisChecked = noteBox.get(keys[index]).isChecked;
        var ntcolor = noteBox.get(keys[index]).color;
        var ntlefttime = nttime;
        Note note =
            Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime);
        noteBox.put(keys[index], note);
        isRunning[index] = true;
        notifyListeners();
      } else {
        isPaused = false;
        isOver = false;
        var ntitle = noteBox.get(keys[index]).title;
        var nttext = noteBox.get(keys[index]).text;
        var nttime = noteBox.get(keys[index]).time;
        var ntisChecked = noteBox.get(keys[index]).isChecked;
        var ntcolor = noteBox.get(keys[index]).color;
        var ntlefttime = leftTime;
        Note note =
            Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime);
        noteBox.put(keys[index], note);
        isRunning[index] = true;
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    isPaused = true;
    if (isRunning[index]) {
      timer.cancel();
      isRunning[index] = false;
      notifyListeners();
    }
  }

  void resetTimer() {
    isPaused = true;
    isOver = false;
    var ntitle = noteBox.get(keys[index]).title;
    var nttext = noteBox.get(keys[index]).text;
    var nttime = noteBox.get(keys[index]).time;
    var ntisChecked = noteBox.get(keys[index]).isChecked;
    var ntcolor = noteBox.get(keys[index]).color;
    var ntlefttime = nttime;
    Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime);
    noteBox.put(keys[index], note);
    stopTimer();
  }

  void loadTimer(List<int> keys, int index) {
    this.keys = keys;
    this.index = index;
    leftTime = noteBox.get(keys[index]).leftTime;
  }

  void startAlarm() async {
    Future.delayed(Duration(seconds: 5), () async {
      // var scheduledNotificationDateTime =
      //     DateTime.now().add(Duration(seconds: 10));
      AndroidNotificationChannelAction channelAction =
          AndroidNotificationChannelAction.createIfNotExists;
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
          icon: 'todoapplogo',
          sound: RawResourceAndroidNotificationSound('alarm'),
          largeIcon: DrawableResourceAndroidBitmap('todoapplogo'),
          //playSound: true,
          //ticker: 'ticker',
          showWhen: true,
          channelAction: channelAction,
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high);

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'alarm.mp3',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          "uiKit.AppLocalizations.of(context).translate('notesapp')",
          "uiKit.AppLocalizations.of(context).translate('taskOver')",
          platformChannelSpecifics);
    });

    // await flutterLocalNotificationsPlugin.schedule(0, 'Office', 'alarmInfo.title',
    //     scheduledNotificationDateTime, platformChannelSpecifics);
  }

  // void onSaveAlarm() {
  //   DateTime scheduleAlarmDateTime;
  //   if (_alarmTime.isAfter(DateTime.now()))
  //     scheduleAlarmDateTime = _alarmTime;
  //   else
  //     scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

  //   var alarmInfo = AlarmInfo(
  //     alarmDateTime: scheduleAlarmDateTime,
  //     gradientColorIndex: _currentAlarms.length,
  //     title: 'alarm',
  //   );
  //   _alarmHelper.insertAlarm(alarmInfo);
  //   scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
  //   Navigator.pop(context);
  //   loadAlarms();
  // }

  // void deleteAlarm(int id) {
  //   _alarmHelper.delete(id);
  //   //unsubscribe for notification
  //   loadAlarms();
  // }
}
