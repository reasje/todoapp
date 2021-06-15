import 'package:flutter/cupertino.dart';

class TaskController {
  TextEditingController textEditingController;
  bool isDone;
  FocusNode focusNode;
  PageStorageKey key;
  TaskController(this.textEditingController, this.isDone, this.focusNode , this.key);
}
