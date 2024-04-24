import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './menus/mine_record_menu.dart';
import './menus/mine_live_course_order_menu.dart';
import './menus/mine_video_course_order_menu.dart';
import './menus/mine_equipment_order_menu.dart';
import './menus/mine_manage_menu.dart';
import './menus/mine_doctor_menu.dart';
import './menus/mine_professional_tool_menu.dart';
import './menus/mine_help_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});
  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with SingleTickerProviderStateMixin {
  final UserController userController = GetInstance().find<UserController>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final PainClientProvider painClientProvider =
      GetInstance().find<PainClientProvider>();
  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  String _colorAnimateStatus = '';

  double _scrollDistance = 0;
  double _opacity = 0; // 初始透明度

  //我的问答信息
  int myAskCounts = 0;
  int myReplyCounts = 0;
  int myCollectCounts = 0;
  int myLikeCounts = 0;

  String? userIdLocal;

  Future<int?> loadMyAskCounts() {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(
            userId: userController.userInfo.id.isNotEmpty
                ? userController.userInfo.id
                : userIdLocal)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyReplyCounts() {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainRepliesByCustomAction(
            userId: userController.userInfo.id.isNotEmpty
                ? userController.userInfo.id
                : userIdLocal)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyCollectCounts() {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(
            collectUserId: userController.userInfo.id.isNotEmpty
                ? userController.userInfo.id
                : userIdLocal)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<int?> loadMyLikeCounts() {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(
            likeUserId: userController.userInfo.id.isNotEmpty
                ? userController.userInfo.id
                : userIdLocal)
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
        completer.complete('success');
      } else {
        completer.completeError('error');
      }
    }
    return completer.future;
  }

  void loadCounts() async {
    await checkUserId();

    List<Future<int?>> futures = [
      loadMyAskCounts(),
      loadMyReplyCounts(),
      loadMyCollectCounts(),
      loadMyLikeCounts()
    ];
    // 等待所有异步任务完成
    final List<int?> results = await Future.wait(futures);
    results.asMap().forEach((index, value) {
      setState(() {
        myAskCounts = results[0] ?? 0;
        myReplyCounts = results[1] ?? 0;
        myCollectCounts = results[2] ?? 0;
        myLikeCounts = results[3] ?? 0;
      });
    });
  }

  void _scrollListener() {
    setState(() {
      _scrollDistance = _scrollController.offset;
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

  @override
  void initState() {
    super.initState();

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
    loadCounts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
                Expanded(
                  child:
                      CustomScrollView(controller: _scrollController, slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.transparent,
                            height: mediaQuerySafeInfo.top + 48,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetBuilder<UserController>(
                                      builder: (controller) {
                                        return Container(
                                          width: 64,
                                          height: 64,
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          child: (userController
                                                      .userInfo.avatar ==
                                                  null)
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/avatar.webp'),
                                                )
                                              : GestureDetector(
                                                  onTap: () =>
                                                      openAvatar(context),
                                                  child: Hero(
                                                    tag: 'user-avatar',
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              254, 251, 254, 1),
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
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.userInfo.name ??
                                                  '赴康云用户',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                                      color: controller.userInfo
                                                                  .identity ==
                                                              1
                                                          ? const Color
                                                              .fromRGBO(
                                                              211, 121, 47, 1)
                                                          : const Color
                                                              .fromRGBO(
                                                              33, 33, 33, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                (controller.userInfo.identity ==
                                                        1
                                                    ? Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(left: 8),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames
                                                                  .guanfangrenzheng,
                                                              size: 18),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink())
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '@',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              33, 33, 33, 1),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    TextSpan(
                                                      text: controller
                                                          .userInfo.username,
                                                      style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              33, 33, 33, 1),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
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
                                        const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromRGBO(101, 80, 220, 1),
                                            Color.fromRGBO(101, 80, 220, 0.9),
                                            Color.fromRGBO(101, 80, 220, 0.8)
                                          ], // 渐变的起始和结束颜色
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: const Center(
                                      child: Text(
                                        '编辑资料',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
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
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${myAskCounts > 99 ? '99+' : myAskCounts}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${myReplyCounts > 99 ? '99+' : myReplyCounts}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${myCollectCounts > 99 ? '99+' : myCollectCounts}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${myLikeCounts > 99 ? '99+' : myLikeCounts}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Container(
                              width: mediaQuerySizeInfo.width - 24,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(12),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: (mediaQuerySizeInfo.width -
                                                24 -
                                                24 -
                                                2) /
                                            2,
                                        height: 48,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GetBuilder<UserController>(
                                              builder: (controller) {
                                                return Text(
                                                  '${controller.info.integral}',
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                      SizedBox(
                                        width: (mediaQuerySizeInfo.width -
                                                24 -
                                                24 -
                                                2) /
                                            2,
                                        height: 48,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GetBuilder<UserController>(
                                              builder: (controller) {
                                                return Text(
                                                  controller.info.balance,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          232, 112, 50, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Center(
                                        child: IconFont(
                                          IconNames.chongzhi,
                                          size: 24,
                                          color: 'rgb(232, 112, 50)',
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
                          const Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Column(
                              children: [
                                //伤痛档案
                                MineRecordMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //面对面康复订单
                                MineLiveCourseOrderMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //专业能力提升订单
                                MineVideoCourseOrderMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //器材订单
                                MineEquipmentOrderMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //管理
                                MineManageMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //专业医师升级
                                MineDoctorMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //专业工具
                                MineProfessionalToolMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                                //咨询与帮助
                                MineHelpMenu(),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          Positioned(
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
                    SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: _opacity,
                            duration: const Duration(milliseconds: 30),
                            curve: Curves.linear, // 指定渐变方式
                            child: GetBuilder<UserController>(
                                builder: (controller) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Center(
                                            child: IconFont(
                                                IconNames.guanfangrenzheng,
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
                              Container(
                                width: 24,
                                height: 24,
                                margin:
                                    const EdgeInsets.only(right: 12, left: 0),
                                child: Center(
                                  child: IconFont(
                                    IconNames.xiaoxizhongxin,
                                    size: 20,
                                    color: 'rgb(0,0,0)',
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 0),
                                child: Center(
                                  child: IconFont(
                                    IconNames.shezhi,
                                    size: 20,
                                    color: 'rgb(0,0,0)',
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
