import 'dart:async';
import 'dart:convert';

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
import 'controllers/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './providers/api/user_client_provider.dart';
import './providers/api/notification_client_provider.dart';
import 'package:flutter/services.dart';
import './cache/token_manager.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  final NotificationController notificationController =
      Get.put(NotificationController());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());

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
          notificationClientProvider.addHistoryUserIdInfo({
            'registration_id': notificationController.rid,
            'history_user_id': resultData.id
          }).then((resultIn) {});
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

  Future<String?> checkUserId() async {
    Completer<String?> completer = Completer();
    if (userController.userInfo.id.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId != null) {
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  void getPainNotifications(String userId) async {
    notificationClientProvider
        .findManyPainNotifications(userId: userId, read: 0)
        .then((result) {
      notificationController.setPainNotiicationNum(result.data.totalCount);
      if (notificationController.rid.isNotEmpty) {
        jpush.setBadge(result.data.totalCount);
      }
    }).catchError((e) {});
  }

  void getNotificationsOnce() async {
    final String? userId = await checkUserId();
    print('userId is $userId');
    if (userId != null) {
      getPainNotifications(userId);
    }
  }

  String? debugLable = 'Unknown';
  final JPush jpush = JPush();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
        final String? userId = await checkUserId();
        Future.delayed(const Duration(seconds: 1), () {
          if (userId != null) {
            getPainNotifications(userId);
          }
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
        if (GetPlatform.isIOS) {
          Get.toNamed('/pain_question_detail', arguments: {
            'questionId': message['extras']['question_id'],
            'painNotificationId': message['extras']['id']
          })!
              .then((value) {
            jpush.setBadge(notificationController.painNotiicationNum);
          });
        } else if (GetPlatform.isAndroid) {
          Map<String, dynamic> jsonMap =
              json.decode(message['extras']['cn.jpush.android.EXTRA']);
          final String questionId = jsonMap['question_id'];
          final String painNotificationId = jsonMap['id'];
          Get.toNamed('/pain_question_detail', arguments: {
            'questionId': questionId,
            'painNotificationId': painNotificationId
          })!
              .then((value) {
            jpush.setBadge(notificationController.painNotiicationNum);
          });
        }
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
        setState(() {
          debugLable = "flutter onNotifyMessageUnShow: $message";
        });
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
        setState(() {
          debugLable = "flutter onInAppMessageShow: $message";
        });
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");

        setState(() {
          debugLable = "flutter onInAppMessageClick: $message";
        });
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
        setState(() {
          debugLable = "flutter onConnected: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setAuth(enable: true);
    // Key
    String appKey = dotenv.env['JPUSH_APP_KEY'] ?? '';
    print('appKey is $appKey');
    jpush.setup(
      appKey: appKey, //你自己应用的 AppKey
      channel: "",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
      if (rid.isNotEmpty) {
        notificationController.setRid(rid);
        notificationClientProvider.createPushRegistrationAction({
          'registration_id': rid,
          'platform': GetPlatform.isAndroid
              ? 1
              : GetPlatform.isIOS
                  ? 0
                  : 5
        }).then((result) {
          if (result.code == 200) {
            print('rid 已保存');
            if (userController.userInfo.id.isNotEmpty) {
              notificationClientProvider.addHistoryUserIdInfo({
                'registration_id': notificationController.rid,
                'history_user_id': userController.userInfo.id
              }).then((resultIn) {});
            }
          } else {
            print(result.message);
          }
        });
      }
    });

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  void painNotificationCallback(int num) {
    if (notificationController.rid.isNotEmpty) {
      jpush.setBadge(num);
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
    getNotificationsOnce();

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

    initPlatformState();
  }

  @override
  void dispose() {
    jpush.pageLeave("HomePage");
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
                  children: [
                    KeepAliveWrapper(
                        child: PainPage(
                            painNotificationCallback:
                                painNotificationCallback)),
                    const KeepAliveWrapper(child: RecoveryPage()),
                    const KeepAliveWrapper(child: SizedBox.shrink()),
                    const KeepAliveWrapper(child: StorePage()),
                    KeepAliveWrapper(
                        child: MinePage(
                            painNotificationCallback: painNotificationCallback))
                  ],
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
              )),
        ],
      ),
    );
  }
}
