import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../iconfont/icon_font.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/data_model.dart';
import '../../models/pain_model.dart';
import 'package:flutter/services.dart';
import '../../../components/keep_alive_wrapper.dart';
import './mine_balance_detail_in.dart';
import './history/pain_search_history_reply.dart';

class MineBalanceDetailPage extends StatefulWidget {
  const MineBalanceDetailPage({super.key});

  @override
  State<MineBalanceDetailPage> createState() => _MineBalanceDetailPageState();
}

class _MineBalanceDetailPageState extends State<MineBalanceDetailPage>
    with SingleTickerProviderStateMixin {
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  late TabController _tabController;

  late SharedPreferences prefs;

  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: initialIndex);
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

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
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
                  const Text('余额明细',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24, height: 24)
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
                  tabs: const [Tab(text: '最近'), Tab(text: '最早')],
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
                    children: const [
                      KeepAliveWrapper(
                          child: MineBalanceDetailInPage(
                        recent: 1,
                      )),
                      KeepAliveWrapper(child: MineBalanceDetailInPage())
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
