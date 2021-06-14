import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/voice_model.dart';
import '../main.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:undo/undo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

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
  NoteProvider() {
    //checkDayChange();
    // setting the timer for only once
    Timer.periodic(Duration(seconds: 60), (timer) {
      // check for if the day is changed
      // if changed will handle the
      // check box uncheck duty for
      // new day .
      checkDayChange();
    });
  }
  // This varrible is used to controll the listview size for the listview
  // to not to be short
  double listview_size;
  // It is used to store
  // the theme status as string
  final prefsBox = Hive.box<String>(prefsBoxName);
  //BuildContext donateContext;
  // Hive box for notes
  final noteBox = Hive.lazyBox<Note>(noteBoxName);
  //////////////////////////////////// *** CHECKBOX CHECK PART *** /////////////////////////////////////
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
            var ntitle = bnote.title;
            var nttext = bnote.text;
            var nttime = bnote.time;
            var ntcolor = bnote.color;
            var ntlefttime = bnote.leftTime;
            var ntImageList = bnote.imageList;
            var ntVoiceList = bnote.voiceList;
            Note note = Note(ntitle, nttext, false, nttime, ntcolor, ntlefttime,
                ntImageList, ntVoiceList);
            noteBox.putAt(i, note);
          }
          prefsBox.put('date',
              "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
        }
      }
    } else {
      prefsBox.put('date',
          "${DateTime.now().year},${DateTime.now().month},${DateTime.now().day}");
    }
    notifyListeners();
  }

  //////////////////////////////////// *** CHECKBOX CHECK PART *** /////////////////////////////////////
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
  int indexOfSelectedColor;
  //////////////////////////////////// *** IMAGELIST PART *** /////////////////////////////////////
  // list of images that will be loaded on user tap
  List<Uint8List> imageList = [];
  List<Uint8List> imageListSnapshot = [];
  Uint8List dismissedImage;
  // used for both loading images and taking images
  final picker = ImagePicker();
  PickedFile _image;
  // Show the image picker dilog
  Future<void> imagePickerGalley() async {
    _image = await picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      var h = await _image.readAsBytes();
      var fileSize = h.lengthInBytes;
      if (fileSize > 300000) {
        if (fileSize < 5000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 60,
          );
        } else if (fileSize < 10000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 50,
          );
        } else if (fileSize < 15000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 40,
          );
        } else {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 30,
          );
        }
      }
      imageList.add(h);
    }
    notifyListeners();
  }

  Future<void> imagePickerCamera() async {
    _image = await picker.getImage(source: ImageSource.camera);
    if (_image != null) {
      var h = await _image.readAsBytes();
      var fileSize = h.lengthInBytes;
      if (fileSize > 300000) {
        if (fileSize < 5000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 60,
          );
        } else if (fileSize < 10000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 50,
          );
        } else if (fileSize < 15000000) {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 40,
          );
        } else {
          h = await FlutterImageCompress.compressWithList(
            h,
            quality: 30,
          );
        }
      }
      imageList.add(h);
    }
    notifyListeners();
  }

  void imageDissmissed(index) {
    dismissedImage = imageList.removeAt(index);
  }

  void imageRecover(index) {
    imageList.insert(index, dismissedImage);
    notifyListeners();
  }

  void rotateImage(Uint8List image, int index) {
    imageList[index] = image;
    notifyListeners();
  }

  Future<Note> getNoteListView(
      List<int> keys, int index, double SizeX, double SizeY) async {
    var note = await noteBox.get(keys[index]);
    var bnote = Note(note.title, note.text, note.isChecked, note.time,
        note.color, note.leftTime, null, null);
    updateListSize(keys, SizeX, SizeY);
    return bnote;
  }

  Future<List<Uint8List>> getImageList() async {
    //myContext = context;
    if (newNote) {
      return imageList;
    } else {
      var note = await noteBox.get(providerKeys[providerIndex]);
      return imageList;
    }
  }

  // This function is used inside the notes_editing_screen as
  // a future function to load the pictures
  Future<Note> getNoteEditStack([List<int> keys, int index]) async {
    if (keys?.isEmpty) {
      bnote = await noteBox.get(providerKeys[providerIndex]);
    } else {
      bnote = await noteBox.get(keys[index]);
    }
    return bnote;
  }

  Future<List<Voice>> getVoiceList() async {
    return voiceList;
  }

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
    if (status == PermissionStatus.permanentlyDenied  || status == PermissionStatus.denied ) {
      //throw RecordingPermissionException("Microphone permission not granted");
      uiKit.showAlertDialog(context, 'microphoneRequired');
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
      await uiKit.showAlertDialog(context, 'voiceTitle');
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
      print(' hh $index');
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
    //print('object $');
    flutterSoundPlayer[index].seekToPlayer(duration);
    voiceProgress[index] = duration;
    notifyListeners();
  }

  void voiceDissmissed(index) {
    dismissedVoice = voiceList.removeAt(index);
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
    imageList.clear();
    title.clear();
    text.clear();
    voiceList.clear();
    time_duration = Duration();
    notifyListeners();
  }

  // getting the controller before the user enters the editing area
  // to detect the if any changes has been occured !
  void takeSnapshot() async {
    ttitle = title.text;
    ttext = text.text;
    old_value = text.text;
    time_snapshot = time_duration;
    begin_edit = false;
    if (!newNote) {
      imageListSnapshot = List.from(imageList);
      voiceListSnapshot = List.from(voiceList);
    }
  }

  // checks the snapsht that has been edited or not
  bool isEdited() {
    // print('imageList : ${imageList}');
    // print('imageListSnapshot : ${imageListSnapshot}');
    if (ttitle == title.text &&
        ttext == text.text &&
        time_duration == time_snapshot &&
        ListEquality().equals(imageList, imageListSnapshot) &&
        ListEquality().equals(voiceList, voiceListSnapshot)) {
      return false;
    } else {
      return true;
    }
  }

  // upodating the database when the check box is checked or unchecked
  void updateIsChecked(bool newValue, List<int> keys, int index) async {
    providerKeys = keys;
    providerIndex = index;
    var bnote = await noteBox.get(providerKeys[providerIndex]);
    var ntitle = bnote.title;
    var nttext = bnote.text;
    var nttime = bnote.time;
    var ntcolor = bnote.color;
    var ntlefttime = bnote.leftTime;
    var ntImageList = bnote.imageList;
    var ntVoiceList = bnote.voiceList;
    Note note = Note(ntitle, nttext, newValue, nttime, ntcolor, ntlefttime,
        ntImageList, ntVoiceList);
    noteBox.put(providerKeys[providerIndex], note);
    //notifyListeners();
  }

  // new Note clieked
  Future<void> newNoteClicked(BuildContext context) {
    noteContext = context;
    // When the add icon is tapped this function will be executed and
    // prepare the provider for the new Note
    clearControllers();
    newNote = true;
    takeSnapshot();
    //notifyListeners();
  }

  // used indie list view after an elemt of listview is tapped
  void loadNote(BuildContext context, [List<int> keys, int index]) async {
    noteContext = context;
    providerKeys = keys;
    providerIndex = index;
    clearControllers();
    // getting the pics form the database.
    var bnote = await noteBox.get(providerKeys[providerIndex]);
    // if the note doesnot include any notes pass
    if (bnote.imageList?.isNotEmpty ?? false) {
      imageList = bnote.imageList;
      print('object');
    }
    if (bnote.imageList?.isNotEmpty ?? false) {
      voiceList = bnote.voiceList;
    }
    title.text = bnote.title;
    text.text = bnote.text;
    ftext.requestFocus();
    text.selection =
        TextSelection.fromPosition(TextPosition(offset: text.text.length));
    time_duration = Duration(seconds: bnote.time);
    noteColor = Color(bnote.color);
    newNote = false;
    notifyListeners();
    takeSnapshot();
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
    // checking whether your going to update the note or add new one
    // that is done by chekcing the newNote true or false
    if (newNote) {
      // One of the title or text fields must be filled for the new Note
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        final String noteText = text.text;
        final int noteTime = time_duration.inSeconds;
        int leftTime = noteTime;
        Note note = Note(noteTitle, noteText, false, noteTime, 0, leftTime,
            imageList, voiceList);
        await noteBox.add(note);
        changes.clearHistory();
        Navigator.pop(noteContext);
      } else {
        ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
          // TODO making better the emptyFieldAlert to title and text must not be null
          uiKit.AppLocalizations.of(noteContext).translate('emptyFieldsAlert'),
          'emptyFieldsAlert',
          false,
          noteContext,
        ));
      }
      // TODO find out why this is here
      clearControllers();
    } else {
      // One of the title or text fields must be filled
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        var bnote = await noteBox.get(providerKeys[providerIndex]);
        String noteTitle;
        title.text.isEmpty ? noteTitle = "Unamed" : noteTitle = title.text;
        Note note = new Note(noteTitle, text.text, bnote.isChecked,
            time_duration.inSeconds, 0, bnote.leftTime, imageList, voiceList);
        await noteBox.put(providerKeys[providerIndex], note);
        changes.clearHistory();
        Navigator.pop(noteContext);
      } else {
        await noteBox.delete(providerKeys[providerIndex]);
        changes.clearHistory();
        Navigator.pop(noteContext);
      }
    }
  }

  // When the clear Icon clicked or back button is tapped
  // this fucntion will be executed checking for changes
  // if the changes has been made it is going to show an alert
  void cancelClicked(BuildContext context) {
    noteContext = context;
    if (isEdited()) {
      if (text.text.isNotEmpty || title.text.isNotEmpty) {
        if (notSaving == 0) {
          ScaffoldMessenger.of(noteContext).clearSnackBars();
          ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
              uiKit.AppLocalizations.of(noteContext)
                  .translate('notSavingAlert'),
              'notSavingAlert',
              false,
              noteContext));
          notSaving = notSaving + 1;
          Future.delayed(Duration(seconds: 10), () {
            notSaving = 0;
          });
        } else {
          notSaving = 0;
          Navigator.pop(noteContext);
          changes.clearHistory();
        }
      } else {
        ScaffoldMessenger.of(noteContext).clearSnackBars();
        ScaffoldMessenger.of(noteContext).showSnackBar(uiKit.MySnackBar(
            uiKit.AppLocalizations.of(noteContext).translate('willingToDelete'),
            'willingToDelete',
            false,
            noteContext));
        Navigator.pop(noteContext);
      }
    } else {
      // making all the changes that has been save for the
      // future undo will be deleted to prevent the future problem
      // causes !
      changes.clearHistory();
      // changing the stacks and getting back to listview Screen !
      Navigator.pop(noteContext);
    }
  }

  // This function  is used to handle the changes that has been
  // occured to the time picker !
  void timerDurationChange(duration) {
    // updating the state and notifiung the listeners
    time_duration = duration;
    // notifyListeners();
  }

  void timerDone() async {
    if (time_duration != time_snapshot) {
      // timer has been updated so that
      // We must update the left time too
      var bnote = await noteBox.get(providerKeys[providerIndex]);
      var ntitle = bnote.title;
      var nttext = bnote.text;
      var ntischecked = bnote.isChecked;
      var nttime = time_duration.inSeconds;
      var ntcolor = bnote.color;
      var ntlefttime = time_duration.inSeconds;
      var ntImageList = bnote.imageList;
      var ntVoiceList = bnote.voiceList;
      Note note = Note(ntitle, nttext, ntischecked, nttime, ntcolor, ntlefttime,
          ntImageList, ntVoiceList);
      noteBox.put(providerKeys[providerIndex], note);
      notifyListeners();
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
        noteContext));
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
    listview_size = (without_timer * SizeX * 0.22) + (with_timer * SizeX * 0.5);
    return true;
  }
}
