import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/notes%20list/state.dart';
import 'package:todoapp/app/on_boarding/state.dart';
import 'package:todoapp/model/note_model.dart';

import '../../applocalizations.dart';
import '../../main.dart';
import '../../widgets/dialog.dart';
import '../../theme/theme_logic.dart';

class OnBoardingLogic extends GetxController {
  OnBoardingState state = OnBoardingState();

  @override
  void onInit() {
    final _themeState = Get.find<ThemeLogic>();
    showAlertDialog(
        title: "Choose you language ! ",
        okButtonText: "فارسی",
        cancelButtonText: "English",
        okButtonFunction: () {
          _themeState.changeLanToPersian();
        });
    super.onInit();
  }
}
