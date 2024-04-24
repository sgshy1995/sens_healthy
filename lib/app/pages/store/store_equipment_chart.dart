import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
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
import '../../../components/number_select.dart';

class StoreEquipmentChartPage extends StatefulWidget {
  const StoreEquipmentChartPage({super.key});

  @override
  State<StoreEquipmentChartPage> createState() =>
      _StoreEquipmentChartPageState();
}

class _StoreEquipmentChartPageState extends State<StoreEquipmentChartPage> {
  final GlobalController globalController = Get.put(GlobalController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final UserController userController = Get.put(UserController());
  final StoreController storeController = Get.put(StoreController());
  bool _readyLoad = false;

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];

  //购物车数据列表
  List<StoreEquipmentChartTypeModel> equipmentChartList = [];

  //购物车聚合列表
  List<StoreEquipmentChartPolymerizationTypeModel>
      equipmentChartPolymerizationList = [];

  List<bool> equipmentChartCheckList = [];

  List<List<bool>> equipmentModelsChartCheckList = [];

  List<String> equimentChartChooseList = [];

  int _counter = 1;

  void handleChangeCounter(int value, int indexOuter, int index) {
    showLoading('请稍后...');
    storeClientProvider
        .updateEquipmentChartAddNum(
            equipmentChartPolymerizationList[indexOuter].chart_ids[index],
            value)
        .then((value) {
      hideLoading();
      if (value.code == 200) {
        loadCharts(ifNeedCheck: true);
      } else {
        showToast(value.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败，请稍后再试');
    });
  }

  double totalCount = 0;

  double totalDiscount = 0;

  int checkCanBuyModelsNum = 0;

  int checkCanBuyAddNumsNum = 0;

  bool checkAll = false;

  void handleCalculateModelsNum() {
    int checkCanBuyModelsNumGet = 0;
    equipmentModelsChartCheckList.asMap().forEach((index, value) {
      equipmentModelsChartCheckList[index].asMap().forEach((indexIn, valueIn) {
        if (equipmentModelsChartCheckList[index][indexIn] &&
            equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .inventory >
                0) {
          checkCanBuyModelsNumGet++;
        }
      });
    });
    setState(() {
      checkCanBuyModelsNum = checkCanBuyModelsNumGet;
    });
  }

  void handleCalculateAddNum() {
    int checkCanBuyAddNumsNumGet = 0;
    equipmentModelsChartCheckList.asMap().forEach((index, value) {
      equipmentModelsChartCheckList[index].asMap().forEach((indexIn, valueIn) {
        if (equipmentModelsChartCheckList[index][indexIn] &&
            equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .inventory >
                0) {
          checkCanBuyAddNumsNumGet +=
              equipmentChartPolymerizationList[index].add_nums[indexIn];
        }
      });
    });
    setState(() {
      checkCanBuyAddNumsNum = checkCanBuyAddNumsNumGet;
    });
  }

  void handleCheckItem(bool? newValue, int index) {
    List<bool> equipmentChartCheckListGet = [...equipmentChartCheckList];
    List<List<bool>> equipmentModelsChartCheckListGet = [
      ...equipmentModelsChartCheckList
    ];

    bool checkAllGet = checkAll;

    equipmentChartCheckListGet[index] = newValue!;
    checkAllGet = equipmentChartCheckListGet.every((element) => element);

    equipmentModelsChartCheckListGet[index].asMap().forEach((indexIn, value) {
      equipmentModelsChartCheckListGet[index][indexIn] =
          equipmentChartCheckListGet[index];
    });

    final double totalCountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[0];
    final double totalDiscountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[1];

    setState(() {
      equipmentChartCheckList = [...equipmentChartCheckListGet];
      equipmentModelsChartCheckList = [...equipmentModelsChartCheckListGet];
      checkAll = checkAllGet;
      totalCount = totalCountGet;
      totalDiscount = totalDiscountGet;
    });

    handleCalculateModelsNum();
    handleCalculateAddNum();
  }

  void handleCheckItemIn(bool? newValue, int indexOuter, int index) {
    List<bool> equipmentChartCheckListGet = [...equipmentChartCheckList];
    List<List<bool>> equipmentModelsChartCheckListGet = [
      ...equipmentModelsChartCheckList
    ];

    bool checkAllGet = checkAll;

    equipmentModelsChartCheckListGet[indexOuter][index] = newValue!;

    bool outerCheck = true;

    equipmentModelsChartCheckListGet[indexOuter]
        .asMap()
        .forEach((index1, value1) {
      if (!equipmentModelsChartCheckListGet[indexOuter][index1] &&
          equipmentChartPolymerizationList[indexOuter]
                  .equipment_model_infos[index1]
                  .inventory >
              0) {
        outerCheck = false;
      }
    });

    equipmentChartCheckListGet[indexOuter] = outerCheck;
    checkAllGet = equipmentChartCheckListGet.every((element) => element);

    final double totalCountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[0];
    final double totalDiscountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[1];

    setState(() {
      equipmentChartCheckList = [...equipmentChartCheckListGet];
      equipmentModelsChartCheckList = [...equipmentModelsChartCheckListGet];
      checkAll = checkAllGet;
      totalCount = totalCountGet;
      totalDiscount = totalDiscountGet;
    });

    handleCalculateModelsNum();
    handleCalculateAddNum();
  }

  void handleCheckAll(bool? newValue) {
    if (equipmentChartPolymerizationList.isEmpty) {
      return;
    }
    bool checkAllGet = newValue!;
    List<bool> equipmentChartCheckListGet = [...equipmentChartCheckList];
    List<List<bool>> equipmentModelsChartCheckListGet = [
      ...equipmentModelsChartCheckList
    ];

    if (checkAllGet) {
      List.generate(equipmentChartCheckListGet.length, (index) {
        equipmentChartCheckListGet[index] = true;
        List.generate(equipmentModelsChartCheckListGet[index].length,
            (indexIn) {
          equipmentModelsChartCheckListGet[index][indexIn] = true;
        });
      });
    } else {
      List.generate(equipmentChartCheckListGet.length, (index) {
        equipmentChartCheckListGet[index] = false;
        List.generate(equipmentModelsChartCheckListGet[index].length,
            (indexIn) {
          equipmentModelsChartCheckListGet[index][indexIn] = false;
        });
      });
    }

    final double totalCountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[0];
    final double totalDiscountGet =
        handleCalculateCounts(equipmentModelsChartCheckListGet)[1];

    setState(() {
      equipmentChartCheckList = [...equipmentChartCheckListGet];
      equipmentModelsChartCheckList = [...equipmentModelsChartCheckListGet];
      checkAll = checkAllGet;
      totalCount = totalCountGet;
      totalDiscount = totalDiscountGet;
    });

    handleCalculateModelsNum();
    handleCalculateAddNum();
  }

  List<double> handleCalculateCounts(
      List<List<bool>> equipmentModelsChartCheckListGet) {
    double totalCountGet = 0;
    double totalDiscountGet = 0;

    List.generate(equipmentChartPolymerizationList.length, (index) {
      List.generate(equipmentModelsChartCheckListGet[index].length, (indexIn) {
        if (equipmentModelsChartCheckListGet[index][indexIn]) {
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
                      equipmentChartPolymerizationList[index]
                          .add_nums[indexIn]));
          totalCountGet += (equipmentChartPolymerizationList[index]
                      .equipment_model_infos[indexIn]
                      .inventory <=
                  0
              ? 0
              : (double.parse(equipmentChartPolymerizationList[index]
                      .equipment_model_infos[indexIn]
                      .price) *
                  equipmentChartPolymerizationList[index].add_nums[indexIn]));
        }
      });
    });

    return [totalCountGet, totalDiscountGet];
  }

  Future<String> loadCharts({bool ifNeedCheck = false}) {
    Completer<String> completer = Completer();

    List<String> equipmentModelsChartCheckeHistoryIdsList = [];

    List<StoreEquipmentChartPolymerizationTypeModel>
        equipmentChartPolymerizationListGet = [];

    if (ifNeedCheck) {
      List.generate(equipmentModelsChartCheckList.length, (index) {
        List.generate(equipmentModelsChartCheckList[index].length, (indexIn) {
          if (equipmentModelsChartCheckList[index][indexIn]) {
            equipmentModelsChartCheckeHistoryIdsList.add(
                equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .id);
          }
        });
      });
    }
    storeClientProvider.getEquipmentChartListAction().then((value) {
      completer.complete('success');
      storeController.setStoreEquipmentChartNum(
          value.data != null ? value.data!.length : 0);

      List<bool> equipmentChartCheckListGet = [];
      List<List<bool>> equipmentModelsChartCheckListGet = [];

      List<StoreEquipmentChartTypeModel> equipmentChartListGet =
          value.data ?? [];

      //遍历生成聚合数组
      List.generate(equipmentChartListGet.length, (index) {
        if (equipmentChartPolymerizationListGet.firstWhereOrNull(
                (polymerization) =>
                    polymerization.equipment_id ==
                    equipmentChartListGet[index].equipment_id) ==
            null) {
          equipmentChartPolymerizationListGet.add(
              StoreEquipmentChartPolymerizationTypeModel(
                  equipment_id: equipmentChartListGet[index].equipment_id,
                  chart_ids: [equipmentChartListGet[index].id],
                  user_id: equipmentChartListGet[index].user_id,
                  equipment_model_ids: [
                    equipmentChartListGet[index].equipment_model_id
                  ],
                  add_nums: [equipmentChartListGet[index].add_num],
                  status_list: [equipmentChartListGet[index].status],
                  equipment_info: equipmentChartListGet[index].equipment_info,
                  equipment_model_infos: [
                    equipmentChartListGet[index].equipment_model_info!
                  ]));
        } else {
          final int indexFind = equipmentChartPolymerizationListGet.indexWhere(
              (polymerization) =>
                  polymerization.equipment_id ==
                  equipmentChartListGet[index].equipment_id);
          equipmentChartPolymerizationListGet[indexFind]
              .chart_ids
              .add(equipmentChartListGet[index].id);
          equipmentChartPolymerizationListGet[indexFind]
              .equipment_model_ids
              .add(equipmentChartListGet[index].equipment_model_id);
          equipmentChartPolymerizationListGet[indexFind]
              .add_nums
              .add(equipmentChartListGet[index].add_num);
          equipmentChartPolymerizationListGet[indexFind]
              .status_list
              .add(equipmentChartListGet[index].status);
          equipmentChartPolymerizationListGet[indexFind]
              .equipment_model_infos
              .add(equipmentChartListGet[index].equipment_model_info!);
        }
      });

      List.generate(equipmentChartPolymerizationListGet.length, (index) {
        equipmentChartCheckListGet.add(false);
        equipmentModelsChartCheckListGet.add(List.generate(
            equipmentChartPolymerizationListGet[index]
                .equipment_model_infos
                .length,
            (index) => false));
      });

      if (ifNeedCheck) {
        List.generate(equipmentChartPolymerizationListGet.length, (index) {
          List.generate(
              equipmentChartPolymerizationListGet[index]
                  .equipment_model_infos
                  .length, (indexIn) {
            if (equipmentModelsChartCheckeHistoryIdsList.contains(
                equipmentChartPolymerizationListGet[index]
                    .equipment_model_infos[indexIn]
                    .id)) {
              equipmentModelsChartCheckListGet[index][indexIn] = true;
            }
          });
        });

        List.generate(equipmentModelsChartCheckListGet.length, (index) {
          bool outerCheck = true;
          equipmentModelsChartCheckListGet[index]
              .asMap()
              .forEach((indexIn, valueIn) {
            if (!equipmentModelsChartCheckListGet[index][indexIn] &&
                equipmentChartPolymerizationListGet[index]
                        .equipment_model_infos[indexIn]
                        .inventory >
                    0) {
              outerCheck = false;
            }
          });
          equipmentChartCheckListGet[index] = outerCheck;
        });

        if (equipmentChartCheckListGet.every((element) => element)) {
          setState(() {
            checkAll = true;
          });
        }
      }

      setState(() {
        equipmentChartPolymerizationList = [];
      });

      setState(() {
        equipmentChartCheckList = [...equipmentChartCheckListGet];
        equipmentModelsChartCheckList = [...equipmentModelsChartCheckListGet];
        equipmentChartPolymerizationList = [
          ...equipmentChartPolymerizationListGet
        ];
        equipmentChartList = [...equipmentChartListGet];
        _readyLoad = true;
      });

      final double totalCountGet =
          handleCalculateCounts(equipmentModelsChartCheckListGet)[0];
      final double totalDiscountGet =
          handleCalculateCounts(equipmentModelsChartCheckListGet)[1];

      setState(() {
        totalCount = totalCountGet;
        totalDiscount = totalDiscountGet;
      });

      handleCalculateModelsNum();
      handleCalculateAddNum();
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  void handleGoToEquipmentDetail(String equipmentId) {
    Get.toNamed('/store_equipment_detail',
        arguments: {'equipmentId': equipmentId});
  }

  void handleGoBack() {
    Get.back();
  }

  void showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8), // 设置顶部边缘为直角
            ),
          ),
          title: null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 4),
                    child: Center(
                      child: IconFont(
                        IconNames.jingshi,
                        size: 14,
                        color: '#000',
                      ),
                    ),
                  ),
                  const Text(
                    '您确定要清空器材购物车吗？',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                  handleClearEquipmentChart();
                },
                child: const Text(
                  '确认',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                },
                child: const Text(
                  '取消',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleClearEquipmentChart() {
    showLoading('请稍后...');
    storeClientProvider.deleteEquipmentChartsByUserAction().then((value) {
      if (value.code == 200) {
        loadCharts().then((value) {
          hideLoading();
        });
      } else {
        hideLoading();
        showToast(value.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败，请稍后再试');
    });
  }

  void handleDeleteCharts(List<String> chartIds) {
    showLoading('请稍后...');
    storeClientProvider
        .deleteEquipmentChartsByIdsAction(chartIds)
        .then((value) {
      if (value.code == 200) {
        loadCharts(ifNeedCheck: true).then((value) {
          hideLoading();
        });
      } else {
        hideLoading();
        showToast(value.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败，请稍后再试');
    });
  }

  void handleGoToOrder() {
    if (totalCount == 0) {
      return;
    }
    List<String> chartIdsList = [];
    List<String> modelsIdsList = [];
    List<int> addNumsList = [];
    List<String> userIdsList = [];
    List<StoreEquipmentTypeModel> equipmentsList = [];
    List.generate(equipmentModelsChartCheckList.length, (index) {
      List.generate(equipmentModelsChartCheckList[index].length, (indexIn) {
        if (equipmentModelsChartCheckList[index][indexIn] &&
            equipmentChartPolymerizationList[index]
                    .equipment_model_infos[indexIn]
                    .inventory >
                0) {
          modelsIdsList.add(equipmentChartPolymerizationList[index]
              .equipment_model_infos[indexIn]
              .id);
          chartIdsList
              .add(equipmentChartPolymerizationList[index].chart_ids[indexIn]);
          addNumsList
              .add(equipmentChartPolymerizationList[index].add_nums[indexIn]);
          userIdsList.add(equipmentChartPolymerizationList[index].user_id);
          equipmentsList
              .add(equipmentChartPolymerizationList[index].equipment_info!);
        }
      });
    });
    Get.toNamed('store_equipment_order', arguments: {
      'models': modelsIdsList,
      'charts': chartIdsList,
      'addNums': addNumsList,
      'userIds': userIdsList,
      'equipments': equipmentsList
    })!
        .then((value) {
      if (value == 'success') {
        showLoading('请稍后...');
        loadCharts(ifNeedCheck: true).then((value) {
          hideLoading();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadCharts();
  }

  @override
  void dispose() {
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
              const Text('课程购物车',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 24,
                height: 24,
                child: equipmentChartPolymerizationList.isNotEmpty
                    ? InkWell(
                        onTap: showClearDialog,
                        child: Center(
                          child: IconFont(
                            IconNames.qingkong,
                            size: 24,
                            color: '#000',
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '已选择 $checkCanBuyModelsNum 件器材商品',
                  style: const TextStyle(
                      color: Colors.black,
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
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: equipmentChartPolymerizationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 12, top: 12),
                                  width: 32,
                                  height: 32,
                                  child: Checkbox(
                                    side: const BorderSide(color: Colors.black),
                                    fillColor: equipmentChartCheckList[index]
                                        ? MaterialStateProperty.all(
                                            Colors.black)
                                        : MaterialStateProperty.all(
                                            Colors.transparent),
                                    checkColor: Colors.white,
                                    value: equipmentChartCheckList[index],
                                    onChanged: (bool? newValue) =>
                                        handleCheckItem(newValue, index),
                                  ),
                                ),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () => handleGoToEquipmentDetail(
                                      equipmentChartPolymerizationList[index]
                                          .equipment_id),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
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
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8), // 设置圆角
                                                  child: Image(
                                                    image: imageProvider,
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
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text:
                                                            equipmentChartPolymerizationList[
                                                                    index]
                                                                .equipment_info!
                                                                .title,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14))),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                RichText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: equipmentTypeList[
                                                              equipmentChartPolymerizationList[
                                                                      index]
                                                                  .equipment_info!
                                                                  .equipment_type],
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                              fontSize: 13,
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
                                        Text(
                                            '已加购型号 · ${equipmentChartPolymerizationList[index].equipment_model_infos.length}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
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
                                            final List<String> multiFigureList =
                                                equipmentChartPolymerizationList[
                                                        index]
                                                    .equipment_model_infos[
                                                        indexIn]
                                                    .multi_figure
                                                    .split(',');
                                            return Slidable(
                                              key: ValueKey('$index-$indexIn'),
                                              // The end action pane is the one at the right or the bottom side.
                                              endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    flex: 1,
                                                    onPressed: (BuildContext
                                                            context) =>
                                                        handleDeleteCharts([
                                                      equipmentChartPolymerizationList[
                                                              index]
                                                          .chart_ids[indexIn]
                                                    ]),
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            254, 32, 52, 1),
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: Icons.delete,
                                                    label: '删除',
                                                  )
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 12),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                        color: equipmentChartPolymerizationList[
                                                                        index]
                                                                    .equipment_model_infos[
                                                                        indexIn]
                                                                    .inventory >
                                                                0
                                                            ? Colors.transparent
                                                            : const Color
                                                                .fromRGBO(247,
                                                                245, 246, 1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12),
                                                          width: 32,
                                                          height: 32,
                                                          child: equipmentChartPolymerizationList[
                                                                          index]
                                                                      .equipment_model_infos[
                                                                          indexIn]
                                                                      .inventory >
                                                                  0
                                                              ? Checkbox(
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  fillColor: equipmentModelsChartCheckList[
                                                                              index]
                                                                          [
                                                                          indexIn]
                                                                      ? MaterialStateProperty.all(
                                                                          Colors
                                                                              .black)
                                                                      : MaterialStateProperty.all(
                                                                          Colors
                                                                              .transparent),
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  value: equipmentModelsChartCheckList[
                                                                          index]
                                                                      [indexIn],
                                                                  onChanged: (bool?
                                                                          newValue) =>
                                                                      handleCheckItemIn(
                                                                          newValue,
                                                                          index,
                                                                          indexIn),
                                                                )
                                                              : null,
                                                        ),
                                                        Expanded(
                                                            child: Row(
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
                                                                NumberSelect(
                                                                    key: ValueKey(
                                                                        '$index-$indexIn-${equipmentChartPolymerizationList[index].add_nums[indexIn]}'),
                                                                    min:
                                                                        equipmentChartPolymerizationList[index].equipment_model_infos[indexIn].inventory <=
                                                                                0
                                                                            ? 0
                                                                            : 1,
                                                                    disabled: equipmentChartPolymerizationList[index]
                                                                            .equipment_model_infos[
                                                                                indexIn]
                                                                            .inventory <=
                                                                        0,
                                                                    max: 99,
                                                                    inputSize:
                                                                        36,
                                                                    onValueChange: (int
                                                                            value) =>
                                                                        handleChangeCounter(
                                                                            value,
                                                                            index,
                                                                            indexIn),
                                                                    currentValue:
                                                                        equipmentChartPolymerizationList[index]
                                                                            .add_nums[indexIn]),
                                                              ],
                                                            ))
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  (equipmentChartPolymerizationList[
                                                                  index]
                                                              .equipment_model_infos[
                                                                  indexIn]
                                                              .inventory <=
                                                          0
                                                      ? Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: SizedBox(
                                                            width: 40,
                                                            height: 40,
                                                            child: InkWell(
                                                              onTap:
                                                                  handleGoBack,
                                                              child: Center(
                                                                child: IconFont(
                                                                  IconNames
                                                                      .lianxi_yishouqing_copy,
                                                                  size: 40,
                                                                  color: '#000',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink())
                                                ],
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            (index !=
                                    equipmentChartPolymerizationList.length - 1
                                ? const Divider(
                                    height: 2,
                                    color: Color.fromRGBO(233, 234, 235, 1),
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
                          '购物车空空如也~',
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
                      Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: Checkbox(
                              isError: true,
                              side: BorderSide(
                                  color: equipmentChartPolymerizationList
                                          .isNotEmpty
                                      ? Colors.black
                                      : const Color.fromRGBO(191, 192, 196, 1)),
                              fillColor: checkAll
                                  ? MaterialStateProperty.all(Colors.black)
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                              checkColor: Colors.white,
                              value: checkAll,
                              onChanged: handleCheckAll,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => handleCheckAll(!checkAll),
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 4,
                                  width: 4,
                                ),
                                Text(
                                  '全选',
                                  style: TextStyle(
                                      color: equipmentChartPolymerizationList
                                              .isNotEmpty
                                          ? Colors.black
                                          : const Color.fromRGBO(
                                              191, 192, 196, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 36,
                        height: 36,
                      ),
                      GestureDetector(
                        onTap: handleGoToOrder,
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
                          child: Row(
                            children: [
                              Text(
                                '立即下单',
                                style: TextStyle(
                                    color: totalCount != 0
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            188, 190, 194, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              (totalCount != 0
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                        ),
                                        (totalCount == totalDiscount
                                            ? Text(
                                                '¥$totalCount',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                '¥$totalCount',
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness: 2,
                                                    decorationColor:
                                                        Color.fromRGBO(
                                                            200, 200, 200, 1),
                                                    color: Color.fromRGBO(
                                                        200, 200, 200, 1),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        (totalCount != totalDiscount
                                            ? Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    '¥$totalDiscount',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            : const SizedBox.shrink())
                                      ],
                                    )
                                  : const SizedBox.shrink())
                            ],
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
