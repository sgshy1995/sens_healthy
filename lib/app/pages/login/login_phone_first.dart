import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/toast.dart';

import 'dart:typed_data';
import 'dart:convert';
import '../../providers/api/user_client_provider.dart';
import '../../controllers/user_controller.dart';
import '../../../utils/validate.dart';

// 定义回调函数类型
typedef StepCallback = void Function(
    int step, bool ifExist, String phone, String code);

class LoginPhoneFirstPage extends StatefulWidget {
  const LoginPhoneFirstPage({super.key, required this.callback});
  final StepCallback callback;

  @override
  State<LoginPhoneFirstPage> createState() => _LoginPhoneFirstPageState();
}

class _LoginPhoneFirstPageState extends State<LoginPhoneFirstPage> {
  String phone = '';
  String code = '';
  bool sendLoaing = false;

  void updatePhone(String newText) {
    setState(() {
      phone = newText;
    });
  }

  void updateCode(String newText) {
    setState(() {
      code = newText;
    });
  }

  void submit() {
    if (phone.isEmpty || !validatePhoneRegExp(phone)) {
      showToast('请输入正确的手机号');
    } else if (code.isEmpty) {
      showToast('请输入验证码');
    } else {
      authPhoneAndCapture();
    }
  }

  final UserController userController = Get.put(UserController());

  Uint8List bytes = Uint8List(0);

  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

  void getCapture() {
    setState(() {
      bytes = Uint8List(0);
    });
    userClientProvider.captureAction(userController.uuid).then((value) {
      // 移除Base64字符串的前缀
      final String base64Str = value.split(',').last;
      // 解码
      setState(() {
        bytes = base64.decode(base64Str);
      });
    });
  }

  void authPhoneAndCapture() {
    if (sendLoaing) {
      return;
    }
    setState(() {
      sendLoaing = true;
    });
    userClientProvider
        .capturePhoneAction(userController.uuid, phone, code, ifReSend: '0')
        .then((result) {
      print('校验手机和验证码结果: ${result.code}');
      // 移除Base64字符串的前缀
      if (result.code == 201) {
        widget.callback(1, false, phone, code);
      } else if (result.code == 409) {
        widget.callback(1, true, phone, code);
      } else {
        showToast(result.message);
      }
      setState(() {
        sendLoaing = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCapture();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + mediaQuerySafeInfo.bottom),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: const Text('欢迎回来',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: const Text('仅支持中国大陆手机号登录',
                style: TextStyle(
                    color: Color.fromRGBO(38, 38, 38, 1), fontSize: 14)),
          ),
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 24),
            child: TextField(
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
                  children: [IconFont(IconNames.dianhua, size: 18)],
                ), // 使用图标
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(239, 239, 239, 1)),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(239, 239, 239, 1)),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
                focusedBorder: OutlineInputBorder(
                  // 聚焦状态下边框样式
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(211, 66, 67, 1)),
                  borderRadius: BorderRadius.circular(10), // 设置圆角大小
                ),
                hintText: '手机号',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4.0), // 增加垂直内边距来增加高度
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11)
              ],
              onChanged: (value) => updatePhone(value),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 48,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
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
                    hintText: '验证码',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0), // 增加垂直内边距来增加高度
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4)
                  ],
                  onChanged: (value) => updateCode(value),
                )),
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(left: 24),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(239, 239, 239, 1)),
                  child: bytes.isEmpty
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Color.fromRGBO(117, 117, 117, 1),
                                strokeWidth: 2),
                          ),
                        )
                      : InkWell(
                          onTap: getCapture,
                          child: Center(
                            child: Image.memory(
                              bytes,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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
              child: Center(
                child: sendLoaing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            strokeWidth: 2),
                      )
                    : const Text(
                        '下一步',
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
