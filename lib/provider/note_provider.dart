import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:todoapp/provider/bottomnav_provider.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:undo/undo.dart';
import 'package:collection/collection.dart';

import 'noteimage_provider.dart';

// TODO orginaing the providers and having multi providres having a separate
// provider for check me .
// flutter_sound had a serious problem with the states
// and if more instances of that was made FlutterSoundPlayer's
// state for example the isPlaying instance was true for all
// even if Just one instance was playing
const stopped = 0;
const paused = 1;
const resumed = 2;
enum SoundPlayerState {
  stopped,
  paused,
  resumed,
}

class NoteProvider extends ChangeNotifier {
  // NoteProvider() {
  //   //checkDayChange();
  //   // setting the timer for only once
  //   Timer.periodic(Duration(seconds: 60), (timer) {
  //     // check for if the day is changed
  //     // if changed will handle the
  //     // check box uncheck duty for
  //     // new day .
  //     checkDayChange();
  //   });
  // }
  // This varrible is used to controll the listview size for the listview
  // to not to be short
  double listview_size;
  // used to control resetCheckBoxs
  bool resetCheckBoxs = false;
  void changeResetCheckBoxs(bool value) {
    resetCheckBoxs = value;
    notifyListeners();
  }

  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);
  //BuildContext donateContext;
  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);

  //////////////////////////////////// *** CHECKBOX CHECK PART *** /////////////////////////////////////
  final TextEditingController title = TextEditingController(text: '');
  final TextEditingController text = TextEditingController(text: '');
  // handeling changes to text textfield
  var changes = new ChangeStack();
  // The Time picker dialog controller
  Duration time_duration = Duration();
  Duration note_duration = Duration();
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
  BuildContext noteContext;
  // the index of the main stack and the floating stack
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
  Note bnote;
  // note color is used for reloading the color selection selected
  Color noteColor;
  Color colorSnapShot;
  int indexOfSelectedColor;
  //////////////////////////////////// *** IMAGELIST PART *** /////////////////////////////////////

  // This function is used inside the notes_editing_screen as
  // a future function to load the pictures
  Future<int> getNoteEditStack([List<int> keys, int index]) async {
    // if (keys?.isEmpty) {
    //   bnote = await noteBox.get(providerKeys[providerIndex]);
    // } else {
    //   bnote = await noteBox.get(keys[index]);
    // }
    // return bnote.leftTime;
    return time_duration.inSeconds;
  }

  Future<List<Voice>> getVoiceList() async {
    return voiceList;
  }

  //////////////////////////////////// *** TASK LIST  PART *** /////////////////////////////////////
  List<Task> taskList = [];
  // This is the controller assigned to the textfield inside
  // so the
  // List<TextEditingController> taskTextList = [];
  TaskController dissmissedTask;
  List<TaskController> taskControllerList = [];
  List<TaskController> taskControllerListSnapShot = [];
  Future<List<TaskController>> getTaskList() async {
    return taskControllerList;
  }

  void taskCheckBoxChanged(int index) {
    if (taskControllerList[index].isDone) {
      taskControllerList[index].isDone = false;
    } else {
      taskControllerList[index].isDone = true;
    }
    notifyListeners();
  }

  void checkListOnSubmit(index) {
    taskControllerList.insert(
        index + 1,
        TaskController(
            TextEditingController(text: ""),
            false,
            FocusNode(),
            PageStorageKey<String>(
                'pageKey ${DateTime.now().microsecondsSinceEpoch}')));
    taskControllerList[index + 1].focusNode.requestFocus();
    notifyListeners();
  }

  void taskDissmissed(int index) {
    dissmissedTask = taskControllerList.removeAt(index);
    notifyListeners();
  }

  void taskRecover(int index) {
    dissmissedTask.key = PageStorageKey<String>(
        'pageKey ${DateTime.now().microsecondsSinceEpoch}');
    taskControllerList.insert(index, dissmissedTask);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var taskController = taskControllerList.elementAt(oldIndex);
    if (newIndex < oldIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        var taskController2 = taskControllerList.elementAt(i - 1);
        taskControllerList[i] = taskController2;
        //taskControllerList.insert(i, );
      }
    } else {
      for (int i = oldIndex; i < newIndex; i++) {
        var taskController = taskControllerList.elementAt(i + 1);
        taskControllerList[i] = taskController;
        //taskControllerList.insert(i, taskController);
      }
    }
    taskControllerList[newIndex] = taskController;
    //taskControllerList.insert(newIndex, taskController);
    notifyListeners();
  }

  //////////////////////////////////// *** VOICE LIST PART *** /////////////////////////////////////
  // The voice note part
  List<Voice> voiceList = [];
  // Used to controll if the notes has been edited or not
  List<Voice> voiceListSnapshot = [];
  // This list is return to UI for details
  // Below varriable is used to show the recorded time in the UI
  Duration recorderDuration = Duration(seconds: 0);
  // If any of the voices has been dismissed  It wil be saved in this varrable
  Voice dismissedVoice;
  // A name for any recordiing that will be used
  String voiceName = 'tempraryFileName';
  // A new Instance of FlutterSoundRecorder for recording
  FlutterSoundRecorder flutterSoundRecorder = new FlutterSoundRecorder();
  // A new Instance of FlutterSoundPlayer for playing USED AS LIST
  List<FlutterSoundPlayer> flutterSoundPlayer =
      List.filled(100, FlutterSoundPlayer());
  // this varriable shows the progress of the voice
  List<Duration> voiceProgress = List.filled(100, Duration(seconds: 0));
  // This shows the total duration of the voice
  List<Duration> voiceDuration = List.filled(100, Duration(seconds: 0));
  // This is the periodical timer for incrementing the voiceProgress duration
  List<Timer> timer = List.filled(100, Timer(Duration(), () {}));
  // Used to control the playing voices
  List<SoundPlayerState> soundPlayerState =
      List.filled(100, SoundPlayerState.stopped);
  //                              *** RECORDER ***                              //
  Future<void> startRecorder(BuildContext context) async {
    PermissionStatus status = await Permission.microphone.request();
    if (status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.denied) {
      //throw RecordingPermissionException("Microphone permission not granted");
      uiKit.showAlertDialog(context, id: 'microphoneRequired');
      return;
    }
    // StreamSink<Food> _playerSubscription;
    // opening the session before starting the recorder is required .
    await flutterSoundRecorder.openAudioSession();
    // starting the recording session by adding the file name to
    await flutterSoundRecorder.startRecorder(
        toFile: voiceName, codec: Codec.defaultCodec);
    // This stream updates the recording duration
    StreamSubscription<RecordingDisposition> sub;
    sub = flutterSoundRecorder.onProgress.listen((event) async {
      if (event.duration > Duration(minutes: 58)) {
        sub.cancel();
        await stopRecorder();
      } else {
        recorderDuration = event.duration;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> pauseRecorder() async {
    await flutterSoundRecorder.pauseRecorder();
    notifyListeners();
  }

  Future<void> resumeRecorder() async {
    flutterSoundRecorder.resumeRecorder();
    notifyListeners();
  }

  Future<void> stopRecorder({BuildContext context}) async {
    // finishing up the recorded voice
    String path = await flutterSoundRecorder.stopRecorder();
    if (context != null) {
      await uiKit.showAlertDialog(context, id: 'voiceTitle');
    } else {
      voiceTitle = "Err:time";
    }
    // time to save the file with path inside the
    // datatbase as the Uint8List
    File file = File(path);
    var h = await file.readAsBytes();
    var v = Voice(
        (voiceTitle == null || voiceTitle == "") ? 'Unamed' : voiceTitle, h);
    voiceList.add(v);
    voiceTitle = null;
    // Time to delete the file to avoid space overflow
    flutterSoundRecorder.deleteRecord(fileName: voiceName);
    notifyListeners();
  }

  String voiceTitle;
  Future<void> setVoiceTitle(String title) {
    voiceTitle = title;
  }

  //                              *** PLAYER ***                              //
  Future<void> startPlayingRecorded(int index) async {
    await checkForPlayingPlayers();
    flutterSoundPlayer[index].openAudioSession();
    voiceDuration[index] = await flutterSoundPlayer[index]
        .startPlayer(fromDataBuffer: voiceList[index].voice);
    timerOn(index);
  }

  Future<void> checkForPlayingPlayers() async {
    var runningElement;
    var anyRunning = soundPlayerState.any((element) {
      if (element == SoundPlayerState.resumed) {
        runningElement = element;
        return true;
      } else {
        return false;
      }
    });
    if (anyRunning) {
      var index = soundPlayerState.indexOf(runningElement);
      pausePlayingRecorded(index);
    }
  }

  Future<void> timerOn(int index) async {
    soundPlayerState[index] = SoundPlayerState.resumed;
    timer[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (voiceProgress[index] >= voiceDuration[index]) {
        voiceProgress[index] = Duration(seconds: 0);
        timerOff(index);
        soundPlayerState[index] = SoundPlayerState.stopped;
        notifyListeners();
      } else {
        voiceProgress[index] = voiceProgress[index] + Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void timerOff(int index) {
    soundPlayerState[index] = SoundPlayerState.paused;
    if (timer[index] != null) {
      timer[index].cancel();
    }
    notifyListeners();
  }

  Future<void> resumePlayingRecorded(int index) async {
    await checkForPlayingPlayers();
    flutterSoundPlayer[index].resumePlayer();
    timerOn(index);
    notifyListeners();
  }

  Future<void> pausePlayingRecorded(int index) async {
    flutterSoundPlayer[index].pausePlayer();
    timerOff(index);
    notifyListeners();
  }

  void seekPlayingRecorder(double value, int index) async {
    if (soundPlayerState[index] == SoundPlayerState.paused ||
        soundPlayerState[index] == SoundPlayerState.stopped) {
      await startPlayingRecorded(index);
    }
    var duration = Duration(seconds: value.toInt());
    flutterSoundPlayer[index].seekToPlayer(duration);
    voiceProgress[index] = duration;
    notifyListeners();
  }

  void voiceDissmissed(index) {
    dismissedVoice = voiceList.removeAt(index);
    notifyListeners();
  }

  void voiceRecover(index) {
    voiceList.insert(index, dismissedVoice);
    notifyListeners();
  }

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
  void clearControllers() {
    final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    _noteImageProvider.clearImageList();
    title.clear();
    text.clear();
    voiceList.clear();
    taskControllerList.clear();
    taskList.clear();
    providerIndex = null;
    time_duration = Duration();
    note_duration = Duration();
    notifyListeners();
  }

  // getting the controller before the user enters the editing area
  // to detect the if any changes has been occured !
  void takeSnapshot() async {
    final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    ttitle = title.text;
    ttext = text.text;
    old_value = text.text;
    time_snapshot = note_duration;
    colorSnapShot = noteColor;
    begin_edit = false;
    if (!newNote) {
      _noteImageProvider.initialImageListSnapshot();
      voiceListSnapshot = List.from(voiceList);
      taskControllerList = List.from(taskControllerList);
    }
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    if (ttitle == title.text &&
        ttext == text.text &&
        time_duration == time_snapshot &&
        ListEquality().equals(_noteImageProvider.imageList,
            _noteImageProvider.imageListSnapshot) &&
        ListEquality().equals(voiceList, voiceListSnapshot) &&
        ListEquality().equals(taskControllerList, taskControllerListSnapShot)) {
      return false;
    } else {
      return true;
    }
  }

  // upodating the database when the check box is checked or unchecked
  void updateIsChecked(List<int> keys, int index) async {
    providerKeys = keys;
    providerIndex = index;

    var bnote = await noteBox.get(providerKeys[providerIndex]);
    var isChecked = bnote.isChecked;
    isChecked = !isChecked;
    var ntitle = bnote.title;
    var nttext = bnote.text;
    var nttime = bnote.time;
    var ntcolor = bnote.color;
    var ntlefttime = bnote.leftTime;
    var ntImageList = bnote.imageList;
    var ntVoiceList = bnote.voiceList;
    var ntTaskList = bnote.taskList;
    var ntResetCheckBoxs = bnote.resetCheckBoxs;
    Note note = Note(ntitle, nttext, isChecked, nttime, ntcolor, ntlefttime,
        ntImageList, ntVoiceList, ntTaskList, ntResetCheckBoxs);
    noteBox.put(providerKeys[providerIndex], note);
    //notifyListeners();
  }

  // new Note clieked
  void newNoteClicked(BuildContext context) {
    final _bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);
    noteContext = context;
    // When the add icon is tapped this function will be executed and
    // prepare the provider for the new Note
    clearControllers();
    taskControllerList.add(TaskController(TextEditingController(text: ""),
        false, FocusNode(), PageStorageKey<String>('pageKey 0')));
    newNote = true;
    _bottomNavProvider.initialSelectedTab();
    _bottomNavProvider.initialPage();
    resetCheckBoxs = false;
    _bottomNavProvider.initialTabs(context);
    takeSnapshot();
    notifyListeners();
  }

  // used indie list view after an elemt of listview is tapped
  void loadNote(BuildContext context, [List<int> keys, int index]) async {
    final _bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);

    noteContext = context;
    final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    providerKeys = keys;
    providerIndex = index;
    _bottomNavProvider.initialSelectedTab();

    // getting the pics form the database.
    var bnote = await noteBox.get(providerKeys[providerIndex]);
    // if the note doesnot include any notes pass
    if (bnote.imageList?.isNotEmpty ?? false) {
      _noteImageProvider.initialImageList(bnote.imageList);
    }
    if (bnote.voiceList?.isNotEmpty ?? false) {
      voiceList = bnote.voiceList;
    }
    if (bnote.taskList?.isNotEmpty ?? false) {
      taskList = bnote.taskList;
      for (int i = 0; i < taskList.length; i++) {
        taskControllerList.add(TaskController(
            TextEditingController(text: taskList[i].title),
            taskList[i].isDone,
            FocusNode(),
            PageStorageKey<String>(
                'pageKey ${DateTime.now().microsecondsSinceEpoch}')));
      }
      // clearing the taskList because
      // the needed information has been
      // obtained
      taskList.clear();
    } else {
      taskControllerList.add(TaskController(TextEditingController(text: ""),
          false, FocusNode(), PageStorageKey<String>('pageKey 0')));
    }
    resetCheckBoxs = bnote.resetCheckBoxs;
    title.text = bnote.title;
    text.text = bnote.text;
    ftext.requestFocus();
    text.selection =
        TextSelection.fromPosition(TextPosition(offset: text.text.length));
    time_duration = Duration(seconds: bnote.leftTime);
    note_duration = Duration(seconds: bnote.time);
    noteColor = Color(bnote.color);
    newNote = false;
    _bottomNavProvider.initialTabs(context);
    _bottomNavProvider.initialPage();
    notifyListeners();

    takeSnapshot();
  }

  //  Note editing tabs and colors managment

  void noteColorSelected(Color color) {
    noteColor = color;
    notifyListeners();
  }

  // getting the color that was choosen by the user
  void changeNoteColor(Color selectedColor, int index) {
    noteColor = selectedColor;
    indexOfSelectedColor = index;
    notifyListeners();
  }

  // executed when the user tapped on the check floating button (done icon FAB)
  void doneClicked(BuildContext context) async {
    noteContext = context;
    final _bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);
          final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    // checking whether your going to update the note or add new one
    // that is done by chekcing the newNote true or false
    if (newNote) {
      // One of the title or text fields must be filled for the new Note

      if (text.text.isEmpty &&
          title.text.isEmpty &&
          taskControllerList[0].textEditingController.text == "" &&
          _noteImageProvider.imageList.isEmpty &&
          voiceList.isEmpty &&
          note_duration == Duration()) {
        if (notSaving == 0) {
          ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
            // TODO making better the emptyFieldAlert to title and text must not be null
            uiKit.AppLocalizations.of(noteContext)
                .translate('emptyFieldsAlert'),
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
          changes.clearHistory();
          clearControllers();
        }
      } else {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        final String noteText = text.text;
        final int noteTime = note_duration.inSeconds;
        int leftTime = noteTime;
        var color = noteColor?.value ?? _bottomNavProvider.tabColors[0].value;
        if (taskControllerList.isNotEmpty) {
          for (int i = 0; i < taskControllerList.length; i++) {
            if (taskControllerList[i].textEditingController.text != '') {
              taskList.add(Task(
                  taskControllerList[i].textEditingController.text,
                  taskControllerList[i].isDone));
            }
          }
        }
        Note note = Note(
          noteTitle,
          noteText,
          false,
          noteTime,
          color,
          leftTime,
          _noteImageProvider.imageList,
          voiceList,
          taskList,
          resetCheckBoxs,
        );
        await noteBox.add(note);
        changes.clearHistory();
        clearControllers();
        notifyListeners();
        Navigator.pop(noteContext);
      }
    } else {
      // One of the title or text fields must be filled
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        var bnote = await noteBox.get(providerKeys[providerIndex]);
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        var color = noteColor?.value ?? _bottomNavProvider.tabColors[0].value;
        if (taskControllerList.isNotEmpty) {
          for (int i = 0; i < taskControllerList.length; i++) {
            if (taskControllerList[i].textEditingController.text != '') {
              taskList.add(Task(
                  taskControllerList[i].textEditingController.text,
                  taskControllerList[i].isDone));
            }
          }
        }
        Note note = new Note(
            noteTitle,
            text.text,
            bnote.isChecked,
            note_duration.inSeconds,
            color,
            bnote.leftTime,
            _noteImageProvider.imageList,
            voiceList,
            taskList,
            resetCheckBoxs);
        await noteBox.put(providerKeys[providerIndex], note);
        changes.clearHistory();
        clearControllers();
        Navigator.pop(noteContext);
      } else {
        await noteBox.delete(providerKeys[providerIndex]);
        changes.clearHistory();
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
        final _noteImageProvider =
        Provider.of<NoteImageProvider>(noteContext, listen: false);
    if (isEdited()) {
      if (text.text.isEmpty &&
          title.text.isEmpty &&
          taskControllerList[0].textEditingController.text == "" &&
          _noteImageProvider.imageList.isEmpty &&
          voiceList.isEmpty &&
          note_duration == Duration()) {
        ScaffoldMessenger.of(noteContext).clearSnackBars();
        ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(noteContext).translate('willingToDelete'),
            'willingToDelete',
            false,
            context: noteContext));
        Navigator.pop(noteContext);
        clearControllers();
      } else {
        if (notSaving == 0) {
          ScaffoldMessenger.of(noteContext).clearSnackBars();
          ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
              uiKit.AppLocalizations.of(noteContext)
                  .translate('notSavingAlert'),
              'notSavingAlert',
              false,
              context: noteContext));
          notSaving = notSaving + 1;
          Future.delayed(Duration(seconds: 10), () {
            notSaving = 0;
          });
        } else {
          notSaving = 0;
          Navigator.pop(noteContext);
          changes.clearHistory();
          clearControllers();
        }
      }
    } else {
      // making all the changes that has been save for the
      // future undo will be deleted to prevent the future problem
      // causes !
      changes.clearHistory();
      // changing the stacks and getting back to listview Screen !
      clearControllers();
      Navigator.pop(noteContext);
    }
  }

  // This function  is used to handle the changes that has been
  // occured to the time picker !
  Duration saved_duration = Duration();
  Duration saved_note_duration = Duration();
  void saveDuration() {
    saved_duration = time_duration;
    saved_note_duration = note_duration;
  }

  void timerDurationChange(duration) {
    // updating the state and notifiung the listeners

    time_duration = duration;
    note_duration = duration;

    // notifyListeners();
  }

  void updateDuration(int leftTime) {
    time_duration = Duration(seconds: leftTime);
  }

  void timerDone() async {
    if (note_duration != time_snapshot) {
      // timer has been updated so that
      // We must update the left time too
      if (!newNote) {
        var bnote = await noteBox.get(providerKeys[providerIndex]);
        var ntitle = bnote.title;
        var nttext = bnote.text;
        var ntischecked = bnote.isChecked;
        var nttime = note_duration.inSeconds;
        var ntcolor = bnote.color;
        var ntlefttime = note_duration.inSeconds;
        var ntImageList = bnote.imageList;
        var ntVoiceList = bnote.voiceList;
        var ntTaskList = bnote.taskList;
        var ntResetCheckBoxs = bnote.resetCheckBoxs;
        Note note = Note(ntitle, nttext, ntischecked, nttime, ntcolor,
            ntlefttime, ntImageList, ntVoiceList, ntTaskList, resetCheckBoxs);
        noteBox.put(providerKeys[providerIndex], note);
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }

  showDogeCopied(BuildContext context) {
    noteContext = context;
    ScaffoldMessenger.of(noteContext).clearSnackBars();
    ScaffoldMessenger.of(noteContext).removeCurrentSnackBar();
    ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
        uiKit.AppLocalizations.of(noteContext).translate('dogeAddressCopied'),
        'dogeAddressCopied',
        false,
        context: noteContext));
  }

  Future<void> reorderList(int oldIndex, int newIndex) async {
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

  List<Note> noteList = [];
  Future<bool> updateListSize(List<int> keys, SizeX, SizeY) async {
    int with_timer = 0;
    int without_timer = 0;

    for (int i = 0; i < keys.length; i++) {
      var bnote = await noteBox.get(keys[i]);
      noteList.add(bnote);
      if (bnote.time == 0) {
        without_timer = without_timer + 1;
      } else {
        without_timer = without_timer + 1;
      }
    }
    listview_size = (without_timer * SizeX * 0.22) + (with_timer * SizeX * 0.5);
    return true;
  }


}
