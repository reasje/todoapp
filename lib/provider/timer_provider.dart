import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:todoapp/provider/note_provider.dart';
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
    isRunning = List<bool>.filled(noteBox.length + 1, false);
    isOver = List<bool>.filled(noteBox.length + 1, false);
    isPaused = List<bool>.filled(noteBox.length + 1, true);
  }

  BuildContext my_context;
  List<bool> isRunning = [];
  List<bool> isOver = [];
  List<bool> isPaused = [];
  var timer;
  int leftTime = 0;
  List<int> keys;
  int index;
  String title = "";
  String text = "";
  int newIndex;
  var target;
  List<Voice> voiceList = [];
  List<Uint8List> imageList = [];
  bool newNote = false;
  final noteBox = Hive.lazyBox<Note>(noteBoxName);
  void startTimer(BuildContext context) async {
    final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    if (timer == null || !timer?.isActive) {
      var bnote = keys == null ? null : await noteBox.get(keys[index]);
      bnote?.leftTime == null ? newNote = true : newNote = false;
      int leftTime = bnote?.leftTime ?? _myProvider.time_duration.inSeconds;
      // This
      leftTime == 0 ? leftTime = _myProvider.note_duration.inSeconds : null;
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
      _myProvider.updateDuration(leftTime);
      leftTime = leftTime - 1;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        var bnote = keys == null ? null : await noteBox.get(keys[index]);
        bnote?.leftTime == null ? newNote = true : newNote = false;
        int leftTime = bnote?.leftTime ?? _myProvider.time_duration.inSeconds;

        leftTime = leftTime - 1;
        _myProvider.updateDuration(leftTime);
        // If the timer finishes
        if (leftTime == 0) {
          stopTimer();
          if (!newNote) {
            var bnote = await noteBox.get(keys[index]);
            var ntitle = bnote.title;
            var nttext = bnote.text;
            var nttime = bnote.time;
            var ntisChecked = bnote.isChecked;
            var ntcolor = bnote.color;
            var ntlefttime = leftTime;
            var ntImageList = bnote.imageList;
            var ntVoiceList = bnote.voiceList;
            var ntTaskList = bnote.taskList;
            Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor,
                ntlefttime, ntImageList, ntVoiceList, ntTaskList);
            await noteBox.put(keys[index], note);
            isRunning[index] = true;
            isOver[index] = true;
          } else {
            isOver[newIndex] = true;
            isRunning[newIndex] = false;
          }
          // Future.microtask(() {
          //   startAlarm();
          // });
          notifyListeners();
          // If the timer is over and the user clicks on start
          // We will be restarting the timer and starting the timer
        } else if (leftTime == -1) {
          if (!newNote) {
            var bnote = await noteBox.get(keys[index]);
            var ntitle = bnote.title;
            var nttext = bnote.text;
            var nttime = bnote.time;
            var ntisChecked = bnote.isChecked;
            var ntcolor = bnote.color;
            var ntlefttime = nttime;
            var ntImageList = bnote.imageList;
            var ntVoiceList = bnote.voiceList;
            var ntTaskList = bnote.taskList;
            Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor,
                ntlefttime, ntImageList, ntVoiceList, ntTaskList);
            await noteBox.put(keys[index], note);
          } else {
            isPaused[newIndex] = true;
            isOver[newIndex] = false;
            isRunning[newIndex] = true;
          }

          notifyListeners();
        } else {
          if (!newNote) {
            isPaused[index] = false;
            isOver[index] = false;
            var bnote = await noteBox.get(keys[index]);
            var ntitle = bnote.title;
            var nttext = bnote.text;
            var nttime = bnote.time;
            var ntisChecked = bnote.isChecked;
            var ntcolor = bnote.color;
            var ntlefttime = leftTime;
            var ntImageList = bnote.imageList;
            var ntVoiceList = bnote.voiceList;
            var ntTaskList = bnote.taskList;
            Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor,
                ntlefttime, ntImageList, ntVoiceList, ntTaskList);
            await noteBox.put(keys[index], note);
            isRunning[index] = true;
          } else {
            isPaused[newIndex] = true;
            isOver[newIndex] = false;
            isRunning[newIndex] = true;
          }
          notifyListeners();
        }
      });
    }
  }

  void clearControllers() {
    keys = null;
    index = null;
  }

  void newNoteIndex() {
    newIndex = noteBox.length;
    notifyListeners();
  }

  // This function is used when the user turn the screen on
  // So the value of the Timer should update
  void updateTimer() async {
    //final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    print(target);
    bool _turnOn;
    leftTime = DateTime.now().difference(target).inSeconds;
    print('LeftTime after update : ${leftTime}');
    if (!newNote) {
      var bnote = await noteBox.get(keys[index]);
      var ntitle = bnote.title;
      var nttext = bnote.text;
      var nttime = bnote.time;
      var ntisChecked = bnote.isChecked;
      var ntcolor = bnote.color;
      var ntimages = bnote.imageList;
      var ntvoices = bnote.voiceList;
      var nttasks = bnote.taskList;
      var ntlefttime;
      if (leftTime >= 0) {
        ntlefttime = 0;
        isPaused[index] = true;
        isOver[index] = true;
        stopTimer();
        newNote ? isRunning[newIndex] = true : isRunning[index] = true;
        _turnOn = false;
        notifyListeners();
      } else if (leftTime == -1) {
        ntlefttime = 0;
        isPaused[index] = true;
        isOver[index] = true;
        stopTimer();
        newNote ? isRunning[newIndex] = true : isRunning[index] = true;
        _turnOn = false;
        notifyListeners();
      } else {
        isPaused[index] = true;
        isOver[index] = true;
        _turnOn = true;
        ntlefttime = leftTime.abs();
      }
      Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime,
          ntimages, ntvoices, nttasks);
      await noteBox.put(keys[index], note);
      if (_turnOn) {
        startTimer(my_context);
      }
    } else {
      // if (leftTime >= 0) {
      //   ntlefttime = 0;
      //   isPaused[index] = true;
      //   isOver[index] = true;
      //   stopTimer();
      //   newNote ? isRunning[newIndex] = true : isRunning[index] = true;
      //   _turnOn = false;
      //   notifyListeners();
      // } else if (leftTime == -1) {
      //   ntlefttime = 0;
      //   isPaused[index] = true;
      //   isOver[index] = true;
      //   stopTimer();
      //   newNote ? isRunning[newIndex] = true : isRunning[index] = true;
      //   _turnOn = false;
      //   notifyListeners();
      // } else {
      //   isPaused[index] = true;
      //   isOver[index] = true;
      //   _turnOn = true;
      //   ntlefttime = leftTime.abs();
      // }
    }
  }

  void stopTimer() {
    newNote ? isPaused[newIndex] = true : isPaused[index] = true;
    if (newNote ? isRunning[newIndex] : isRunning[index]) {
      timer.cancel();
      newNote ? isRunning[newIndex] = false : isRunning[index] = false;
      notifyListeners();
    }
  }

  void resetTimer(BuildContext context) async {
    final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    newNote ? isPaused[newIndex] = true : isPaused[index] = true;
    newNote ? isOver[newIndex] = false : isOver[index] = false;
    if (!newNote) {
      var bnote = await noteBox.get(keys[index]);
      var ntitle = bnote.title;
      var nttext = bnote.text;
      var nttime = bnote.time;
      var ntisChecked = bnote.isChecked;
      var ntcolor = bnote.color;
      var ntimages = bnote.imageList;
      var ntvoices = bnote.voiceList;
      var nttasks = bnote.taskList;
      var ntlefttime = nttime;
      Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime,
          ntimages, ntvoices, nttasks);
      await noteBox.put(keys[index], note);
      _myProvider.updateDuration(_myProvider.note_duration.inSeconds);
    } else {
      _myProvider.updateDuration(_myProvider.note_duration.inSeconds);
    }
    //notifyListeners();
    stopTimer();
  }

  void loadTimer(List<int> keys, int index, BuildContext context) async {
    var bnote = await noteBox.get(keys[index]);
    this.keys = keys;
    this.index = index;
    this.my_context = context;
    if (bnote.imageList?.isNotEmpty ?? false) {
      imageList = bnote.imageList;
    }
    if (bnote.imageList?.isNotEmpty ?? false) {
      voiceList = bnote.voiceList;
    }
    title = uiKit.AppLocalizations.of(my_context).translate('notesapp');
    text = uiKit.AppLocalizations.of(my_context).translate('taskOver');
    leftTime = bnote.leftTime;
  }

  // Used when there was a timer screen
  // Future<List<Uint8List>> getImageList() async {
  //   //myContext = context;
  //   return imageList;
  // }
  //   Future<List<Voice>> getVoiceList() async {
  //   //myContext = context;
  //   return voiceList;
  // }
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
