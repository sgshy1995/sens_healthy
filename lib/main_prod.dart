import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import './app/pages/pain/pain_search.dart';
import './app/pages/prescription/prescription_section.dart';
import './app/pages/prescription/prescription_detail.dart';
import './app/pages/store/store_course_live_detail.dart';
import './app/pages/store/store_course_video_detail.dart';
import 'app/pages/store/store_course_section.dart';
import 'app/pages/store/store_course_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future main() async {
  await dotenv.load(fileName: ".env.prod"); // 加载生产环境配置
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter绑定初始化
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Try reading data from the 'action' key. If it doesn't exist, returns null.
  final String? token = prefs.getString('token');
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(GetMaterialApp(
        theme: ThemeData(
          // 修改默认进度指示器颜色
          primaryColor: Colors.black, // 修改主题的默认颜色为绿色
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color.fromRGBO(200, 200, 200, 1), // 设置进度指示器的颜色
          ),
        ),
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
          GetPage(
            name: '/pain_search',
            page: () => const PainSearchPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/prescription_section',
            page: () => PrescriptionSectionPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/prescription_detail',
            page: () => const PrescriptionDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_live_detail',
            page: () => const StoreCourseLiveDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_video_detail',
            page: () => const StoreCourseVideoDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_section',
            page: () => const StoreCourseSectionPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_search',
            page: () => const StoreCourseSearchPage(),
            middlewares: [AuthMiddleware()],
          ),
        ],
        initialBinding: HomeBinding()));
  });
}
