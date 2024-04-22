import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/pages/pain/pain.dart';
import 'pages/prescription/prescription.dart';
import '../app/pages/store/store.dart';
import '../app/pages/mine/mine.dart';
import '../components/keep_alive_wrapper.dart';
import '../utils/get_device_id.dart';
import 'package:lottie/lottie.dart';
import './models/user_model.dart';
import './controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/api/user_client_provider.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  /// 这里的 Getx 实例必须手动 put
  /// 因为在 GetMaterialApp 中 initialRoute: token is String ? '/' : '/login'
  /// 如果是从登录页过来的，因为初始化页面不是 Home, 会导致这里的 userController 和 userClientProvider 找不到 报错
  final UserController userController = Get.put(UserController());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

  late final AnimationController _animationHomeController;
  late final AnimationController _animationRecoveryController;
  late final AnimationController _animationStoreController;
  late final AnimationController _animationMineController;

  int currentIndex = 0;

  void getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      userController.setToken(token);
      userClientProvider.getUserInfoByJWTAction().then((value) {
        final resultCode = value.code;
        final resultData = value.data;
        if (resultCode == 200 && resultData != null) {
          userController.setUserInfo(resultData);
        }
      }).catchError((e) {});
    }
  }

  void getInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      userController.setToken(token);
      userClientProvider.getInfoByJWTAction().then((value) {
        final resultCode = value.code;
        final resultData = value.data;
        if (resultCode == 200 && resultData != null) {
          userController.setInfo(resultData);
        }
      }).catchError((e) {});
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.red, // 强制状态栏颜色为红色
    ));
    _animationHomeController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 700);
    _animationRecoveryController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 700);
    _animationStoreController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 700);
    _animationMineController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 700);
    //首先执行首页动画
    _animationHomeController.forward();
    getUserInfo();
    getInfo();
  }

  @override
  void dispose() {
    _animationHomeController.dispose();
    _animationRecoveryController.dispose();
    _animationStoreController.dispose();
    _animationMineController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    if (currentIndex == index) {
      return;
    }
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        _animationHomeController.reset();
        _animationHomeController.forward();
        break;
      case 1:
        _animationRecoveryController.reset();
        _animationRecoveryController.forward();
        break;
      case 2:
        _animationStoreController.reset();
        _animationStoreController.forward();
        break;
      case 3:
        _animationMineController.reset();
        _animationMineController.forward();
        break;
      default:
        print('Unknown Tab');
    }
  }

  List<Widget> pages = const [
    KeepAliveWrapper(child: PainPage()),
    KeepAliveWrapper(child: RecoveryPage()),
    KeepAliveWrapper(child: StorePage()),
    KeepAliveWrapper(child: MinePage())
  ];

  @override
  Widget build(BuildContext context) {
    //获取设备信息
    GetDeviceInfo().getDeviceId();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromRGBO(211, 66, 67, 1), //选中的颜色
        type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
        currentIndex: currentIndex,
        onTap: changeTab,
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),
        selectedLabelStyle: const TextStyle(
            fontSize: 12, color: Color.fromRGBO(211, 66, 67, 1)),
        items: [
          BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/home-new.json',
                          fit: BoxFit.contain,
                          repeat: false,
                          controller: _animationHomeController,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Image.asset(
                          'assets/images/tabs/home.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              label: "首页"),
          BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/recovery-new.json',
                          fit: BoxFit.contain,
                          repeat: false,
                          controller: _animationRecoveryController,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Image.asset(
                          'assets/images/tabs/recovery.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              label: "康复"),
          BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/store-new.json',
                          fit: BoxFit.contain,
                          repeat: false,
                          controller: _animationStoreController,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Image.asset(
                          'assets/images/tabs/store.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              label: "商城"),
          BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/mine-new.json',
                          fit: BoxFit.contain,
                          repeat: false,
                          controller: _animationMineController,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: Image.asset(
                          'assets/images/tabs/mine.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              label: "我的")
        ],
      ),
      body: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: IndexedStack(
            index: currentIndex,
            children: pages,
          )),
    );
  }
}
