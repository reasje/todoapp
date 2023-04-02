import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/app/note_screen/logic/note_provider.dart';
import 'package:todoapp/app/note_screen/logic/noteimage_provider.dart';
import 'package:todoapp/app/note_screen/logic/notepassword_provider.dart';
import 'package:todoapp/app/note_screen/logic/notevoice_recorder_provider.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

import '../applocalizations.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:todoapp/app/settings/logic/drive_provider.dart';

Future showAlertDialog(BuildContext context,
    {String id, drive.DriveApi driveApi, drive.File driveFile, LazyBox<Note> noteBox, String fileId, int index, String desc}) async {
  bool _passwordInVisible = true;

  var mCtx = context;

  final _notePasswordProvider = Provider.of<NotePasswordProvider>(mCtx, listen: false);

  final _noteImageProvider = Provider.of<NoteImageProvider>(mCtx, listen: false);

  final _themeProvider = Provider.of<ThemeProvider>(mCtx, listen: false);

  final _noteVoiceRecorderProvider = Provider.of<NoteVoiceRecorderProvider>(mCtx, listen: false);

  TextEditingController dialogController = TextEditingController(text: desc ?? '');
  id == 'password' ? dialogController.text = _notePasswordProvider.password : null;
  double h = MediaQuery.of(mCtx).size.height;

  double w = MediaQuery.of(mCtx).size.width;

  return showDialog(
      context: mCtx,
      builder: (ctxt) {
        return StatefulBuilder(
          builder: (BuildContext ctx, setState) {
            return AlertDialog(
              backgroundColor: _themeProvider.mainColor,
              title: Center(
                  child: Text(
                id == "lan"
                    ? "Choose you language ! "
                    : id == "up"
                        ? AppLocalizations.of(ctx).translate('fileExists')
                        : id == "internet"
                            ? AppLocalizations.of(ctx).translate('noInternet')
                            : id == "signIn"
                                ? AppLocalizations.of(ctx).translate('signIn')
                                : id == "noNotes"
                                    ? AppLocalizations.of(ctx).translate('noNotes')
                                    : id == 'microphoneRequired'
                                        ? AppLocalizations.of(ctx).translate('microphoneRequired')
                                        : id == 'voiceTitle'
                                            ? AppLocalizations.of(ctx).translate('voiceTitle')
                                            : id == 'imageDesc'
                                                ? AppLocalizations.of(ctx).translate('imageDesc')
                                                : id == 'password'
                                                    ? AppLocalizations.of(ctx).translate('setPassword')
                                                    : AppLocalizations.of(ctx).translate('continue'),
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
              )),
              content: Container(
                height: id == 'voiceTitle' || id == 'imageDesc' || id == 'password' ? h * 0.18 : h * 0.1,
                width: w * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    id == 'voiceTitle' || id == 'imageDesc' || id == 'password'
                        ? TextField(
                            obscureText: _passwordInVisible,
                            autofocus: true,
                            controller: dialogController,
                            keyboardType: id == 'password' ? TextInputType.number : null,
                            maxLength: id == 'password'
                                ? 10
                                : id != 'imageDesc'
                                    ? 10
                                    : 415,
                            cursorColor: _themeProvider.swachColor,
                            cursorHeight: id != 'imageDesc' ? h * 0.048 : h * 0.03,
                            style: TextStyle(
                                color: _themeProvider.textColor,
                                fontSize: id != 'imageDesc'
                                    ? _themeProvider.isEn
                                        ? w * 0.07
                                        : w * 0.05
                                    : _themeProvider.isEn
                                        ? w * 0.04
                                        : w * 0.03,
                                fontWeight: FontWeight.w200),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(_themeProvider.isEn ? h * w * 0.00001 : h * w * 0.00001),
                                hintText: id == 'imageDesc'
                                    ? AppLocalizations.of(ctx).translate('imageDesc')
                                    : id == 'password'
                                        ? AppLocalizations.of(ctx).translate('passwordHint')
                                        : AppLocalizations.of(ctx).translate('titleHint'),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  autofocus: false,
                                  color: _themeProvider.textColor,
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
                                    color: _themeProvider.hintColor.withOpacity(0.12),
                                    fontSize: id != 'imageDesc'
                                        ? _themeProvider.isEn
                                            ? w * 0.07
                                            : w * 0.05
                                        : _themeProvider.isEn
                                            ? w * 0.05
                                            : w * 0.04,
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _themeProvider.textColor),
                              child: InkWell(
                                child: Center(
                                    child: Text(
                                  id == "lan"
                                      ? "فارسی"
                                      : id == "internet" || id == "signIn" || id == "noNotes" || id == "microphoneRequired"
                                          ? AppLocalizations.of(ctx).translate('ok')
                                          : AppLocalizations.of(ctx).translate('cancel'),
                                  style: TextStyle(color: _themeProvider.mainColor, fontWeight: FontWeight.bold),
                                )),
                                onTap: () {
                                  id == "lan" ? _themeProvider.changeLanToPersian() : null;
                                  Navigator.pop(ctx);
                                },
                              )),
                          id != "internet" && id != "signIn" && id != "noNotes" && id != "microphoneRequired"
                              ? Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 50,
                                  width: 100,
                                  //margin: EdgeInsets.only(right: 30),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: _themeProvider.textColor),
                                  child: InkWell(
                                      child: Center(
                                          child: Text(
                                        id == "lan" ? "English" : AppLocalizations.of(ctx).translate('ok'),
                                        style: TextStyle(color: _themeProvider.mainColor, fontWeight: FontWeight.bold),
                                      )),
                                      onTap: () {
                                        id == 'password'
                                            ? _notePasswordProvider.setPassword(dialogController.text)
                                            : id == "lan"
                                                ? _themeProvider.changeLanToEnglish()
                                                : id == "up"
                                                    ? upload(driveApi, driveFile, noteBox, AppLocalizations.of(ctx).translate('uploading'),
                                                        AppLocalizations.of(ctx).translate('uploadDone'), fileId)
                                                    : id == "voiceTitle"
                                                        ? _noteVoiceRecorderProvider.setVoiceTitle(dialogController.text)
                                                        : id == 'imageDesc'
                                                            ? _noteImageProvider.updateImageDesc(index, dialogController.text)
                                                            : download(driveApi, driveFile, AppLocalizations.of(ctx).translate('downloading'),
                                                                AppLocalizations.of(ctx).translate('downloadDone'), noteBox, fileId);
                                        Navigator.pop(ctx);
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
