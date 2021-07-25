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
  ScrollController scrollController = new ScrollController();

  // used to control resetCheckBoxs
  bool resetCheckBoxs = false;
  void changeResetCheckBoxs(bool value) {
    resetCheckBoxs = value;
    notifyListeners();
  }

  Future<List<TaskController>> getTaskList() async {
    return taskControllerList;
  }

  void reorderTaskList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var taskController = taskControllerList.elementAt(oldIndex);
    if (newIndex < oldIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        var taskController2 = taskControllerList.elementAt(i - 1);
        taskControllerList[i] = taskController2;
        //taskControllerList.insert(i, );
      }
    } else {
      for (int i = oldIndex; i < newIndex; i++) {
        var taskController = taskControllerList.elementAt(i + 1);
        taskControllerList[i] = taskController;
        //taskControllerList.insert(i, taskController);
      }
    }
    taskControllerList[newIndex] = taskController;
    //taskControllerList.insert(newIndex, taskController);
    notifyListeners();
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
    // taskControllerList.forEach((element) {
    //   element.focusNode.addListener(() {
    //     element.focusNode.hasFocus ?    scrollController.animateTo(
    //   scrollController.position.maxScrollExtent,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // ) : null;
    //   });
    // });
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
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    
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
