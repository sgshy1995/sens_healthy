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

class LoginPhoneController extends GetxController {
  RxInt step = 0.obs;
  RxString phone = ''.obs;
  RxString code = ''.obs;
  final RxBool ifExist = false.obs;
  void _handleChangeStep(
      int stepNew, bool ifExistNew, String phoneNew, String codeNew) {
    phone.value = phoneNew;
    code.value = codeNew;
    ifExist.value = ifExistNew;
    step.value = stepNew;

    print('_handleChangeStep step 变化为: $stepNew');

    update();
  }

  void _handleBackStep(int stepNew) {
    step.value = stepNew;
    print('_handleBackStep step 变化为: $stepNew');
    update();
  }
}

class LoginPhone extends StatelessWidget {
  LoginPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPhoneController>(
        init: LoginPhoneController(), // 在这里初始化控制器
        builder: (controller) {
          return Column(
            children: [
              Visibility(
                visible: controller.step.value == 0,
                child: LoginPhoneFirst(callback: controller._handleChangeStep),
              ),
              Visibility(
                visible: controller.step.value == 1,
                child: LoginPhoneSecond(
                    callback: controller._handleBackStep,
                    initialIsExist: controller.ifExist.value,
                    phone: controller.phone.value,
                    code: controller.code.value),
              ),
            ],
          );
        });
    ;
  }
}
