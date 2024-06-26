import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineProfessionalToolMenu extends StatefulWidget {
  const MineProfessionalToolMenu({super.key});

  @override
  State<MineProfessionalToolMenu> createState() =>
      _MineProfessionalToolMenuState();
}

class _MineProfessionalToolMenuState extends State<MineProfessionalToolMenu> {
  final UserController userController = Get.put(UserController());

  void handleGotoJoint() {
    Get.toNamed('mine_professinal_joint');
  }

  void handleGotoSpine() {
    Get.toNamed('mine_professinal_spine');
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 14,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(195, 77, 73, 1),
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                  ),
                  const Text('专业工具',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: handleGotoJoint,
                child: Container(
                  width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                  height: 54,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        width: 24,
                        height: 24,
                        child: Center(
                          child: IconFont(
                            IconNames.guanjie,
                            size: 24,
                            color: 'rgb(0, 0, 0)',
                          ),
                        ),
                      ),
                      const Text('关节角度',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: handleGotoSpine,
                child: Container(
                  width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                  height: 54,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        width: 24,
                        height: 24,
                        child: Center(
                          child: IconFont(
                            IconNames.jizhu,
                            size: 24,
                            color: 'rgb(0, 0, 0)',
                          ),
                        ),
                      ),
                      const Text('脊柱角度',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
