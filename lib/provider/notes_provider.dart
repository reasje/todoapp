import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/model/note_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:undo/undo.dart';

class myProvider extends ChangeNotifier {
  final TextEditingController title = TextEditingController(text: '');
  final TextEditingController text = TextEditingController(text: '');
  // handeling changes to text textfield
  var changes = new ChangeStack();
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
  // Hiive database
  final noteBox = Hive.box<Note>(noteBoxName);
  List<int> providerKeys;
  int providerIndex;
  TextEditingController get myTitle => title;
  TextEditingController get myText => text;
  bool newNote;
  // This is used inside of Note textfield to control and save the changes for undo property
  void listenerActivated(newValue) {
    // This Line is used for prevent unusual behavior of the textfield
    // It executes the on change function twice after entering only one word
    if (new_value_helper != newValue) {
      // Staging the changes !
      changes.add(new Change(old_value, () {}, (oldValue) {
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

  // When the add icon is tapped this function will be executed and
  // prepare the provider for the new Note
  void addNewNote() {
    clearTitleAndText();
    newNote = true;
    notifyListeners();
  }

  // Updating the Stacks
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
    old_value = text.text;
    begin_edit = false;
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    if (ttitle == title.text && ttext == text.text) {
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
    Note note = Note(ntitle, nttext, newValue);
    noteBox.put(providerKeys[providerIndex], note);
    notifyListeners();
  }

  // new Note clieked
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
        changes.clearHistory();
        changeStacks();
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(myContext).translate('emptyFieldsAlert'),
            false));
      }
      clearTitleAndText();
    } else {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        Note note = new Note(noteTitle, text.text,
            noteBox.get(providerKeys[providerIndex]).isChecked);
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
              false));
          notSaving = notSaving + 1;
        } else {
          notSaving = 0;
          changeStacks();
        }
      } else {
        ScaffoldMessenger.of(myContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(myContext).translate('willingToDelete'),
            false));
        changeStacks();
        notifyListeners();
      }
    } else {
      changes.clearHistory();
      changeStacks();
      notifyListeners();
    }
  }
}
