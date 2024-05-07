import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../../components/slide_transition_x.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './center_course.dart';
import './center_major.dart';

class CenterPage extends StatefulWidget {
  const CenterPage({super.key});

  @override
  State<CenterPage> createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());

  final GlobalKey<CenterCoursePageState> _centerCoursePageState =
      GlobalKey<CenterCoursePageState>();
  final GlobalKey<CenterMajorPageState> _centerMajorPageState =
      GlobalKey<CenterMajorPageState>();

  late TabController _tabController;

  int tabSelectionIndex = 0;

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
    setState(() {
      tabSelectionIndex = _tabController.index;
    });
    _centerCoursePageState.currentState?.scrollToTop();
    _centerMajorPageState.currentState?.scrollToTop();
  }

  void _handleTabViewScroll() {
    final index = _tabController.animation!.value.round();
    if (tabSelectionIndex != index) {
      setState(() {
        tabSelectionIndex = index;
      });
      _centerCoursePageState.currentState?.scrollToTop();
      _centerMajorPageState.currentState?.scrollToTop();
    }
  }

  double _opacity = 1.0; // 初始透明度

  double _scrollDistance = 0;

  void scrollCallBack(double scrollDistance) {
    setState(() {
      _scrollDistance = scrollDistance < 0
          ? 0
          : scrollDistance <= (44 + 24)
              ? -scrollDistance
              : (0 - (44 + 24));

      double percentage = scrollDistance / (44 + 24);
      double opacity = 1.0 - percentage;
      _opacity = opacity.clamp(0.0, 1.0); // 限制透明度在 0.0 到 1.0 之间
    });
  }

  List bookList = [];

  void handleGoBack() {
    Get.back();
  }

  late final String timeStringNow;

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return '早上';
    } else if (hour >= 12 && hour < 14) {
      return '中午';
    } else if (hour >= 14 && hour < 18) {
      return '下午';
    } else {
      return '晚上';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_handleTabViewScroll);
    _tabController.addListener(_handleTabSelection);
    if (Get.arguments != null && Get.arguments['tab'] != null) {
      if (Get.arguments['tab'] == 'major') {
        _tabController.animateTo(1);
        tabSelectionIndex = 1;
      }
    }
    timeStringNow = getTimeOfDay();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(children: [
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
          child: Column(children: [
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                KeepAliveWrapper(
                    child: CenterCoursePage(
                        key: _centerCoursePageState,
                        scrollCallBack: scrollCallBack)),
                KeepAliveWrapper(
                    child: CenterMajorPage(
                        key: _centerMajorPageState,
                        scrollCallBack: scrollCallBack)),
              ],
            ))
          ])),
      Positioned(
        top: _scrollDistance + mediaQuerySafeInfo.top + 24,
        left: 0,
        right: 0,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 30),
                  curve: Curves.linear, // 指定渐变方式
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<UserController>(
                          builder: (controller) {
                            return Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 18),
                              child: (userController.userInfo.avatar == null)
                                  ? const CircleAvatar(
                                      radius: 22,
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar.webp'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: const Color.fromRGBO(
                                          254, 251, 254, 1),
                                      radius: 22,
                                      backgroundImage: CachedNetworkImageProvider(
                                          '${globalController.cdnBaseUrl}/${userController.userInfo.avatar}'),
                                    ),
                            );
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<UserController>(builder: (controller) {
                              return RichText(
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$timeStringNow好,',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 6,
                                      )),
                                      TextSpan(
                                        text:
                                            controller.userInfo.name ?? '赴康云用户',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ));
                            }),
                            const SizedBox(
                              height: 8,
                            ),
                            RichText(
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '开始您新的一天健康之旅!',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(100, 100, 100, 1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: IconFont(IconNames.sayhi, size: 32),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 50, // TabBar高度
                  color: Colors.transparent,
                  child: TabBar(
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.all(0),
                    isScrollable: true, // 设置为true以启用横向滚动
                    indicatorPadding: EdgeInsets.zero, // 设置指示器的内边距为零
                    onTap: (index) {
                      // 切换时滚动到顶部
                      // _storeCourseLivePageState
                      //     .currentState
                      //     ?.scrollToTop();
                      // _storeCourseVideoPageState
                      //     .currentState
                      //     ?.scrollToTop();
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
                    indicatorColor: const Color.fromRGBO(255, 255, 255, 1),
                    controller: _tabController,
                    tabs: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 4),
                              child: Center(
                                child: IconFont(
                                  IconNames.live_fill,
                                  size: 20,
                                  color: tabSelectionIndex == 0
                                      ? 'rgb(151,63,247)'
                                      : 'rgb(0,0,0)',
                                ),
                              ),
                            ),
                            const Text('面对面康复指导')
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 4),
                              child: Center(
                                child: IconFont(
                                  IconNames.video_fill,
                                  size: 20,
                                  color: tabSelectionIndex == 1
                                      ? 'rgb(28,144,237)'
                                      : 'rgb(0,0,0)',
                                ),
                              ),
                            ),
                            const Text('专业能力提升')
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                top: 18,
                left: 40,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 30),
                    curve: Curves.linear, // 指定渐变方式
                    child: GetBuilder<UserController>(builder: (controller) {
                      return (controller.userInfo.identity == 1
                          ? Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(left: 0),
                              child: Center(
                                child: IconFont(IconNames.guanfangrenzheng,
                                    size: 24),
                              ),
                            )
                          : const SizedBox.shrink());
                    })))
          ],
        ),
      ),
      Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Column(
            children: [
              SizedBox(
                height: mediaQuerySafeInfo.top,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: handleGoBack,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 16,
                              color: 'rgb(255,255,255)',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _opacity == 0
                      ? GetBuilder<UserController>(builder: (controller) {
                          return Row(
                            children: [
                              const SizedBox(
                                width: 6,
                              ),
                              RichText(
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$timeStringNow好,',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 6,
                                      )),
                                      TextSpan(
                                        text:
                                            controller.userInfo.name ?? '赴康云用户',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                width: 6,
                              ),
                              GetBuilder<UserController>(builder: (controller) {
                                return (controller.userInfo.identity == 1
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        margin: const EdgeInsets.only(left: 0),
                                        child: Center(
                                          child: IconFont(
                                              IconNames.guanfangrenzheng,
                                              size: 24),
                                        ),
                                      )
                                    : const SizedBox.shrink());
                              })
                            ],
                          );
                        })
                      : const SizedBox.shrink()
                ],
              )
            ],
          ))
    ]));
  }
}
