import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';

import '../main.dart';
import 'colors_pallette.dart';
import 'theme_state.dart';

class ThemeLogic extends GetxController {
  ThemeState state = ThemeState();

  @override
  void onInit() {
    initialColorsAndLan();
    super.onInit();
  }

  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);

  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  // A function to be executed when the app runs at first
  // and will initialize the colors and language
  Future<bool> initialColorsAndLan() async {
    // checks if it's the first time
    // that the user comes to app
    String? firstTime;
    if (prefsBox.get('firstTime') != null) {
      firstTime = prefsBox.get('firstTime');
    } else {
      prefsBox.put('firstTime', "Yes");
      firstTime = "Yes";
      noteBox.clear();
    }
    if (firstTime == "Yes") {
      state.isFirstTime = true;
    } else {
      state.isFirstTime = false;
    }
    String? lan;
    if (prefsBox.get('lan') != null) {
      lan = prefsBox.get('lan');
    } else {
      prefsBox.put('lan', 'en');
      lan = 'en';
    }
    if (lan == 'en') {
      state.isEn = true;
      state.locale = Locale("en", "US");
    } else {
      state.isEn = false;
      state.locale = Locale("fa", "IR");
    }
    String? theme;
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
    state.noteTitleColor.addAll(List<Color>.filled(100, Colors.white));
    // The colors for the timer border
    // will initial the color
    changeBrightness(toWhat: theme);

    return true;
  }

  void changeBrightness({String? toWhat}) {
    // This function is called when the user
    // taps on the lamp to change the brigtness
    String? theme;
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
      state.splashImage = 'assets/images/SplashScreenBlack.gif';
      state.noTaskImage = "assets/images/notask.png";
      // shimmerColor = blackShimmer;
      state.mainColor = ColorsPallette.blackMainColor;
      state.mainOpColor = ColorsPallette.whiteMainColor;
      state.textColor = ColorsPallette.blackTextColor;
      state.brightness = Brightness.dark;
      state.noteTitleColor.fillRange(0, 100, ColorsPallette.blackNoteTitleColor);
      state.hinoteColor = state.textColor!.withOpacity(0.5);
      state.swashColor = state.swashColor.withOpacity(0.7);
      state.titleColor = ColorsPallette.blackTitleColor;
      prefsBox.put('theme', 'black');
    } else {
      state.splashImage = 'assets/images/SplashScreenWhite.gif';
      state.noTaskImage = "assets/images/notask.png";
      // shimmerColor = whiteShimmer;
      state.mainColor = ColorsPallette.whiteMainColor;
      state.mainOpColor = ColorsPallette.blackMainColor;
      state.textColor = ColorsPallette.whiteTextColor;
      state.brightness = Brightness.light;
      state.titleColor = ColorsPallette.whiteTitleColor;
      state.noteTitleColor.fillRange(0, 100, ColorsPallette.whiteNoteTitleColor);
      state.swashColor = state.swashColor.withOpacity(0.7);
      state.hinoteColor = ColorsPallette.whiteTextColor.withOpacity(0.5);
      prefsBox.put('theme', 'white');
    }
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
    String lan = prefsBox.get('lan') ?? prefsBox.put('lan', 'en') as String;
    if (lan == 'en') {
      changeLanToPersian();
    } else {
      changeLanToEnglish();
    }
  }

  void changeLanToPersian() {
    state.isEn = false;
    prefsBox.put('lan', 'fa');
    state.locale = Locale("fa", "IR");
  }

  void changeLanToEnglish() {
    state.isEn = true;
    prefsBox.put('lan', 'en');
    state.locale = Locale("en", "US");
  }

  // This function will be executed as soon as the user crosses
  // the on boarding screen
  void changeFirstTime() {
    prefsBox.put('firstTime', "No");
  }
}
