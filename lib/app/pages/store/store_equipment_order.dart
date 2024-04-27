import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sens_healthy/app/models/user_model.dart';
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

class StoreEquipmentOrderPage extends StatefulWidget {
  const StoreEquipmentOrderPage({super.key});

  @override
  State<StoreEquipmentOrderPage> createState() =>
      _StoreEquipmentOrderPageState();
}

class _StoreEquipmentOrderPageState extends State<StoreEquipmentOrderPage> {
  // 创建一个滚动控制器
  final ScrollController _scrollController = ScrollController();
  final GlobalController globalController = Get.put(GlobalController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final UserController userController = Get.put(UserController());
  final StoreController storeController = Get.put(StoreController());
  bool _readyLoad = false;

  bool checkWeixin = true;
  bool checkZhifubao = false;
  bool checkBalance = false;

  AddressInfoTypeModel? selectAddressInfo;

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

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];

  List<int> addNumsList = [];
  List<String> chartInIdsList = [];
  List<String> modelsIdsList = [];
  List<String> userIdsList = [];
  List<StoreEquipmentTypeModel> equipmentsList = [];

  final String orderTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  //待定单拟购物车聚合列表
  List<StoreEquipmentChartPolymerizationTypeModel>
      equipmentChartPolymerizationList = [];

  double totalCount = 0;
  double totalDiscount = 0;
  int totalAddNum = 0;

  bool checkAll = false;

  int handleCalculateTotalAddNum() {
    int totalAddNumGet = 0;

    List.generate(equipmentChartPolymerizationList.length, (index) {
      List.generate(
          equipmentChartPolymerizationList[index].equipment_model_infos.length,
          (indexIn) {
        totalAddNumGet +=
            equipmentChartPolymerizationList[index].add_nums[indexIn];
      });
    });

    return totalAddNumGet;
  }

  List<double> handleCalculateCounts() {
    double totalCountGet = 0;
    double totalDiscountGet = 0;

    List.generate(equipmentChartPolymerizationList.length, (index) {
      List.generate(
          equipmentChartPolymerizationList[index].equipment_model_infos.length,
          (indexIn) {
        totalDiscountGet += (equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .inventory <=
                0
            ? 0
            : equipmentChartPolymerizationList[index]
                        .equipment_model_infos[indexIn]
                        .is_discount ==
                    1
                ? (double.parse(equipmentChartPolymerizationList[index]
                        .equipment_model_infos[indexIn]
                        .discount!) *
                    equipmentChartPolymerizationList[index].add_nums[indexIn])
                : (double.parse(equipmentChartPolymerizationList[index]
                        .equipment_model_infos[indexIn]
                        .price) *
                    equipmentChartPolymerizationList[index].add_nums[indexIn]));
        totalCountGet += (equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .inventory <=
                0
            ? 0
            : (double.parse(equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .price) *
                equipmentChartPolymerizationList[index].add_nums[indexIn]));
      });
    });

    return [totalCountGet, totalDiscountGet];
  }

  void loadCharts() async {
    List<StoreEquipmentChartPolymerizationTypeModel>
        equipmentChartPolymerizationListGet = [];

    // 同时执行多个异步任务
    List<Future<DataFinalModel<StoreEquipmentInModelTypeModel>>> futures =
        modelsIdsList.map((id) {
      return storeClientProvider.getModelByIdAction(id);
    }).toList();
    // 等待所有异步任务完成
    final List<DataFinalModel<dynamic>?> results = await Future.wait(futures);
    bool rejectCheck = false;
    final List<StoreEquipmentInModelTypeModel> modelsListGet = [];
    results.asMap().forEach((index, result) {
      if (result == null) {
        rejectCheck = true;
      } else if (result.code == 200) {
        modelsListGet.add(result.data);
      } else {
        rejectCheck = true;
      }
    });

    if (!rejectCheck) {
      //遍历生成聚合数组
      List.generate(modelsListGet.length, (index) {
        if (equipmentChartPolymerizationListGet.firstWhereOrNull(
                (polymerization) =>
                    polymerization.equipment_id ==
                    modelsListGet[index].equipment_id) ==
            null) {
          equipmentChartPolymerizationListGet.add(
              StoreEquipmentChartPolymerizationTypeModel(
                  equipment_id: modelsListGet[index].equipment_id,
                  chart_ids: [''],
                  user_id: userIdsList[index],
                  equipment_model_ids: [modelsListGet[index].id],
                  add_nums: [addNumsList[index]],
                  status_list: [modelsListGet[index].status],
                  equipment_info: equipmentsList[index],
                  equipment_model_infos: [modelsListGet[index]]));
        } else {
          final int indexFind = equipmentChartPolymerizationListGet.indexWhere(
              (polymerization) =>
                  polymerization.equipment_id ==
                  modelsListGet[index].equipment_id);
          equipmentChartPolymerizationListGet[indexFind].chart_ids.add('');
          equipmentChartPolymerizationListGet[indexFind]
              .equipment_model_ids
              .add(modelsListGet[index].id);
          equipmentChartPolymerizationListGet[indexFind]
              .add_nums
              .add(addNumsList[index]);
          equipmentChartPolymerizationListGet[indexFind]
              .status_list
              .add(modelsListGet[index].status);
          equipmentChartPolymerizationListGet[indexFind]
              .equipment_model_infos
              .add(modelsListGet[index]);
        }
      });

      setState(() {
        equipmentChartPolymerizationList = [
          ...equipmentChartPolymerizationListGet
        ];
        _readyLoad = true;
      });

      final double totalCountGet = handleCalculateCounts()[0];
      final double totalDiscountGet = handleCalculateCounts()[1];
      final int totalAddNumGet = handleCalculateTotalAddNum();

      setState(() {
        totalCount = totalCountGet;
        totalDiscount = totalDiscountGet;
        totalAddNum = totalAddNumGet;
      });

      if (userController.info.default_address_id != null) {
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
  }

  void handleGoBack() {
    Get.back();
  }

  void handleBuy() {
    if (totalCount == 0) {
      return;
    }
    if (userController.info.default_address_id == null) {
      showToast('请选择配送地址');
      // 滚动到最顶部
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
      showLoading('请稍后...');
      final Map<String, dynamic> form = {
        'equipment_info': {
          'equipment_ids': equipmentsList.map((e) => e.id).join(','),
          'model_ids': modelsIdsList.join(','),
          'order_nums': addNumsList.join(','),
          'payment_num': totalDiscount.toString()
        },
        'shipping_address': userController.info.default_address_info.all_text,
        'shipping_name': userController.info.default_address_info.name,
        'shipping_phone': userController.info.default_address_info.phone,
        'order_time': orderTime,
        'payment_type': checkWeixin
            ? 1
            : checkZhifubao
                ? 2
                : checkBalance
                    ? 0
                    : 3
      };

      if (chartInIdsList.isNotEmpty) {
        form['equipment_chart_ids'] = chartInIdsList.join(',');
      }

      storeClientProvider.addEquipmentOrderByUserIdAction(form).then((result) {
        if (result.code == 200) {
          userClientProvider.getInfoByJWTAction().then((resultIn) {
            if (resultIn.code == 200 && resultIn.data != null) {
              userController.setInfo(resultIn.data!);
              hideLoading();
              Get.toNamed('/store_course_order_result', arguments: {
                'result': 'success',
                'orderNo': result.data!.order_no,
                'paymentType': checkWeixin
                    ? 'weixin'
                    : checkZhifubao
                        ? 'zhifubao'
                        : checkBalance
                            ? 'balance'
                            : 'others',
                'total': result.data!.payment_num
              })!
                  .then((value) {
                Get.back(result: 'success');
              });
            } else {
              hideLoading();
              showToast(result.message);
            }
          }).catchError((e) {
            print('e1 $e');
            hideLoading();
            showToast('请求失败, 请稍后再试');
          });
        } else {
          hideLoading();
          showToast(result.message);
        }
      }).catchError((e) {
        print('e2 $e');
        hideLoading();
        showToast('请求失败, 请稍后再试');
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

  void handleGotoAddress() {
    Get.toNamed('/mine_address', arguments: {
      'ifCanSelect': true,
      'selectId': selectAddressInfo?.id
    })!
        .then((value) {
      if (value is AddressInfoTypeModel) {
        setState(() {
          selectAddressInfo = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    modelsIdsList = Get.arguments['models'];
    chartInIdsList = Get.arguments['charts'] ?? [];
    addNumsList = Get.arguments['addNums'];
    userIdsList = Get.arguments['userIds'];
    equipmentsList = Get.arguments['equipments'];
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
      (equipmentChartPolymerizationList.isNotEmpty
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
          child: (equipmentChartPolymerizationList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: equipmentChartPolymerizationList.length + 2,
                      itemBuilder: (BuildContext context, int indexOuter) {
                        final int index = indexOuter - 1;
                        int itemTotalAddNum = 0;
                        if (equipmentChartPolymerizationList.length > index &&
                            index > -1) {
                          List.generate(
                              equipmentChartPolymerizationList[index]
                                  .add_nums
                                  .length, (indexIn) {
                            itemTotalAddNum +=
                                equipmentChartPolymerizationList[index]
                                    .add_nums[indexIn];
                          });
                        }
                        return indexOuter == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    const Text(
                                      '配送地址',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child:
                                          userController.info
                                                      .default_address_id ==
                                                  null
                                              ? GestureDetector(
                                                  onTap: handleGotoAddress,
                                                  child: Container(
                                                    height: 48,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          '请选择地址',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                          height: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child: Center(
                                                            child: IconFont(
                                                              IconNames.qianjin,
                                                              size: 16,
                                                              color: '#000',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: handleGotoAddress,
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              width:
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      48 -
                                                                      12 -
                                                                      24 -
                                                                      12 -
                                                                      16,
                                                              child: RichText(
                                                                  maxLines: 99,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  text: TextSpan(
                                                                      text: selectAddressInfo !=
                                                                              null
                                                                          ? selectAddressInfo!
                                                                              .all_text
                                                                          : userController
                                                                              .info
                                                                              .default_address_info
                                                                              .all_text,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontSize:
                                                                              14)))),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                selectAddressInfo != null
                                                                    ? selectAddressInfo!
                                                                        .name
                                                                    : userController
                                                                        .info
                                                                        .default_address_info
                                                                        .name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                                width: 12,
                                                              ),
                                                              Text(
                                                                  selectAddressInfo !=
                                                                          null
                                                                      ? selectAddressInfo!
                                                                          .phone
                                                                      : userController
                                                                          .info
                                                                          .default_address_info
                                                                          .phone,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                              const SizedBox(
                                                                height: 12,
                                                                width: 12,
                                                              ),
                                                              ((selectAddressInfo ==
                                                                              null &&
                                                                          userController.info.default_address_info.tag !=
                                                                              null) ||
                                                                      (selectAddressInfo !=
                                                                              null &&
                                                                          selectAddressInfo!.tag !=
                                                                              null)
                                                                  ? Container(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          6,
                                                                          0,
                                                                          6,
                                                                          0),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(
                                                                              8)),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.black)),
                                                                      child:
                                                                          Text(
                                                                        selectAddressInfo !=
                                                                                null
                                                                            ? selectAddressInfo!.tag!
                                                                            : userController.info.default_address_info.tag!,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 13),
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink())
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 24,
                                                        height: 12,
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: Center(
                                                          child: IconFont(
                                                            IconNames.qianjin,
                                                            size: 16,
                                                            color: '#000',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '商品清单',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : indexOuter ==
                                    equipmentChartPolymerizationList.length + 1
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                            '${globalController.cdnBaseUrl}/${equipmentChartPolymerizationList[index].equipment_info!.cover}',
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
                                                        RichText(
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                                text: equipmentChartPolymerizationList[
                                                                        index]
                                                                    .equipment_info!
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
                                                                  text: equipmentTypeList[equipmentChartPolymerizationList[
                                                                          index]
                                                                      .equipment_info!
                                                                      .equipment_type],
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
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          '共 $itemTotalAddNum 件',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Text(
                                                    '已选择型号 · ${equipmentChartPolymerizationList[index].equipment_model_infos.length}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14)),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      equipmentChartPolymerizationList[
                                                              index]
                                                          .equipment_model_infos
                                                          .length, (indexIn) {
                                                    final List<String>
                                                        multiFigureList =
                                                        equipmentChartPolymerizationList[
                                                                index]
                                                            .equipment_model_infos[
                                                                indexIn]
                                                            .multi_figure
                                                            .split(',');
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 70,
                                                              height: 70,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8), // 设置圆角
                                                                  child: Image(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                width: 70,
                                                                height: 70,
                                                                imageUrl:
                                                                    '${globalController.cdnBaseUrl}/${multiFigureList[0]}',
                                                                fit: BoxFit
                                                                    .cover,
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
                                                                RichText(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    text: TextSpan(
                                                                        text: equipmentChartPolymerizationList[index]
                                                                            .equipment_model_infos[
                                                                                indexIn]
                                                                            .title,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 13))),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    (equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].is_discount ==
                                                                            0
                                                                        ? Text(
                                                                            '¥${equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].price}',
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          )
                                                                        : Text(
                                                                            '¥${equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].price}',
                                                                            style: const TextStyle(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                decorationThickness: 2,
                                                                                decorationColor: Color.fromRGBO(200, 200, 200, 1),
                                                                                color: Color.fromRGBO(200, 200, 200, 1),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          )),
                                                                    (equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].is_discount ==
                                                                            1
                                                                        ? Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                width: 12,
                                                                                height: 12,
                                                                              ),
                                                                              Text(
                                                                                '¥${equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].discount}',
                                                                                style: const TextStyle(color: Color.fromRGBO(197, 124, 63, 1), fontSize: 13, fontWeight: FontWeight.bold),
                                                                              )
                                                                            ],
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink())
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  'x ${equipmentChartPolymerizationList[index].add_nums[indexIn]} 件',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: indexIn !=
                                                                  equipmentChartPolymerizationList[
                                                                              index]
                                                                          .equipment_model_infos
                                                                          .length -
                                                                      1
                                                              ? 12
                                                              : 0,
                                                        )
                                                      ],
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      (index !=
                                              equipmentChartPolymerizationList
                                                      .length -
                                                  1
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
      (equipmentChartPolymerizationList.isNotEmpty
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
                                '共$totalAddNum件',
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
