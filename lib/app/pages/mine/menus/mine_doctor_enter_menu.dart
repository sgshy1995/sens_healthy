import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

// 定义回调函数类型
typedef EnterCallback = void Function();

class MineDoctorEnterMenu extends StatefulWidget {
  const MineDoctorEnterMenu(
      {super.key, required this.booksLength, required this.enterCallback});

  final int booksLength;

  final EnterCallback enterCallback;

  @override
  State<MineDoctorEnterMenu> createState() => _MineDoctorEnterMenuState();
}

class _MineDoctorEnterMenuState extends State<MineDoctorEnterMenu> {
  final UserController userController = Get.put(UserController());

  void handleGotoDoctorPage() {
    Get.toNamed('mine_doctor')!.then((value) {
      widget.enterCallback();
    });
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
                      Color.fromRGBO(0, 0, 0, 1),
                      Color.fromRGBO(0, 0, 0, 0.9),
                      Color.fromRGBO(0, 0, 0, 0.8)
                    ], // 渐变的起始和结束颜色
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 12),
                        child: Center(
                          child: IconFont(
                            IconNames.doctor_enter,
                            size: 20,
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
                  Row(
                    children: [
                      widget.booksLength > 0
                          ? Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(249, 81, 84, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                              margin: const EdgeInsets.only(right: 12),
                              child: Center(
                                child: Text(
                                  '${widget.booksLength > 99 ? '99+' : widget.booksLength}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
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
