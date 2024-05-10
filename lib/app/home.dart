import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../app/pages/pain/pain.dart';
import '../iconfont/icon_font.dart';
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

import './cache/token_manager.dart';

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

  late final AnimationController _animationCenterController;
  late final Animation<double> _animationCenter;

  int currentIndex = 0;

  void getUserInfo() async {
    final String? token = await TokenManager.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      userController.setToken(token);
      userClientProvider.getUserInfoByJWTAction().then((value) {
        final resultCode = value.code;
        final resultData = value.data;
        if (resultCode == 200 && resultData != null) {
          prefs.setString('user_id', resultData.id);
          userController.setUserInfo(resultData);
        }
      }).catchError((e) {});
    }
  }

  void getInfo() async {
    final String? token = await TokenManager.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      userController.setToken(token);
      userClientProvider.getInfoByJWTAction().then((value) {
        final resultCode = value.code;
        final resultData = value.data;
        if (resultCode == 200 && resultData != null) {
          prefs.setString('user_info_id', resultData.id);
          userController.setInfo(resultData);
        }
      }).catchError((e) {});
    }
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.red, // 强制状态栏颜色为红色
    // ));
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

    _animationCenterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animationCenter =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationCenterController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationCenterController.reverse();
            }
          });

    Future.delayed(const Duration(seconds: 1), () {
      _animationCenterController.forward();
    });
  }

  @override
  void dispose() {
    _animationHomeController.dispose();
    _animationRecoveryController.dispose();
    _animationStoreController.dispose();
    _animationMineController.dispose();
    _animationCenterController.dispose();
    super.dispose();
  }

  bool centerCool = false;

  void handleGotoCenterPage() {
    if (centerCool) {
      return;
    }
    _animationCenterController.duration = const Duration(milliseconds: 50);
    setState(() {
      centerCool = true;
    });
    _animationCenterController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationCenterController.duration = const Duration(milliseconds: 300);
      setState(() {
        centerCool = false;
      });
      Get.toNamed('/center');
    });
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
        break;
      case 3:
        _animationStoreController.reset();
        _animationStoreController.forward();
        break;
      case 4:
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
    KeepAliveWrapper(child: SizedBox.shrink()),
    KeepAliveWrapper(child: StorePage()),
    KeepAliveWrapper(child: MinePage())
  ];

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    //获取设备信息
    GetDeviceInfo().getDeviceId();

    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              fixedColor: const Color.fromRGBO(211, 66, 67, 1), //选中的颜色
              type:
                  BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
              currentIndex: currentIndex,
              onTap: changeTab,
              unselectedLabelStyle: const TextStyle(
                  fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),
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
                const BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 26,
                      height: 26,
                      child: SizedBox.shrink(),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: currentIndex == 3
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
                    icon: currentIndex == 4
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
          ),
          Positioned(
              left: mediaQuerySizeInfo.width / 2 -
                  (mediaQuerySizeInfo.width / 5 / 2),
              bottom: 0,
              child: Container(
                width: mediaQuerySizeInfo.width / 5,
                height: mediaQuerySafeInfo.bottom + 56,
                color: Colors.transparent,
                padding: EdgeInsets.only(bottom: mediaQuerySafeInfo.bottom),
                child: GestureDetector(
                  onTap: handleGotoCenterPage,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationCenter,
                      builder: (BuildContext context, Widget? child) {
                        return ScaleTransition(
                            scale: _animationCenter,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(211, 66, 67, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Center(
                                child:
                                    IconFont(IconNames.xuexizhongxin, size: 24),
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
