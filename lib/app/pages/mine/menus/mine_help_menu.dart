import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineHelpMenu extends StatefulWidget {
  const MineHelpMenu({super.key});

  @override
  State<MineHelpMenu> createState() => _MineHelpMenuState();
}

class _MineHelpMenuState extends State<MineHelpMenu> {
  final UserController userController = Get.put(UserController());

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
                  const Text('咨询与帮助',
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
              SizedBox(
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
                          IconNames.shiyongbangzhu,
                          size: 24,
                          color: 'rgb(0, 0, 0)',
                        ),
                      ),
                    ),
                    const Text('使用帮助',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
              SizedBox(
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
                          IconNames.kefuyushouhou,
                          size: 24,
                          color: 'rgb(0, 0, 0)',
                        ),
                      ),
                    ),
                    const Text('客服与售后',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ),
              SizedBox(
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
                          IconNames.shangwuhezuo,
                          size: 24,
                          color: 'rgb(0, 0, 0)',
                        ),
                      ),
                    ),
                    const Text('商务合作',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
