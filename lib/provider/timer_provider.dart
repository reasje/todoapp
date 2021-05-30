import 'dart:async';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

void printMe() {
  print('Hell');
}

class TimerState extends ChangeNotifier {
  TimerState() {
    this.keys = [];
    this.keys.add(0);
    this.index = 0;
  }

  BuildContext my_context;
  List<bool> isRunning = List<bool>.filled(100, false);
  bool isOver = false;
  bool isPaused = true;
  var timer;
  int leftTime = 0;
  List<int> keys;
  int index;
  String title = "";
  String text = "";
  var target;
  final noteBox = Hive.box<Note>(noteBoxName);
  void startTimer() async {
    if (timer == null || !timer?.isActive) {
      int leftTime = noteBox.get(keys[index]).leftTime;
      var now = DateTime.now();
      if (leftTime > 900) {
        leftTime = leftTime - 180;
      }
      int hour = int.parse(
          ((leftTime / 3600) % 60).floor().toString().padLeft(2, '0'));
      int minute =
          int.parse(((leftTime / 60) % 60).floor().toString().padLeft(2, '0'));
      int second =
          int.parse((leftTime % 60).floor().toString().padLeft(2, '0'));
      Duration duration =
          Duration(hours: hour, minutes: minute, seconds: second);
      target = now.add(duration);
      await AndroidAlarmManager.oneShotAt(target, 0, startAlarm);
      leftTime = leftTime - 1;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        int leftTime = noteBox.get(keys[index]).leftTime;
        print('Left Time : ${leftTime}');
        leftTime = leftTime - 1;
        // If the timer finishes
        if (leftTime == 0) {
          isOver = true;
          stopTimer();
          var ntitle = noteBox.get(keys[index]).title;
          var nttext = noteBox.get(keys[index]).text;
          var nttime = noteBox.get(keys[index]).time;
          var ntisChecked = noteBox.get(keys[index]).isChecked;
          var ntcolor = noteBox.get(keys[index]).color;
          var ntlefttime = leftTime;
          Note note = Note(
              ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime, null);
          noteBox.put(keys[index], note);
          isRunning[index] = true;
          isOver = true;
          // Future.microtask(() {
          //   startAlarm();
          // });
          notifyListeners();
          // If the timer is over and the user clicks on start
          // We will be restarting the timer and starting the timer
        } else if (leftTime == -1) {
          isPaused = true;
          isOver = false;
          var ntitle = noteBox.get(keys[index]).title;
          var nttext = noteBox.get(keys[index]).text;
          var nttime = noteBox.get(keys[index]).time;
          var ntisChecked = noteBox.get(keys[index]).isChecked;
          var ntcolor = noteBox.get(keys[index]).color;
          var ntlefttime = nttime;
          Note note = Note(
              ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime, null);
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
          Note note = Note(
              ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime, null);
          noteBox.put(keys[index], note);
          isRunning[index] = true;
          notifyListeners();
        }
      });
    }
  }

  void cancelAlarm() async {
    await AndroidAlarmManager.cancel(0);
  }

  void updateTimer() {
    print(target);
    bool _turnOn;
    leftTime = DateTime.now().difference(target).inSeconds;
    print('LeftTime after update : ${leftTime}');
    var ntitle = noteBox.get(keys[index]).title;
    var nttext = noteBox.get(keys[index]).text;
    var nttime = noteBox.get(keys[index]).time;
    var ntisChecked = noteBox.get(keys[index]).isChecked;
    var ntcolor = noteBox.get(keys[index]).color;
    var ntimages = noteBox.get(keys[index]).imageList;
    var ntlefttime;
    if (leftTime >= 0) {
      ntlefttime = 0;
      isPaused = true;
      isOver = true;
      stopTimer();
      isRunning[index] = true;
      _turnOn = false;
      notifyListeners();
    } else if (leftTime == -1) {
      ntlefttime = 0;
      isPaused = true;
      isOver = true;
      stopTimer();
      isRunning[index] = true;
      _turnOn = false;
      notifyListeners();
    } else {
      isPaused = false;
      isOver = false;
      _turnOn = true;
      ntlefttime = leftTime.abs();
    }
    Note note = Note(
        ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime, ntimages);
    noteBox.put(keys[index], note);
    if (_turnOn) {
      startTimer();
    }
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
    var ntimages = noteBox.get(keys[index]).imageList;
    var ntlefttime = nttime;
    Note note = Note(
        ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime, ntimages);
    noteBox.put(keys[index], note);
    stopTimer();
    cancelAlarm();
  }

  void loadTimer(List<int> keys, int index, BuildContext context) {
    this.keys = keys;
    this.index = index;
    this.my_context = context;
    title = uiKit.AppLocalizations.of(context).translate('notesapp');
    text = uiKit.AppLocalizations.of(context).translate('taskOver');
    leftTime = noteBox.get(keys[index]).leftTime;
  }

  Future<void> startAlarm() async {
    Future.delayed(Duration(seconds: 0), () async {
      // var scheduledNotificationDateTime =
      //     DateTime.now().add(Duration(seconds: 10));
      AndroidNotificationChannelAction channelAction =
          AndroidNotificationChannelAction.createIfNotExists;
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'alarm_notif', 'alarm_notif', 'Channel for Alarm notification',
          icon: 'todoapplogo',
          sound: RawResourceAndroidNotificationSound('alarm'),
          largeIcon: DrawableResourceAndroidBitmap('todoapplogo'),
          playSound: true,
          ticker: 'ticker',
          showWhen: true,
          channelAction: channelAction,
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: new DefaultStyleInformation(true, true));

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'alarm.mp3',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, title, text, platformChannelSpecifics);
    });

    // await flutterLocalNotificationsPlugin.schedule(0, 'Office', 'alarmInfo.title',
    //     scheduledNotificationDateTime, platformChannelSpecifics);
  }

  // trying to avoid the user from getting back while the timer is on
  // void backPressed() {
  //   if (isRunning[index]) {
  //     print('object');
  //     ScaffoldMessenger.of(my_context).showSnackBar(uiKit.MySnackBar(
  //         uiKit.AppLocalizations.of(my_context).translate('cannotGoBack'),
  //         false,
  //         my_context));
  //   } else {
  //     var _myProvider = Provider.of<myProvider>(my_context);
  //     _myProvider.changeTimerStack();
  //   }
  // }

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
