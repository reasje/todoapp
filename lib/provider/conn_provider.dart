import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart' as conn;

class ConnState extends ChangeNotifier {
  Color conn_color;
  bool is_conn;
  // ConnState() {
  //   //checkConn();
  //   connSub();
  // }
  Future<void> checkConn() async {
    var connectivityResult = await conn.Connectivity().checkConnectivity();
    if (connectivityResult == conn.ConnectivityResult.none) {
      is_conn = false;
    } else {
      is_conn = true;
    }
    notifyListeners();
  }

  Future<void> connSub() async {
    conn.Connectivity()
        .onConnectivityChanged
        .listen((conn.ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == conn.ConnectivityResult.none) {
        is_conn = false;
      } else {
        is_conn = true;
      }
      notifyListeners();
    });
  }
}
