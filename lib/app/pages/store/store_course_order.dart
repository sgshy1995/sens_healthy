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

abstract class StoreAnyCourseTypeModel
    implements StoreLiveCourseTypeModel, StoreVideoCourseTypeModel {}

class StoreCourseOrderPage extends StatefulWidget {
  const StoreCourseOrderPage({super.key});

  @override
  State<StoreCourseOrderPage> createState() => _StoreCourseOrderPageState();
}

class _StoreCourseOrderPageState extends State<StoreCourseOrderPage> {
  // 创建一个滚动控制器
  final ScrollController _scrollController = ScrollController();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();
  final UserController userController = GetInstance().find<UserController>();
  final StoreController storeController = GetInstance().find<StoreController>();
  bool _readyLoad = false;

  bool checkWeixin = true;
  bool checkZhifubao = false;
  bool checkBalance = false;

  void handleCheckWeixin(bool? newValue) {
    setState(() {
      checkWeixin = true;
      checkZhifubao = false;
      checkBalance = false;
    });
  }

  void handleCheckZhifubao(bool? newValue) {
    setState(() {
      checkWeixin = false;
      checkZhifubao = true;
      checkBalance = false;
    });
  }

  void handleCheckBalance(bool? newValue) {
    if (double.parse(userController.info.balance) < totalDiscount) {
      return;
    }
    setState(() {
      checkWeixin = false;
      checkZhifubao = false;
      checkBalance = true;
    });
  }

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

  List<Map<String, dynamic>> courseInOrderIdsList = [];
  List<dynamic> courseInOrderList = [];

  double totalCount = 0;

  double totalDiscount = 0;

  bool checkAll = false;

  List<double> handleCalculateCounts() {
    double totalCountGet = 0;
    double totalDiscountGet = 0;

    List.generate(courseInOrderList.length, (index) {
      totalCountGet += double.parse(courseInOrderList[index].price);
      totalDiscountGet += double.parse(courseInOrderList[index].is_discount == 1
          ? courseInOrderList[index].discount!
          : courseInOrderList[index].price);
    });

    return [totalCountGet, totalDiscountGet];
  }

  void loadCharts() async {
    // 同时执行多个异步任务
    List<Future<DataFinalModel<dynamic>>> futures =
        courseInOrderIdsList.map((item) {
      return item['type'] == 1
          ? storeClientProvider.getCourseLiveByIdAction(item['id'])
          : storeClientProvider.getCourseVideoByIdAction(item['id']);
    }).toList();
    // 等待所有异步任务完成
    final List<DataFinalModel<dynamic>?> results = await Future.wait(futures);
    bool rejectCheck = false;
    final List<dynamic> courseInOrderListGet = [];
    results.asMap().forEach((index, result) {
      // 注意：这里将上传失败的图片也作为违规图片处理
      if (result == null) {
        rejectCheck = true;
      } else if (result.code == 200) {
        courseInOrderListGet.add(result.data);
      } else {
        rejectCheck = true;
      }
    });
    if (!rejectCheck) {
      setState(() {
        courseInOrderList = [...courseInOrderListGet];
        _readyLoad = true;
      });
      final double totalCountGet = handleCalculateCounts()[0];
      final double totalDiscountGet = handleCalculateCounts()[1];

      setState(() {
        totalCount = totalCountGet;
        totalDiscount = totalDiscountGet;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        // 滚动到最底部
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void handleGoBack() {
    Get.back();
  }

  void handleBuy() {
    if (totalCount == 0) {
      return;
    }
    showLoading(checkWeixin
        ? '模拟调取微信支付...'
        : checkZhifubao
            ? '模拟调取支付宝支付...'
            : checkBalance
                ? '扣除余额...'
                : '其他方式支付中...');
    Future.delayed(const Duration(milliseconds: 2000), () {
      hideLoading();
      showLoading('订单生成中...');
      Future.delayed(const Duration(milliseconds: 2000), () {
        hideLoading();
        Get.toNamed('/store_course_order_result', arguments: {
          'result': 'success',
          'orderNo': '2183042024041213490157928557',
          'paymentType': checkWeixin
              ? 'weixin'
              : checkZhifubao
                  ? 'zhifubao'
                  : checkBalance
                      ? 'balance'
                      : 'others',
          'total': totalDiscount.toString()
        })!
            .then((value) {
          Get.back(result: 'success');
        });
      });
    });
  }

  bool _readyRefreshBalance = true;

  void handleRefreshBalance() {
    setState(() {
      _readyRefreshBalance = false;
    });
    userClientProvider.getInfoByJWTAction().then((value) {
      final resultCode = value.code;
      final resultData = value.data;
      if (resultCode == 200 && resultData != null) {
        userController.updateInfoBalance(resultData.balance);
      }
      setState(() {
        _readyRefreshBalance = true;
      });
    }).catchError((e) {
      setState(() {
        _readyRefreshBalance = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    courseInOrderIdsList = Get.arguments;
    loadCharts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    Widget skeleton() {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 36,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Shimmer.fromColors(
                baseColor: const Color.fromRGBO(229, 229, 229, 1),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 44,
                  height: 14,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                children: List.generate(
                    10,
                    (index) => Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 150,
                              width: mediaQuerySizeInfo.width - 24,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 44,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
        body: Column(children: [
      Container(
        padding: EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
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
              const Text('订单支付',
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
      (courseInOrderList.isNotEmpty
          ? Container(
              height: 36,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              color: const Color.fromRGBO(244, 244, 244, 1),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '商品价格可能会发生变化, 请您尽快完成支付。',
                  style: TextStyle(
                      color: Color.fromRGBO(211, 121, 47, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : const SizedBox.shrink()),
      Expanded(
          child: (courseInOrderList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: courseInOrderList.length + 2,
                      itemBuilder: (BuildContext context, int indexOuter) {
                        final int index = indexOuter - 1;
                        return indexOuter == 0
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '商品清单',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : indexOuter == courseInOrderList.length + 1
                                ? Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '支付方式',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 24, 12, 24),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () => handleCheckWeixin(
                                                    !checkWeixin),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 12),
                                                      width: 24,
                                                      height: 24,
                                                      child: Checkbox(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                12), // 设置顶部边缘为直角
                                                          ),
                                                        ),
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.black),
                                                        fillColor: checkWeixin
                                                            ? MaterialStateProperty
                                                                .all(Colors
                                                                    .black)
                                                            : MaterialStateProperty
                                                                .all(Colors
                                                                    .transparent),
                                                        checkColor:
                                                            Colors.white,
                                                        value: checkWeixin,
                                                        onChanged:
                                                            handleCheckWeixin,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Center(
                                                        child: IconFont(
                                                          IconNames
                                                              .zhifu_weixin,
                                                          size: 28,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      '微信支付',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    handleCheckZhifubao(
                                                        !checkZhifubao),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 12),
                                                      width: 24,
                                                      height: 24,
                                                      child: Checkbox(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                12), // 设置顶部边缘为直角
                                                          ),
                                                        ),
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.black),
                                                        fillColor: checkZhifubao
                                                            ? MaterialStateProperty
                                                                .all(Colors
                                                                    .black)
                                                            : MaterialStateProperty
                                                                .all(Colors
                                                                    .transparent),
                                                        checkColor:
                                                            Colors.white,
                                                        value: checkZhifubao,
                                                        onChanged:
                                                            handleCheckZhifubao,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Center(
                                                        child: IconFont(
                                                          IconNames
                                                              .zhifu_zhifubao,
                                                          size: 28,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      '支付宝支付',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              GestureDetector(
                                                onTap: () => handleCheckBalance(
                                                    !checkBalance),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 12),
                                                      width: 24,
                                                      height: 24,
                                                      child: Checkbox(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                12), // 设置顶部边缘为直角
                                                          ),
                                                        ),
                                                        side: BorderSide(
                                                            color: double.parse(
                                                                        userController
                                                                            .info
                                                                            .balance) >=
                                                                    totalDiscount
                                                                ? Colors.black
                                                                : const Color
                                                                    .fromRGBO(
                                                                    191,
                                                                    192,
                                                                    196,
                                                                    1)),
                                                        fillColor: checkBalance
                                                            ? MaterialStateProperty
                                                                .all(Colors
                                                                    .black)
                                                            : MaterialStateProperty
                                                                .all(Colors
                                                                    .transparent),
                                                        checkColor:
                                                            Colors.white,
                                                        value: checkBalance,
                                                        onChanged:
                                                            handleCheckBalance,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Center(
                                                        child: IconFont(
                                                          IconNames.yue,
                                                          size: 28,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      double.parse(userController
                                                                  .info
                                                                  .balance) >=
                                                              totalDiscount
                                                          ? '余额支付'
                                                          : '余额不足',
                                                      style: TextStyle(
                                                          color: double.parse(
                                                                      userController
                                                                          .info
                                                                          .balance) >=
                                                                  totalDiscount
                                                              ? Colors.black
                                                              : const Color
                                                                  .fromRGBO(191,
                                                                  192, 196, 1),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              Row(
                                                children: [
                                                  RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: '余额: ',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          const WidgetSpan(
                                                            child: SizedBox(
                                                                width:
                                                                    4), // 设置间距为10
                                                          ),
                                                          TextSpan(
                                                            text: userController
                                                                .info.balance,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      )),
                                                  const SizedBox(
                                                    height: 12,
                                                    width: 24,
                                                  ),
                                                  (_readyRefreshBalance
                                                      ? GestureDetector(
                                                          onTap:
                                                              handleRefreshBalance,
                                                          child: SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .shuaxin,
                                                                size: 24,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(
                                                          width: 24,
                                                          height: 24,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    strokeWidth:
                                                                        2),
                                                          ),
                                                        )),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      height: 120 / 4 * 3,
                                                      child: CachedNetworkImage(
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8), // 设置圆角
                                                          child: Image(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        width: 120,
                                                        height: 120 / 4 * 3,
                                                        imageUrl:
                                                            '${globalController.cdnBaseUrl}/${courseInOrderList[index].cover}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                      width: 12,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        (courseInOrderList[
                                                                    index]
                                                                is StoreLiveCourseTypeModel
                                                            ? Container(
                                                                height: 20,
                                                                decoration: const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            203,
                                                                            174,
                                                                            241,
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(8))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        6,
                                                                        0,
                                                                        6,
                                                                        0),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width: 18,
                                                                      height:
                                                                          18,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              4),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            IconFont(
                                                                          IconNames
                                                                              .live_fill,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              'rgb(151,63,247)',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                        '直播课',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                151,
                                                                                63,
                                                                                247,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold))
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 20,
                                                                decoration: const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            172,
                                                                            202,
                                                                            239,
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(8))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        6,
                                                                        0,
                                                                        6,
                                                                        0),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width: 18,
                                                                      height:
                                                                          18,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              4),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            IconFont(
                                                                          IconNames
                                                                              .live_fill,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              'rgb(69,141,229)',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                        '视频课',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                69,
                                                                                141,
                                                                                229,
                                                                                1),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold))
                                                                  ],
                                                                ),
                                                              )),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        RichText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                                text: courseInOrderList[
                                                                        index]
                                                                    .title,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14))),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        RichText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '${courseInOrderList[index] is StoreLiveCourseTypeModel ? '面对面康复指导' : '专业能力提升'} · ',
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                TextSpan(
                                                                  text: courseTypeList[
                                                                      courseInOrderList[
                                                                              index]
                                                                          .course_type],
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                )
                                                              ],
                                                            )),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        RichText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      '${courseInOrderList[index] is StoreLiveCourseTypeModel ? '直播次数' : '视频数'}: ',
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${courseInOrderList[index] is StoreLiveCourseTypeModel ? courseInOrderList[index].live_num : courseInOrderList[index].video_num}',
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ((courseInOrderList[index]
                                                                    is StoreLiveCourseTypeModel &&
                                                                courseInOrderList[
                                                                            index]
                                                                        .is_discount ==
                                                                    1) ||
                                                            (courseInOrderList[
                                                                        index]
                                                                    is StoreVideoCourseTypeModel &&
                                                                courseInOrderList[
                                                                            index]
                                                                        .is_discount ==
                                                                    1)
                                                        ? Container(
                                                            height: 24,
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    4, 0, 4, 0),
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1)),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  width: 18,
                                                                  height: 18,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              4),
                                                                  child: Center(
                                                                    child: IconFont(
                                                                        IconNames
                                                                            .pic_discount,
                                                                        size:
                                                                            18),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  courseInOrderList[index]
                                                                              .is_discount ==
                                                                          1
                                                                      ? '折扣 -${(((double.parse(courseInOrderList[index].price) - double.parse(courseInOrderList[index].discount!)) / double.parse(courseInOrderList[index].price)) * 100).round()}%'
                                                                      : "",
                                                                  style: const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          209,
                                                                          120,
                                                                          47,
                                                                          1),
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox(
                                                            height: 12,
                                                            width: 12,
                                                          )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        (courseInOrderList[
                                                                        index]
                                                                    .is_discount ==
                                                                0
                                                            ? Text(
                                                                '¥${courseInOrderList[index].price}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                '¥${courseInOrderList[index].price}',
                                                                style: const TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    decorationThickness:
                                                                        2,
                                                                    decorationColor:
                                                                        Color.fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        (courseInOrderList[
                                                                        index]
                                                                    .is_discount ==
                                                                1
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 12,
                                                                    height: 12,
                                                                  ),
                                                                  Text(
                                                                    '¥${courseInOrderList[index].discount}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            197,
                                                                            124,
                                                                            63,
                                                                            1),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              )
                                                            : const SizedBox
                                                                .shrink())
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      (index != courseInOrderList.length - 1
                                          ? const Divider(
                                              height: 2,
                                              color: Color.fromRGBO(
                                                  233, 234, 235, 1),
                                            )
                                          : const SizedBox.shrink())
                                    ],
                                  );
                      }),
                )
              : _readyLoad
                  ? Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            'assets/images/empty.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text(
                          '暂无订单信息~',
                          style: TextStyle(
                              color: Color.fromRGBO(224, 222, 223, 1),
                              fontSize: 14),
                        )
                      ],
                    ))
                  : skeleton())),
      (courseInOrderList.isNotEmpty
          ? Column(
              children: [
                const Divider(
                  height: 2,
                  color: Color.fromRGBO(233, 234, 235, 1),
                ),
                Container(
                  width: mediaQuerySizeInfo.width,
                  padding: EdgeInsets.fromLTRB(
                      0, 16, 0, 16 + mediaQuerySafeInfo.bottom),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '共${courseInOrderList.length}件',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 8,
                                height: 8,
                              ),
                              RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '合计: ',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: '$totalDiscount',
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(195, 77, 73, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                          (totalDiscount != totalCount
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '已折扣: ',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      187, 127, 74, 1),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${totalCount - totalDiscount}',
                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationThickness: 2,
                                                  color: Color.fromRGBO(
                                                      187, 127, 74, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ))
                                  ],
                                )
                              : const SizedBox.shrink())
                        ],
                      ),
                      const SizedBox(
                        width: 36,
                        height: 36,
                      ),
                      GestureDetector(
                        onTap: handleBuy,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          decoration: totalCount != 0
                              ? const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromRGBO(211, 66, 67, 1),
                                      Color.fromRGBO(211, 66, 67, 0.8),
                                      Color.fromRGBO(211, 66, 67, 0.6)
                                    ], // 渐变的起始和结束颜色
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)))
                              : const BoxDecoration(
                                  color: Color.fromRGBO(244, 244, 245, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                          child: Center(
                            child: Text(
                              '立即购买',
                              style: TextStyle(
                                  color: totalCount != 0
                                      ? Colors.white
                                      : const Color.fromRGBO(188, 190, 194, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : const SizedBox.shrink())
    ]));
  }
}
