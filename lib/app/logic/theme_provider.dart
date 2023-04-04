import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';

import '../../main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    initialColorsAndLan();
  }
  List<Color> noteTitleColor;
  Color shimmerColor;
  Color mainColor;
  Color textColor;
  Color titleColor;
  Color hintColor;
  Brightness brightness;
  Color swashColor = Color(0xFF001b48);
  bool isEn;
  // this ThemeProvider is used to control the showcase
  bool isFirstTime;
  Locale locale;
  String noTaskImage;
  Color red = Color(0xFFff4444);
  Color green = Color(0xFF00c851);
  Color yellow = Color(0xFFffbb33);
  Color blue = Color(0xFF33b5e5);
  Color purple = Color(0xffaa66cc);

  List<Color> shadedColors = [];

  List<Color> getNoteColors() {
    shadedColors.clear();
    shadedColors.add(red);
    shadedColors.add(green);
    shadedColors.add(yellow);
    shadedColors.add(blue);
    shadedColors.add(purple);
    return shadedColors;
  }

  String splashImage;
  Color whiteMainColor = Color(0xffe6ebf2);
  Color blackMainColor = Color(0xff303234);
  // Color whiteShadowColor = Colors.black;
  // Color whiteShimmer = Colors.grey.withOpacity(0.6);
  // Color blackShimmer = Colors.grey.withOpacity(0.5);
  // Color blackShadowColor = Color(0xff000000).withOpacity(0.4);
  // Color whiteLightShadowColor = Colors.white;
  // Color blackLightShadowColor = Color(0xff494949).withOpacity(0.4);
  Color whiteTextColor = Colors.black.withOpacity(.5);
  Color blackTextColor = Colors.white.withOpacity(.5);
  Color whiteTitleColor = Colors.black;
  Color blackTitleColor = Colors.white;

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
    String firstTime;
    if (prefsBox.get('firstTime') != null) {
      firstTime = prefsBox.get('firstTime');
    } else {
      prefsBox.put('firstTime', "Yes");
      firstTime = "Yes";
      noteBox.clear();
    }
    if (firstTime == "Yes") {
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
    // will initial the color
    changeBrightness(toWhat: theme);
    notifyListeners();
  }

  void changeBrightness({String toWhat}) {
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
      noTaskImage = "assets/images/notask.png";
      // shimmerColor = blackShimmer;
      mainColor = blackMainColor;
      textColor = blackTextColor;
      brightness = Brightness.dark;
      noteTitleColor.fillRange(0, 100, blackNoteTitleColor);
      hintColor = textColor.withOpacity(0.5);
      swashColor = swashColor.withOpacity(0.7);
      titleColor = blackTitleColor;
      prefsBox.put('theme', 'black');
    } else {
      splashImage = 'assets/images/SplashScreenWhite.gif';
      noTaskImage = "assets/images/notask.png";
      // shimmerColor = whiteShimmer;
      mainColor = whiteMainColor;
      textColor = whiteTextColor;
      brightness = Brightness.light;
      titleColor = whiteTitleColor;
      noteTitleColor.fillRange(0, 100, whiteNoteTitleColor);
      swashColor = swashColor.withOpacity(0.7);
      hintColor = whiteTextColor.withOpacity(0.5);
      prefsBox.put('theme', 'white');
    }
    notifyListeners();
  }

  bool checkIsWhite() {
    if (prefsBox.get('theme') == 'white') {
      return true;
    } else {
      return false;
    }
  }

  // Changes the lan as soon as the user taps on lan button
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
