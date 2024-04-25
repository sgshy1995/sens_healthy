import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import './app/cache/token_manager.dart';
import './app/home.dart';
import './app/pages/login/login.dart';
import './app/pages/login/agreement.dart';
import './app/middlewares/route.dart';
import './app/bindings/home_binding.dart';
import './app/pages/pain/pain_question_detail.dart';
import './app/pages/pain/pain_question_publish.dart';
import './app/pages/pain/pain_search.dart';
import './app/pages/prescription/prescription_section.dart';
import './app/pages/prescription/prescription_detail.dart';
import './app/pages/store/store_course_live_detail.dart';
import './app/pages/store/store_course_video_detail.dart';
import './app/pages/store/store_course_section.dart';
import './app/pages/store/store_course_search.dart';
import './app/pages/store/store_course_chart.dart';
import './app/pages/store/store_course_order.dart';
import './app/pages/store/store_course_order_result.dart';
import './app/pages/store/store_equipment_detail.dart';
import './app/pages/store/store_equipment_section.dart';
import './app/pages/store/store_equipment_search.dart';
import './app/pages/store/store_equipment_chart.dart';
import './app/pages/store/store_equipment_order.dart';
import './app/pages/mine/mine_address.dart';
import './app/pages/mine/mine_address_publish.dart';
import './app/pages/mine/mine_record_publish.dart';
import './app/pages/mine/mine_data.dart';
import './app/pages/mine/mine_setting.dart';
import './app/pages/mine/privacy.dart';
import './app/pages/mine/mine_about.dart';
import './app/pages/mine/mine_account.dart';
import './app/pages/mine/mine_phone_change.dart';
import './app/pages/mine/mine_history.dart';
import './app/pages/mine/mine_balance.dart';
import './app/pages/mine/mine_balance_detail.dart';

Future main() async {
  await dotenv.load(fileName: ".env.dev"); // 加载开发环境配置
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter绑定初始化
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Obtain shared preferences.
  final String? token = await TokenManager.getToken();
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
          GetPage(
            name: '/store_course_chart',
            page: () => const StoreCourseChartPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_order',
            page: () => const StoreCourseOrderPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_course_order_result',
            page: () => const StoreCourseOrderResultPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_equipment_detail',
            page: () => const StoreEquipmentDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_equipment_section',
            page: () => const StoreEquipmentSectionPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_equipment_search',
            page: () => const StoreEquipmentSearchPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_equipment_chart',
            page: () => const StoreEquipmentChartPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/store_equipment_order',
            page: () => const StoreEquipmentOrderPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_address',
            page: () => const MineAddressPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_address_publish',
            page: () => const MineAddressPublishPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_record_publish',
            page: () => const MineRecordPublishPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_data',
            page: () => const MineDataPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_setting',
            page: () => const MineSettingPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/privacy',
            page: () => PrivacyPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_about',
            page: () => const MineAboutPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_account',
            page: () => const MineAccountPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_phone_change',
            page: () => const MinePhoneChangePage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_history',
            page: () => const MineHistoryPage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_balance',
            page: () => const MineBalancePage(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: '/mine_balance_detail',
            page: () => const MineBalanceDetailPage(),
            middlewares: [AuthMiddleware()],
          ),
        ],
        routingCallback: (Routing? routing) {
          if (routing != null && routing.current == '/login') {
            //prefs.remove('token');
          }
        },
        initialBinding: HomeBinding()));
  });
}
