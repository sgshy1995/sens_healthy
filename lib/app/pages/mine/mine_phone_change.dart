import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/toast.dart';

import '../../../iconfont/icon_font.dart';
import '../../../utils/validate.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';

import '../../providers/api/user_client_provider.dart';

import '../../providers/api/user_client_provider.dart';
import '../../models/pain_model.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';

class MinePhoneChangePage extends StatefulWidget {
  const MinePhoneChangePage({super.key});

  @override
  State<MinePhoneChangePage> createState() => _MinePhoneChangePageState();
}

class _MinePhoneChangePageState extends State<MinePhoneChangePage> {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  final TextEditingController _textControllerPhone = TextEditingController();
  final TextEditingController _textControllerCode = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  String? phoneInputValue;

  String? codeInputValue;

  void handleGoBack() {
    Get.back();
  }

  void changePhoneInput(String? value) {
    setState(() {
      phoneInputValue = value;
    });
    checkIfCanPublish();
  }

  void changeCodeInput(String? value) {
    setState(() {
      codeInputValue = value;
    });
    checkIfCanPublishCode();
  }

  bool publishCheck = false;

  bool sendLoading = false;

  bool reSendLoading = false;

  bool ifNextStep = false;

  bool publishCheckCode = false;

  bool submitLoading = false;

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //手机号是否正确和是否填写
    if (phoneInputValue == null ||
        phoneInputValue!.isEmpty ||
        !validatePhoneRegExp(phoneInputValue!)) {
      publishCheckGet = false;
    }
    if (publishCheck != publishCheckGet) {
      setState(() {
        publishCheck = publishCheckGet;
      });
    }
  }

  void checkIfCanPublishCode() {
    bool publishCheckGet = true;
    //验证码是否填写
    if (codeInputValue == null || codeInputValue!.isEmpty) {
      publishCheckGet = false;
    }
    if (publishCheckCode != publishCheckGet) {
      setState(() {
        publishCheckCode = publishCheckGet;
      });
    }
  }

  bool isCooling = false;

  int coolNumber = 60;

  Timer? timer;

  void startTimer() {
    try {
      timer?.cancel(); // 取消定时器
    } catch (e) {}
    setState(() {
      isCooling = true;
      coolNumber = 60;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timerIn) {
      if (coolNumber > 0) {
        setState(() {
          coolNumber -= 1;
        });
      } else {
        if (timer != null) {
          timer!.cancel(); // 取消定时器
        }
        setState(() {
          coolNumber = 60;
          isCooling = false;
        });
      }
    });
  }

  void handleGetCode() {
    if (!publishCheck || sendLoading) {
      return;
    }
    setState(() {
      sendLoading = true;
    });
    userClientProvider
        .getCapturePhoneChangeAction(userController.uuid, phoneInputValue!,
            userController.userInfo.username)
        .then((result) {
      print('校验手机和验证码结果: ${result.code}');
      // 移除Base64字符串的前缀
      if (result.code == 201) {
        setState(() {
          ifNextStep = true;
        });
        startTimer();
      } else if (result.code == 409) {
        showToast('您的验证码仍在有效期内');
        setState(() {
          ifNextStep = true;
        });
        startTimer();
      } else {
        showToast(result.message);
      }
      setState(() {
        sendLoading = false;
      });
    });
  }

  void handleReGetCode() {
    if (!reSendLoading) {
      return;
    }
    setState(() {
      reSendLoading = true;
    });
    userClientProvider
        .getCapturePhoneChangeAction(userController.uuid, phoneInputValue!,
            userController.userInfo.username)
        .then((result) {
      print('校验手机和验证码结果: ${result.code}');
      // 移除Base64字符串的前缀
      if (result.code == 201) {
        startTimer();
      } else if (result.code == 409) {
        showToast('您的验证码仍在有效期内');
        startTimer();
      } else {
        showToast(result.message);
      }
      setState(() {
        reSendLoading = false;
      });
    });
  }

  void handleConfirmChange() {
    if (!publishCheckCode || submitLoading) {
      return;
    }
    setState(() {
      submitLoading = true;
    });
    userClientProvider.updateUserByJwtAction({'phone': phoneInputValue},
        deviceId: userController.uuid,
        phoneCapture: codeInputValue).then((result) {
      // 移除Base64字符串的前缀
      if (result.code == 200) {
        userClientProvider.getUserInfoByJWTAction().then((resultIn) {
          if (resultIn.code == 200 && resultIn.data != null) {
            userController.setUserInfo(resultIn.data!);
            if (timer != null) {
              timer!.cancel(); // 取消定时器
            }
            setState(() {
              submitLoading = false;
            });
            showToast('手机号已更新');
            Get.back();
          } else {
            setState(() {
              submitLoading = false;
            });
            showToast('获取用户信息失败');
          }
        }).catchError((e1) {
          setState(() {
            submitLoading = false;
          });
          showToast('操作失败, 请稍后再试');
        });
      } else {
        showToast(result.message);
        setState(() {
          submitLoading = false;
        });
      }
    }).catchError((e) {
      showToast('操作失败, 请稍后再试');
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _textControllerPhone.dispose();
    _textControllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(children: [
      Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
        child: SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              )
            ],
          ),
        ),
      ),
      const Divider(
        height: 2,
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      Expanded(
          child: Container(
              color: Colors.white,
              height: mediaQuerySizeInfo.height -
                  12 -
                  (mediaQuerySafeInfo.top + 12) -
                  36 -
                  2,
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  const SizedBox(height: 12),
                  Visibility(
                      visible: !ifNextStep,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '请输入要更换的新手机号',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  focusNode: _focusNode1,
                                  onTapOutside: (PointerDownEvent p) {
                                    // 点击外部区域时取消焦点
                                    _focusNode1.unfocus();
                                  },
                                  autofocus: true,
                                  controller: _textControllerPhone,
                                  maxLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                      fontSize: 15, // 设置字体大小为20像素
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 15),
                                    fillColor:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    filled: true, // 使用图标
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(4), // 设置圆角大小
                                    ),
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    hintText: '11位大陆手机号',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 12.0), // 增加垂直内边距来增加高度
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11)
                                  ],
                                  onChanged: changePhoneInput,
                                )),
                                GestureDetector(
                                  onTap: handleGetCode,
                                  child: Container(
                                    height: 32,
                                    width: 120,
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    margin: const EdgeInsets.only(left: 24),
                                    decoration: BoxDecoration(
                                        color: sendLoading
                                            ? const Color.fromRGBO(0, 0, 0, 0.5)
                                            : publishCheck
                                                ? Colors.black
                                                : const Color.fromRGBO(
                                                    244, 244, 245, 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                      child: sendLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  strokeWidth: 2),
                                            )
                                          : Text(
                                              '获取验证码',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: publishCheck
                                                      ? Colors.white
                                                      : const Color.fromRGBO(
                                                          188, 190, 194, 1)),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  Visibility(
                      visible: ifNextStep,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '短信验证码已发送至您的新手机号',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  focusNode: _focusNode2,
                                  onTapOutside: (PointerDownEvent p) {
                                    // 点击外部区域时取消焦点
                                    _focusNode2.unfocus();
                                  },
                                  autofocus: true,
                                  controller: _textControllerCode,
                                  maxLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                      fontSize: 15, // 设置字体大小为20像素
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 15),
                                    fillColor:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    filled: true, // 使用图标
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(4), // 设置圆角大小
                                    ),
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    hintText: '请输入验证码',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 12.0), // 增加垂直内边距来增加高度
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6)
                                  ],
                                  onChanged: changeCodeInput,
                                )),
                                (!isCooling
                                    ? GestureDetector(
                                        onTap: handleReGetCode,
                                        child: Container(
                                          height: 32,
                                          width: 120,
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
                                          margin:
                                              const EdgeInsets.only(left: 24),
                                          decoration: BoxDecoration(
                                              color: reSendLoading
                                                  ? const Color.fromRGBO(
                                                      0, 0, 0, 0.5)
                                                  : Colors.black,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                          child: Center(
                                            child: reSendLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            strokeWidth: 2),
                                                  )
                                                : const Text(
                                                    '重新获取',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 32,
                                        width: 120,
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 0),
                                        margin: const EdgeInsets.only(left: 24),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                244, 244, 245, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Center(
                                          child: Text(
                                            '$coolNumber秒重新获取',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    188, 190, 194, 1)),
                                          ),
                                        ),
                                      ))
                              ],
                            )
                          ],
                        ),
                      )),
                  const SizedBox(height: 48),
                  ifNextStep
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: InkWell(
                            onTap: handleConfirmChange,
                            child: Container(
                              width: mediaQuerySizeInfo.width - 24,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: submitLoading
                                      ? const Color.fromRGBO(0, 0, 0, 0.5)
                                      : publishCheckCode
                                          ? Colors.black
                                          : const Color.fromRGBO(
                                              244, 244, 245, 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: Center(
                                child: submitLoading
                                    ? const SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: CircularProgressIndicator(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            strokeWidth: 2),
                                      )
                                    : Text(
                                        '确定修改',
                                        style: TextStyle(
                                            color: publishCheckCode
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    188, 190, 194, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ))))
    ]));
  }
}
