import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/store_client_provider.dart';
import '../../providers/api/appointment_client_provider.dart';
import '../../providers/api/major_client_provider.dart';
import '../../providers/api/notification_client_provider.dart';
import '../../controllers/store_controller.dart';
import '../../controllers/notification_controller.dart';
import './pain_question.dart';
import './pain_consult.dart';
import '../../../components/keep_alive_wrapper.dart';
import 'package:get/get.dart';
import './pain_question_publish.dart';
import './pain_search.dart';

// 定义回调函数类型
typedef PainNotificationCallback = void Function(int num);

class PainPage extends StatefulWidget {
  const PainPage({super.key, required this.painNotificationCallback});

  final PainNotificationCallback painNotificationCallback;

  @override
  State<PainPage> createState() => _PainPageState();
}

class _PainPageState extends State<PainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<PainQuestionPageState> _painQuestionPageState =
      GlobalKey<PainQuestionPageState>();
  final GlobalKey<PainConsultPageState> _painConsultPageState =
      GlobalKey<PainConsultPageState>();
  final UserController userController = Get.put(UserController());
  final StoreController storeController = Get.put(StoreController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());
  final MajorClientProvider majorClientProvider =
      Get.put(MajorClientProvider());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());

  late TabController _tabController;
  double _opacity = 1.0; // 初始透明度
  double _scrollDistance = 0; // 初始滚动位置

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadGlobalDatas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void scrollCallBack(double scrollDistance) {
    // 上滑
    setState(() {
      // 计算滚动位置百分比
      _scrollDistance = scrollDistance < 0
          ? 0
          : scrollDistance <= (36 + 12)
              ? -scrollDistance
              : (0 - (36 + 12));
      double percentage = scrollDistance / (36 + 12);
      double opacity = 1.0 - percentage;
      _opacity = opacity.clamp(0.0, 1.0); // 限制透明度在 0.0 到 1.0 之间
    });
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
    //scrollToTop();
  }

  void handleGoToSearch() {
    // 切换时滚动到顶部
    _painQuestionPageState.currentState?.scrollToTop();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PainSearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  void handleGoToPublish() async {
    final result = await Navigator.push<String>(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PainQuestionPublishPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              )
                  .chain(CurveTween(curve: Curves.easeInOut))
                  .animate(curvedAnimation),
              child: child,
            );
          }),
    );
    if (result == 'success') {
      _painQuestionPageState.currentState?.onRefresh();
    }
    // Get.to(
    //   PainQuestionPublishPage(),
    //   transition: Transition.downToUp,
    // );
  }

  // void scrollToTop() {
  //   _scrollController.animateTo(
  //     0.0, // 滚动位置为顶部
  //     duration: const Duration(milliseconds: 300), // 动画持续时间
  //     curve: Curves.easeInOut, // 动画曲线
  //   );
  // }

  Future<int?> loadEquipmentWaitCounts(String userId) {
    Completer<int?> completer = Completer();
    storeClientProvider
        .findManyEquipmentOrdersWithPaginationAction(userId: userId, status: 2)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadEquipmentShippingCounts(String userId) {
    Completer<int?> completer = Completer();
    storeClientProvider
        .findManyEquipmentOrdersWithPaginationAction(userId: userId, status: 3)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadEquipmentReceivedCounts(String userId) {
    Completer<int?> completer = Completer();
    storeClientProvider
        .findManyEquipmentOrdersWithPaginationAction(userId: userId, status: 4)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadEquipmentCanceledCounts(String userId) {
    Completer<int?> completer = Completer();
    storeClientProvider
        .findManyEquipmentOrdersWithPaginationAction(userId: userId, status: 0)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadLearningCounts(String userId) {
    Completer<int?> completer = Completer();
    appointmentClientProvider
        .getPatientCoursesPaginationAction(userId: userId, status: 1)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMajorCourseCounts(String userId) {
    Completer<int?> completer = Completer();
    majorClientProvider
        .findManyMajorCoursesAction(userId: userId)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadPainNotificationCounts(String userId) {
    Completer<int?> completer = Completer();
    notificationClientProvider
        .findManyPainNotifications(userId: userId, read: 0)
        .then((result) {
      completer.complete(result.data.totalCount);
      widget.painNotificationCallback(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> checkUserId() async {
    Completer<String?> completer = Completer();
    if (userController.userInfo.id.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId != null) {
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  Future<String?> loadEquipmentOrderCounts() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();

      // 等待所有异步任务完成
      final List<int?> results = await Future.wait([
        loadEquipmentWaitCounts(userId!),
        loadEquipmentShippingCounts(userId),
        loadEquipmentReceivedCounts(userId),
        loadEquipmentCanceledCounts(userId)
      ]);

      results.asMap().forEach((index, value) {
        storeController.setStoreEquipmentWaitCounts(results[0] ?? 0);
        storeController.setStoreEquipmentShippingCounts(results[1] ?? 0);
        storeController.setStoreEquipmentReceivedCounts(results[2] ?? 0);
        storeController.setStoreEquipmentCanceledCounts(results[3] ?? 0);
      });
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> loadPatientCourseOrderCounts() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();

      // 等待所有异步任务完成
      final List<int?> results =
          await Future.wait([loadLearningCounts(userId!)]);
      storeController.setLearningCounts(results[0] ?? 0);
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> loadMajorCourseOrderCounts() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();

      // 等待所有异步任务完成
      final List<int?> results =
          await Future.wait([loadMajorCourseCounts(userId!)]);

      storeController.setMajorCourseCounts(results[0] ?? 0);
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> loadPainNotificationCountsInfo() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();

      // 等待所有异步任务完成
      final List<int?> results =
          await Future.wait([loadPainNotificationCounts(userId!)]);

      notificationController.setPainNotiicationNum(results[0] ?? 0);
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  void loadGlobalDatas() {
    Future.wait([
      loadEquipmentOrderCounts(),
      loadPatientCourseOrderCounts(),
      loadMajorCourseOrderCounts(),
      loadPainNotificationCountsInfo()
    ]);
  }

  void handleGotoEquipmentOrderPage() {
    Get.toNamed('/mine_equipment_order', arguments: {'initialIndex': 0})!
        .then((value) {
      loadEquipmentOrderCounts();
    });
  }

  void handleGotoNotificationPage() {
    Get.toNamed('/notification')!.then((value) {
      widget
          .painNotificationCallback(notificationController.painNotiicationNum);
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // 使用 AnimatedOpacity 来动态改变透明度
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    KeepAliveWrapper(
                        child: PainQuestionPage(
                            key: _painQuestionPageState,
                            scrollCallBack: scrollCallBack)),
                    KeepAliveWrapper(
                        child: PainConsultPage(key: _painConsultPageState)),
                  ],
                ),
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
                      Stack(
                        children: [
                          Container(
                            height: 36 + mediaQuerySafeInfo.top + 12,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            child: AnimatedOpacity(
                              opacity: _opacity,
                              duration: const Duration(milliseconds: 30),
                              curve: Curves.linear, // 指定渐变方式
                              child: Container(
                                height: 36 + mediaQuerySafeInfo.top + 12,
                                padding: EdgeInsets.fromLTRB(
                                    12, mediaQuerySafeInfo.top + 12, 12, 0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(
                                          243, 243, 244, 1), // 底部边框颜色
                                      width: 0, // 底部边框宽度
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      height: 36,
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          color:
                                              Color.fromRGBO(233, 234, 235, 1)),
                                      child: GestureDetector(
                                        onTap: handleGoToSearch,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18,
                                              height: 18,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.sousuo,
                                                  size: 18,
                                                  color: 'rgb(75,77,81)',
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                                child: Text(
                                              '搜索话题 / 问答 ...',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      75, 77, 81, 1),
                                                  fontSize: 14),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: handleGotoEquipmentOrderPage,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            color: Colors.transparent,
                                            margin: const EdgeInsets.only(
                                                right: 12, left: 18),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.kabao,
                                                size: 20,
                                                color: 'rgb(0,0,0)',
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: handleGotoNotificationPage,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            color: Colors.transparent,
                                            margin:
                                                const EdgeInsets.only(right: 6),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.xiaoxizhongxin,
                                                size: 20,
                                                color: 'rgb(0,0,0)',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GetBuilder<StoreController>(builder: (controller) {
                            return ((controller.equipmentWaitCounts +
                                        controller.equipmentShippingCounts) >
                                    0
                                ? Positioned(
                                    top: mediaQuerySafeInfo.top + 8,
                                    right: 42,
                                    child: AnimatedOpacity(
                                      opacity: _opacity,
                                      duration:
                                          const Duration(milliseconds: 30),
                                      curve: Curves.linear, // 指定渐变方式
                                      child: GestureDetector(
                                        onTap: handleGotoEquipmentOrderPage,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  249, 81, 84, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24))),
                                          child: Center(
                                            child: Text(
                                              '${(controller.equipmentWaitCounts + controller.equipmentShippingCounts) > 99 ? '99+' : (controller.equipmentWaitCounts + controller.equipmentShippingCounts)}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                : const SizedBox.shrink());
                          }),
                          GetBuilder<NotificationController>(
                              builder: (controller) {
                            return (controller.painNotiicationNum > 0
                                ? Positioned(
                                    top: mediaQuerySafeInfo.top + 8,
                                    right: 8,
                                    child: AnimatedOpacity(
                                      opacity: _opacity,
                                      duration:
                                          const Duration(milliseconds: 30),
                                      curve: Curves.linear, // 指定渐变方式
                                      child: GestureDetector(
                                        onTap: handleGotoNotificationPage,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  249, 81, 84, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24))),
                                          child: Center(
                                            child: Text(
                                              '${controller.painNotiicationNum > 99 ? '99+' : controller.painNotiicationNum}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                : const SizedBox.shrink());
                          })
                        ],
                      ),
                      Container(
                        height: 50, // TabBar高度
                        color: Colors.white,
                        child: TabBar(
                          onTap: (index) {
                            if (index == 1) {
                              // 切换时滚动到顶部
                              _painQuestionPageState.currentState
                                  ?.scrollToTop();
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
                          unselectedLabelColor:
                              const Color.fromRGBO(0, 0, 0, 1),
                          labelColor: const Color.fromRGBO(211, 66, 67, 1),
                          indicatorColor: const Color.fromRGBO(211, 66, 67, 1),
                          controller: _tabController,
                          tabs: const [Tab(text: '伤痛问答'), Tab(text: '康复资讯')],
                        ),
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
                onTap: handleGoToPublish,
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
                      IconNames.tianjia,
                      size: 24,
                      color: 'rgb(255,255,255)',
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
