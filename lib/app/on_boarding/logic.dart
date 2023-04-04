import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/notes%20list/state.dart';
import 'package:todoapp/app/on_boarding/state.dart';
import 'package:todoapp/model/note_model.dart';

import '../../applocalizations.dart';
import '../../main.dart';
import '../../widgets/dialog.dart';
import '../logic/theme_provider.dart';
import 'package:provider/provider.dart';

class OnBoardingLogic extends GetxController {
  OnBoardingState state = OnBoardingState();

  @override
  void onInit() {
  
final _themeProvider = Provider.of<ThemeProvider>(Get.overlayContext, listen: false);
    showAlertDialog(Get.overlayContext,title: "Choose you language ! ",okButtonText: "فارسی",cancelButtonText: "English",okButtonFunction: (){_themeProvider.changeLanToPersian();});
    super.onInit();
  }
}
