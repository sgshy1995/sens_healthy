import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app/home.dart';
import './app/pages/login/login.dart';
import './app/pages/login/agreement.dart';
import './app/middlewares/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './app/bindings/home_binding.dart';
import 'package:intl/date_symbol_data_local.dart';
import './app/pages/pain/pain_question_detail.dart';
import './app/pages/pain/pain_question_publish.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future main() async {
  await dotenv.load(fileName: ".env.dev"); // 加载开发环境配置
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter绑定初始化
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Try reading data from the 'action' key. If it doesn't exist, returns null.
  final String? token = prefs.getString('token');
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(GetMaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        initialRoute: token is String ? '/' : '/login',
        getPages: [
          GetPage(
            name: '/',
            page: () => const HomePage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/agreement', page: () => AgreementPage()),
          GetPage(
            name: '/pain_question_detail',
            page: () => const PainQuestionDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/pain_question_publish',
            page: () => const PainQuestionPublishPage(),
            middlewares: [AuthMiddleware()],
          ),
        ],
        initialBinding: HomeBinding()));
  });
}
