import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/noteimage_provider.dart';
import 'package:todoapp/provider/notepassword_provider.dart';
import 'package:todoapp/provider/notevoice_recorder_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/uiKit.dart' as uiKit;
import '../applocalizations.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:todoapp/provider/drive_provider.dart';

Future showAlertDialog(BuildContext context,
    {String id,
    drive.DriveApi driveApi,
    drive.File driveFile,
    LazyBox<Note> noteBox,
    String file_id,
    int index,
    String desc}) async {
  bool _passwordInVisible = true;

  var mCtx = context;

  final _notePasswordProvider =
      Provider.of<NotePasswordProvider>(mCtx, listen: false);

  final _noteImageProvider =
      Provider.of<NoteImageProvider>(mCtx, listen: false);

  final _themeProvider = Provider.of<ThemeProvider>(mCtx, listen: false);

  final _noteVoiceRecorderProvider =
      Provider.of<NoteVoiceRecorderProvider>(mCtx, listen: false);

  TextEditingController dialogController =
      TextEditingController(text: desc ?? '');

  double SizeX = MediaQuery.of(mCtx).size.height;

  double SizeY = MediaQuery.of(mCtx).size.width;

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
                        ? uiKit.AppLocalizations.of(ctx).translate('fileExists')
                        : id == "internet"
                            ? uiKit.AppLocalizations.of(ctx)
                                .translate('noInternet')
                            : id == "signIn"
                                ? uiKit.AppLocalizations.of(ctx)
                                    .translate('signIn')
                                : id == "noNotes"
                                    ? uiKit.AppLocalizations.of(ctx)
                                        .translate('noNotes')
                                    : id == 'microphoneRequired'
                                        ? uiKit.AppLocalizations.of(ctx)
                                            .translate('microphoneRequired')
                                        : id == 'voiceTitle'
                                            ? uiKit.AppLocalizations.of(ctx)
                                                .translate('voiceTitle')
                                            : id == 'imageDesc'
                                                ? uiKit.AppLocalizations.of(ctx)
                                                    .translate('imageDesc')
                                                : id == 'password'
                                                    ? uiKit.AppLocalizations.of(
                                                            ctx)
                                                        .translate(
                                                            'setPassword')
                                                    : uiKit.AppLocalizations.of(
                                                            ctx)
                                                        .translate('continue'),
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
              )),
              content: Container(
                height:
                    id == 'voiceTitle' || id == 'imageDesc' || id == 'password'
                        ? SizeX * 0.18
                        : SizeX * 0.1,
                width: SizeY * 0.7,
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
                            cursorHeight: id != 'imageDesc'
                                ? SizeX * 0.048
                                : SizeX * 0.03,
                            style: TextStyle(
                                color: _themeProvider.textColor,
                                fontSize: id != 'imageDesc'
                                    ? _themeProvider.isEn
                                        ? SizeY * 0.07
                                        : SizeY * 0.05
                                    : _themeProvider.isEn
                                        ? SizeY * 0.04
                                        : SizeY * 0.03,
                                fontWeight: FontWeight.w200),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    _themeProvider.isEn
                                        ? SizeX * SizeY * 0.00001
                                        : SizeX * SizeY * 0.00001),
                                hintText: id == 'imageDesc'
                                    ? uiKit.AppLocalizations.of(ctx)
                                        .translate('imageDesc')
                                    : id == 'password'
                                        ? uiKit.AppLocalizations.of(ctx)
                                            .translate('passwordHint')
                                        : uiKit.AppLocalizations.of(ctx)
                                            .translate('titleHint'),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  autofocus: false,
                                  color: _themeProvider.textColor,
                                  icon: Icon(_passwordInVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
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
                                    color: _themeProvider.hintColor
                                        .withOpacity(0.12),
                                    fontSize: id != 'imageDesc'
                                        ? _themeProvider.isEn
                                            ? SizeY * 0.07
                                            : SizeY * 0.05
                                        : _themeProvider.isEn
                                            ? SizeY * 0.05
                                            : SizeY * 0.04,
                                    fontWeight: FontWeight.w400)),
                          )
                        : Container(),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.bottomRight,
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _themeProvider.textColor),
                              child: InkWell(
                                child: Center(
                                    child: Text(
                                  id == "lan"
                                      ? "فارسی"
                                      : id == "internet" ||
                                              id == "signIn" ||
                                              id == "noNotes" ||
                                              id == "microphoneRequired"
                                          ? uiKit.AppLocalizations.of(ctx)
                                              .translate('ok')
                                          : uiKit.AppLocalizations.of(ctx)
                                              .translate('cancel'),
                                  style: TextStyle(
                                      color: _themeProvider.mainColor,
                                      fontWeight: FontWeight.bold),
                                )),
                                onTap: () {
                                  id == "lan"
                                      ? _themeProvider.changeLanToPersian()
                                      : null;
                                  Navigator.pop(ctx);
                                },
                              )),
                          id != "internet" &&
                                  id != "signIn" &&
                                  id != "noNotes" &&
                                  id != "microphoneRequired"
                              ? Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 50,
                                  width: 100,
                                  //margin: EdgeInsets.only(right: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: _themeProvider.textColor),
                                  child: InkWell(
                                      child: Center(
                                          child: Text(
                                        id == "lan"
                                            ? "English"
                                            : uiKit.AppLocalizations.of(ctx)
                                                .translate('ok'),
                                        style: TextStyle(
                                            color: _themeProvider.mainColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      onTap: () {
                                        id == 'password'
                                            ? _notePasswordProvider.setPassword(
                                                dialogController.text)
                                            : id == "lan"
                                                ? _themeProvider
                                                    .changeLanToEnglish()
                                                : id == "up"
                                                    ? upload(
                                                        driveApi,
                                                        driveFile,
                                                        noteBox,
                                                        uiKit.AppLocalizations.of(ctx)
                                                            .translate(
                                                                'uploading'),
                                                        uiKit.AppLocalizations.of(ctx)
                                                            .translate(
                                                                'uploadDone'),
                                                        file_id)
                                                    : id == "voiceTitle"
                                                        ? _noteVoiceRecorderProvider
                                                            .setVoiceTitle(
                                                                dialogController
                                                                    .text)
                                                        : id == 'imageDesc'
                                                            ? _noteImageProvider
                                                                .updateImageDesc(
                                                                    index,
                                                                    dialogController
                                                                        .text)
                                                            : download(
                                                                driveApi,
                                                                driveFile,
                                                                uiKit.AppLocalizations.of(ctx)
                                                                    .translate(
                                                                        'downloading'),
                                                                uiKit.AppLocalizations.of(ctx)
                                                                    .translate('downloadDone'),
                                                                noteBox,
                                                                file_id);
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
