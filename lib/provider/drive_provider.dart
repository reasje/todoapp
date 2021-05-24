import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/GoogleAuthClient.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'dart:convert';
import 'package:todoapp/uiKit.dart' as uiKit;

// This is the file id and the name
// used to upload the file and check wether the file
// exisstce or not and
String file_name = "NotesAppData";

Future<void> upload(
    drive.DriveApi driveApi, drive.File driveFile, Box<Note> noteBox,
    [String file_id]) async {
  List<int> my_intlist = [];
  List<String> my_stringlist = [];
  List<List<int>> list = [];
  if (file_id != null) {
    driveApi.files.delete(file_id);
    driveApi.files.emptyTrash();
  }
  for (int i = 0; i < noteBox.length; i++) {
    var element = noteBox.getAt(i);
    var title = element.title;
    var text = element.text;
    var time = element.time;
    Map<String, dynamic> toJson() => {
          "title": title,
          "text": text,
          "time": time,
        };
    var my_json = toJson();

    my_stringlist.add(json.encode(my_json));
  }
  print(my_stringlist);
  my_intlist = my_stringlist.toString().codeUnits;
  list.add(my_intlist);
  print(noteBox.length);
  final Stream<List<int>> mediaStream =
      Future.value(my_intlist).asStream().asBroadcastStream();
  var media = new drive.Media(mediaStream, my_intlist.length + 1);
  driveFile.name = file_name;
  driveFile.mimeType = 'text';
  final result = await driveApi.files.create(driveFile, uploadMedia: media);
  print("Upload result: $result");
}

Future<void> download(drive.DriveApi driveApi, drive.File driveFile,
    Box<Note> noteBox, String file_id) async {
  drive.Media media = await driveApi.files
      .get(file_id, downloadOptions: drive.DownloadOptions.fullMedia);
  final subescription = media.stream.listen((event) {
    String string = String.fromCharCodes(event);
    var list = json.decode(string);
    for (int i = 0; i < list.length; i++) {
      var title = list[i]['title'];
      var text = list[i]['text'];
      int time = list[i]['time'];
      noteBox.add(Note(title, text, false, time, 0, time));
    }
  });
}

Future<void> login(bool command, BuildContext context) async {
  // command true -> upload
  // command flase -> download
  // At first we think that the file exists
  bool doesEx = true;
  // used to get infromation inside the box
  final noteBox = Hive.box<Note>(noteBoxName);
  try {
    // used to sign in to google drive
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    // getting the signinded account information
    print("User account $account");
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
        await upload(driveApi, driveFile, noteBox);
      } else {
        // show continue dialog
        uiKit.showAlertDialog(
            context, "up", driveApi, driveFile, noteBox, file_id);
      }
    } else {
      // The command is download
      if (file_id == null) {
        // file does not existce
        await download(driveApi, driveFile, noteBox, file_id);
      } else {
        // show continue dialog
        uiKit.showAlertDialog(
            context, "down", driveApi, driveFile, noteBox, file_id);
      }
    }
  } catch (err) {
    print("err : $err");
    uiKit.showAlertDialog(context, "internet");
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
      if (list.files[i].name == file_name) {
        file_id = list.files[i].id;
      }
    }
  });
  return file_id;
}
