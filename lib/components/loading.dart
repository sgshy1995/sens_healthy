import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading(String text) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskType = EasyLoadingMaskType.custom
    ..textStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 32.0
    ..radius = 10
    ..indicatorColor = Colors.white
    ..contentPadding = const EdgeInsets.all(16)
    ..backgroundColor = Colors.transparent
    ..boxShadow = [
      const BoxShadow(color: Colors.transparent),
    ]
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..indicatorWidget = Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(bottom: 12),
      child: const CircularProgressIndicator(
          color: Color.fromRGBO(255, 255, 255, 1), strokeWidth: 2),
    );
  EasyLoading.show(status: text);
}

void hideLoading() {
  EasyLoading.dismiss();
}
