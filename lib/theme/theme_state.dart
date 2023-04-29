import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';

class ThemeState {
  RxList<Color> noteTitleColor = <Color>[].obs;

  Rxn<Color> _shimmerColor =Rxn<Color>() ;
  set shimmerColor(Color? value) => _shimmerColor.value = value;
  Color? get shimmerColor => _shimmerColor.value;

  Rxn<Color> _mainColor =Rxn<Color>() ;
  set mainColor(Color? value) => _mainColor.value = value;
  Color? get mainColor => _mainColor.value;

  Rxn<Color> _mainOpColor =Rxn<Color>() ;
  set mainOpColor(Color? value) => _mainOpColor.value = value;
  Color? get mainOpColor => _mainOpColor.value;

  Rxn<Color> _textColor =Rxn<Color>() ;
  set textColor(Color? value) => _textColor.value = value;
  Color? get textColor => _textColor.value;

  Rxn<Color> _titleColor =Rxn<Color>() ;
  set titleColor(Color? value) => _titleColor.value = value;
  Color? get titleColor => _titleColor.value;

  Rxn<Color> _hinoteColor =Rxn<Color>() ;
  set hinoteColor(Color? value) => _hinoteColor.value = value;
  Color? get hinoteColor => _hinoteColor.value;

  Rx<Color> _swashColor = Color(0xFF001b48).obs;
  set swashColor(Color value) => _swashColor.value = value;
  Color get swashColor => _swashColor.value;

  Rxn<Brightness> _brightness =Rxn<Brightness>() ;
  set brightness(Brightness? value) => _brightness.value = value;
  Brightness? get brightness => _brightness.value;

  Rxn<bool> _isEn = Rxn<bool>();
  set isEn(bool? value) => _isEn.value = value;
  bool? get isEn => _isEn.value;

  Rxn<bool> _isFirstTime = Rxn<bool>();
  set isFirstTime(bool? value) => _isFirstTime.value = value;
  bool? get isFirstTime => _isFirstTime.value;

  Rxn<Locale> _locale =Rxn<Locale>() ;
  set locale(Locale? value) => _locale.value = value;
  Locale? get locale => _locale.value;

  Rxn<String> _noTaskImage =Rxn<String>() ;
  set noTaskImage(String? value) => _noTaskImage.value = value;
  String? get noTaskImage => _noTaskImage.value;

  Rxn<String> _splashImage =Rxn<String>() ;
  set splashImage(String? value) => _splashImage.value = value;
  String? get splashImage => _splashImage.value;

  ThemeState();
}
