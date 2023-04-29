import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class NoteColorState {
  // note color is used for reloading the color selection selected
  // Color noteColor;
  // Color colorSnapShot;
  // int indexOfSelectedColor;
  //  Note editing tabs and colors managment
  static List<Color> noteColors = [
    Color(0xFFff4444),
    Color(0xFF00c851),
    Color(0xFFffbb33),
    Color(0xFF33b5e5),
    Color(0xffaa66cc),
  ];

  final Rx<Color?> _noteColor = noteColors[0].obs;
  set noteColor(Color? value) => _noteColor.value = value;
  Color? get noteColor => _noteColor.value;

  final Rx<Color?> _colorSnapShot = noteColors[0].obs;
  set colorSnapShot(Color? value) => _colorSnapShot.value = value;
  Color? get colorSnapShot => _colorSnapShot.value;
  
  final _indexOfSelectedColor = 1.obs;
  set indexOfSelectedColor(int value) => _indexOfSelectedColor.value = value;
  int get indexOfSelectedColor => _indexOfSelectedColor.value;
  NoteColorState();
}
