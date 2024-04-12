import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import '../../models/store_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/data_model.dart';
import '../../../components/long_press_menu.dart';

class StoreCourseOrderResultPage extends StatefulWidget {
  const StoreCourseOrderResultPage({super.key});

  @override
  State<StoreCourseOrderResultPage> createState() =>
      _StoreCourseOrderResultPageState();
}

class _StoreCourseOrderResultPageState
    extends State<StoreCourseOrderResultPage> {
  String result = '';
  String orderNo = '';
  String total = '';
  String paymentType = '';
  void handleGoBack() {
    Get.back(result: 'success');
  }

  @override
  void initState() {
    super.initState();
    result = Get.arguments['result'];
    orderNo = Get.arguments['orderNo'];
    total = Get.arguments['total'];
    paymentType = Get.arguments['paymentType'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(246, 246, 246, 1),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
              child: SizedBox(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: InkWell(
                        onTap: handleGoBack,
                        child: Center(
                          child: IconFont(
                            IconNames.fanhui,
                            size: 24,
                            color: '#000',
                          ),
                        ),
                      ),
                    ),
                    const Text('支付结果',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 24, height: 24)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
              color: Color.fromRGBO(233, 234, 235, 1),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    12, 12, 12, mediaQuerySafeInfo.bottom + 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 340,
                      child: Stack(
                        children: [
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 200 - 24) / 2,
                              top: 60,
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  238, 236, 248, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                        )),
                                    Positioned(
                                        top: 30,
                                        left: 30,
                                        child: Container(
                                          width: 140,
                                          height: 140,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  214, 213, 233, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(70))),
                                        )),
                                    Positioned(
                                        top: 60,
                                        left: 60,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color.fromRGBO(
                                                      102, 126, 234, 1),
                                                  Color.fromRGBO(
                                                      118, 75, 162, 1)
                                                ], // 渐变的起始和结束颜色
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: Center(
                                            child: SizedBox(
                                              width: 36,
                                              height: 36,
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.duigou,
                                                  size: 36,
                                                  color: 'rgb(255,255,255)',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              )),
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 200 - 24) / 2 -
                                  10,
                              top: 50,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Color.fromRGBO(253, 238, 234, 1)),
                                child: Center(
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.zixingche,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 200 - 24) / 2 -
                                  50,
                              top: 160,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Color.fromRGBO(255, 240, 193, 1)),
                                child: Center(
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.jianshenke,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 24) / 2 + 20,
                              top: 235,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Color.fromRGBO(233, 231, 243, 1)),
                                child: Center(
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.tubiaozhizuomoban,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 24) / 2 + 90,
                              top: 140,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Color.fromRGBO(233, 231, 243, 1)),
                                child: Center(
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.jianji,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: (mediaQuerySizeInfo.width - 24) / 2 + 80,
                              top: 20,
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35)),
                                    color: Color.fromRGBO(222, 218, 234, 1)),
                                child: Center(
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.xiaidekecheng,
                                        size: 44,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '恭喜您, 支付成功!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Center(
                                  child: IconFont(
                                    IconNames.a_yinhangkadaizhifuzhifu,
                                    size: 24,
                                    color: 'rgb(211, 66, 67)',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                                height: 12,
                              ),
                              const Text(
                                '支付信息',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            height: 2,
                            color: Color.fromRGBO(233, 234, 235, 1),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '支付金额',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '¥ $total',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '支付方式',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                paymentType == 'weixin'
                                    ? '微信支付'
                                    : paymentType == 'zhifubao'
                                        ? '支付宝支付'
                                        : paymentType == 'balance'
                                            ? '余额支付'
                                            : '其他支付',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '订单号',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              LongPressMenu(
                                copyContent: orderNo,
                                child: Text(
                                  orderNo,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '订单状态',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                result == 'success'
                                    ? '已支付'
                                    : result == 'error'
                                        ? '未支付成功'
                                        : '等待支付',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: handleGoBack,
                      child: Container(
                        height: 42,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(211, 66, 67, 1),
                              Color.fromRGBO(211, 66, 67, 0.8),
                              Color.fromRGBO(211, 66, 67, 0.6)
                            ], // 渐变的起始和结束颜色
                          ),
                        ),
                        child: const Center(
                            child: Text(
                          '返回',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
