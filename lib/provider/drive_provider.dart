import 'package:hive/hive.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/provider/GoogleAuthClient.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'dart:convert';

// This is the file id and the name
// used to upload the file and check wether the file
// exisstce or not and
String file_id_name = "NotesAppg";

Future<void> upload() async {
  // At first we think that the file exists
  bool doesEx = true;
  // file id
  String file_id = null;
  // used to get infromation inside the box
  final noteBox = Hive.box<Note>(noteBoxName);
  // used to sign in to google drive
  print("hshsh");
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
  await driveApi.files.list().then((value) {
    var list = value;
    for (int i = 0; i < list.files.length; i++) {
      if (list.files[i].name == file_id_name) {
        file_id = list.files[i].id;
      }
    }
  });
  // Checking if the file Exists
  // try {
  //   await driveApi.files.get(file_id_name);
  // } catch (err) {
  //   doesEx = false;
  // }

  if (file_id != null) {
    // if the file exists then ask
    // if the user wants to continue and update the file
    print("Exists ");
  } else {
    List<int> my_intlist = [];
    List<String> my_stringlist = [];
    List<List<int>> list = [];
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
    driveFile.name = file_id_name;
    driveFile.mimeType = 'text';
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");
  }
}

Future<void> download() async {
  // At first we think that the file exists
  bool doesEx = true;
  // file id
  String file_id;
  // a list to
  // used to get infromation inside the box
  final noteBox = Hive.box<Note>(noteBoxName);
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
  await driveApi.files.list().then((value) {
    var list = value;
    for (int i = 0; i < list.files.length; i++) {
      if (list.files[i].name == file_id_name) {
        file_id = list.files[i].id;
      }
    }
  });
  drive.Media media = await driveApi.files
      .get(file_id, downloadOptions: drive.DownloadOptions.fullMedia);
  final subescription = media.stream.listen((event) {
    String string = String.fromCharCodes(event);
    var list = json.decode(string);
    for (int i = 0; i < list.length; i++) {
      // list[i] = json.encode(list[i]);
      var title = list[i]['title'];
      var text = list[i]['text'];
      int time = list[i]['time'];
      //print(time  + title + text);
      noteBox.add(Note(title, text, false, time, 0, time));
    }
    // noteBox.add(Note.fromJson(json.decode(string)));
  });
  //print(String.fromCharCodes(pp.stream));
  // Checking if the file Exists
  // try {
  //   await driveApi.files.get(file_id_name);
  // } catch (err) {
  //   doesEx = false;
  // }
  // controling the procces
  if (file_id != null) {
    print("Hell");
  } else {
    // The file not found
    print("Hell2");
  }
}

Future<void> signInFun() {
  // implementing sign in and also the sav to database
}
