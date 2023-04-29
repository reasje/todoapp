import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:undo/undo.dart';

class NoteTitleTextState {

  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController textController = TextEditingController(text: '');
  // handeling changes to text textfield
  var changes = new ChangeStack();

  // focus nodes for each text field
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode textFocusNode = FocusNode();

  Rx<bool> _canRedo = false.obs;
  set canRedo(bool value) => _canRedo.value = value;
  bool get canRedo => _canRedo.value;

  Rx<bool> _canUndo = false.obs;
  set canUndo(bool value) => _canUndo.value = value;
  bool get canUndo => _canUndo.value;

  Rx<String?> _titleSnapShot = null.obs;
  set titleSnapShot(String? value) => _titleSnapShot.value = value;
  String? get titleSnapShot => _titleSnapShot.value;

  Rx<String?> _textSnapShot = null.obs;
  set textSnapShot(String? value) => _textSnapShot.value = value;
  String? get textSnapShot => _textSnapShot.value;

  Rx<PickedFile?> _image = null.obs;
  set image(PickedFile? value) => _image.value = value;
  PickedFile? get image => _image.value;

  Rx<String?> _textOldValue = null.obs;
  set textOldValue(String? value) => _textOldValue.value = value;
  String? get textOldValue => _textOldValue.value;

  Rx<String?> _textNewValueHelper = null.obs;
  set textNewValueHelper(String? value) => _textNewValueHelper.value = value;
  String? get textNewValueHelper => _textNewValueHelper.value;

  Rx<String?> _textRedoValue = null.obs;
  set textRedoValue(String? value) => _textRedoValue.value = value;
  String? get textRedoValue => _textRedoValue.value;

  Rx<bool> _beginEdit = true.obs;
  set beginEdit(bool value) => _beginEdit.value = value;
  bool get beginEdit => _beginEdit.value;

  NoteTitleTextState();
}
