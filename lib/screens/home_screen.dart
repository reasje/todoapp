import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:todoapp/provider/timer_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'dart:async';
import 'package:notification_permissions/notification_permissions.dart';

// checkMe() {
//   final dateBox = Hive.box<String>(dateBoxName);
//   String date = dateBox.get('date');
//   var now = DateTime.now();
//   if (date != null) {
//     List<String> dateList = date.split(',');
//     int day = now.day;
//     int month = now.month;
//     int year = now.year;
//     Box<Note> noteBox = Hive.box<Note>(noteBoxName);
//     if (int.parse(dateList[0]) < year ||
//         int.parse(dateList[1]) < month ||
//         int.parse(dateList[2]) < day) {
//       if (noteBox.length != 0) {
//         for (int i = 0; i < noteBox.length; i++) {
//           var ntitle = noteBox.getAt(i).title;
//           var nttext = noteBox.getAt(i).text;
//           var nttime = noteBox.getAt(i).time;
//           var ntcolor = noteBox.getAt(i).color;
//           Note note = Note(ntitle, nttext, false, nttime, ntcolor);
//           noteBox.putAt(i, note);
//         }
//         dateBox.put('date',
//             "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
//       }
//     }
//   } else {
//     dateBox.put('date',
//         "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
//   }
// }

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Future<String> permissionStatusFuture;
  AnimationController _anicontroller;
  bool shouldRun = false;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  LazyBox<Note> noteBox = Hive.lazyBox<Note>(noteBoxName);
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    permissionStatusFuture = getCheckNotificationPermStatus();
    // With this, we will be able to check if the permission is granted or not
    // when returning to the application
    WidgetsBinding.instance.addObserver(this);
  }

  void _requestPermissions() {
    NotificationPermissions.requestNotificationPermissions(
      openSettings: true,
      iosSettings:
          const NotificationSettingsIos(sound: true, badge: true, alert: true),
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final _timerState = Provider.of<TimerState>(context, listen: false);
    if (state == AppLifecycleState.resumed && shouldRun) {
      print('Resumed');
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
      _timerState.updateTimer();
    } else if (state == AppLifecycleState.paused &&
        (_timerState.isRunning.any((element) => element == true))) {
      print('Paused');
      _timerState.stopTimer();
      shouldRun = true;
    }
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    final _timerState = Provider.of<TimerState>(context);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _myProvider.mainColor,
      body: 
      // WillPopScope(
      //   onWillPop: () async {
      //     // current index of the stack is editing stack
      //     if (_myProvider.stack_index == 1) {
      //       _myProvider.cancelClicked();
      //     }
      //     // if current stack is timer stack
      //     else if (_myProvider.stack_index == 2) {
      //       if (_timerState.isRunning.any((element) => element == true)) {
      //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //         ScaffoldMessenger.of(context).showSnackBar(uiKit.MySnackBar(
      //             uiKit.AppLocalizations.of(context).translate('cannotGoBack'),
      //             false,
      //             context));
      //       } else {
      //         _myProvider.changeTimerStack();
      //       }
      //     }
      //     // if the current stack is the donate stack
      //     else if (_myProvider.stack_index == 3) {
      //       _myProvider.goBackToMain();
      //     } else if (_myProvider.stack_index == 0) {
      //       return true;
      //     }
      //     return true;
      //   },
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: FutureBuilder(
                future: permissionStatusFuture,
                builder: (context, snapshot) {
                  // if we are waiting for data, show a progress indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasData) {
                    // The permission is granted, then just show the text
                    if (snapshot.data == permGranted) {
                      return Container(
                          height: SizeX * 0.98,
                          width: SizeY,
                          padding: EdgeInsets.only(),
                          child: Container(
                              width: SizeY,
                              height: SizeX,
                              child: Column(
                                children: [
                                  uiKit.MyRorderable(
                                  )
                                ],
                              )));
                    } else {
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    }
                  } else {
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
          ),
        ),
      //),
    );
  }
}
