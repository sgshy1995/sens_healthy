import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineDoctorEnterMenu extends StatefulWidget {
  const MineDoctorEnterMenu({super.key});

  @override
  State<MineDoctorEnterMenu> createState() => _MineDoctorEnterMenuState();
}

class _MineDoctorEnterMenuState extends State<MineDoctorEnterMenu> {
  final UserController userController = Get.put(UserController());

  void handleGotoDoctorPage() {
    Get.toNamed('mine_doctor');
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: handleGotoDoctorPage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(211, 66, 67, 1),
                      Color.fromRGBO(211, 66, 67, 0.8),
                      Color.fromRGBO(211, 66, 67, 0.7)
                    ], // 渐变的起始和结束颜色
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        child: Center(
                          child: IconFont(
                            IconNames.doctor_enter,
                            size: 24,
                            color: 'rgb(255, 255, 255)',
                          ),
                        ),
                      ),
                      const Text('康复医师入口',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Center(
                      child: IconFont(
                        IconNames.qianjin,
                        size: 16,
                        color: 'rgb(255, 255, 255)',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
