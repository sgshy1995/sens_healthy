import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

class MineRecordMenu extends StatefulWidget {
  const MineRecordMenu({super.key});

  @override
  State<MineRecordMenu> createState() => _MineRecordMenuState();
}

class _MineRecordMenuState extends State<MineRecordMenu> {
  final UserController userController = GetInstance().find<UserController>();

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
                  const Text('伤痛档案',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ],
              ),
              (userController.info.injury_history == null ||
                      userController.info.injury_history!.isEmpty
                  ? Row(
                      children: [
                        const Text('未维护',
                            style: TextStyle(
                                color: Color.fromRGBO(156, 156, 156, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(left: 8),
                          child: Center(
                            child: IconFont(
                              IconNames.qianjin,
                              size: 16,
                              color: 'rgb(156, 156, 156)',
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Text('已维护',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(left: 8),
                          child: Center(
                            child: IconFont(
                              IconNames.qianjin,
                              size: 16,
                              color: 'rgb(156, 156, 156)',
                            ),
                          ),
                        ),
                      ],
                    ))
            ],
          )
        ],
      ),
    );
  }
}
