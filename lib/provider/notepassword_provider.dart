import 'package:flutter/cupertino.dart';

class NotePasswordProvider extends ChangeNotifier {

  String password;

  String passwordSnapShot;

  void setPassword(String newPassword) {
    password = newPassword;
  }

  void clearPassword() {
    password = '';
  }
}
