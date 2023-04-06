import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:provider/provider.dart';
import '../../../applocalizations.dart';
import '../../../widgets/dialog.dart';

class NoteVoiceRecorderProvider with ChangeNotifier {
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
  BuildContext voiceContext;
  Future<void> startRecorder(BuildContext context) async {
    voiceContext = context;
    PermissionStatus status = await Permission.microphone.request();
    if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.denied) {
      //throw RecordingPermissionException("Microphone permission not granted");
      showAlertDialog(voiceContext,
          title: AppLocalizations.of(context).translate('microphoneRequired'),
          cancelButtonText: AppLocalizations.of(context).translate('cancel'),
          okButtonText: AppLocalizations.of(context).translate('ok'));
      return;
    }
    // StreamSink<Food> _playerSubscription;
    // opening the session before starting the recorder is required .
    await flutterSoundRecorder.openAudioSession();
    // starting the recording session by adding the file name to
    await flutterSoundRecorder.startRecorder(toFile: voiceName, codec: Codec.defaultCodec);
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

  void clearVoiceList() {
    voiceList.clear();
  }

  void initialVoiceList(List<Voice> givenVoiceList) {
    voiceList = givenVoiceList;
  }

  void initialVoiceListSnapshot() {
    voiceListSnapshot = List.from(voiceList);
  }

  void stopRecorder() async {
    // finishing up the recorded voice
    String path = await flutterSoundRecorder.stopRecorder();
    final _noteVoiceRecorderProvider = Provider.of<NoteVoiceRecorderProvider>(Get.overlayContext, listen: false);
    TextEditingController dialogController = TextEditingController(text: '');
    await showAlertDialog(Get.overlayContext,
        title: AppLocalizations.of(Get.overlayContext).translate('voiceTitle'),
        hastTextField: true,
        textFieldhintText: AppLocalizations.of(Get.overlayContext).translate('titleHint'),
        okButtonText: AppLocalizations.of(Get.overlayContext).translate('ok'),
        cancelButtonText: AppLocalizations.of(Get.overlayContext).translate('cancel'), okButtonFunction: () {
      _noteVoiceRecorderProvider.setVoiceTitle(dialogController.text);
    });

    // time to save the file with path inside the
    // datatbase as the Uint8List
    File file = File(path);
    var h = await file.readAsBytes();
    var v = Voice((voiceTitle == null || voiceTitle == "") ? 'Unamed' : voiceTitle, h);
    voiceList.add(v);
    voiceTitle = null;
    // Time to delete the file to avoid space overflow
    flutterSoundRecorder.deleteRecord(fileName: voiceName);
    notifyListeners();
  }

  String voiceTitle;
  void setVoiceTitle(String title) {
    voiceTitle = title;
  }

  void voiceDismissed(index) {
    dismissedVoice = voiceList.removeAt(index);
    notifyListeners();
  }

  void voiceRecover(index) {
    voiceList.insert(index, dismissedVoice);
    notifyListeners();
  }

  Future<List<Voice>> getVoiceList() async {
    return voiceList;
  }
}
