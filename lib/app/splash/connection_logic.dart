import 'package:connectivity/connectivity.dart' as conn;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todoapp/app/splash/connection_state.dart';

class ConnectionLogic extends GetxController {
  ConnectionState state = ConnectionState();
  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }
  Future<void> checkConnection() async {
    var connectivityResult = await conn.Connectivity().checkConnectivity();
    if (connectivityResult == conn.ConnectivityResult.none) {
      state.isConnected = false;
    } else {
      state.isConnected = true;
    }
  }

  Future<void> connSub() async {
    conn.Connectivity().onConnectivityChanged.listen((conn.ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == conn.ConnectivityResult.none) {
        state.isConnected = false;
      } else {
        state.isConnected = true;
      }
    });
  }
}
