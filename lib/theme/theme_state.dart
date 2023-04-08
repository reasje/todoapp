import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';

class ThemeState {
  // list of images that will be loaded on user tap
  RxList<Color> noteTitleColor = [].obs;

  Rx<Color> _shimmerColor = null.obs;
  set shimmerColor(Color value) => _shimmerColor.value = value;
  Color get shimmerColor => _shimmerColor.value;

  Rx<Color> _mainColor = null.obs;
  set mainColor(Color value) => _mainColor.value = value;
  Color get mainColor => _mainColor.value;

  Rx<Color> _mainOpColor = null.obs;
  set mainOpColor(Color value) => _mainOpColor.value = value;
  Color get mainOpColor => _mainOpColor.value;

  Rx<Color> _textColor = null.obs;
  set textColor(Color value) => _textColor.value = value;
  Color get textColor => _textColor.value;

  Rx<Color> _titleColor = null.obs;
  set titleColor(Color value) => _titleColor.value = value;
  Color get titleColor => _titleColor.value;

  Rx<Color> _hinoteColor = null.obs;
  set hinoteColor(Color value) => _hinoteColor.value = value;
  Color get hinoteColor => _hinoteColor.value;

  Rx<Color> _swashColor = Color(0xFF001b48).obs;
  set swashColor(Color value) => _swashColor.value = value;
  Color get swashColor => _swashColor.value;

  Rx<Brightness> _brightness = null.obs;
  set brightness(Brightness value) => _brightness.value = value;
  Brightness get brightness => _brightness.value;

  Rx<bool> _isEn = null.obs;
  set isEn(bool value) => _isEn.value = value;
  bool get isEn => _isEn.value;

  Rx<bool> _isFirstTime = null.obs;
  set isFirstTime(bool value) => _isFirstTime.value = value;
  bool get isFirstTime => _isFirstTime.value;

  Rx<Locale> _locale = null.obs;
  set locale(Locale value) => _locale.value = value;
  Locale get locale => _locale.value;

  Rx<String> _noTaskImage = null.obs;
  set noTaskImage(String value) => _noTaskImage.value = value;
  String get noTaskImage => _noTaskImage.value;

  Rx<String> _splashImage = null.obs;
  set splashImage(String value) => _splashImage.value = value;
  String get splashImage => _splashImage.value;

  ThemeState();
}
