import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../models/notification_model.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/pain_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import '../../providers/api/notification_client_provider.dart';
import '../../controllers/notification_controller.dart';

class NotificationInteractionPage extends StatefulWidget {
  final String? keyword;

  const NotificationInteractionPage({super.key, this.keyword});

  @override
  State<NotificationInteractionPage> createState() =>
      NotificationInteractionPageState();
}

class NotificationInteractionPageState
    extends State<NotificationInteractionPage> with TickerProviderStateMixin {
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());
  final NotificationController notificationController =
      Get.put(NotificationController());

  late String keywordCanChange;

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // 滚动位置为顶部
      duration: const Duration(milliseconds: 300), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  PainNotificationStatisticsTypeModel painNotificationStatisticsInfo =
      PainNotificationStatisticsTypeModel.fromJson(null);

  Future<String> getPainReplyNotifications({int? page}) {
    Completer<String> completer = Completer();
    notificationClientProvider
        .findManyPainNotificationStatisticsAction()
        .then((value) {
      setState(() {
        painNotificationStatisticsInfo = value.data!;
      });
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  void _scrollListener() {
    setState(() {
      _scrollDistance = _scrollController.offset;
      if (_scrollDistance < 0) {
        _rotationAngle = _scrollDistance > -_headerTriggerDistance
            ? (0 - _scrollDistance) / _headerTriggerDistance * 360
            : 360;
      } else {
        _rotationAngle = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    keywordCanChange = widget.keyword ?? '';
    _onRefresh();
    _scrollController.addListener(_scrollListener);
    _RotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 一圈的弧度值，这里表示一圈的角度为360度
    ).animate(_RotateController);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _RotateController.dispose();
    // painClientProvider.dispose();
    // userController.dispose();
    // globalController.dispose();
  }

  Future<void> onRefresh() async {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getPainReplyNotifications();
      _refreshController.refreshCompleted();
      if (result == 'success') {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (e) {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    String result;
    try {
      result = await getPainReplyNotifications();
      print('最终的加载结果是: $result');
      if (result == 'success') {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  final Key linkKey = GlobalKey();

  EdgeInsets safePadding = MediaQuery.of(Get.context!).padding;

  Widget buildHeader(BuildContext context, RefreshStatus? mode) {
    return Container(
      color: Colors.transparent,
      height: _headerTriggerDistance,
      child: Center(
          // child: Text(
          //     mode == RefreshStatus.idle
          //         ? "下拉刷新"
          //         : mode == RefreshStatus.refreshing
          //             ? "刷新中..."
          //             : mode == RefreshStatus.canRefresh
          //                 ? "可以松手了!"
          //                 : mode == RefreshStatus.completed
          //                     ? "刷新成功!"
          //                     : "刷新失败",
          //     style: TextStyle(color: Colors.black))),
          child:
              (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh)
                  ? Transform.rotate(
                      angle: _rotationAngle * (3.14159 / 180),
                      child: IconFont(
                        IconNames.shuaxin,
                        size: 28,
                        color: '#333',
                      ),
                    )
                  : const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color.fromRGBO(33, 33, 33, 1),
                            strokeWidth: 2),
                      ),
                    )),
    );
  }

  void handleGotoNotificationLike() {
    Get.toNamed('/notification_like')!.then((value) {
      getPainReplyNotifications();
    });
  }

  void handleGotoNotificationSay() {
    Get.toNamed('/notification_say')!.then((value) {
      getPainReplyNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: RefreshConfiguration(
            headerTriggerDistance: 60.0,
            enableScrollWhenRefreshCompleted:
                true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
            child: SmartRefresher(
                physics: const ClampingScrollPhysics(), // 禁止回弹效果
                enablePullDown: true,
                enablePullUp: false,
                header: CustomHeader(
                    builder: buildHeader,
                    onOffsetChange: (offset) {
                      //do some ani
                    }),
                controller: _refreshController,
                onRefresh: _onRefresh,
                // child: ListView.builder(
                //   controller: _scrollController,
                //   itemBuilder: (c, i) => i == 0
                //       ? Container(
                //           height: mediaQuerySafeInfo.top + 12 + 50 + 12 + 12 + 12,
                //           color: Colors.white,
                //         )
                //       : SizedBox(
                //           height: 100,
                //           child: Card(child: Center(child: Text(items[i]))),
                //         ),
                //   itemCount: items.length,
                // ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        height: 32,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(177, 177, 177, 1)),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '互动消息',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: handleGotoNotificationLike,
                                child: Container(
                                  width: mediaQuerySizeInfo.width / 3,
                                  height: 120,
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromRGBO(
                                                    100, 100, 100, 1)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(22))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.dianzan,
                                            size: 20,
                                            color: '#000',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      const Text(
                                        '点赞',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: handleGotoNotificationSay,
                                child: Container(
                                  width: mediaQuerySizeInfo.width / 3,
                                  height: 120,
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromRGBO(
                                                    100, 100, 100, 1)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(22))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.pinglun_1,
                                            size: 20,
                                            color: '#000',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      const Text(
                                        '答复/评论',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: mediaQuerySizeInfo.width / 3,
                                height: 120,
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: const Color.fromRGBO(
                                                  100, 100, 100, 1)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(22))),
                                      child: Center(
                                        child: IconFont(
                                          IconNames.chuangzuozhezhongxin,
                                          size: 20,
                                          color: '#000',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      '创作中心',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          painNotificationStatisticsInfo.like_num > 0
                              ? Positioned(
                                  top: 14,
                                  left: mediaQuerySizeInfo.width / 3 * 0 +
                                      mediaQuerySizeInfo.width / 3 / 2 +
                                      4,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(249, 81, 84, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                      child: Center(
                                        child: Text(
                                          '${painNotificationStatisticsInfo.like_num > 99 ? '99+' : painNotificationStatisticsInfo.like_num}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                          (painNotificationStatisticsInfo.reply_num +
                                      painNotificationStatisticsInfo
                                          .comment_num) >
                                  0
                              ? Positioned(
                                  top: 14,
                                  left: mediaQuerySizeInfo.width / 3 * 1 +
                                      mediaQuerySizeInfo.width / 3 / 2 +
                                      4,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(249, 81, 84, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                      child: Center(
                                        child: Text(
                                          '${(painNotificationStatisticsInfo.reply_num + painNotificationStatisticsInfo.comment_num) > 99 ? '99+' : (painNotificationStatisticsInfo.reply_num + painNotificationStatisticsInfo.comment_num)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                          painNotificationStatisticsInfo.major_num > 0
                              ? Positioned(
                                  top: 14,
                                  left: mediaQuerySizeInfo.width / 3 * 0 +
                                      mediaQuerySizeInfo.width / 3 / 2 +
                                      4,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(249, 81, 84, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                      child: Center(
                                        child: Text(
                                          '${painNotificationStatisticsInfo.major_num > 99 ? '99+' : painNotificationStatisticsInfo.major_num}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        height: 32,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(177, 177, 177, 1)),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '会话消息',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 64),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.asset(
                                  'assets/images/ddd.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const Text(
                                '没有会话~',
                                style: TextStyle(
                                    color: Color.fromRGBO(28, 30, 69, 1),
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ))
        ],
      ),
    );
  }
}
