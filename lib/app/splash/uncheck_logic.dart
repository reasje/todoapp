import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';

import '../../main.dart';

class UnCheckLogic {
  static Future<void> checkDayChange() async {
    // It is used to store
    // the theme status as string
    final prefsBox = Hive.box<String>(prefsBoxName);
    //BuildContext donateContext;
    // Hive box for notes
    final noteBox = Hive.lazyBox<Note>(noteBoxName);
    String date = prefsBox.get('date');
    var now = DateTime.now();
    if (date != null) {
      List<String> dateList = date.split(',');
      int day = now.day;
      int month = now.month;
      int year = now.year;
      if (int.parse(dateList[0]) < year || int.parse(dateList[1]) < month || int.parse(dateList[2]) < day) {
        if (noteBox.length != 0) {
          for (int i = 0; i < noteBox.length; i++) {
            var bnote = await noteBox.getAt(i);
            if (bnote.resetCheckBoxs == true) {
              var noteTitle = bnote.title;
              var noteText = bnote.text;
              var ntIsChecked = bnote.isChecked;
              var noteColor = bnote.color;
              var ntImageList = bnote.imageList;
              var ntVoiceList = bnote.voiceList;
              var ntTaskList = bnote.taskList;
              var ntPassword = bnote.password;
              // unchecking all the tasks
              ntTaskList.forEach((element) {
                element.isDone = false;
              });
              var ntResetCheckBoxs = bnote.resetCheckBoxs;
              Note note = Note(noteTitle, noteText, ntIsChecked, noteColor, ntImageList, ntVoiceList, ntTaskList, ntResetCheckBoxs, ntPassword);
              noteBox.putAt(i, note);
            }
          }
          prefsBox.put('date', "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
        }
      }
    } else {
      prefsBox.put('date', "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
    }
  }
}
