import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:googleapis/drive/v3.dart' as drive;

class SigninState extends ChangeNotifier {
  bool isSignedin;
  signIn.GoogleSignInAccount account;
  Future<void> checkSignin() async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    isSignedin = await googleSignIn.isSignedIn();
    notifyListeners();
  }

  Future<void> signinToAccount() async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    if (isSignedin) {
      googleSignIn.signOut();
      isSignedin = false;
    } else {
      account = await googleSignIn.signIn();
      if (account != null) {
        var head = googleSignIn.currentUser.authHeaders;
        print('check account $head');
        isSignedin = true;
      }
    }

    notifyListeners();
  }
}
