import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sens_healthy/components/loading.dart';
import '../../../iconfont/icon_font.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/store_client_provider.dart';
import '../../models/data_model.dart';
import '../../models/pain_model.dart';
import 'package:flutter/services.dart';
import '../../../components/keep_alive_wrapper.dart';
import './mine_equipment_order_in.dart';
import './mine_equipment_order_search.dart';

class MineEquipmentOrderPage extends StatefulWidget {
  const MineEquipmentOrderPage({super.key});

  @override
  State<MineEquipmentOrderPage> createState() => _MineEquipmentOrderPageState();
}

class _MineEquipmentOrderPageState extends State<MineEquipmentOrderPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<MineEquipmentOrderInPageState>
      _mineEquipmentOrderInWaitPageState =
      GlobalKey<MineEquipmentOrderInPageState>();
  final GlobalKey<MineEquipmentOrderInPageState>
      _mineEquipmentOrderInShippingPageState =
      GlobalKey<MineEquipmentOrderInPageState>();
  final GlobalKey<MineEquipmentOrderInPageState>
      _mineEquipmentOrderInReceivedPageState =
      GlobalKey<MineEquipmentOrderInPageState>();
  final GlobalKey<MineEquipmentOrderInPageState>
      _mineEquipmentOrderInCanceledPageState =
      GlobalKey<MineEquipmentOrderInPageState>();

  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  late TabController _tabController;
  late SharedPreferences prefs;

  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Get.arguments['initialIndex'] != null) {
      initialIndex = Get.arguments['initialIndex'];
    }
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  void handleGoBack() {
    Get.back();
  }

  // void handleGotoSearch() {
  //   Get.toNamed('mine_equipment_order_search')!.then((value) {
  //     if (value == 'rebuy') {
  //       rebuyCallback();
  //     }
  //   });
  // }

  void handleGotoSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MineEquipmentOrderSearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ).then((value) {
      if (value == 'rebuy') {
        rebuyCallback();
      }
    });
  }

  void showDetailCallback() {
    setState(() {
      _mineEquipmentOrderInWaitPageState.currentState?.readyLoad = false;
      _mineEquipmentOrderInWaitPageState.currentState?.initPagination();

      _mineEquipmentOrderInShippingPageState.currentState?.readyLoad = false;
      _mineEquipmentOrderInShippingPageState.currentState?.initPagination();

      _mineEquipmentOrderInReceivedPageState.currentState?.readyLoad = false;
      _mineEquipmentOrderInReceivedPageState.currentState?.initPagination();

      _mineEquipmentOrderInCanceledPageState.currentState?.readyLoad = false;
      _mineEquipmentOrderInCanceledPageState.currentState?.initPagination();

      _mineEquipmentOrderInWaitPageState.currentState?.onRefresh();

      _mineEquipmentOrderInShippingPageState.currentState?.onRefresh();

      _mineEquipmentOrderInReceivedPageState.currentState?.onRefresh();

      _mineEquipmentOrderInCanceledPageState.currentState?.onRefresh();
    });
  }

  void rebuyCallback() {
    _tabController.animateTo(0);
    showDetailCallback();
  }

  void handleSearch() async {}

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 36 + mediaQuerySafeInfo.top + 12,
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: Container(
              height: 36 + mediaQuerySafeInfo.top + 12,
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(243, 243, 244, 1), // 底部边框颜色
                    width: 0, // 底部边框宽度
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 18),
                    child: GestureDetector(
                      onTap: handleGoBack,
                      child: Center(
                        child: IconFont(
                          IconNames.fanhui,
                          size: 20,
                          color: 'rgb(0,0,0)',
                        ),
                      ),
                    ),
                  ),
                  const Text('器材订单管理',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(left: 18),
                    child: InkWell(
                      onTap: () {
                        // 点击外部区域时取消焦点
                        handleGotoSearch();
                      },
                      child: Center(
                        child: IconFont(
                          IconNames.sousuo,
                          size: 20,
                          color: 'rgb(0,0,0)',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Container(
                height: 50, // TabBar高度
                color: Colors.white,
                child: TabBar(
                  onTap: (index) {
                    if (index == 1) {
                      // 切换时滚动到顶部
                      //_painQuestionPageState.currentState?.scrollToTop();
                    }
                  },
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(211, 66, 67, 1), // 底部边框颜色
                        width: 3, // 底部边框宽度
                      ),
                    ),
                  ),
                  unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 1),
                  labelColor: const Color.fromRGBO(211, 66, 67, 1),
                  indicatorColor: const Color.fromRGBO(211, 66, 67, 1),
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '待发货'),
                    Tab(text: '已发货'),
                    Tab(text: '已签收'),
                    Tab(text: '已取消')
                  ],
                ),
              ),
              const Divider(
                height: 2,
                color: Color.fromRGBO(243, 243, 244, 1),
              ),
              Expanded(
                child: GetBuilder<UserController>(
                  builder: (controller) => TabBarView(
                    controller: _tabController,
                    children: [
                      KeepAliveWrapper(
                          child: MineEquipmentOrderInPage(
                        key: _mineEquipmentOrderInWaitPageState,
                        showDetailCallback: showDetailCallback,
                        rebuyCallback: rebuyCallback,
                        userId: controller.userInfo.id,
                        status: 2,
                      )),
                      KeepAliveWrapper(
                          child: MineEquipmentOrderInPage(
                        key: _mineEquipmentOrderInShippingPageState,
                        showDetailCallback: showDetailCallback,
                        rebuyCallback: rebuyCallback,
                        userId: controller.userInfo.id,
                        status: 3,
                      )),
                      KeepAliveWrapper(
                          child: MineEquipmentOrderInPage(
                        key: _mineEquipmentOrderInReceivedPageState,
                        showDetailCallback: showDetailCallback,
                        rebuyCallback: rebuyCallback,
                        userId: controller.userInfo.id,
                        status: 4,
                      )),
                      KeepAliveWrapper(
                          child: MineEquipmentOrderInPage(
                        key: _mineEquipmentOrderInCanceledPageState,
                        showDetailCallback: showDetailCallback,
                        rebuyCallback: rebuyCallback,
                        userId: controller.userInfo.id,
                        status: 0,
                      )),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
