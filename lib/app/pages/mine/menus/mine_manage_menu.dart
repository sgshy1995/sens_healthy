import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineManageMenu extends StatefulWidget {
  const MineManageMenu({super.key});

  @override
  State<MineManageMenu> createState() => _MineManageMenuState();
}

class _MineManageMenuState extends State<MineManageMenu> {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void handleGoToAddress() {
      Get.toNamed('/mine_address');
    }

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
                  const Text('管理',
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
                onTap: handleGoToAddress,
                child: SizedBox(
                  width: (mediaQuerySizeInfo.width - 24 - 24) / 4,
                  height: 54,
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
                            IconNames.shouhuodizhi,
                            size: 24,
                            color: 'rgb(0, 0, 0)',
                          ),
                        ),
                      ),
                      const Text('收货地址',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
