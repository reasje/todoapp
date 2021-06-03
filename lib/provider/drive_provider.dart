import 'package:flutter/cupertino.dart';
import 'package:googleapis/mybusinesslodging/v1.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/model/googleauthclient_model.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:todoapp/provider/conn_provider.dart';
import 'package:todoapp/provider/signin_provider.dart';
import 'dart:convert';
import 'package:todoapp/uiKit.dart' as uiKit;
import 'package:connectivity/connectivity.dart' as conn;

// This is the file id and the name
// used to upload the file and check wether the file
// exisstce or not and
String file_name = "NotesAppData";

Future<String> upload(
    drive.DriveApi driveApi, drive.File driveFile, Box<Note> noteBox,
    [String file_id]) async {
  // some lists are used to add 
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
    // hint uft8 charcters are not as bytes
    // like persian characters
    // persian characters are utf8 type so
    // But the flutter uses utf16 characters
    // So we convert the uft16 and utf8 to utf16 so
    // then we have no problem uploading
    // When downloading we convert the utf16 to
    // utf8 and utf16
    title = utf8.fuse(base64).encode(title);
    var text = element.text;
    text = utf8.fuse(base64).encode(text);
    // time is type int and is an exception
    var time = element.time;

    /// converting this to json format string
    Map<String, dynamic> toJson() => {
          "title": title,
          "text": text,
          "time": time,
        };
    // completing all the string json format to real json
    var my_json = toJson();
    // adding all the string to a list of string with the unicode format .
    my_stringlist.add(json.encode(my_json));
  }
  my_intlist = my_stringlist.toString().codeUnits;
  list.add(my_intlist);
  print(noteBox.length);
  final Stream<List<int>> mediaStream =
      Future.value(my_intlist).asStream().asBroadcastStream();
  var media = new drive.Media(mediaStream, my_intlist.length);
  driveFile.name = file_name;
  driveFile.mimeType = 'text';
  final result = await driveApi.files.create(driveFile, uploadMedia: media);
  String string = "Upload result: $result";
  print("Upload result: $result");
  return string;
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
      title = utf8.fuse(base64).decode(title);
      var text = list[i]['text'];
      text = utf8.fuse(base64).decode(text);
      int time = list[i]['time'];
      noteBox.add(Note(title, text, false, time, 0, time, null));
    }
  });
}

Future<void> login(bool command, BuildContext context) async {
  // command true -> upload
  // command flase -> download
  // At first we think that the file exists
  bool doesEx = true;
  // used to get infromation inside the boxu
  final noteBox = Hive.box<Note>(noteBoxName);
  //used to sign in to google drive
  final _connState = Provider.of<ConnState>(context, listen: false);
  final _signinState = Provider.of<SigninState>(context, listen: false);
  if (noteBox.isEmpty && command != false) {
    uiKit.showAlertDialog(context, "noNotes");
  } else {
    if (!_connState.is_conn) {
      // I am connected to a mobile network or wifi.
      print("No connection has been stablished");
      uiKit.showAlertDialog(context, "internet");
    } else {
      _signinState.checkSignin();
      if (_signinState.isSignedin) {
        // The user is signed in
        final googleSignIn =
            signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
        final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
        // getting the signinded account information
        if (account == null) {
          print("null account : $account ");
          uiKit.showAlertDialog(context, "internet");
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
      } else {
        uiKit.showAlertDialog(context, "signIn");
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
      if (list.files[i].name == file_name) {
        file_id = list.files[i].id;
      }
    }
  });
  return file_id;
}
