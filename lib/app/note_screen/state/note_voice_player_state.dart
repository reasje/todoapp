import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

// flutter_sound had a serious problem with the states
// and if more instances of that was made FlutterSoundPlayer's
// state for example the isPlaying instance was true for all
// even if Just one instance was playing
enum SoundPlayerState {
  stopped,
  paused,
  resumed,
}

class NoteVoicePlayerState {
  ScrollController scrollController = new ScrollController();

  // list of images that will be loaded on user tap
  RxList<FlutterSoundPlayer> flutterSoundPlayer = List.filled(100, FlutterSoundPlayer()).obs;
  // this varriable shows the progress of the voice
  RxList<Duration> voiceProgress = List.filled(100, Duration(seconds: 0)).obs;
  // This shows the total duration of the voice
  RxList<Duration> voiceDuration = List.filled(100, Duration(seconds: 0)).obs;
// This is the periodical timer for incrementing the voiceProgress duration
  RxList<Timer> timer = List.filled(100, Timer(Duration(), () {})).obs;
  // Used to control the playing voices
  RxList<SoundPlayerState> soundPlayerState = List.filled(100, SoundPlayerState.stopped).obs;

  NoteVoicePlayerState();
}
