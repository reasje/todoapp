import 'dart:async';
import 'dart:io';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:provider/provider.dart';
import '../../../applocalizations.dart';
import '../../../widgets/dialog.dart';
import '../state/note_voice_recorder_state.dart';

class NoteVoiceRecorderLogic with ChangeNotifier {
  NoteVoiceRecorderState state = NoteVoiceRecorderState();

  Future<void> startRecorder(BuildContext context) async {
    PermissionStatus status = await Permission.microphone.request();
    if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.denied) {
      //throw RecordingPermissionException("Microphone permission not granted");
      showAlertDialog(Get.overlayContext,
          title:  locale.microphoneRequired.tr,
          cancelButtonText:  locale.cancel.tr,
          okButtonText:  locale.ok.tr);
      return;
    }
    // StreamSink<Food> _playerSubscription;
    // opening the session before starting the recorder is required .
    await state.flutterSoundRecorder.openAudioSession();
    // starting the recording session by adding the file name to
    await state.flutterSoundRecorder.startRecorder(toFile: state.voiceName, codec: Codec.defaultCodec);
    // This stream updates the recording duration
    StreamSubscription<RecordingDisposition> sub;
    sub = state.flutterSoundRecorder.onProgress.listen((event) async {
      if (event.duration > Duration(minutes: 58)) {
        sub.cancel();
        await stopRecorder();
      } else {
        state.recorderDuration = event.duration;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> pauseRecorder() async {
    await state.flutterSoundRecorder.pauseRecorder();
    notifyListeners();
  }

  Future<void> resumeRecorder() async {
    state.flutterSoundRecorder.resumeRecorder();
    notifyListeners();
  }

  void clearVoiceList() {
    state.voiceList.clear();
  }

  void initialVoiceList(List<Voice> givenVoiceList) {
    state.voiceList = givenVoiceList;
  }

  void initialVoiceListSnapshot() {
    state.voiceListSnapshot = List.from(state.voiceList);
  }

  void stopRecorder() async {
    // finishing up the recorded voice
    String path = await state.flutterSoundRecorder.stopRecorder();
    final _noteVoiceRecorderLogic = Provider.of<NoteVoiceRecorderLogic>(Get.overlayContext, listen: false);
    TextEditingController dialogController = TextEditingController(text: '');
    await showAlertDialog(Get.overlayContext,
        title:  locale.voiceTitle.tr,
        hastTextField: true,
        textFieldhintText:  locale.titleHint.tr,
        okButtonText:  locale.ok.tr,
        cancelButtonText:  locale.cancel.tr, okButtonFunction: () {
      _noteVoiceRecorderLogic.setVoiceTitle(dialogController.text);
    });

    // time to save the file with path inside the
    // datatbase as the Uint8List
    File file = File(path);
    var h = await file.readAsBytes();
    var v = Voice((voiceTitle == null || voiceTitle == "") ? 'Unamed' : voiceTitle, h);
    state.voiceList.add(v);
    voiceTitle = null;
    // Time to delete the file to avoid space overflow
    state.flutterSoundRecorder.deleteRecord(fileName: state.voiceName);
    notifyListeners();
  }

  String voiceTitle;
  void setVoiceTitle(String title) {
    voiceTitle = title;
  }

  void voiceDismissed(index) {
    state.dismissedVoice = state.voiceList.removeAt(index);
    notifyListeners();
  }

  void voiceRecover(index) {
    state.voiceList.insert(index, state.dismissedVoice);
    notifyListeners();
  }

  Future<List<Voice>> getVoiceList() async {
    return state.voiceList;
  }
}
