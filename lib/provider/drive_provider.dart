import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/googleauthclient_model.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/model/voice_model.dart';
import 'package:todoapp/provider/conn_provider.dart';
import 'package:todoapp/provider/signin_provider.dart';
import 'dart:convert';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:todoapp/model/image_model.dart' as imageModel;

// consider adding them ,
// This is the file id and the name
// used to upload the file and check wether the file
// exisstce or not and
String _fileName = "NotesAppData";
BuildContext driverContext;
Future<void> upload(drive.DriveApi driveApi, drive.File driveFile,
    LazyBox<Note> noteBox, String uploadiung, String downloadDone,
    [String _fileId]) async {
  await EasyLoading.show(
    dismissOnTap: false,
    status: uploadiung,
  );
  // String list is the list that the jsons of each note as a
  // string will be saved in it
  List<String> _stringList = [];
  // List<List<int>> list = [];
  // int list is the list hloding the code characters
  // of the String list
  List<int> intList = [];
  if (_fileId != null) {
    driveApi.files.delete(_fileId);
    driveApi.files.emptyTrash();
  }
  for (int i = 0; i < noteBox.length; i++) {
    var element = await noteBox.getAt(i);
    // hint uft8 charcters are not as bytes
    // like persian characters
    // persian characters are utf8 type so
    // But the flutter uses utf16 characters
    // So we convert the uft16 and utf8 to utf16 so
    // then we have no problem uploading
    // When downloading we convert the utf16 to
    // utf8 and utf16
    var title = element.title;
    title = utf8.fuse(base64).encode(title);
    var text = element.text;
    text = utf8.fuse(base64).encode(text);
    var password = element.password;
    password = utf8.fuse(base64).encode(password);
    // time is type int and is an exception
    var time = element.time;
    var resetCheckBoxs = element.resetCheckBoxs;
    var color = element.color;
    var isChecked = element.isChecked;
    // resetCheckBoxs = utf8.fuse(base64).encode(resetCheckBoxs.toString());
    // List<String> imageList = [];
    // for (int i = 0; i < element.imageList.length; i++) {
    //   imageList.add(base64Encode(element.imageList[i].image));
    // }
    List<Voice> voiceList = List.from(element.voiceList);
    List<String> voiceTitleList = [];
    List<String> voiceVoiceList = [];
    for (int i = 0; i < voiceList.length; i++) {
      voiceTitleList.add(utf8.fuse(base64).encode(voiceList[i].title));
      voiceVoiceList.add(base64Encode(voiceList[i].voice));
    }
    List<imageModel.Image> imageList = List.from(element.imageList);
    List<String> imageDescList = [];
    List<String> imageImageList = [];
    for (int i = 0; i < imageList.length; i++) {
      imageDescList.add(utf8.fuse(base64).encode(imageList[i].desc));
      imageImageList.add(base64Encode(imageList[i].image));
    }
    List<Task> taskList = List.from(element.taskList);
    List<String> taskTitleList = [];
    List<String> taskIsDoneList = [];
    for (int i = 0; i < taskList.length; i++) {
      taskTitleList.add(utf8.fuse(base64).encode(taskList[i].title));
      taskIsDoneList
          .add(utf8.fuse(base64).encode(taskList[i].isDone.toString()));
    }

    /// converting this to json format string
    Map<String, dynamic> toJson() => {
          "title": title,
          "text": text,
          "time": time,
          "isChecked": isChecked,
          "imageDescList": imageDescList,
          "imageImageList": imageImageList,
          "voiceTitleList": voiceTitleList,
          "voiceVoiceList": voiceVoiceList,
          "taskTitleList": taskTitleList,
          "taskIsDoneList": taskIsDoneList,
          "resetCheckBoxs": resetCheckBoxs,
          "color": color,
          "password": password,
        };
    // completing all the string json format to real json
    var my_json = toJson();
    // adding all the string to a list of string with the unicode format .
    _stringList.add(json.encode(my_json));
  }
  intList = _stringList.toString().codeUnits;
  // list.add(my_intlist);
  final Stream<List<int>> mediaStream =
      Future.value(intList).asStream().asBroadcastStream();
  var media = new drive.Media(mediaStream, intList.length);
  driveFile.name = _fileName;
  driveFile.mimeType = 'text';
  await driveApi.files.create(driveFile, uploadMedia: media);
  await EasyLoading.dismiss();
  await EasyLoading.showSuccess(downloadDone);
}

Future<void> download(
    drive.DriveApi driveApi,
    drive.File driveFile,
    String downloading,
    String downloadDone,
    LazyBox<Note> noteBox,
    String file_id) async {
  await EasyLoading.show(
    dismissOnTap: false,
    status: downloading,
  );
  String downloaded = "";
  drive.Media media = await driveApi.files
      .get(file_id, downloadOptions: drive.DownloadOptions.fullMedia);
  var sub = media.stream.listen((event) async {
    downloaded = downloaded + String.fromCharCodes(event);
  });
  sub.onDone(() async {
    sub.cancel();
    var list = json.decode(downloaded);
    for (int i = 0; i < list.length; i++) {
      var title = list[i]['title'];
      title = utf8.fuse(base64).decode(title);
      var text = list[i]['text'];
      text = utf8.fuse(base64).decode(text);
      var password = list[i]['password'];
      password = utf8.fuse(base64).decode(password);
      int time = list[i]['time'];
      bool resetCheckBoxs = list[i]['resetCheckBoxs'];
      int color = list[i]['color'];
      bool isChecked = list[i]['isChecked'];
      // Downloading voices
      List<Voice> voiceList = [];
      List<String> voiceTitleList = List.from(list[i]['voiceTitleList']);
      List<String> voiceVoiceListDownloaded =
          List.from(list[i]['voiceVoiceList']);
      for (int i = 0; i < voiceTitleList.length; i++) {
        Voice voice = Voice(utf8.fuse(base64).decode(voiceTitleList[i]),
            base64.decode(voiceVoiceListDownloaded[i]));
        voiceList.add(voice);
      }
      List<imageModel.Image> imageList = [];
      List<String> imageDescList = List.from(list[i]['imageDescList']);
      List<String> imageImageListDownloaded =
          List.from(list[i]['imageImageList']);
      for (int i = 0; i < imageDescList.length; i++) {
        imageModel.Image image = imageModel.Image(
            base64.decode(imageImageListDownloaded[i]),
            utf8.fuse(base64).decode(imageDescList[i]));
        imageList.add(image);
      }

      List<Task> taskList = [];
      List<String> taskTitleList = List.from(list[i]['taskTitleList']);
      List<String> taskTaskListDownloaded =
          List.from(list[i]['taskIsDoneList']);
      for (int i = 0; i < taskTitleList.length; i++) {
        Task task = Task(utf8.fuse(base64).decode(taskTitleList[i]),
            utf8.fuse(base64).decode(taskTaskListDownloaded[i]) == 'true');
        taskList.add(task);
      }
      await noteBox.add(Note(title, text, isChecked, time, color, time,
          imageList, voiceList, taskList, resetCheckBoxs, password));
    }
    await EasyLoading.dismiss();
    await EasyLoading.showSuccess(downloadDone);
  });
}

Future<void> login(bool command, BuildContext context) async {
  // command true -> upload
  // command flase -> download
  // At first we think that the file exists
  bool doesEx = true;
  // used to get infromation inside the boxu
  final noteBox = Hive.lazyBox<Note>(noteBoxName);
  //used to sign in to google drive
  final _connState = Provider.of<ConnState>(context, listen: false);
  final _signinState = Provider.of<SigninState>(context, listen: false);
  if (noteBox.isEmpty && command != false) {
    uiKit.showAlertDialog(context, id: "noNotes");
  } else {
    if (!_connState.is_conn) {
      // I am connected to a mobile network or wifi.
      uiKit.showAlertDialog(context, id: "internet");
    } else {
      _signinState.checkSignin();
      if (_signinState.isSignedin) {
        // The user is signed in
        final googleSignIn =
            signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
        final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
        // getting the signinded account information
        if (account == null) {
          uiKit.showAlertDialog(context, id: "internet");
        } else {
          try {
            final authHeaders = await account.authHeaders;
            final authenticateClient = GoogleAuthClient(authHeaders);
            final driveApi = drive.DriveApi(authenticateClient);
            var driveFile = new drive.File();
            driveApi.files.emptyTrash();
            String file_id = await checkFileExsitance(driveApi);
            // if the cmmand is upload or download
            if (command) {
              if (file_id == null) {
                // file does not existce
                await upload(
                    driveApi,
                    driveFile,
                    noteBox,
                    uiKit.AppLocalizations.of(context).translate('uploading'),
                    uiKit.AppLocalizations.of(context).translate('uploadDone'));
              } else {
                // show continue dialog
                uiKit.showAlertDialog(context,
                    id: "up",
                    driveApi: driveApi,
                    driveFile: driveFile,
                    noteBox: noteBox,
                    file_id: file_id);
              }
            } else {
              // The command is download
              if (file_id == null) {
                // file does not existce
                await download(
                  driveApi,
                  driveFile,
                  uiKit.AppLocalizations.of(context).translate('downloading'),
                  uiKit.AppLocalizations.of(context).translate('downloadDone'),
                  noteBox,
                  file_id,
                );
              } else {
                // show continue dialog
                uiKit.showAlertDialog(context,
                    id: "down",
                    driveApi: driveApi,
                    driveFile: driveFile,
                    noteBox: noteBox,
                    file_id: file_id);
              }
            }
          } catch (err) {
            print("err : $err");
            uiKit.showAlertDialog(context, id: "internet");
          }
        }
      } else {
        uiKit.showAlertDialog(context, id: "signIn");
      }
    }
  }
}

Future<String> checkFileExsitance(drive.DriveApi driveApi) async {
  // file id
  String file_id = null;
  // looping through the files to check wether the file exsitce or note
  // the if statement is based on the file name
  await driveApi.files.list().then((value) {
    var list = value;
    for (int i = 0; i < list.files.length; i++) {
      if (list.files[i].name == _fileName) {
        file_id = list.files[i].id;
      }
    }
  });
  return file_id;
}
