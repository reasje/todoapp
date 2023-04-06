import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todoapp/app/note_screen/state/note_password_state.dart';

class NotePasswordLogic extends GetxController {
  NotePasswordState state = NotePasswordState();

  void setPassword(String newPassword) {
    state.password = newPassword;
  }

  void clearPassword() {
    state.password = '';
  }

  // TODO: add password snapshot 
}
