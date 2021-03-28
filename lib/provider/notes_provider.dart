import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;

class myProvider extends ChangeNotifier {
  final TextEditingController title = TextEditingController(text: '');
  final TextEditingController text = TextEditingController(text: '');
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
  final noteBox = Hive.box<Note>(noteBoxName);
  List<int> providerKeys;
  int providerIndex;
  TextEditingController get myTitle => title;
  TextEditingController get myText => text;
  bool newNote;
  // fo the clear button in the form
  void clearTitle() {
    title.clear();
    notifyListeners();
  }

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

  void addNewNote() {
    clearTitleAndText();
    newNote = true;
    notifyListeners();
  }

  void changeStacks() {
    if (stack_index < 1) {
      stack_index++;
    } else {
      stack_index = 0;
    }
    if (floating_index < 1) {
      floating_index++;
    } else {
      floating_index = 0;
    }
    notifyListeners();
  }

  // getting the controller before the user enters the editing area
  // to detect the if any changes has been occured !
  void takeSnapshot() {
    ttitle = title.text;
    ttext = text.text;
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    print("${ttitle} , ${title.text}");
    if (ttitle == title.text && ttext == text.text) {
      return false;
    } else {
      return true;
    }
  }

  void updateIsChecked(bool newValue, List<int> keys, int index) {
    providerKeys = keys;
    providerIndex = index;
    var ntitle = noteBox.get(providerKeys[providerIndex]).title;
    var nttext = noteBox.get(providerKeys[providerIndex]).text;
    Note note = Note(ntitle, nttext, newValue);
    noteBox.put(providerKeys[providerIndex], note);
    notifyListeners();
  }

  void newNoteClicked(BuildContext context) {
    myContext = context;
    addNewNote();
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
    newNote = false;
    takeSnapshot();
    changeStacks();
    notifyListeners();
  }

  // executed when the user tapped on the check floating button (done icon FAB)
  void doneClicked() {
    // checking whether your going to update the note or add new one
    // that is done by chekcing the newNote true or false
    if (newNote) {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        final String noteText = text.text;
        Note note = Note(noteTitle, noteText, false);
        noteBox.add(note);
        changeStacks();
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(myContext)
                .translate('emptyFieldsAlert')));
      }
      clearTitleAndText();
    } else {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        Note note = new Note(noteTitle, text.text,
            noteBox.get(providerKeys[providerIndex]).isChecked);
        noteBox.put(providerKeys[providerIndex], note);
        changeStacks();
        notifyListeners();
      } else {
        noteBox.delete(providerKeys[providerIndex]);
        changeStacks();
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void cancelClicked() {
    if (isEdited()) {
      print("object");
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        if (notSaving == 0) {
          ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
              uiKit.AppLocalizations.of(myContext)
                  .translate('notSavingAlert')));
          notSaving = notSaving + 1;
        } else {
          notSaving = 0;
          changeStacks();
        }
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(myContext).translate('willingToDelete')));
        changeStacks();
        notifyListeners();
      }
    } else {
      changeStacks();
      notifyListeners();
    }
  }

  void loop() {
    for (int i = 0; i < noteBox.length; i++) {
      print(noteBox.getAt(i).isChecked);
    }
  }
}
