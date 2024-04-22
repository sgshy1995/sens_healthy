import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import './store_equipment_in.dart';

class StoreEquipmentSectionPage extends StatefulWidget {
  const StoreEquipmentSectionPage({super.key});
  @override
  State<StoreEquipmentSectionPage> createState() =>
      _StoreEquipmentSectionPageState();
}

class _StoreEquipmentSectionPageState extends State<StoreEquipmentSectionPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<StoreEquipmentInPageState> _storeEquipmentInPageState =
      GlobalKey<StoreEquipmentInPageState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final StoreController storeController = GetInstance().find<StoreController>();
  double _opacity = 1.0; // 初始透明度
  double _scrollDistance = 0; // 初始滚动位置

  int tabSelectionIndex = 0;

  int chartNum = 0;

  void handleGoToSearch() {}

  void handleGoToChart() {
    Get.toNamed('store_equipment_chart');
  }

  void loadChartsNum() {
    storeClientProvider.getEquipmentChartListAction().then((value) {
      storeController.setStoreEquipmentChartNum(
          value.data != null ? value.data!.length : 0);
    });
  }

  void handleGoBack() {
    Get.back();
  }

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];
  int? equipmentTypeChoose;
  void handleChooseCourseType(int? index) {
    setState(() {
      equipmentTypeChoose = index;
    });
    Get.back();
    reLoadChildren(index);
  }

  void reLoadChildren(int? index) {
    _storeEquipmentInPageState.currentState?.readyLoad = false;
    _storeEquipmentInPageState.currentState?.initPagination();
    _storeEquipmentInPageState.currentState?.equipmentTypeGet = index;
    _storeEquipmentInPageState.currentState?.onRefresh();
  }

  void handleClearChoose() {
    setState(() {
      equipmentTypeChoose = null;
    });
    reLoadChildren(null);
  }

  void handleSearch(BuildContext context, {bool ifSetToHistory = true}) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments['equipmentTypeChoose'] != null) {
      equipmentTypeChoose = Get.arguments['equipmentTypeChoose'];
    }
    loadChartsNum();
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
      key: _scaffoldKey,
      drawer: Drawer(
        width: 240,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.zero, // 设置顶部边缘为直角
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          height: double.infinity,
          color: const Color.fromRGBO(254, 251, 254, 1),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuerySafeInfo.top + 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 12, left: 6),
                    child: Center(
                      child: IconFont(
                        IconNames.liebiaoxingshi,
                        size: 20,
                        color: 'rgb(0,0,0)',
                      ),
                    ),
                  ),
                  const Text('选择器材分类',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                children: List.generate(equipmentTypeList.length, (index) {
                  return SizedBox(
                    height: 64,
                    child: GestureDetector(
                      onTap: () => handleChooseCourseType(index),
                      child: Center(
                        child: (equipmentTypeChoose != index
                            ? Text(
                                equipmentTypeList[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Center(
                                      child: IconFont(IconNames.duigou,
                                          size: 18, color: 'rgb(209,80,54)'),
                                    ),
                                  ),
                                  Text(
                                    equipmentTypeList[index],
                                    style: const TextStyle(
                                        color: Color.fromRGBO(209, 80, 54, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                      ),
                    ),
                  );
                }),
              ),
              GestureDetector(
                onTap: () {
                  handleClearChoose();
                  Get.back();
                },
                child: SizedBox(
                  height: 64,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: const Text(
                        '清空选择',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            // 使用 AnimatedOpacity 来动态改变透明度
            Expanded(
              child: Stack(children: [
                Column(
                  children: [
                    // 使用 AnimatedOpacity 来动态改变透明度
                    Expanded(
                      child: StoreEquipmentInPage(
                          ifUseCarousel: false,
                          equipmentType: equipmentTypeChoose,
                          key: _storeEquipmentInPageState),
                    )
                  ],
                ),
              ]),
            )
          ],
        ),
        Positioned(
            top: _scrollDistance,
            left: 0,
            right: 0,
            child: Visibility(
                visible: true,
                child: Column(
                  children: [
                    Container(
                      height: 36 + mediaQuerySafeInfo.top + 12,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Container(
                        height: 36 + mediaQuerySafeInfo.top + 12,
                        padding: EdgeInsets.fromLTRB(
                            12, mediaQuerySafeInfo.top + 12, 12, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: null,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              child: GestureDetector(
                                onTap: handleGoBack,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  margin:
                                      const EdgeInsets.only(right: 12, left: 6),
                                  child: Center(
                                    child: IconFont(
                                      IconNames.fanhui,
                                      size: 20,
                                      color: 'rgb(0,0,0)',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                              width: 24,
                            ),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Color.fromRGBO(233, 234, 235, 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('已选择',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 13,
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      // 打开抽屉
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    child: (equipmentTypeChoose != null
                                        ? Text(
                                            equipmentTypeList[
                                                equipmentTypeChoose!],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ))
                                        : const Text('全部分类',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ))),
                                  ),
                                  (equipmentTypeChoose != null
                                      ? GestureDetector(
                                          onTap: handleClearChoose,
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.7),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: Center(
                                                    child: IconFont(
                                                        IconNames.guanbi,
                                                        size: 12,
                                                        color:
                                                            'rgb(255, 255, 255)'),
                                                  ),
                                                ),
                                                const Text('清空选择',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 2, 4, 2),
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  233, 234, 235, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.guanbi,
                                                      size: 12,
                                                      color:
                                                          'rgb(233,234,235)'),
                                                ),
                                              ),
                                              const Text('清空选择',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        233, 234, 235, 1),
                                                    fontSize: 13,
                                                  ))
                                            ],
                                          ),
                                        ))
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 12,
                      color: Colors.white,
                    ),
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(243, 243, 244, 1),
                    )
                  ],
                ))),
        Positioned(
            bottom: 24,
            right: 24,
            child: InkWell(
              onTap: handleGoToChart,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(158, 158, 158, 0.3),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Color.fromRGBO(211, 66, 67, 1),
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                child: Center(
                  child: IconFont(
                    IconNames.gouwuche,
                    size: 24,
                    color: 'rgb(255,255,255)',
                  ),
                ),
              ),
            )),
        (Obx(() => storeController.storeEquipmentChartNum > 0
            ? Positioned(
                bottom: 56,
                right: 18,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Center(
                    child: Text(
                      '${storeController.storeEquipmentChartNum.value}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
            : const SizedBox.shrink()))
      ]),
    );
  }
}
