import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/notes_provider.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/screen/bloc_example.dart';
import 'package:todoapp/screen/splash_screen.dart';
import 'applocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const String noteBoxName = 'Note';
const String dateBoxName = 'dates';

void main() async {
  // ensurening that the init is done !
  WidgetsFlutterBinding.ensureInitialized();
  // getting the path of the document in the device for accesing the database
  final document = await getApplicationDocumentsDirectory();
  // Giving the path of the data base to the Hive
  Hive.init(document.path);
  // registering the adapter
  Hive.registerAdapter(NoteAdapter());
  // opening the box
  await Hive.openBox<Note>(noteBoxName);
  // the database of time for day change recognizing
  await Hive.openBox<String>(dateBoxName);
  // Hydrated bloc for keeping the instances of the
  // blocs alive
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => myProvider())],
        child: Consumer<myProvider>(
          builder: (context, _myProvider, _) {
            return new MaterialApp(
              locale: _myProvider.locale,
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
              theme: ThemeData(
                  fontFamily: GoogleFonts.ubuntuCondensed().fontFamily),
              home: MySplashScreen(),
            );
          },
        ));
  }
}
