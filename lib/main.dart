import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './app/home.dart';
import './app/pages/login/login.dart';
import './app/pages/login/agreement.dart';

import './app/middlewares/routeMiddleware.dart';
import './app/middlewares/route.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter绑定初始化
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Try reading data from the 'action' key. If it doesn't exist, returns null.
  final String? token = prefs.getString('token');
  runApp(
      GetMaterialApp(initialRoute: token is String ? '/' : '/login', getPages: [
    GetPage(
      name: '/',
      page: () => const HomePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/agreement', page: () => AgreementPage()),
  ]));
}
