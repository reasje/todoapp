import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_logic.dart';
import 'package:todoapp/app/note_screen/logic/notepassword_logic.dart';

import 'package:todoapp/theme/theme_logic.dart';

import '../applocalizations.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:todoapp/app/settings/drive_logic.dart';

Future showAlertDialog(
    {String? title,
    drive.DriveApi? driveApi,
    drive.File? driveFile,
    LazyBox<Note>? noteBox,
    String? fileId,
    int? index,
    String? desc,
    Widget? buttons,
    bool hastTextField = false,
    int textFieldMaxLength = 10,
    String textFieldhintText = "",
    TextInputType? textInputType,
    String? okButtonText,
    String? cancelButtonText,
    Function? okButtonFunction,
    Function? cancelButtonFunction,
    TextEditingController? dialogController}) async {
  bool _passwordInVisible = true;

  final _themeLogic = Get.find<ThemeLogic>().state;

  double h = Get.height;

  double w = Get.width;

  return showDialog(
      context: Get.context!,
      builder: (ctxt) {
        return StatefulBuilder(
          builder: (BuildContext ctx, setState) {
            return AlertDialog(
              backgroundColor: _themeLogic.mainColor,
              title: Center(
                  child: Text(
                title!,
                style: TextStyle(
                  color: _themeLogic.textColor,
                ),
              )),
              content: Container(
                height: h * 0.18,
                width: w * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    hastTextField
                        ? TextField(
                            obscureText: _passwordInVisible,
                            autofocus: true,
                            controller: dialogController,
                            keyboardType: textInputType,
                            maxLength: textFieldMaxLength,
                            cursorColor: _themeLogic.swashColor,
                            cursorHeight: h * 0.03,
                            style: TextStyle(
                                color: _themeLogic.textColor, fontSize: _themeLogic.isEn! ? w * 0.04 : w * 0.03, fontWeight: FontWeight.w200),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(_themeLogic.isEn! ? h * w * 0.00001 : h * w * 0.00001),
                                hintText: textFieldhintText,
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  autofocus: false,
                                  color: _themeLogic.textColor,
                                  icon: Icon(_passwordInVisible ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    _passwordInVisible = !_passwordInVisible;
                                    setState(() {});
                                  },
                                ),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: _themeLogic.hinoteColor!.withOpacity(0.12),
                                    fontSize: _themeLogic.isEn! ? w * 0.05 : w * 0.04,
                                    fontWeight: FontWeight.w400)),
                          )
                        : Container(),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.bottomRight,
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _themeLogic.textColor),
                              child: InkWell(
                                child: Center(
                                    child: Text(
                                  okButtonText!,
                                  style: TextStyle(color: _themeLogic.mainColor, fontWeight: FontWeight.bold),
                                )),
                                onTap: () {
                                  okButtonFunction!();
                                  Get.back();
                                },
                              )),
                          cancelButtonText != null
                              ? Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 50,
                                  width: 100,
                                  //margin: EdgeInsets.only(right: 30),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _themeLogic.textColor),
                                  child: InkWell(
                                      child: Center(
                                          child: Text(
                                        cancelButtonText,
                                        style: TextStyle(color: _themeLogic.mainColor, fontWeight: FontWeight.bold),
                                      )),
                                      onTap: () {
                                        if (cancelButtonFunction != null) {
                                          cancelButtonFunction();
                                        }
                                        Get.back();
                                      }))
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
}
