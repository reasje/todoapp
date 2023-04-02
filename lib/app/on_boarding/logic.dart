import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/notes%20list/state.dart';
import 'package:todoapp/app/on_boarding/state.dart';
import 'package:todoapp/model/note_model.dart';

import '../../main.dart';
import '../../widgets/dialog.dart';

class OnBoardingLogic extends GetxController {
  OnBoardingState state = OnBoardingState();

  @override
  void onInit() {
    showAlertDialog(Get.overlayContext, id: "lan");
    super.onInit();
  }
}
