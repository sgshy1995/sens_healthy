import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';

import '../../../components/keep_alive_wrapper.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/notification_client_provider.dart';

import './notification_interaction.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final UserController userController = Get.put(UserController());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());
  final NotificationController notificationController =
      Get.put(NotificationController());

  final GlobalKey<NotificationInteractionPageState>
      _notificationInteractionPageState =
      GlobalKey<NotificationInteractionPageState>();

  late TabController _tabController;

  void handleReadAll() {}

  void handleGoBack() {
    Get.back();
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
    _notificationInteractionPageState.currentState?.scrollToTop();
  }

  Future<int?> loadPainNotificationCounts() {
    Completer<int?> completer = Completer();
    notificationClientProvider
        .findManyPainNotifications(userId: userController.userInfo.id, read: 0)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> loadPainNotificationCountsInfo() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      // 等待所有异步任务完成
      final List<int?> results =
          await Future.wait([loadPainNotificationCounts()]);
      notificationController.setPainNotiicationNum(results[0] ?? 0);
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  void showReadAllDialog() {
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
                    '您确定要将所有消息标记为已读吗？',
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
                  handleConfirmReadAll();
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

  void handleConfirmReadAll() {
    showLoading('请稍后...');
    notificationClientProvider.readAllAction().then((value) {
      if (value.code == 200) {
        Future.wait([
          loadPainNotificationCountsInfo(),
          _notificationInteractionPageState.currentState != null
              ? _notificationInteractionPageState.currentState!
                  .getPainReplyNotifications()
              : loadPainNotificationCountsInfo()
        ]).then((value) async {
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadPainNotificationCountsInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    Widget skeleton() {
      return Container();
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
              Row(
                children: [
                  InkWell(
                    onTap: handleGoBack,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: IconFont(
                          IconNames.fanhui,
                          size: 24,
                          color: '#000',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                    height: 32,
                  )
                ],
              ),
              const Text('消息通知',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  GestureDetector(
                    onTap: showReadAllDialog,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(right: 12),
                      child: Center(
                        child: IconFont(
                          IconNames.biaojiyidu,
                          size: 24,
                          color: '#000',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: IconFont(
                          IconNames.shezhi,
                          size: 24,
                          color: '#000',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      const Divider(
        height: 2,
        color: Color.fromRGBO(233, 234, 235, 1),
      ),
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
          tabs: [
            const Tab(text: '系统通知 (0)'),
            GetBuilder<NotificationController>(builder: (controller) {
              return Tab(text: '互动 (${controller.painNotiicationNum})');
            })
          ],
        ),
      ),
      Expanded(
          child: TabBarView(controller: _tabController, children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/empty_notification.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Text(
                  '没有通知',
                  style: TextStyle(
                      color: Color.fromRGBO(224, 222, 223, 1), fontSize: 14),
                )
              ],
            ),
          ),
        ),
        KeepAliveWrapper(
            child: NotificationInteractionPage(
                key: _notificationInteractionPageState)),
      ]))
    ]));
  }
}
