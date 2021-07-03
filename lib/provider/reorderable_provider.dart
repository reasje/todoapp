import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';

import '../main.dart';

class ReorderableProvider with ChangeNotifier {
    // This varrible is used to controll the listview size for the listview
  // to not to be short
  double listViewSize;
    // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);
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

  Future<bool> updateListSize(List<int> keys, SizeX, SizeY) async {
    int with_timer = 0;
    int without_timer = 0;
    for (int i = 0; i < keys.length; i++) {
      var bnote = await noteBox.get(keys[i]);
      if (bnote.time == 0) {
        without_timer = without_timer + 1;
      } else {
        without_timer = without_timer + 1;
      }
    }
    listViewSize = (without_timer * SizeX * 0.22) + (with_timer * SizeX * 0.5);
    return true;
  }
  
}