import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';

import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';

import '../../providers/api/user_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/api/notification_client_provider.dart';
import '../../controllers/notification_controller.dart';

class MineAccountPage extends StatefulWidget {
  const MineAccountPage({super.key});

  @override
  State<MineAccountPage> createState() => _MineAccountPageState();
}

class _MineAccountPageState extends State<MineAccountPage> {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());
  final NotificationController notificationController =
      Get.put(NotificationController());

  void handleGoBack() {
    Get.back();
  }

  void handleGotoPhone() {
    handleGoBack();
    Get.toNamed('/mine_phone_change');
  }

  void handleGotoAgreement() {
    Get.toNamed('/agreement');
  }

  void handleGotoPrivacy() {
    Get.toNamed('/privacy');
  }

  void handleGotoAbout() {
    Get.toNamed('/mine_about');
  }

  void handleLogout() async {
    //清除推送注册id绑定的用户信息
    notificationClientProvider
        .addHistoryUserIdInfo({'registration_id': notificationController.rid});
    //退出登录
    userClientProvider.logoutAction();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    await prefs.remove('user_info_id');
    await prefs.remove('device_uuid');
    userController.setUUID('');
    userController.setToken('');
    userController.setUserInfo(UserTypeModel.fromJson(null));
    userController.setInfo(UserInfoTypeModel.fromJson(null));
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offAllNamed('/login');
    });
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8), // 设置顶部边缘为直角
            ),
          ),
          title: null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 4),
                    child: Center(
                      child: IconFont(
                        IconNames.jingshi,
                        size: 14,
                        color: '#000',
                      ),
                    ),
                  ),
                  const Text(
                    '您确定要退出登录吗？',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                  handleLogout();
                },
                child: const Text(
                  '确认',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                },
                child: const Text(
                  '取消',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void handleShowPhoneSections() {
      showModalBottomSheet(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero, // 设置顶部边缘为直角
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 0, 24, mediaQuerySafeInfo.bottom),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: handleGotoPhone,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.biangeng_1,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('修改手机号',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleGoBack,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.guanbi,
                                    size: 20,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ) // Your form widget here
                    ));
          }).then((value) {});
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    12, mediaQuerySafeInfo.top + 12, 12, 12),
                child: SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: handleGoBack,
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      const Text('账号与安全',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 24, height: 24)
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 2,
                color: Color.fromRGBO(233, 234, 235, 1),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '手机号',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: handleShowPhoneSections,
                                  child: Row(
                                    children: [
                                      GetBuilder<UserController>(
                                          builder: (controller) {
                                        return Text(
                                          controller.userInfo.phone,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        );
                                      }),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        margin: const EdgeInsets.only(left: 12),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.qianjin,
                                            size: 16,
                                            color: 'rgb(156, 156, 156)',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromRGBO(233, 234, 235, 1),
                          ),
                          SizedBox(
                            height: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '微信关联',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 1206,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Center(
                                          child: IconFont(IconNames.weixin,
                                              size: 20),
                                        ),
                                      ),
                                      GetBuilder<UserController>(
                                          builder: (controller) {
                                        return Text(
                                          controller.userInfo.wx_unionid != null
                                              ? '已关联'
                                              : '未关联',
                                          style: TextStyle(
                                              color: controller.userInfo
                                                          .wx_unionid !=
                                                      null
                                                  ? Colors.black
                                                  : const Color.fromRGBO(
                                                      156, 156, 156, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        );
                                      }),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        margin: const EdgeInsets.only(left: 12),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.qianjin,
                                            size: 16,
                                            color: 'rgb(156, 156, 156)',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromRGBO(233, 234, 235, 1),
                          ),
                          SizedBox(
                            height: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Apple账号关联',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 1206,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.apple,
                                            size: 20,
                                            color: 'rgb(47,46,45)',
                                          ),
                                        ),
                                      ),
                                      GetBuilder<UserController>(
                                          builder: (controller) {
                                        return const Text(
                                          '未关联',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  156, 156, 156, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        );
                                      }),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        margin: const EdgeInsets.only(left: 12),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.qianjin,
                                            size: 16,
                                            color: 'rgb(156, 156, 156)',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromRGBO(233, 234, 235, 1),
                          ),
                          SizedBox(
                            height: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '申请注销',
                                  style: TextStyle(
                                      color: Color.fromRGBO(156, 156, 156, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: 72,
                                    width: 120,
                                    color: Colors.white,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Center(
                                          child: IconFont(
                                            IconNames.qianjin,
                                            size: 16,
                                            color: 'rgb(156, 156, 156)',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
          Positioned(
              left: 12,
              bottom: mediaQuerySafeInfo.bottom + 12,
              child: InkWell(
                onTap: showLogoutDialog,
                child: Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(211, 66, 67, 1),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: const Center(
                    child: Text(
                      '退出登录',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
