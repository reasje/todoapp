import 'package:todoapp/uikit.dart' as uiKit;
import 'package:flutter/material.dart';

Widget MySnackBar(String text){
  return SnackBar(
    elevation: 6.0,
    backgroundColor: uiKit.Colors.lightBlue,
    behavior: SnackBarBehavior.floating,
    content:Text(
        text,
        style: TextStyle(color: uiKit.Colors.darkBlue , fontFamily: 'Iransans'),
      ),
  );
}

