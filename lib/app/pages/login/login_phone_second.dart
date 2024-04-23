import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/toast.dart';

import 'dart:typed_data';
import 'dart:convert';
import '../../providers/api/user_client_provider.dart';
import '../../controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 定义回调函数类型
typedef StepCallback = void Function(int step);

class LoginPhoneSecondController extends GetxController {}

class LoginPhoneSecond extends StatelessWidget {
  LoginPhoneSecond(
      {super.key,
      required this.callback,
      required this.initialIsExist,
      required this.phone,
      required this.code}) {
    isExist = initialIsExist.obs;
  }

  late final String phone;
  late final String code;

  final StepCallback callback;

  final bool initialIsExist;
  final RxBool isCooling = true.obs;
  final RxBool sendLoading = false.obs;
  final RxInt coolNumber = 60.obs;
  late final RxBool isExist;

  final RxBool loginLoading = false.obs;

  late final Timer? timer;

  final RxString capture = ''.obs;

  void updateCapture(String newCapture) {
    capture.value = newCapture;
  }

  Future<String?> getUserInfo(String token) async {
    Completer<String?> completer = Completer();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userController.setToken(token);
    userClientProvider.getUserInfoByJWTAction().then((value) {
      final resultCode = value.code;
      final resultData = value.data;
      if (resultCode == 200 && resultData != null) {
        prefs.setString('user_id', resultData.id);
        userController.setUserInfo(resultData);
        completer.complete('success');
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> getInfo(String token) async {
    Completer<String?> completer = Completer();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userController.setToken(token);
    userClientProvider.getInfoByJWTAction().then((value) {
      final resultCode = value.code;
      final resultData = value.data;
      if (resultCode == 200 && resultData != null) {
        prefs.setString('user_info_id', resultData.id);
        userController.setInfo(resultData);
        completer.complete('success');
      }
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  void submit() {
    if (loginLoading.value) {
      return;
    }
    if (capture.value.isEmpty) {
      showToast('请输入短信验证码');
    } else {
      loginLoading.value = true;
      userClientProvider
          .loginAction(userController.uuid, phone, capture.value)
          .then((result) async {
        if (result.code == 200 && result.data != null) {
          final token = result.data!.token;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          userController.setToken(token);
          //等待请求数据完成
          List<Future<String?>> futures = [getUserInfo(token), getInfo(token)];
          // 等待所有异步任务完成
          await Future.wait(futures);
          loginLoading.value = false;
          Get.offAllNamed('/');
        } else {
          loginLoading.value = false;
          showToast(result.message);
        }
      });
    }
  }

  final UserController userController = GetInstance().find<UserController>();

  final Rx<Uint8List> bytes = Rx<Uint8List>(Uint8List(0));

  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();

  void reGetCapture() {
    if (sendLoading.value) {
      return;
    }
    isExist.value = false;
    sendLoading.value = true;
    userClientProvider
        .capturePhoneAction(userController.uuid, phone, code, ifReSend: '1')
        .then((result) {
      sendLoading.value = false;
      print('校验手机和验证码结果: ${result.code}');
      // 移除Base64字符串的前缀
      if (result.code == 201) {
        isCooling.value = true;
        startTimer();
      } else if (result.code == 409) {
        showToast('验证码仍在有效期内');
        isExist.value = true;
        isCooling.value = true;
        startTimer();
      } else {
        showToast(result.message);
      }
    });
  }

  void goBackToPreStep() {
    callback(0);
  }

  void startTimer() {
    try {
      timer?.cancel(); // 取消定时器
    } catch (e) {}
    coolNumber.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timerIn) {
      if (coolNumber.value > 0) {
        coolNumber.value -= 1;
      } else {
        if (timer != null) {
          timer!.cancel(); // 取消定时器
        }
        coolNumber.value = 60;
        isCooling.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCooling.value) {
      startTimer();
    }

    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + mediaQuerySafeInfo.bottom),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const Text('短信验证',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Obx(() => Text(
                        isExist.value ? '您的短信验证码仍在有效期内' : '一条短信验证码已发送至您的手机',
                        style: const TextStyle(
                            color: Color.fromRGBO(38, 38, 38, 1),
                            fontSize: 14))),
                  ),
                ],
              ),
              InkWell(
                onTap: goBackToPreStep,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(239, 239, 239, 1),
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Center(
                    child: IconFont(
                      IconNames.turnback,
                      size: 20,
                      color: '#262626',
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 48,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  autofocus: true, // 设置为 true，使 TextField 自动获取焦点
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 14, // 设置字体大小为20像素
                  ),
                  decoration: InputDecoration(
                    prefixIconColor: const Color.fromRGBO(117, 117, 117, 1),
                    fillColor: const Color.fromRGBO(239, 239, 239, 1),
                    filled: true,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [IconFont(IconNames.paihangbang, size: 18)],
                    ), // 使用图标
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(239, 239, 239, 1)),
                      borderRadius: BorderRadius.circular(10), // 设置圆角大小
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(239, 239, 239, 1)),
                      borderRadius: BorderRadius.circular(10), // 设置圆角大小
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 聚焦状态下边框样式
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(211, 66, 67, 1)),
                      borderRadius: BorderRadius.circular(10), // 设置圆角大小
                    ),
                    hintText: '短信验证码',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0), // 增加垂直内边距来增加高度
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  onChanged: (value) => updateCapture(value),
                )),
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(left: 24),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(239, 239, 239, 1)),
                  child: Obx(() => sendLoading.value
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Color.fromRGBO(117, 117, 117, 1),
                                strokeWidth: 2),
                          ),
                        )
                      : isCooling.value
                          ? Center(
                              child: Center(
                                child: Text(
                                  '$coolNumber秒重试',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(117, 117, 117, 1),
                                      fontSize: 14),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: reGetCapture,
                              child: const Center(
                                child: Text(
                                  '重新发送',
                                  style: TextStyle(
                                      color: Color.fromRGBO(211, 66, 67, 1),
                                      fontSize: 14),
                                ),
                              ),
                            )),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            height: 48,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 222, 88, 1),
                  Color.fromRGBO(252, 169, 119, 1),
                  Color.fromRGBO(251, 144, 134, 1),
                  Color.fromRGBO(211, 66, 67, 1)
                ], // 渐变的起始和结束颜色
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                submit();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.transparent, width: 2)))),
              child: const Center(
                child: Text(
                  '登录',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
