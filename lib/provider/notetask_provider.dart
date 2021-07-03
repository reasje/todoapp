import 'package:flutter/cupertino.dart';
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';

class NoteTaskProvider with ChangeNotifier {
  List<Task> taskList = [];
  // This is the controller assigned to the textfield inside
  // so the
  // List<TextEditingController> taskTextList = [];
  TaskController dissmissedTask;

  List<TaskController> taskControllerList = [];

  List<TaskController> taskControllerListSnapShot = [];

    // used to control resetCheckBoxs
  bool resetCheckBoxs = false;
  void changeResetCheckBoxs(bool value) {
    resetCheckBoxs = value;
    notifyListeners();
  }
  
  Future<List<TaskController>> getTaskList() async {
    return taskControllerList;
  }

  void taskCheckBoxChanged(int index) {
    print('object');
    if (taskControllerList[index].isDone) {
      taskControllerList[index].isDone = false;
    } else {
      taskControllerList[index].isDone = true;
    }
    notifyListeners();
  }

  void clearTaskList() {
    taskList.clear();
  }

  void clearTaskControllerList() {
    taskControllerList.clear();
  }

  void initialTaskControllerList() {
    taskControllerList = List.from(taskControllerList);
  }

  void initialTaskList(List<Task> givenTaskList) {
    taskList = givenTaskList;
  }

  void checkListOnSubmit(index) {
    taskControllerList.insert(
        index + 1,
        TaskController(
            TextEditingController(text: ""),
            false,
            FocusNode(),
            PageStorageKey<String>(
                'pageKey ${DateTime.now().microsecondsSinceEpoch}')));
    taskControllerList[index + 1].focusNode.requestFocus();
    notifyListeners();
  }

  void taskDissmissed(int index) {
    dissmissedTask = taskControllerList.removeAt(index);
    notifyListeners();
  }

  void taskRecover(int index) {
    dissmissedTask.key = PageStorageKey<String>(
        'pageKey ${DateTime.now().microsecondsSinceEpoch}');
    taskControllerList.insert(index, dissmissedTask);
    notifyListeners();
  }
}
