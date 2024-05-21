import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import '../../../iconfont/icon_font.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/user_client_provider.dart';
import 'login_phone.dart';
import '../../../components/toast.dart';

import '../../../utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/api/notification_client_provider.dart';
import '../../controllers/notification_controller.dart';

import '../../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  /// 这里的 Getx 实例必须手动 put
  /// 如果是从退出登录过来的，会导致这里的 userController 找不到 报错
  final UserController userController = Get.put(UserController());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());

  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeBottomAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideName1Animation;
  late Animation<Offset> _slideName2Animation;

  late bool isChecked;

  void clearLocalRefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user_id');
    prefs.remove('user_info_id');
  }

  final JPush jpush = JPush();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
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
            notificationClientProvider.addHistoryUserIdInfo({
              'registration_id': notificationController.rid
            }).then((resultIn) {});
          } else {
            print(result.message);
          }
        });
      }
    });

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    jpush.pageEnterTo("LoginPage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  //预请求获取网络权限
  void getCapture() async {
    await userClientProvider.captureAction(userController.uuid);
  }

  @override
  void initState() {
    super.initState();
    clearLocalRefs();

    //获取设备信息
    GetDeviceInfo().getDeviceId();

    getCapture();

    isChecked = false;

    _controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller3 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fadeAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.elasticOut, // 应用回弹效果
      ),
    );

    _fadeBottomAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller3,
        curve: Curves.linear, // 应用回弹效果
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.elasticOut, // 应用回弹效果
      ),
    );

    _slideName1Animation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.elasticOut, // 应用回弹效果
      ),
    );

    _slideName2Animation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.elasticOut, // 应用回弹效果
      ),
    );

    _controller1.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller2.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller3.forward();
    });
  }

  @override
  void dispose() {
    jpush.pageLeave("LoginPage");
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
  }

  void loginSuccessCallback() {
    Get.back();
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.off(const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_back.png'),
              fit: BoxFit.cover)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 0, 0, mediaQuerySafeInfo.bottom),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.3),
              Color.fromRGBO(0, 0, 0, 0.5),
              Color.fromRGBO(0, 0, 0, 0.8)
            ], // 渐变的起始和结束颜色
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: mediaQuerySafeInfo.top + 36,
                left: 36,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                      child: Center(
                        child: SizedBox(
                            width: 36,
                            height: 36,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: mediaQuerySafeInfo.top + 36 + 64 + 24,
                left: 36,
                child: SlideTransition(
                  position: _slideName1Animation,
                  child: SvgPicture.asset('assets/images/name1.svg',
                      height: 20, semanticsLabel: 'Acme Logo'),
                )),
            Positioned(
                top: mediaQuerySafeInfo.top + 36 + 64 + 24 + 20 + 12,
                left: 36,
                child: SlideTransition(
                  position: _slideName2Animation,
                  child: SvgPicture.asset('assets/images/name2.svg',
                      height: 20, semanticsLabel: 'Acme Logo 1'),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FadeTransition(
                  opacity: _fadeBottomAnimation,
                  child: Container(
                    width: mediaQuerySizeInfo.width,
                    padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          height: 40,
                          child: ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () {
                              if (!isChecked) {
                                showToast('请阅读并同意用户协议');
                              } else {
                                showModalBottomSheet(
                                    backgroundColor:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    isScrollControlled: true,
                                    context: Get.context!,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: LoginPhone(
                                                  loginSuccessCallback:
                                                      loginSuccessCallback) // Your form widget here
                                              ));
                                    });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconFont(IconNames.phone, size: 18),
                                Container(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: const Text(
                                    '手机号登录',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 36,
                                  child: Divider(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  width: 4,
                                  child: const Divider(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                                const SizedBox(
                                  width: 36,
                                  child: Divider(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        side: BorderSide(
                                            color:
                                                Color.fromRGBO(38, 220, 117, 1),
                                            width: 2)))),
                            onPressed: () {},
                            child: Center(
                              child: IconFont(IconNames.weixin, size: 18),
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 0),
                                  width: 32,
                                  height: 32,
                                  child: Checkbox(
                                    side: const BorderSide(color: Colors.white),
                                    fillColor: isChecked
                                        ? MaterialStateProperty.all(
                                            Colors.white)
                                        : MaterialStateProperty.all(
                                            Colors.transparent),
                                    checkColor: Colors.black,
                                    value: isChecked,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isChecked = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        child: const Text(
                                          '已阅读并同意',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              decorationStyle:
                                                  TextDecorationStyle.solid),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          Get.toNamed('/agreement');
                                        });
                                      },
                                      child: const Text(
                                        '用户服务协议',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.white,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            decorationStyle:
                                                TextDecorationStyle.solid),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
