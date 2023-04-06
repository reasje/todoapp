import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/image_model.dart' as imageModel;
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';
class NoteVoiceRecorderState {

  ScrollController scrollController = new ScrollController();

  // list of images that will be loaded on user tap
  RxList<Task> taskList = [].obs;
  RxList<TaskController> taskControllerList = [].obs;
  RxList<TaskController> taskControllerListSnapShot = [].obs;

  Rx<TaskController> _dissmissedTask = null.obs;
  set dissmissedTask(TaskController value) => _dissmissedTask.value = value;
  TaskController get dissmissedTask => _dissmissedTask.value;
  
  NoteVoiceRecorderState();
}