import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../state/note_color_state.dart';

class NoteColorLogic extends GetxController {
  NoteColorState state = NoteColorState();

  void noteColorSelected(Color color) {
    state.noteColor = color;
  }

  void initialNoteColor(Color givenColor) {
    state.noteColor = givenColor;
  }

  void clearNoteColor() {
    state.noteColor = null;
  }

  // getting the color that was choosen by the user
  void changeNoteColor(Color selectedColor, int index) {
    state.noteColor = selectedColor;
    state.indexOfSelectedColor = index;
  }
}
