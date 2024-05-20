import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import '../../providers/api/appointment_client_provider.dart';
import '../../providers/api/major_client_provider.dart';
import '../../providers/api/notification_client_provider.dart';
import '../../controllers/notification_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './menus/mine_record_menu.dart';
import './menus/mine_live_course_order_menu.dart';
import './menus/mine_video_course_order_menu.dart';
import './menus/mine_equipment_order_menu.dart';
import './menus/mine_manage_menu.dart';
import './menus/mine_doctor_menu.dart';
import './menus/mine_professional_tool_menu.dart';
import './menus/mine_help_menu.dart';
import './menus/mine_doctor_enter_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 定义回调函数类型
typedef PainNotificationCallback = void Function(int num);

class MinePage extends StatefulWidget {
  const MinePage({super.key, required this.painNotificationCallback});

  final PainNotificationCallback painNotificationCallback;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final StoreController storeController = Get.put(StoreController());
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());
  final MajorClientProvider majorClientProvider =
      Get.put(MajorClientProvider());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());
  final NotificationController notificationController =
      Get.put(NotificationController());

  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  late AnimationController _rotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  String _colorAnimateStatus = '';

  double _scrollDistance = 0;
  double _opacity = 0; // 初始透明度

  //我的问答信息
  int myAskCounts = 0;
  int myReplyCounts = 0;
  int myCollectCounts = 0;
  int myLikeCounts = 0;

  String? userIdLocal;

  Future<int?> loadMyAskCounts(String userId) {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(userId: userId)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyReplyCounts(String userId) {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainRepliesByCustomAction(userId: userId)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyCollectCounts(String userId) {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(collectUserId: userId)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyLikeCounts(String userId) {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(likeUserId: userId)
        .then((result) {
      completer.complete(result.data.totalCount);
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
        setState(() {
          userIdLocal = userId;
        });
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  //器材订单信息
  int equipmentWaitCounts = 0;
  int equipmentShippingCounts = 0;
  int equipmentReceivedCounts = 0;
  int equipmentCanceledCounts = 0;

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

  //面对面康复订单信息
  int learningCounts = 0;
  int finishCounts = 0;

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

  Future<int?> loadFinishCounts(String userId) {
    Completer<int?> completer = Completer();
    appointmentClientProvider
        .getPatientCoursesPaginationAction(userId: userId, status: 2)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  //专业能力提升订单信息
  int majorCourseCounts = 0;

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

  Future<String?> loadInfos() async {
    Completer<String?> completer = Completer();
    if (userController.token.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Future.wait([
          userClientProvider.getUserInfoByJWTAction(),
          userClientProvider.getInfoByJWTAction()
        ]).then((valuesIn) {
          if (valuesIn[0].code == 200 &&
              valuesIn[0].data != null &&
              valuesIn[1].code == 200 &&
              valuesIn[1].data != null) {
            userController.setUserInfo(valuesIn[0].data! as UserTypeModel);
            userController.setInfo(valuesIn[1].data! as UserInfoTypeModel);
            completer.complete('success');
          } else {
            completer.completeError('error');
          }
        }).catchError((e) {
          completer.completeError(e);
        });
      });
    } else {
      completer.complete('first-load-not-need-refresh');
    }

    return completer.future;
  }

  Future<String?> loadCounts() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();

      // 等待所有异步任务完成
      final List<int?> results = await Future.wait([
        loadMyAskCounts(userId!),
        loadMyReplyCounts(userId),
        loadMyCollectCounts(userId),
        loadMyLikeCounts(userId)
      ]);

      setState(() {
        myAskCounts = results[0] ?? 0;
        myReplyCounts = results[1] ?? 0;
        myCollectCounts = results[2] ?? 0;
        myLikeCounts = results[3] ?? 0;
      });
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
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

      setState(() {
        equipmentWaitCounts = results[0] ?? 0;
        equipmentShippingCounts = results[1] ?? 0;
        equipmentReceivedCounts = results[2] ?? 0;
        equipmentCanceledCounts = results[3] ?? 0;
      });
      storeController.setStoreEquipmentWaitCounts(results[0] ?? 0);
      storeController.setStoreEquipmentShippingCounts(results[1] ?? 0);
      storeController.setStoreEquipmentReceivedCounts(results[2] ?? 0);
      storeController.setStoreEquipmentCanceledCounts(results[3] ?? 0);
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
      final List<int?> results = await Future.wait(
          [loadLearningCounts(userId!), loadFinishCounts(userId)]);
      setState(() {
        learningCounts = results[0] ?? 0;
        finishCounts = results[1] ?? 0;
      });
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

      setState(() {
        majorCourseCounts = results[0] ?? 0;
      });
      storeController.setMajorCourseCounts(results[0] ?? 0);
    }).then((value) {
      completer.complete('success');
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

  int booksLength = 0;

  Future<String?> loadBooks() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      final String? userId = await checkUserId();
      appointmentClientProvider
          .findManyBooksReadyBookedAction(userId!)
          .then((result) {
        if (result.code == 200) {
          setState(() {
            booksLength = result.data!.length;
          });
          completer.complete('success');
        } else {
          completer.completeError('error');
        }
      }).catchError((e) {
        completer.completeError(e);
      });
    });

    return completer.future;
  }

  void handleGotoHistory(int index) {
    Get.toNamed('/mine_history', arguments: {'initialIndex': index});
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

      double percentage = _scrollDistance <= 36
          ? 1
          : (60 - _scrollDistance < 24 ? 60 - _scrollDistance : 0) / 24;
      double opacity = 1.0 - percentage;
      _opacity = opacity.clamp(0.0, 1.0); // 限制透明度在 0.0 到 1.0 之间

      if (_scrollController.offset >= 60 && _colorAnimateStatus != 'forward') {
        setState(() {
          _colorAnimateStatus = 'forward';
        });
        _animationController.forward();
      } else if (_scrollController.offset <= 60 &&
          _colorAnimateStatus != 'reverse') {
        setState(() {
          _colorAnimateStatus = 'reverse';
        });
        _animationController.reverse();
      }
    });
  }

  void openAvatar(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GalleryPhotoViewWrapper(
          showIndicator: false,
          galleryItems: [
            GalleryExampleItem(
                id: 'user-avatar',
                resource:
                    '${globalController.cdnBaseUrl}/${userController.userInfo.avatar}',
                isSvg: false,
                canBeDownloaded: true,
                imageType: 'network')
          ],
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: 0,
          scrollDirection: Axis.horizontal,
        ),
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

  void handleGotoDataPage() {
    Get.toNamed('/mine_data');
  }

  void handleGotoSettingPage() {
    Get.toNamed('/mine_setting');
  }

  void handleGotoBalance() {
    Get.toNamed('/mine_balance');
  }

  void showEquipmentOrderDetailCallback() {
    loadEquipmentOrderCounts();
  }

  void handleGotoNotificationPage() {
    Get.toNamed('/notification')!.then((value) {
      widget
          .painNotificationCallback(notificationController.painNotiicationNum);
    });
  }

  @override
  void initState() {
    super.initState();

    _onRefresh();
    _scrollController.addListener(_scrollListener);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 一圈的弧度值，这里表示一圈的角度为360度
    ).animate(_rotateController);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorTween = ColorTween(
            begin: const Color.fromRGBO(248, 219, 221, 1),
            end: const Color.fromRGBO(244, 189, 190, 1))
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear, // 指定变化曲线为 easeInOut
      ),
    );

    _scrollController.addListener(_scrollListener);
  }

  void enterCallback() {
    loadBooks();
  }

  void _onRefresh() async {
    // monitor network fetch
    Future.wait([
      loadCounts(),
      loadInfos(),
      loadEquipmentOrderCounts(),
      loadPatientCourseOrderCounts(),
      loadMajorCourseOrderCounts(),
      loadPainNotificationCountsInfo(),
      loadBooks()
    ]);
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(211, 66, 67, 0.2),
                Color.fromRGBO(211, 66, 67, 0.1),
                Color.fromRGBO(211, 66, 67, 0)
              ], // 渐变的起始和结束颜色
            )),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  width: mediaQuerySizeInfo.width,
                  height: mediaQuerySafeInfo.top + 48,
                  padding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mediaQuerySafeInfo.top,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 48,
                            child: _scrollDistance <= 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox.shrink(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: handleGotoNotificationPage,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.only(
                                                  right: 12, left: 0),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.xiaoxizhongxin,
                                                  size: 20,
                                                  color: 'rgb(0,0,0)',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: handleGotoSettingPage,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.only(
                                                  right: 0),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.shezhi,
                                                  size: 20,
                                                  color: 'rgb(0,0,0)',
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          _scrollDistance <= 0
                              ? GetBuilder<NotificationController>(
                                  builder: (controller) {
                                  return (controller.painNotiicationNum > 0
                                      ? Positioned(
                                          top: 2,
                                          right: 26,
                                          child: GestureDetector(
                                            onTap: handleGotoNotificationPage,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      249, 81, 84, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                              child: Center(
                                                child: Text(
                                                  '${controller.painNotiicationNum > 99 ? '99+' : controller.painNotiicationNum}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ))
                                      : const SizedBox.shrink());
                                })
                              : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshConfiguration(
                      headerTriggerDistance: 60.0,
                      enableScrollWhenRefreshCompleted: true,
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
                        child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GetBuilder<UserController>(
                                                builder: (controller) {
                                                  return Container(
                                                    width: 64,
                                                    height: 64,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child: (userController
                                                                .userInfo
                                                                .avatar ==
                                                            null)
                                                        ? const CircleAvatar(
                                                            radius: 32,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/avatar.webp'),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () =>
                                                                openAvatar(
                                                                    context),
                                                            child: Hero(
                                                              tag:
                                                                  'user-avatar',
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromRGBO(
                                                                        254,
                                                                        251,
                                                                        254,
                                                                        1),
                                                                radius: 32,
                                                                backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                        '${globalController.cdnBaseUrl}/${userController.userInfo.avatar}'),
                                                              ),
                                                            ),
                                                          ),
                                                  );
                                                },
                                              ),
                                              GetBuilder<UserController>(
                                                builder: (controller) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        controller.userInfo
                                                                .name ??
                                                            '赴康云用户',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            controller.userInfo
                                                                        .identity ==
                                                                    1
                                                                ? '医师'
                                                                : '患者',
                                                            style: TextStyle(
                                                                color: controller
                                                                            .userInfo
                                                                            .identity ==
                                                                        1
                                                                    ? const Color
                                                                        .fromRGBO(
                                                                        211,
                                                                        121,
                                                                        47,
                                                                        1)
                                                                    : const Color
                                                                        .fromRGBO(
                                                                        33,
                                                                        33,
                                                                        33,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          (controller.userInfo
                                                                      .identity ==
                                                                  1
                                                              ? Container(
                                                                  width: 18,
                                                                  height: 18,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8),
                                                                  child: Center(
                                                                    child: IconFont(
                                                                        IconNames
                                                                            .guanfangrenzheng,
                                                                        size:
                                                                            18),
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink())
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      RichText(
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text: '@',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              TextSpan(
                                                                text: controller
                                                                    .userInfo
                                                                    .username,
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: handleGotoDataPage,
                                            child: Container(
                                              height: 36,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      18, 0, 18, 0),
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          101, 80, 220, 1),
                                                      Color.fromRGBO(
                                                          101, 80, 220, 0.9),
                                                      Color.fromRGBO(
                                                          101, 80, 220, 0.8)
                                                    ], // 渐变的起始和结束颜色
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18))),
                                              child: const Center(
                                                child: Text(
                                                  '编辑资料',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 0, 24, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () => handleGotoHistory(0),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${myAskCounts > 99 ? '99+' : myAskCounts}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                    width: 12,
                                                  ),
                                                  const Text(
                                                    '提问',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => handleGotoHistory(1),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${myReplyCounts > 99 ? '99+' : myReplyCounts}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                    width: 12,
                                                  ),
                                                  const Text(
                                                    '回答',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => handleGotoHistory(2),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${myCollectCounts > 99 ? '99+' : myCollectCounts}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                    width: 12,
                                                  ),
                                                  const Text(
                                                    '收藏',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => handleGotoHistory(2),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${myLikeCounts > 99 ? '99+' : myLikeCounts}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                    width: 12,
                                                  ),
                                                  const Text(
                                                    '点赞',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    //专业医师入口
                                    GetBuilder<UserController>(
                                        builder: (controller) {
                                      return (controller.userInfo.identity ==
                                                  1 &&
                                              controller
                                                      .userInfo.authenticate ==
                                                  2)
                                          ? MineDoctorEnterMenu(
                                              booksLength: booksLength,
                                              enterCallback: enterCallback)
                                          : const SizedBox.shrink();
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      child: Container(
                                        width: mediaQuerySizeInfo.width - 24,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        padding: const EdgeInsets.all(12),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: (mediaQuerySizeInfo
                                                              .width -
                                                          24 -
                                                          24 -
                                                          2) /
                                                      2,
                                                  height: 48,
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GetBuilder<
                                                          UserController>(
                                                        builder: (controller) {
                                                          return Text(
                                                            '${controller.info.integral}',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                        height: 6,
                                                      ),
                                                      const Text(
                                                        '积分',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 2,
                                                  height: 24,
                                                  color: const Color.fromRGBO(
                                                      227, 227, 227, 1),
                                                ),
                                                GestureDetector(
                                                  onTap: handleGotoBalance,
                                                  child: Container(
                                                    width: (mediaQuerySizeInfo
                                                                .width -
                                                            24 -
                                                            24 -
                                                            2) /
                                                        2,
                                                    height: 48,
                                                    color: Colors.transparent,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GetBuilder<
                                                            UserController>(
                                                          builder:
                                                              (controller) {
                                                            return Text(
                                                              controller
                                                                  .info.balance,
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          232,
                                                                          112,
                                                                          50,
                                                                          1),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                          height: 6,
                                                        ),
                                                        const Text(
                                                          '余额',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: GestureDetector(
                                                onTap: handleGotoBalance,
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.chongzhi,
                                                      size: 24,
                                                      color:
                                                          'rgb(232, 112, 50)',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      child: Column(
                                        children: [
                                          //伤痛档案
                                          const MineRecordMenu(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //面对面康复订单
                                          MineLiveCourseOrderMenu(
                                            learningCounts: learningCounts,
                                            finishCounts: finishCounts,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //专业能力提升订单
                                          MineVideoCourseOrderMenu(
                                              majorCourseCounts:
                                                  majorCourseCounts),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //器材订单
                                          MineEquipmentOrderMenu(
                                            showDetailCallback:
                                                showEquipmentOrderDetailCallback,
                                            equipmentWaitCounts:
                                                equipmentWaitCounts,
                                            equipmentShippingCounts:
                                                equipmentShippingCounts,
                                            equipmentReceivedCounts:
                                                equipmentReceivedCounts,
                                            equipmentCanceledCounts:
                                                equipmentCanceledCounts,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //管理
                                          const MineManageMenu(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //专业医师升级
                                          const MineDoctorMenu(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //专业工具
                                          const MineProfessionalToolMenu(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          //咨询与帮助
                                          const MineHelpMenu(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      )),
                )
              ],
            ),
          ),
          _scrollDistance > 0
              ? Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    color: _colorTween.value,
                    width: mediaQuerySizeInfo.width,
                    height: mediaQuerySafeInfo.top + 48,
                    padding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: mediaQuerySafeInfo.top,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              height: 48,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedOpacity(
                                    opacity: _opacity,
                                    duration: const Duration(milliseconds: 30),
                                    curve: Curves.linear, // 指定渐变方式
                                    child: GetBuilder<UserController>(
                                        builder: (controller) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.userInfo.name ?? '赴康云用户',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          (controller.userInfo.identity == 1
                                              ? Container(
                                                  width: 18,
                                                  height: 18,
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  child: Center(
                                                    child: IconFont(
                                                        IconNames
                                                            .guanfangrenzheng,
                                                        size: 18),
                                                  ),
                                                )
                                              : const SizedBox.shrink())
                                        ],
                                      );
                                    }),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: handleGotoNotificationPage,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.only(
                                              right: 12, left: 0),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.xiaoxizhongxin,
                                              size: 20,
                                              color: 'rgb(0,0,0)',
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: handleGotoSettingPage,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          color: Colors.transparent,
                                          margin:
                                              const EdgeInsets.only(right: 0),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.shezhi,
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
                            GetBuilder<NotificationController>(
                                builder: (controller) {
                              return (controller.painNotiicationNum > 0
                                  ? Positioned(
                                      top: 2,
                                      right: 26,
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
                                      ))
                                  : const SizedBox.shrink());
                            })
                          ],
                        ),
                      ],
                    ),
                  ))
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
