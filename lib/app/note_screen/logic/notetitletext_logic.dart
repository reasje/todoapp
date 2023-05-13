import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:undo/undo.dart';

import '../state/note_title_text_state.dart';

class NoteTitleTextLogic extends GetxController {
  NoteTitleTextState state = NoteTitleTextState();
  // Handeling the Undo function
  void changesUndo() {
    state.changes.undo();
    state.canRedo = true;
  }

  // handeling the Redo function
  void changesRedo() {
    state.changes.redo();
    state.textController.text = state.textRedoValue!;
    state.textController.selection = TextSelection.fromPosition(TextPosition(offset: state.textController.text.length));
    state.canUndo = true;
  }

  // fo the clear button in the form
  void clearTitle() {
    state.titleController.clear();
  }

  // Clearing only the text
  void clearText() {
    state.textController.clear();
  }

  // This is used inside of Note textfield to control and save the state.changes for undo property
  void listenerActivated(newValue) {
    // This Line is used for prevent unusual behavior of the textfield
    // It executes the on change function twice after entering only one word
    if (state.textNewValueHelper != newValue) {
      // Staging the state.changes !
      state.changes.add(new Change(state.textOldValue, () {
        state.textRedoValue = newValue;
      }, (String? oldValue) {
        // When the change is being applies or in other words
        // The undo button is selected I want to make the text controller
        // text equal to the oldValue that the change got before .
        state.textController.text = oldValue!;
        // Updating the textOldValue and making it ready for the next change
        state.textOldValue = oldValue;
        // Making the cursor stay at the right position
        state.textController.selection = TextSelection.fromPosition(TextPosition(offset: state.textController.text.length));
      }));
      state.canUndo = true;
      // After giving the value of the textOldValue as Oldvalue to the change
      // It's Time to update textOldValue for the next change
      state.textOldValue = state.textController.text;
      // updating the textNewValueHelper to prevent extra execution of onChange function
      state.textNewValueHelper = newValue;
    }
  }

  @override
  void dispose() {
    state.textController.dispose();
    state.titleController.dispose();
    super.dispose();
  }
}
