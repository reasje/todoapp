import 'dart:async';
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
import 'package:todoapp/model/image_model.dart' as imageModel;
class TimerProvider extends ChangeNotifier {
  TimerProvider() {
    this.keys = [];
    this.keys.add(0);
    this.index = 0;
    reNewList();
  }

  BuildContext timerContext;
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
  List<imageModel.Image>imageList = [];
  List<int> providerKeys;
  int providerIndex;
  bool newNote = false;
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  // When the timer gets started 
  void startTimer(BuildContext context) async {
    final _myProvider = Provider.of<NoteProvider>(context, listen: false);
    if (timer == null || !timer?.isActive) {
      var bnote = keys == null ? null : await noteBox.get(keys[index]);
      bnote?.leftTime == null ? newNote = true : newNote = false;
      int leftTime = bnote?.leftTime ?? time_duration.inSeconds;
      // This
      leftTime == 0 ? leftTime = note_duration.inSeconds : null;
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
      updateDuration(leftTime);
      leftTime = leftTime - 1;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        var bnote = keys == null ? null : await noteBox.get(keys[index]);
        bnote?.leftTime == null ? newNote = true : newNote = false;
        int leftTime = bnote?.leftTime ?? time_duration.inSeconds;

        leftTime = leftTime - 1;
        updateDuration(leftTime);
        print('object$leftTime');
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
            var ntResetCheckBoxs = bnote.resetCheckBoxs;
            Note note = Note(
              ntitle,
              nttext,
              ntisChecked,
              nttime,
              ntcolor,
              ntlefttime,
              ntImageList,
              ntVoiceList,
              ntTaskList,
              ntResetCheckBoxs
            );
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
            isPaused[index] = true;
            isOver[index] = false;
            isRunning[index] = true;
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
            var ntResetCheckBoxs = bnote.resetCheckBoxs;
            Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor,
                ntlefttime, ntImageList, ntVoiceList, ntTaskList, ntResetCheckBoxs);
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
            var ntResetCheckBoxs = bnote.resetCheckBoxs;
            Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor,
                ntlefttime, ntImageList, ntVoiceList, ntTaskList , ntResetCheckBoxs);
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

  void reNewList() {
    isRunning = List<bool>.filled(noteBox.length + 1, false);
    isOver = List<bool>.filled(noteBox.length + 1, false);
    isPaused = List<bool>.filled(noteBox.length + 1, true);
  }

  void clearControllers() {
    keys = null;
    index = null;
    notifyListeners();
  }

  void newNoteIndex() {
    reNewList();
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
      var ntResetCheckBoxs = bnote.resetCheckBoxs;
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
          ntimages, ntvoices, nttasks , ntResetCheckBoxs);
      await noteBox.put(keys[index], note);
      if (_turnOn) {
        startTimer(timerContext);
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
      var ntResetCheckBoxs = bnote.resetCheckBoxs;
      Note note = Note(ntitle, nttext, ntisChecked, nttime, ntcolor, ntlefttime,
          ntimages, ntvoices, nttasks , ntResetCheckBoxs);
      await noteBox.put(keys[index], note);
      updateDuration(note_duration.inSeconds);
    } else {
      updateDuration(note_duration.inSeconds);
    }
    //notifyListeners();
    stopTimer();
  }

  void loadTimer(List<int> keys, int index, BuildContext context) async {
    var bnote = await noteBox.get(keys[index]);
    this.keys = keys;
    this.index = index;
    this.timerContext = context;
    if (bnote.imageList?.isNotEmpty ?? false) {
      imageList = bnote.imageList;
    }
    if (bnote.imageList?.isNotEmpty ?? false) {
      voiceList = bnote.voiceList;
    }
    title = uiKit.AppLocalizations.of(timerContext).translate('notesapp');
    text = uiKit.AppLocalizations.of(timerContext).translate('taskOver');
    leftTime = bnote.leftTime;
    newIndex = null;
    notifyListeners();
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
    // The Time picker dialog controller
  Duration time_duration = Duration();
  Duration note_duration = Duration();
  // this varriable is used in snapshot to chacke
  // that no changes has been made
  Duration time_snapshot;
    // This function  is used to handle the changes that has been
  // occured to the time picker !
  Duration saved_duration = Duration();
  Duration saved_note_duration = Duration();
  void saveDuration() {
    saved_duration = time_duration;
    saved_note_duration = note_duration;
  }

  void timerDurationChange(duration) {
    // updating the state and notifiung the listeners

    time_duration = duration;
    note_duration = duration;

    // notifyListeners();
  }

  void updateDuration(int leftTime) {
    time_duration = Duration(seconds: leftTime);
  }

  void timerDone() async {
    if (note_duration != time_snapshot) {
      // timer has been updated so that
      // We must update the left time too
      if (!newNote) {
        var bnote = await noteBox.get(providerKeys[providerIndex]);
        var ntitle = bnote.title;
        var nttext = bnote.text;
        var ntischecked = bnote.isChecked;
        var nttime = note_duration.inSeconds;
        var ntcolor = bnote.color;
        var ntlefttime = note_duration.inSeconds;
        var ntImageList = bnote.imageList;
        var ntVoiceList = bnote.voiceList;
        var ntTaskList = bnote.taskList;
        var ntResetCheckBoxs = bnote.resetCheckBoxs;
        Note note = Note(ntitle, nttext, ntischecked, nttime, ntcolor,
            ntlefttime, ntImageList, ntVoiceList, ntTaskList, ntResetCheckBoxs);
        noteBox.put(providerKeys[providerIndex], note);
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }
  // This function is used inside the notes_editing_screen as
  // a future function to load the pictures
  Future<int> getTimeDuration([List<int> keys, int index]) async {
    return time_duration.inSeconds;
  }
  // trying to avoid the user from getting back while the timer is on
  // void backPressed() {
  //   if (isRunning[index]) {
  //     print('object');
  //     ScaffoldMessenger.of(timerContext).showSnackBar(uiKit.MySnackBar(
  //         uiKit.AppLocalizations.of(timerContext).translate('cannotGoBack'),
  //         false,
  //         timerContext));
  //   } else {
  //     var _myProvider = Provider.of<myProvider>(timerContext);
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
