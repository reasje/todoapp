import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/app/note_screen/logic/bottomnav_provider.dart';
import 'package:todoapp/app/note_screen/logic/notecolor_logic.dart';
import 'package:todoapp/app/note_screen/logic/notepassword_logic.dart';
import 'package:todoapp/app/note_screen/logic/notetitletext_logic.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_logic.dart';
import '../../../applocalizations.dart';
import '../../../main.dart';

import 'package:collection/collection.dart';
import '../../../widgets/snackbar.dart';
import 'noteimage_logic.dart';
import 'notetask_logic.dart';

class NoteProvider extends ChangeNotifier {
  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);

  //BuildContext donateContext;
  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  // this is used for showing the SnackBar
  BuildContext noteContext;

  // the index of the main stack and the floating stack
  // to press the back button twice for getting back to the notes list ! without saving
  int notSaving = 0;

  // used to save the keys in provider
  List<int> providerKeys;

  int providerIndex;

  bool newNote;

  Note bnote;

  // for the clear the form
  void clearControllers() {
    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    final _noteColorLogic = Get.find<NoteColorLogic>();

    _noteImageLogic.clearImageList();

    _notePasswordLogic.clearPassword();

    _noteTitleTextLogic.clearTitle();

    _noteTitleTextLogic.clearText();

    _noteVoiceRecorderLogic.clearVoiceList();

    _noteTaskLogic.clearTaskList();

    _noteTaskLogic.clearTaskControllerList();

    providerIndex = null;

    _noteColorLogic.clearNoteColor();

    notifyListeners();
  }

  // getting the controller before the user enters the editing area
  // to detect the if any changes has been occured !
  void takeSnapshot() async {
    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    final _noteColorLogic = Get.find<NoteColorLogic>();

    _noteTitleTextLogic.state.titleSnapShot = _noteTitleTextLogic.state.titleController.text;

    _noteTitleTextLogic.state.textSnapShot = _noteTitleTextLogic.state.textController.text;

    _noteTitleTextLogic.state.textOldValue = _noteTitleTextLogic.state.textController.text;

    _noteColorLogic.state.colorSnapShot = _noteColorLogic.state.noteColor;

    _noteTitleTextLogic.state.beginEdit = false;

    _notePasswordLogic.state.passwordSnapShot = _notePasswordLogic.state.password;

    if (!newNote) {
      _noteImageLogic.initialImageListSnapshot();

      _noteVoiceRecorderLogic.initialVoiceListSnapshot();

      _noteTaskLogic.initialTaskControllerList();
    }
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    if (_notePasswordLogic.state.password == _notePasswordLogic.state.passwordSnapShot &&
        _noteTitleTextLogic.state.titleSnapShot == _noteTitleTextLogic.state.titleController.text &&
        _noteTitleTextLogic.state.textSnapShot == _noteTitleTextLogic.state.textController.text &&
        ListEquality().equals(_noteImageLogic.state.imageList, _noteImageLogic.state.imageListSnapshot) &&
        ListEquality().equals(_noteVoiceRecorderLogic.state.voiceList, _noteVoiceRecorderLogic.state.voiceListSnapshot) &&
        ListEquality().equals(_noteTaskLogic.state.taskControllerList, _noteTaskLogic.state.taskControllerListSnapShot)) {
      return false;
    } else {
      return true;
    }
  }

  // updating the database when the check box is checked or unchecked
  void updateIsChecked(List<int> keys, int index) async {
    providerKeys = keys;

    providerIndex = index;

    var bnote = await noteBox.get(providerKeys[providerIndex]);

    var isChecked = bnote.isChecked;

    isChecked = !isChecked;

    var noteTitle = bnote.title;

    var noteText = bnote.text;

    var noteColor = bnote.color;

    var ntImageList = bnote.imageList;

    var ntVoiceList = bnote.voiceList;

    var ntTaskList = bnote.taskList;

    var ntResetCheckBoxs = bnote.resetCheckBoxs;

    var ntPassword = bnote.password;

    Note note = Note(noteTitle, noteText, isChecked, noteColor, ntImageList, ntVoiceList, ntTaskList, ntResetCheckBoxs, ntPassword);

    noteBox.put(providerKeys[providerIndex], note);

    //notifyListeners();
  }

  // new Note clieked
  Future newNoteClicked(BuildContext context) async {
    final _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);

    final _noteTaskLogic = Provider.of<NoteTaskLogic>(context, listen: false);

    noteContext = context;
    // When the add icon is tapped this function will be executed and
    // prepare the provider for the new Note

    clearControllers();

    _noteTaskLogic.state
      ..taskControllerList.add(TaskController(TextEditingController(text: ""), false, FocusNode(), PageStorageKey<String>('pageKey 0')));

    newNote = true;

    _bottomNavProvider.initialSelectedTab();

    _bottomNavProvider.initialPage();

    _noteTaskLogic.resetCheckBoxs = false;

    await _bottomNavProvider.initialTabs(context);

    takeSnapshot();

    notifyListeners();

    return true;
  }

  // used indie list view after an elemt of listview is tapped
  Future<void> loadNote(BuildContext context, [List<int> keys, int index]) async {
    noteContext = context;

    providerKeys = keys;

    providerIndex = index;

    final _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);

    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    final _noteColorLogic = Get.find<NoteColorLogic>();

    _bottomNavProvider.initialSelectedTab();

    // getting the pics form the database.
    var bnote = await noteBox.get(providerKeys[providerIndex]);

    // if the note doesnot include any notes pass
    if (bnote.imageList?.isNotEmpty ?? false) {
      _noteImageLogic.initialImageList(bnote.imageList);
    }

    if (bnote.voiceList?.isNotEmpty ?? false) {
      _noteVoiceRecorderLogic.initialVoiceList(bnote.voiceList);
    }

    if (bnote.taskList?.isNotEmpty ?? false) {
      _noteTaskLogic.initialTaskList(bnote.taskList);

      for (int i = 0; i < _noteTaskLogic.state.taskList.length; i++) {
        _noteTaskLogic.state.taskControllerList.add(TaskController(TextEditingController(text: _noteTaskLogic.state.taskList[i].title),
            _noteTaskLogic.state.taskList[i].isDone, FocusNode(), PageStorageKey<String>('pageKey ${DateTime.now().microsecondsSinceEpoch}')));
      }

      // clearing the taskList because
      // the needed information has been
      // obtained
      _noteTaskLogic.clearTaskList();
    } else {
      _noteTaskLogic.state.taskControllerList
          .add(TaskController(TextEditingController(text: ""), false, FocusNode(), PageStorageKey<String>('pageKey 0')));
    }

    _noteTaskLogic.resetCheckBoxs = bnote.resetCheckBoxs;

    _noteTitleTextLogic.state.titleController.text = bnote.title;

    _noteTitleTextLogic.state.textController.text = bnote.text;

    _noteTitleTextLogic.state.textFocusNode.requestFocus();

    // saving password
    _notePasswordLogic.state.password = bnote.password;

    _noteTitleTextLogic.state.textController.selection =
        TextSelection.fromPosition(TextPosition(offset: _noteTitleTextLogic.state.textController.text.length));

    _noteColorLogic.initialNoteColor(Color(bnote.color));

    newNote = false;

    await _bottomNavProvider.initialTabs(context);

    _bottomNavProvider.initialPage();

    notifyListeners();

    takeSnapshot();
  }

  // executed when the user tapped on the check floating button (done icon FAB)
  void doneClicked(BuildContext context) async {
    noteContext = context;

    final _bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);

    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    final _noteColorLogic = Get.find<NoteColorLogic>();

    // checking whether your going to update the note or add new one
    // that is done by chekcing the newNote true or false
    if (newNote) {
      // One of the title or text fields must be filled for the new Note

      if (_noteTitleTextLogic.state.textController.text.isEmpty &&
          _noteTitleTextLogic.state.titleController.text.isEmpty &&
          _noteTaskLogic.state.taskControllerList[0].textEditingController.text == "" &&
          _noteImageLogic.state.imageList.isEmpty &&
          _noteVoiceRecorderLogic.state.voiceList.isEmpty &&
          _notePasswordLogic.state.password == '') {
        if (notSaving == 0) {
          ScaffoldMessenger.of(noteContext).showSnackBar(MySnackBar(
            // TODO making better the emptyFieldAlert to title and text must not be null
            AppLocalizations.of(noteContext).translate('emptyFieldsAlert'),
            'emptyFieldsAlert',
            false,
            context: noteContext,
          ));
          notSaving = notSaving + 1;
          Future.delayed(Duration(seconds: 10), () {
            notSaving = 0;
          });
        } else {
          notSaving = 0;
          Navigator.pop(noteContext);
          _noteTitleTextLogic.state.changes.clearHistory();
          clearControllers();
        }
      } else {
        String noteTitle;

        _noteTitleTextLogic.state.titleController.text.isEmpty ? noteTitle = "Unamed" : noteTitle = _noteTitleTextLogic.state.titleController.text;

        var noteText = _noteTitleTextLogic.state.textController.text;

        print("_noteColorLogic.noteColor? ${_noteColorLogic.state.noteColor}");
        var color = _noteColorLogic.state.noteColor.value;

        var password = _notePasswordLogic.state.password;

        if (_noteTaskLogic.state.taskControllerList.isNotEmpty) {
          for (int i = 0; i < _noteTaskLogic.state.taskControllerList.length; i++) {
            if (_noteTaskLogic.state.taskControllerList[i].textEditingController.text != '') {
              _noteTaskLogic.state.taskList.add(
                  Task(_noteTaskLogic.state.taskControllerList[i].textEditingController.text, _noteTaskLogic.state.taskControllerList[i].isDone));
            }
          }
        }
        Note note = Note(noteTitle, noteText, false, color, _noteImageLogic.state.imageList, _noteVoiceRecorderLogic.state.voiceList,
            _noteTaskLogic.state.taskList, _noteTaskLogic.resetCheckBoxs, password);
        await noteBox.add(note);
        _noteTitleTextLogic.state.changes.clearHistory();
        clearControllers();
        notifyListeners();
        Navigator.pop(noteContext);
      }
    } else {
      // One of the title or text fields must be filled
      if (_noteTitleTextLogic.state.textController.text.isNotEmpty || _noteTitleTextLogic.state.titleController.text.isNotEmpty) {
        var bnote = await noteBox.get(providerKeys[providerIndex]);

        var noteTitle;

        _noteTitleTextLogic.state.titleController.text.isEmpty ? noteTitle = "Unamed" : noteTitle = _noteTitleTextLogic.state.titleController.text;

        var color = _noteColorLogic.state.noteColor.value;

        var password = _notePasswordLogic.state.password;

        if (_noteTaskLogic.state.taskControllerList.isNotEmpty) {
          for (int i = 0; i < _noteTaskLogic.state.taskControllerList.length; i++) {
            if (_noteTaskLogic.state.taskControllerList[i].textEditingController.text != '') {
              _noteTaskLogic.state.taskList.add(
                  Task(_noteTaskLogic.state.taskControllerList[i].textEditingController.text, _noteTaskLogic.state.taskControllerList[i].isDone));
            }
          }
        }
        Note note = new Note(noteTitle, _noteTitleTextLogic.state.textController.text, bnote.isChecked, color, _noteImageLogic.state.imageList,
            _noteVoiceRecorderLogic.state.voiceList, _noteTaskLogic.state.taskList, _noteTaskLogic.resetCheckBoxs, password);

        await noteBox.put(providerKeys[providerIndex], note);

        _noteTitleTextLogic.state.changes.clearHistory();

        clearControllers();

        Navigator.pop(noteContext);
      } else {
        await noteBox.delete(providerKeys[providerIndex]);

        _noteTitleTextLogic.state.changes.clearHistory();

        clearControllers();

        Navigator.pop(noteContext);
      }
    }
  }

  // When the clear Icon clicked or back button is tapped
  // this fucntion will be executed checking for changes
  // if the changes has been made it is going to show an alert
  void cancelClicked(BuildContext context) {
    noteContext = context;

    final _notePasswordLogic = Get.find<NotePasswordLogic>();

    final _noteImageLogic = Get.find<NoteImageLogic>();

    final _noteVoiceRecorderLogic = Get.find<NoteVoiceRecorderLogic>();

    final _noteTaskLogic = Get.find<NoteTaskLogic>();

    final _noteTitleTextLogic = Get.find<NoteTitleTextLogic>();

    if (isEdited()) {
      if (_noteTitleTextLogic.state.textController.text.isEmpty &&
          _noteTitleTextLogic.state.titleController.text.isEmpty &&
          _noteTaskLogic.state.taskControllerList[0].textEditingController.text == "" &&
          _noteImageLogic.state.imageList.isEmpty &&
          _noteVoiceRecorderLogic.state.voiceList.isEmpty &&
          _notePasswordLogic.state.password == '') {
        ScaffoldMessenger.of(noteContext).clearSnackBars();

        ScaffoldMessenger.of(noteContext)
            .showSnackBar(MySnackBar(AppLocalizations.of(noteContext).translate('willingToDelete'), 'willingToDelete', false, context: noteContext));

        Navigator.pop(noteContext);

        clearControllers();
      } else {
        if (notSaving == 0) {
          ScaffoldMessenger.of(noteContext).clearSnackBars();

          ScaffoldMessenger.of(noteContext)
              .showSnackBar(MySnackBar(AppLocalizations.of(noteContext).translate('notSavingAlert'), 'notSavingAlert', false, context: noteContext));

          notSaving = notSaving + 1;

          Future.delayed(Duration(seconds: 10), () {
            notSaving = 0;
          });
        } else {
          notSaving = 0;

          Navigator.pop(noteContext);

          _noteTitleTextLogic.state.changes.clearHistory();

          clearControllers();
        }
      }
    } else {
      // making all the changes that has been save for the
      // future undo will be deleted to prevent the future problem
      // causes !

      _noteTitleTextLogic.state.changes.clearHistory();

      // changing the stacks and getting back to listview Screen !
      clearControllers();

      Navigator.pop(noteContext);
    }
  }
}
