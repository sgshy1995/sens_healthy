import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/toast.dart';

import 'dart:typed_data';
import 'dart:convert';
import '../../providers/api/user_client_provider.dart';
import '../../controllers/user_controller.dart';

import './login_phone_first.dart';
import './login_phone_second.dart';

// 定义回调函数类型
typedef LoginSuccessCallback = void Function();

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key, required this.loginSuccessCallback});

  final LoginSuccessCallback loginSuccessCallback;

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  int step = 0;
  String phone = '';
  String code = '';
  bool ifExist = false;

  void handleChangeStep(
      int stepNew, bool ifExistNew, String phoneNew, String codeNew) {
    setState(() {
      phone = phoneNew;
      code = codeNew;
      ifExist = ifExistNew;
      step = stepNew;
    });

    print('_handleChangeStep step 变化为: $stepNew');
  }

  void handleBackStep(int stepNew) {
    setState(() {
      step = stepNew;
    });
    print('_handleBackStep step 变化为: $stepNew');
  }

  void loginSuccessCallback() {
    widget.loginSuccessCallback();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: step == 0,
          child: LoginPhoneFirstPage(callback: handleChangeStep),
        ),
        Visibility(
          visible: step == 1,
          child: LoginPhoneSecond(
              callback: handleBackStep,
              initialIsExist: ifExist,
              phone: phone,
              code: code,
              loginSuccessCallback: loginSuccessCallback),
        ),
      ],
    );
  }
}
