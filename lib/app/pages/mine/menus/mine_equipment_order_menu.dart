import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../controllers/user_controller.dart';

// 定义回调函数类型
typedef ShowDetailCallback = void Function();

class MineEquipmentOrderMenu extends StatefulWidget {
  const MineEquipmentOrderMenu(
      {super.key,
      required this.showDetailCallback,
      required this.equipmentWaitCounts,
      required this.equipmentShippingCounts,
      required this.equipmentReceivedCounts,
      required this.equipmentCanceledCounts});

  final int equipmentWaitCounts;
  final int equipmentShippingCounts;
  final int equipmentReceivedCounts;
  final int equipmentCanceledCounts;

  final ShowDetailCallback showDetailCallback;

  @override
  State<MineEquipmentOrderMenu> createState() => _MineEquipmentOrderMenuState();
}

class _MineEquipmentOrderMenuState extends State<MineEquipmentOrderMenu> {
  final UserController userController = Get.put(UserController());

  void handleGotoOrderPage(int index) {
    Get.toNamed('/mine_equipment_order', arguments: {'initialIndex': index})!
        .then((value) {
      widget.showDetailCallback();
    });
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
                  const Text('器材订单',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ],
              ),
              GestureDetector(
                onTap: () => handleGotoOrderPage(0),
                child: Container(
                  width: 80,
                  height: 16,
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconFont(
                      IconNames.qianjin,
                      size: 16,
                      color: 'rgb(156, 156, 156)',
                    ),
                  ),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => handleGotoOrderPage(0),
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
                                      IconNames.qicai_daifahuo,
                                      size: 24,
                                      color: 'rgb(0, 0, 0)',
                                    ),
                                  ),
                                ),
                                const Text('待发货',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal))
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () => handleGotoOrderPage(1),
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
                                    IconNames.qicai_yifahuo,
                                    size: 24,
                                    color: 'rgb(0, 0, 0)',
                                  ),
                                ),
                              ),
                              const Text('已发货',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleGotoOrderPage(2),
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
                                    IconNames.qicai_yiqianshou,
                                    size: 24,
                                    color: 'rgb(0, 0, 0)',
                                  ),
                                ),
                              ),
                              const Text('已签收',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleGotoOrderPage(3),
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
                                    IconNames.qicai_yiquxiao,
                                    size: 24,
                                    color: 'rgb(0, 0, 0)',
                                  ),
                                ),
                              ),
                              const Text('已取消',
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
              (widget.equipmentWaitCounts > 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 + 10,
                      child: GestureDetector(
                        onTap: () => handleGotoOrderPage(0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.equipmentWaitCounts > 99 ? '99+' : widget.equipmentWaitCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()),
              (widget.equipmentShippingCounts > 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 +
                          10 +
                          ((mediaQuerySizeInfo.width - 24 - 24) / 4) * 1,
                      child: GestureDetector(
                        onTap: () => handleGotoOrderPage(1),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.equipmentShippingCounts > 99 ? '99+' : widget.equipmentShippingCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()),
              (widget.equipmentReceivedCounts > 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 +
                          10 +
                          ((mediaQuerySizeInfo.width - 24 - 24) / 4) * 2,
                      child: GestureDetector(
                        onTap: () => handleGotoOrderPage(2),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.equipmentReceivedCounts > 99 ? '99+' : widget.equipmentReceivedCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()),
              (widget.equipmentCanceledCounts > 0
                  ? Positioned(
                      top: 4,
                      left: ((mediaQuerySizeInfo.width - 24 - 24) / 4) / 2 +
                          10 +
                          ((mediaQuerySizeInfo.width - 24 - 24) / 4) * 3,
                      child: GestureDetector(
                        onTap: () => handleGotoOrderPage(3),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(249, 81, 84, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Center(
                            child: Text(
                              '${widget.equipmentCanceledCounts > 99 ? '99+' : widget.equipmentCanceledCounts}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink())
            ],
          )
        ],
      ),
    );
  }
}
