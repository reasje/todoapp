import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_logic.dart';
import 'package:todoapp/app/donate/logic/donate_provider.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/note_screen/logic/notecolor_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/note_screen/logic/notepassword_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetask_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetitletext_logic.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_player_logic.dart';

import 'package:todoapp/app/settings/settings_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'app/splash/connection_logic.dart';
import 'app/splash/uncheck_logic.dart';
import 'app/splash/screen/splash_screen.dart';
import 'applocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const String noteBoxName = 'Note';
const String prefsBoxName = 'prefs';

// Flutter notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// void printHello() {
//   print('object');
// }

void main() async {
  // ensurening that the init is done !
  WidgetsFlutterBinding.ensureInitialized();
  // flutter notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('todoapplogo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
  // getting the path of the document in the device for accesing the database
  final document = await getApplicationDocumentsDirectory();
  // Giving the path of the data base to the Hive
  Hive.init(document.path);
  // registering the adapter
  Hive.registerAdapter(imageModel.ImageAdapter());
  // registering the adapter
  Hive.registerAdapter(TaskAdapter());
  // registering the adapter
  Hive.registerAdapter(VoiceAdapter());
  // registering the adapter
  Hive.registerAdapter(NoteAdapter());
  // opening the box
  await Hive.openLazyBox<Note>(noteBoxName);
  // the database of time for day change recognizing
  await Hive.openBox<String>(prefsBoxName);
  // android alarm manager services
  // final int helloAlarmID = 0;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
  // runApp(MyApp());
  configLoading();
  //await AndroidAlarmManager.periodic(const Duration(seconds: 1), 1, printHello, exact: true, wakeup: true);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _themeLogic = Get.put(ThemeLogic());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_themeLogic.state.isEn != null) {
        return GetMaterialApp(
          // locale: _themeState.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            // A class which loads the strings form JSON files
            //GlobalCupertinoLocalizations.delegate,
            // Built-in localization for simple text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("en", "US"),
            Locale("fa", "IR"),
          ],
          // Return a locale which will be used by the app
          // localeResolutionCallback: (locale, supportedLocales) {
          //   // Check if the current device locale is supported
          //   for (var supportedLocale in supportedLocales) {
          //     if (supportedLocale.languageCode == locale.languageCode &&
          //         supportedLocale.countryCode == locale.countryCode) {
          //       return supportedLocale;
          //     }
          //   }
          //   return supportedLocales.first;
          // },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity, fontFamily: _themeLogic.state.isEn! ? "Ubuntu Condensed" : "Dubai"),
          home: SplashScreen(),
          builder: EasyLoading.init(),
        );
      } else {
        return Container();
      }
    });
  }
}
