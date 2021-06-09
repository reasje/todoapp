import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';

import '../main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    initialColorsAndLan();
  }
  List<Color> noteTitleColor;
  Color shimmerColor;
  Color mainColor;
  Color shadowColor;
  Color lightShadowColor;
  Color textColor;
  Color titleColor;
  Color hintColor;
  Brightness brightness;
  Color swachColor;
  bool isEn;
  // this varrable is used to control the showcase
  bool isFirstTime;
  Locale locale;
  String noTaskImage;
  // This the color to be used for the buttons and so on
  MaterialColor blueMaterial =
      const MaterialColor(0xFF3694fc, const <int, Color>{
    50: const Color(0x1A001b48),
    100: const Color(0x33001b48),
    200: const Color(0x4D001b48),
    300: const Color(0x66001b48),
    400: const Color(0x80001b48),
    500: const Color(0x99001b48),
    600: const Color(0xB3001b48),
    700: const Color(0xCC001b48),
    800: const Color(0xE6001b48),
    900: const Color(0xFF001b48),
  });

  String splashImage;
  Color whiteMainColor = Color(0xffe6ebf2);
  Color blackMainColor = Color(0xff303234);
  Color whiteShadowColor = Colors.black;
  Color whiteShimmer = Colors.grey.withOpacity(0.6);
  Color blackShimmer = Colors.grey.withOpacity(0.5);
  Color blackShadowColor = Color(0xff000000).withOpacity(0.4);
  Color whiteLightShadowColor = Colors.white;
  Color blackLightShadowColor = Color(0xff494949).withOpacity(0.4);
  Color whiteTextColor = Colors.black.withOpacity(.5);
  Color blackTextColor = Colors.white.withOpacity(.5);
  Color whiteTitleColor = Colors.black;
  Color blackTitleColor = Colors.white;
  Color runningColor;
  Color pausedColor;
  Color overColor;
  Color whiteNoteTitleColor = Colors.black.withOpacity(.5);
  Color blackNoteTitleColor = Colors.white.withOpacity(.5);

  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);

  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  // A function to be executed when the app runs at first
  // and will initialize the colors and language
  Future initialColorsAndLan() async {
    // checks if it's the first time
    // that the user comes to app
    String first_time;
    if (prefsBox.get('firstTime') != null) {
      first_time = prefsBox.get('firstTime');
    } else {
      prefsBox.put('firstTime', "Yes");
      first_time = "Yes";
    }
    if (first_time == "Yes") {
      isFirstTime = true;
    } else {
      isFirstTime = false;
    }
    String lan;
    if (prefsBox.get('lan') != null) {
      lan = prefsBox.get('lan');
    } else {
      prefsBox.put('lan', 'en');
      lan = 'en';
    }
    if (lan == 'en') {
      isEn = true;
      locale = Locale("en", "US");
    } else {
      isEn = false;
      locale = Locale("fa", "IR");
    }
    String theme;
    if (prefsBox.get('theme') != null) {
      theme = prefsBox.get('theme');
    } else {
      prefsBox.put('theme', 'white');
      theme = 'white';
    }
    // i think this is not needed any more
    // cuz I have deleted the set state for the
    // note when the expansion is changed for the
    // better animation pusrpose
    noteTitleColor = List<Color>.filled(100, Colors.white);
    // The colors for the timer border
    runningColor = Colors.greenAccent[400];
    pausedColor = blueMaterial.withOpacity(0.7);
    overColor = Colors.redAccent[400];
    // will initial the color
    changeBrigness(toWhat: theme);
    notifyListeners();
  }

  void changeBrigness({String toWhat}) {
    // This function is called when the user
    // taps on the lamp to change the brigtness
    String theme;
    // If the function is called from the inital function
    // the to toWhat will not be null and so we will
    // prepare to initilize the color according to
    // toWhat and because this function will make the
    // opposite color of which the theme  is
    // we will make the theme opposite in the below code
    if (toWhat == null) {
      theme = prefsBox.get('theme');
    } else {
      if (toWhat == 'white') {
        theme = 'black';
      } else {
        theme = 'white';
      }
    }
    if (theme == 'white') {
      splashImage = 'assets/images/SplashScreenBlack.gif';
      noTaskImage = "assets/images/blacknotask.png";
      shimmerColor = blackShimmer;
      mainColor = blackMainColor;
      shadowColor = blackShadowColor;
      lightShadowColor = blackLightShadowColor;
      textColor = blackTextColor;
      brightness = Brightness.dark;
      noteTitleColor.fillRange(0, 100, blackNoteTitleColor);
      hintColor = textColor.withOpacity(0.5);
      swachColor = blueMaterial.withOpacity(0.7);
      titleColor = blackTitleColor;
      prefsBox.put('theme', 'black');
    } else {
      splashImage = 'assets/images/SplashScreenWhite.gif';
      noTaskImage = "assets/images/notask.png";
      shimmerColor = whiteShimmer;
      mainColor = whiteMainColor;
      shadowColor = whiteShadowColor;
      lightShadowColor = whiteLightShadowColor;
      textColor = whiteTextColor;
      brightness = Brightness.light;
      titleColor = whiteTitleColor;
      noteTitleColor.fillRange(0, 100, whiteNoteTitleColor);
      swachColor = blueMaterial.withOpacity(0.7);
      hintColor = whiteTextColor.withOpacity(0.5);
      prefsBox.put('theme', 'white');
    }
    notifyListeners();
  }

  bool checkIsWhite(){
    if (prefsBox.get('theme') == 'white') {
      return true;
    } else {
      return false;
    }
  }

  // Chnages the lan as soon as the user taps on lan button
  void changeLan() {
    String lan = prefsBox.get('lan') ?? prefsBox.put('lan', 'en');
    if (lan == 'en') {
      changeLanToPersian();
    } else {
      changeLanToEnglish();
    }
  }

  void changeLanToPersian() {
    isEn = false;
    prefsBox.put('lan', 'fa');
    locale = Locale("fa", "IR");
    notifyListeners();
  }

  void changeLanToEnglish() {
    isEn = true;
    prefsBox.put('lan', 'en');
    locale = Locale("en", "US");
    notifyListeners();
  }

  // This function will be executed as soon as the user crosses
  // the on boarding screen
  void changeFirstTime() {
    prefsBox.put('firstTime', "No");
  }
}
