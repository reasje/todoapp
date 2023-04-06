import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:todoapp/model/voice_model.dart';

class NoteVoiceRecorderState {
  
  // A new Instance of FlutterSoundRecorder for recording
  FlutterSoundRecorder flutterSoundRecorder = new FlutterSoundRecorder();

  // The voice note part
  RxList<Voice> voiceList = [].obs;
  // Used to controller if the notes has been edited or not
  RxList<Voice> voiceListSnapshot = [].obs;
  RxList<TaskController> taskControllerListSnapShot = [].obs;

  // This list is return to UI for details
  // Below variable is used to show the recorded time in the UI
  Rx<Duration> _recorderDuration = Duration(seconds: 0).obs;
  set recorderDuration(Duration value) => _recorderDuration.value = value;
  Duration get recorderDuration => _recorderDuration.value;

// If any of the voices has been dismissed  It wil be saved in this variable
  Rx<Voice> _dismissedVoice =  null.obs;
  set dismissedVoice(Voice value) => _dismissedVoice.value = value;
  Voice get dismissedVoice => _dismissedVoice.value;

  Rx<String> _voiceName = 'tempraryFileName'.obs;
  set voiceName(String value) => _voiceName.value = value;
  String get voiceName => _voiceName.value;

  NoteVoiceRecorderState();
}
