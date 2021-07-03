import 'package:flutter/cupertino.dart';

class NoteColorProvider with ChangeNotifier {
  // note color is used for reloading the color selection selected
  Color noteColor;
  Color colorSnapShot;
  int indexOfSelectedColor;
  //  Note editing tabs and colors managment

  void noteColorSelected(Color color) {
    noteColor = color;
    notifyListeners();
  }

  void initialNoteColor(Color givenColor) {
    noteColor = givenColor;
  }

  // getting the color that was choosen by the user
  void changeNoteColor(Color selectedColor, int index) {
    noteColor = selectedColor;
    indexOfSelectedColor = index;
    notifyListeners();
  }
}
