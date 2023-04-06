import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_logic.dart';

import '../state/note_voice_player_state.dart';

class NoteVoicePlayerLogic extends GetxController {
  NoteVoicePlayerState state = NoteVoicePlayerState();

  Future<void> startPlayingRecorded(int index, BuildContext context) async {
    final _noteVoiceRecorderLogic = Provider.of<NoteVoiceRecorderLogic>(context, listen: false);
    await checkForPlayingPlayers();
    state.flutterSoundPlayer[index].openAudioSession();
    state.voiceDuration[index] =
        await state.flutterSoundPlayer[index].startPlayer(fromDataBuffer: _noteVoiceRecorderLogic.state.voiceList[index].voice);
    timerOn(index);
  }

  Future<void> checkForPlayingPlayers() async {
    var runningElement;
    var anyRunning = state.soundPlayerState.any((element) {
      if (element == SoundPlayerState.resumed) {
        runningElement = element;
        return true;
      } else {
        return false;
      }
    });
    if (anyRunning) {
      var index = state.soundPlayerState.indexOf(runningElement);
      pausePlayingRecorded(index);
    }
  }

  Future<void> timerOn(int index) async {
    state.soundPlayerState[index] = SoundPlayerState.resumed;
    state.timer[index] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.voiceProgress[index] >= state.voiceDuration[index]) {
        state.voiceProgress[index] = Duration(seconds: 0);
        timerOff(index);
        state.soundPlayerState[index] = SoundPlayerState.stopped;
      } else {
        state.voiceProgress[index] = state.voiceProgress[index] + Duration(seconds: 1);
      }
    });
  }

  void timerOff(int index) {
    state.soundPlayerState[index] = SoundPlayerState.paused;
    if (state.timer[index] != null) {
      state.timer[index].cancel();
    }
  }

  Future<void> resumePlayingRecorded(int index) async {
    await checkForPlayingPlayers();
    state.flutterSoundPlayer[index].resumePlayer();
    timerOn(index);
  }

  Future<void> pausePlayingRecorded(int index) async {
    state.flutterSoundPlayer[index].pausePlayer();
    timerOff(index);
  }

  void seekPlayingRecorder(double value, int index, BuildContext context) async {
    if (state.soundPlayerState[index] == SoundPlayerState.paused || state.soundPlayerState[index] == SoundPlayerState.stopped) {
      await startPlayingRecorded(index, context);
    }
    var duration = Duration(seconds: value.toInt());
    state.flutterSoundPlayer[index].seekToPlayer(duration);
    state.voiceProgress[index] = duration;
  }
}
