import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class ConnectionState {
  final _isConnected = false.obs;
  set isConnected(bool value) => _isConnected.value = value;
  bool get isConnected => _isConnected.value;
  ConnectionState();
}
