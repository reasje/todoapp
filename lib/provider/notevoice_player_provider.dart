import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/notevoice_recorder_provider.dart';

class NoteVoicePlayerProvider with ChangeNotifier {


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
  //                              *** PLAYER ***                              //
  Future<void> startPlayingRecorded(int index, BuildContext context) async {
    final _noteVoiceRecorderProvider =
        Provider.of<NoteVoiceRecorderProvider>(context, listen: false);
    await checkForPlayingPlayers();
    flutterSoundPlayer[index].openAudioSession();
    voiceDuration[index] = await flutterSoundPlayer[index].startPlayer(
        fromDataBuffer: _noteVoiceRecorderProvider.voiceList[index].voice);
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

  void seekPlayingRecorder(
      double value, int index, BuildContext context) async {
    if (soundPlayerState[index] == SoundPlayerState.paused ||
        soundPlayerState[index] == SoundPlayerState.stopped) {
      await startPlayingRecorded(index, context);
    }
    var duration = Duration(seconds: value.toInt());
    flutterSoundPlayer[index].seekToPlayer(duration);
    voiceProgress[index] = duration;
    notifyListeners();
  }
}