import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class SettingsState {
    final _isSignedIn = false.obs;
  set isSignedIn(bool value) => _isSignedIn.value = value;
  bool get isSignedIn => _isSignedIn.value;
  Rx<signIn.GoogleSignInAccount?> _account = null.obs;
  set account(signIn.GoogleSignInAccount? value) => _account.value = value;
  signIn.GoogleSignInAccount? get account => _account.value;
  SettingsState();
}
