import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:undo/undo.dart';

// TODO orginaing the providers and having multi providres having a separate
// provider for check me .
class myProvider extends ChangeNotifier {
  myProvider() {
    initialColorsAndLan();
    checkDayChange();
    // setting the timer for only once
    Timer.periodic(Duration(seconds: 60), (timer) {
      checkDayChange();
    });
  }

  List<Color> noteTitleColor;

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

  // Hiive database
  final noteBox = Hive.box<Note>(noteBoxName);
  // THEME MANAGMENT PART   /                ////                  /             ////           /
  String splashImage;
  Color whiteMainColor = Color(0xffe6ebf2);
  Color blackMainColor = Color(0xff303234);
  Color whiteShadowColor = Colors.black;
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

  // This was the date box but now I use it to store
  // the theme status as string
  final dateBox = Hive.box<String>(dateBoxName);

  Future initialColorsAndLan() async {
    String first_time;
    if (dateBox.get('firstTime') != null) {
      first_time = dateBox.get('firstTime');
    } else {
      dateBox.put('firstTime', "Yes");
      first_time = "Yes";
    }
    if (first_time == "Yes") {
      isFirstTime = true;
    } else {
      isFirstTime = false;
    }
    String lan;
    if (dateBox.get('lan') != null) {
      lan = dateBox.get('lan');
    } else {
      dateBox.put('lan', 'en');
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
    if (dateBox.get('theme') != null) {
      theme = dateBox.get('theme');
    } else {
      dateBox.put('theme', 'white');
      theme = 'white';
    }
    noteTitleColor = List<Color>.filled(100, Colors.white);
    runningColor = Colors.greenAccent[400];
    pausedColor = blueMaterial.withOpacity(0.7);
    overColor = Colors.redAccent[400];
    if (theme == 'white') {
      splashImage = 'assets/images/SplashScreenWhite.gif';
      noTaskImage = "assets/images/notask.png";
      mainColor = whiteMainColor;
      shadowColor = whiteShadowColor;
      lightShadowColor = whiteLightShadowColor;
      textColor = whiteTextColor;
      brightness = Brightness.light;
      swachColor = blueMaterial.withOpacity(0.7);
      hintColor = whiteTextColor.withOpacity(0.5);
      titleColor = whiteTitleColor;
      noteTitleColor.fillRange(0, 100, whiteNoteTitleColor);
    } else {
      splashImage = 'assets/images/SplashScreenBlack.gif';
      noTaskImage = "assets/images/blacknotask.png";
      mainColor = blackMainColor;
      shadowColor = blackShadowColor;
      lightShadowColor = blackLightShadowColor;
      textColor = blackTextColor;
      brightness = Brightness.dark;
      titleColor = blackTitleColor;
      noteTitleColor.fillRange(0, 100, blackNoteTitleColor);
      hintColor = textColor.withOpacity(0.5);
      swachColor = blueMaterial.withOpacity(0.7);
    }
    notifyListeners();
  }

  void changeBrigness() {
    String theme = dateBox.get('theme');
    runningColor = Colors.greenAccent[400];
    pausedColor = blueMaterial.withOpacity(0.7);
    overColor = Colors.redAccent[400];
    if (theme == 'white') {
      splashImage = 'assets/images/SplashScreenBlack.gif';
      noTaskImage = "assets/images/blacknotask.png";
      mainColor = blackMainColor;
      shadowColor = blackShadowColor;
      lightShadowColor = blackLightShadowColor;
      textColor = blackTextColor;
      brightness = Brightness.dark;
      noteTitleColor.fillRange(0, 100, blackNoteTitleColor);
      hintColor = textColor.withOpacity(0.5);
      swachColor = blueMaterial.withOpacity(0.7);
      titleColor = blackTitleColor;
      dateBox.put('theme', 'black');
      notifyListeners();
    } else {
      splashImage = 'assets/images/SplashScreenWhite.gif';
      noTaskImage = "assets/images/notask.png";
      mainColor = whiteMainColor;
      shadowColor = whiteShadowColor;
      lightShadowColor = whiteLightShadowColor;
      textColor = whiteTextColor;
      brightness = Brightness.light;
      titleColor = whiteTitleColor;
      noteTitleColor.fillRange(0, 100, whiteNoteTitleColor);
      swachColor = blueMaterial.withOpacity(0.7);
      hintColor = whiteTextColor.withOpacity(0.5);
      dateBox.put('theme', 'white');
      notifyListeners();
    }
  }

  void changeNoteTitleColor(bool isExpanded, int index) {
    print(isExpanded);
    if (isExpanded) {
      noteTitleColor[index] = swachColor;
    } else {
      String theme = dateBox.get('theme');
      if (theme == 'white') {
        noteTitleColor[index] = whiteTextColor;
      } else {
        noteTitleColor[index] = blackTextColor;
      }
    }
    notifyListeners();
  }

  void changeLan() {
    String lan = dateBox.get('lan') ?? dateBox.put('lan', 'en');
    if (lan == 'en') {
      isEn = false;
      dateBox.put('lan', 'fa');
      locale = Locale("fa", "IR");
    } else {
      isEn = true;
      dateBox.put('lan', 'en');
      locale = Locale("en", "US");
    }
    notifyListeners();
  }

  void changeLanToPersian() {
    isEn = false;
    dateBox.put('lan', 'fa');
    locale = Locale("fa", "IR");
    notifyListeners();
  }

  void changeLanToEnglish() {
    isEn = true;
    dateBox.put('lan', 'en');
    locale = Locale("en", "US");
    notifyListeners();
  }

  bool boolIsWhite;
  bool isWhite() {
    String theme = dateBox.get('theme');
    if (theme == 'white') {
      return true;
    } else {
      return false;
    }
  }

  bool changeFirstTime() {
    dateBox.put('firstTime', "No");
    notifyListeners();
  }

  List<int> durationKeys;
  int duartionIndex;
  void saveDuration(List<int> keys, int index, int duration) {
    var ntitle = noteBox.get(keys[index]).title;
    var nttext = noteBox.get(keys[index]).text;
    var nttime = noteBox.get(keys[index]).time;
    var ntlefttime = duration;
    var ntcolor = noteBox.get(keys[index]).color;
    var ntchecked = noteBox.get(keys[index]).isChecked;
    Note note = Note(ntitle, nttext, ntchecked, nttime, ntcolor, ntlefttime);
    noteBox.put(keys[index], note);
  }

  //////////////////////////////////// CHECKBOX CHECK PART///////////////////////////////////////////////////
  Future<void> checkDayChange() async {
    String date = dateBox.get('date');
    var now = DateTime.now();
    if (date != null) {
      List<String> dateList = date.split(',');
      int day = now.day;
      int month = now.month;
      int year = now.year;
      if (int.parse(dateList[0]) < year ||
          int.parse(dateList[1]) < month ||
          int.parse(dateList[2]) < day) {
        if (noteBox.length != 0) {
          for (int i = 0; i < noteBox.length; i++) {
            var ntitle = noteBox.getAt(i).title;
            var nttext = noteBox.getAt(i).text;
            var nttime = noteBox.getAt(i).time;
            var ntcolor = noteBox.getAt(i).color;
            var ntlefttime = noteBox.getAt(i).leftTime;
            Note note =
                Note(ntitle, nttext, false, nttime, ntcolor, ntlefttime);
            noteBox.putAt(i, note);
          }
          dateBox.put('date',
              "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
        }
      }
    } else {
      dateBox.put('date',
          "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
    }
    notifyListeners();
  }

  final TextEditingController title = TextEditingController(text: '');
  final TextEditingController text = TextEditingController(text: '');
  // handeling changes to text textfield
  var changes = new ChangeStack();
  // The Time picker dialog controller
  Duration time_duration = Duration();
  // this varriable is used in snapshot to chacke
  // that no changes has been made
  Duration time_snapshot;
  // these two varrables are used to check if anything has been changed or not .
  String ttitle;
  String ttext;
  // focus nodes for each text field
  final FocusNode fTitle = FocusNode();
  final FocusNode ftext = FocusNode();
  // this is used for showing the SnackBar
  BuildContext myContext;
  // the index of the main stack and the floating stack
  int stack_index = 0;
  int floating_index = 0;
  // to press the back button twice for getting back to the notes list ! without saving
  int notSaving = 0;
  // the chnage and edit controller
  String old_value;
  String new_value_helper;
  String redo_value;
  bool begin_edit;

  List<int> providerKeys;
  int providerIndex;
  TextEditingController get myTitle => title;
  TextEditingController get myText => text;
  bool newNote;
  // note color is used for reloading the color selection selected
  Color noteColor;
  int indexOfSelectedColor;
  // This is used inside of Note textfield to control and save the changes for undo property
  void listenerActivated(newValue) {
    // This Line is used for prevent unusual behavior of the textfield
    // It executes the on change function twice after entering only one word
    if (new_value_helper != newValue) {
      // Staging the changes !
      changes.add(new Change(old_value, () {
        redo_value = newValue;
      }, (oldValue) {
        // When the chnage is being apllies or in other words
        // The undo button is selected I want to make the text controller
        // text equal to the oldValue that the change got before .
        text.text = oldValue;
        // Updating the old_value and making it ready for the next change
        old_value = oldValue;
        // Making the cursor stay at the right position
        text.selection =
            TextSelection.fromPosition(TextPosition(offset: text.text.length));
      }));
      // After giving the value of the old_value as Oldvalue to the change
      // It's Time to update old_value for the next change
      old_value = text.text;
      // updating the new_value_helper to prevent extra execution of onChange function
      new_value_helper = newValue;
      notifyListeners();
    }
  }

  // Redo and Undo button activation change and used
  // to avoid direct access to provider
  bool get canRedo => changes.canRedo;
  bool get canUndo => changes.canUndo;
  // Handeling the Undo function
  void changesUndo() {
    changes.undo();
    notifyListeners();
  }

  // handeling the Redo function
  void changesRedo() {
    changes.redo();
    text.text = redo_value;
    text.selection =
        TextSelection.fromPosition(TextPosition(offset: text.text.length));
    notifyListeners();
  }

  // fo the clear button in the form
  void clearTitle() {
    title.clear();
    notifyListeners();
  }

  // Clearing only the text
  void clearText() {
    text.clear();
    notifyListeners();
  }

  // for the clear the form
  void clearTitleAndText() {
    title.clear();
    text.clear();
    notifyListeners();
  }

  void clearDuration() {
    time_duration = Duration();
    notifyListeners();
  }

  // Updating the Stacks
  void changeStacks() {
    if (stack_index < 1) {
      stack_index++;
    } else {
      stack_index = 0;
    }
    notifyListeners();
  }

  void goBackToMain() {
    stack_index = 0;
    notifyListeners();
  }

  void changeTimerStack() {
    if (stack_index < 2) {
      stack_index = 2;
    } else {
      stack_index = 0;
    }
    notifyListeners();
  }

  // getting the controller before the user enters the editing area
  // to detect the if any changes has been occured !
  void takeSnapshot() {
    ttitle = title.text;
    ttext = text.text;
    old_value = text.text;
    time_snapshot = time_duration;
    begin_edit = false;
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    if (ttitle == title.text &&
        ttext == text.text &&
        time_duration == time_snapshot) {
      return false;
    } else {
      return true;
    }
  }

  // upodating the database when the check box is checked or unchecked
  void updateIsChecked(bool newValue, List<int> keys, int index) {
    providerKeys = keys;
    providerIndex = index;
    var ntitle = noteBox.get(providerKeys[providerIndex]).title;
    var nttext = noteBox.get(providerKeys[providerIndex]).text;
    var nttime = noteBox.get(providerKeys[providerIndex]).time;
    var ntcolor = noteBox.get(providerKeys[providerIndex]).color;
    var ntlefttime = noteBox.get(providerKeys[providerIndex]).leftTime;
    Note note = Note(ntitle, nttext, newValue, nttime, ntcolor, ntlefttime);
    noteBox.put(providerKeys[providerIndex], note);
    notifyListeners();
  }

  // new Note clieked
  void newNoteClicked(BuildContext context) {
    myContext = context;
    // When the add icon is tapped this function will be executed and
    // prepare the provider for the new Note
    clearTitleAndText();
    clearDuration();
    newNote = true;
    takeSnapshot();
    changeStacks();
    notifyListeners();
  }

  // used indie list view after an elemt of listview is tapped
  void loadNote(List<int> keys, int index, BuildContext context) {
    myContext = context;
    providerKeys = keys;
    providerIndex = index;
    title.text = noteBox.get(keys[index]).title;
    text.text = noteBox.get(keys[index]).text;
    time_duration = Duration(seconds: noteBox.get(keys[index]).time);
    noteColor = Color(noteBox.get(keys[index]).color);
    newNote = false;
    takeSnapshot();
    changeStacks();
    notifyListeners();
  }

  // getting the color that was choosen by the user
  void changeNoteColor(Color selectedColor, int index) {
    noteColor = selectedColor;
    indexOfSelectedColor = index;
    notifyListeners();
  }

  // executed when the user tapped on the check floating button (done icon FAB)
  void doneClicked() {
    print('object');
    // checking whether your going to update the note or add new one
    // that is done by chekcing the newNote true or false
    if (newNote) {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        final String noteText = text.text;
        final int noteTime = time_duration.inSeconds;
        int leftTime = noteTime;

        Note note = Note(noteTitle, noteText, false, noteTime, 0, leftTime);
        noteBox.add(note);
        changes.clearHistory();
        changeStacks();
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
          uiKit.AppLocalizations.of(myContext).translate('emptyFieldsAlert'),
          false,
          myContext,
        ));
      }
      // TODO find out why this is here
      clearTitleAndText();
    } else {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        Note note = new Note(
          noteTitle,
          text.text,
          noteBox.get(providerKeys[providerIndex]).isChecked,
          time_duration.inSeconds,
          0,
          time_duration.inSeconds,
        );
        noteBox.put(providerKeys[providerIndex], note);
        changes.clearHistory();
        changeStacks();
        notifyListeners();
      } else {
        noteBox.delete(providerKeys[providerIndex]);
        changes.clearHistory();
        changeStacks();
        notifyListeners();
      }
    }
    notifyListeners();
  }

  // When the clear Icon clicked or back button is tapped
  // this fucntion will be executed checking for changes
  // if the changes has been made it is going to show an alert
  void cancelClicked() {
    if (isEdited()) {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        if (notSaving == 0) {
          ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
              uiKit.AppLocalizations.of(myContext).translate('notSavingAlert'),
              false,
              myContext));
          notSaving = notSaving + 1;
          Future.delayed(Duration(seconds: 10), () {
            notSaving = 0;
          });
        } else {
          notSaving = 0;
          changeStacks();
          changes.clearHistory();
          notifyListeners();
        }
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(myContext).translate('willingToDelete'),
            false,
            myContext));
        changeStacks();
        notifyListeners();
      }
    } else {
      // making all the changes that has been save for the
      // future undo will be deleted to prevent the future problem
      // causes !
      changes.clearHistory();
      // changing the stacks and getting bavk to listview Screen !
      changeStacks();
      notifyListeners();
    }
  }

  // This function  is used to handle the changes that has been
  // occured to the time picker !
  void timerDurationChange(duration) {
    // updating the state and notifiung the listeners
    time_duration = duration;
    notifyListeners();
  }

  void gotoDonate() {
    if (stack_index == 0) {
      stack_index = 3;
    } else {
      stack_index = 0;
    }
    notifyListeners();
  }
}
