import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:todoapp/app/settings/settings_state.dart';

class SettingsLogic extends GetxController {
  SettingsState state = SettingsState();

  Future<void> checkSignIn() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    state.isSignedIn = await googleSignIn.isSignedIn();
  }

  Future<void> signInToAccount() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    if (state.isSignedIn) {
      googleSignIn.signOut();
      state.isSignedIn = false;
    } else {
      state.account = await googleSignIn.signIn();
      if (state.account != null) {
        var head = googleSignIn.currentUser!.authHeaders;
        print('check account $head');
        state.isSignedIn = true;
      }
    }
  }
}
