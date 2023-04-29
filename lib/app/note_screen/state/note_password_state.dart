import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
class NotePasswordState {

  Rx<String?> _password = null.obs;
  set password(String? value) => _password.value = value;
  String? get password => _password.value;
  
  Rx<String?> _passwordSnapShot = null.obs;
  set passwordSnapShot(String? value) => _passwordSnapShot.value = value;
  String? get passwordSnapShot => _passwordSnapShot.value;

  NotePasswordState();
}