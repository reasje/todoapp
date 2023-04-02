import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/notes%20list/state.dart';
import 'package:todoapp/model/note_model.dart';

import '../../main.dart';

class NotesLogic extends ChangeNotifier {
  NotesState state = NotesState();


  // Hive box for notes
  //BuildContext donateContext;
  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  void load() {
    state.isLoading = true;
  }

  void loadingOver() {
    state.isLoading = false;
  }


  Future<void> reorderNoteList(int oldIndex, int newIndex) async {
    List<int> keys = noteBox.keys.cast<int>().toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    var bnote = await noteBox.get(keys[oldIndex]);

    Note note = bnote;
    if (newIndex < oldIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        var bnote2 = await noteBox.get(keys[i - 1]);
        noteBox.put(keys[i], bnote2);
      }
    } else {
      for (int i = oldIndex; i < newIndex; i++) {
        var bnote = await noteBox.get(keys[i + 1]);
        noteBox.put(keys[i], bnote);
      }
    }
    noteBox.put(keys[newIndex], note);
  }

  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);
  Future<void> checkDayChange() async {
    String date = prefsBox.get('date');
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
            var bnote = await noteBox.getAt(i);
            if (bnote.resetCheckBoxs == true) {
              var ntitle = bnote.title;
              var nttext = bnote.text;
              var ntIsChecked = bnote.isChecked;
              var ntcolor = bnote.color;
              var ntImageList = bnote.imageList;
              var ntVoiceList = bnote.voiceList;
              var ntTaskList = bnote.taskList;
                          var ntPassword = bnote.password;
              // unchecking all the tasks
              ntTaskList.forEach((element) {
                element.isDone = false;
              });
              var ntResetCheckBoxs = bnote.resetCheckBoxs;
              Note note = Note(
                ntitle,
                nttext,
                ntIsChecked,
                ntcolor,
                ntImageList,
                ntVoiceList,
                ntTaskList,
                ntResetCheckBoxs,
                ntPassword
              );
              noteBox.putAt(i, note);
            }
          }
          prefsBox.put('date',
              "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
        }
      }
    } else {
      prefsBox.put('date',
          "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
    }
  }
}