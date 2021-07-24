import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/noteimage_provider.dart';
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
  var mCtx = context;
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  final _noteImageProvider =
      Provider.of<NoteImageProvider>(mCtx, listen: false);
  final _themeProvider = Provider.of<ThemeProvider>(mCtx, listen: false);
  final _noteVoiceRecorderProvider =
      Provider.of<NoteVoiceRecorderProvider>(mCtx, listen: false);
  TextEditingController voiceTitleController =
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
                                                : uiKit.AppLocalizations.of(ctx)
                                                    .translate('continue'),
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
              )),
              content: Container(
                height: id == 'voiceTitle' || id == 'imageDesc'
                    ? SizeX * 0.23
                    : SizeX * 0.12,
                width: SizeY * 0.7,
                child: Column(
                  children: [
                    id == 'voiceTitle' || id == 'imageDesc'
                        ? TextField(
                            autofocus: true,
                            controller: voiceTitleController,
                            maxLength: id != 'imageDesc' ? 10 : 415,
                            cursorColor: _themeProvider.swachColor,
                            cursorHeight: id != 'imageDesc'
                                ? SizeX * 0.052
                                : SizeX * 0.03,
                            style: TextStyle(
                                color: _themeProvider.textColor,
                                fontSize: id != 'imageDesc'
                                    ? _themeProvider.isEn
                                        ? SizeX * SizeY * 0.0001
                                        : SizeX * SizeY * 0.00008
                                    : _themeProvider.isEn
                                        ? SizeX * SizeY * 0.00006
                                        : SizeX * SizeY * 0.00004,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    _themeProvider.isEn
                                        ? SizeX * SizeY * 0.00001
                                        : SizeX * SizeY * 0.00001),
                                hintText: id == 'imageDesc'
                                    ? uiKit.AppLocalizations.of(ctx)
                                        .translate('imageDesc')
                                    : uiKit.AppLocalizations.of(ctx)
                                        .translate('titleHint'),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: _themeProvider.hintColor
                                        .withOpacity(0.12),
                                    fontSize: id != 'imageDesc'
                                        ? _themeProvider.isEn
                                            ? SizeX * SizeY * 0.00008
                                            : SizeX * SizeY * 0.00006
                                        : _themeProvider.isEn
                                            ? SizeX * SizeY * 0.00007
                                            : SizeX * SizeY * 0.00005,
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
                                        //_myProvider.changeLanToEnglish();
                                        id == "lan"
                                            ? _themeProvider
                                                .changeLanToEnglish()
                                            : id == "up"
                                                ? upload(
                                                    driveApi,
                                                    driveFile,
                                                    noteBox,
                                                    uiKit.AppLocalizations.of(ctx)
                                                        .translate('uploading'),
                                                    uiKit.AppLocalizations.of(ctx)
                                                        .translate(
                                                            'uploadDone'),
                                                    file_id)
                                                : id == "voiceTitle"
                                                    ? _noteVoiceRecorderProvider
                                                        .setVoiceTitle(
                                                            voiceTitleController
                                                                .text)
                                                    : id == 'imageDesc'
                                                        ? _noteImageProvider
                                                            .updateImageDesc(
                                                                index,
                                                                voiceTitleController
                                                                    .text)
                                                        : download(
                                                            driveApi,
                                                            driveFile,
                                                            uiKit.AppLocalizations.of(ctx)
                                                                .translate(
                                                                    'downloading'),
                                                            uiKit.AppLocalizations
                                                                    .of(ctx)
                                                                .translate(
                                                                    'downloadDone'),
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
