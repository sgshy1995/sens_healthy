import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: non_constant_identifier_names
void showToast(String msg, {Color? backgroundColor, Color? textColor}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0.8),
      textColor: textColor ?? Colors.white,
      fontSize: 14.0);
}
