import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todoapp/model/taskController.dart';
import 'package:todoapp/model/task_model.dart';

import '../state/note_task_state.dart';

class NoteTaskLogic extends GetxController {
  NoteTaskState state = NoteTaskState();

  // used to control resetCheckBoxs
  bool? resetCheckBoxs = false;
  void changeResetCheckBoxs(bool value) {
    resetCheckBoxs = value;
    
  }

  Future<List<TaskController?>> getTaskList() async {
    return state.taskControllerList;
  }

  void reorderTaskList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var taskController = state.taskControllerList.elementAt(oldIndex);
    if (newIndex < oldIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        var taskController2 = state.taskControllerList.elementAt(i - 1);
        state.taskControllerList[i] = taskController2;
        //state.taskControllerList.insert(i, );
      }
    } else {
      for (int i = oldIndex; i < newIndex; i++) {
        var taskController = state.taskControllerList.elementAt(i + 1);
        state.taskControllerList[i] = taskController;
        //state.taskControllerList.insert(i, taskController);
      }
    }
    state.taskControllerList[newIndex] = taskController;
    //state.taskControllerList.insert(newIndex, taskController);
    
  }

  void taskCheckBoxChanged(int index) {
    print('object');
    if (state.taskControllerList[index]!.isDone!) {
      state.taskControllerList[index]!.isDone = false;
    } else {
      state.taskControllerList[index]!.isDone = true;
    }
    
  }

  void clearTaskList() {
    state.taskList!.clear();
  }

  void clearTaskControllerList() {
    state.taskControllerList.clear();
  }

  void initialTaskControllerList() {
    state.taskControllerList = List.from(state.taskControllerList) as RxList<TaskController?>;
    // state.taskControllerList.forEach((element) {
    //   element.focusNode.addListener(() {
    //     element.focusNode.hasFocus ?    state.scrollController.animateTo(
    //   state.scrollController.position.maxScrollExtent,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // ) : null;
    //   });
    // });
  }

  void initialTaskList(List<Task>? givenTaskList) {
    state.taskList = givenTaskList as RxList<Task>?;
  }

  void checkListOnSubmit(index) {
    state.taskControllerList.insert(
        index + 1,
        TaskController(
            TextEditingController(text: ""), false, FocusNode(), PageStorageKey<String>('pageKey ${DateTime.now().microsecondsSinceEpoch}')));
    state.scrollController.animateTo(
      state.scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );

    state.taskControllerList[index + 1]!.focusNode.requestFocus();
    
  }

  void taskDissmissed(int index) {
    state.dissmissedTask = state.taskControllerList.removeAt(index);
    
  }

  void taskRecover(int index) {
    state.dissmissedTask!.key = PageStorageKey<String>('pageKey ${DateTime.now().microsecondsSinceEpoch}');
    state.taskControllerList.insert(index, state.dissmissedTask);
    
  }
}
