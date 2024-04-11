import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/app/models/store_model.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/api/store_client_provider.dart';
import './store_course_live.dart';
import './store_course_video.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class StoreCoursePage extends StatefulWidget {
  StoreCoursePage({super.key, required this.scrollCallBack});

  late ScrollCallback scrollCallBack;

  @override
  State<StoreCoursePage> createState() => StoreCoursePageState();
}

class StoreCoursePageState extends State<StoreCoursePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<StoreCourseLivePageState> _storeCourseLivePageState =
      GlobalKey<StoreCourseLivePageState>();
  final GlobalKey<StoreCourseVideoPageState> _storeCourseVideoPageState =
      GlobalKey<StoreCourseVideoPageState>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  late TabController _tabController;

  int tabSelectionIndex = 0;

  void scrollCallBack(double scrollDistance) {
    // 上滑
    setState(() {
      // 计算滚动位置百分比
      _scrollDistance = scrollDistance < 0
          ? 0
          : scrollDistance <= (36 + 12)
              ? -scrollDistance
              : (0 - (36 + 12));
    });
    widget.scrollCallBack(scrollDistance);
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
    _storeCourseLivePageState.currentState?.scrollToTop();
    _storeCourseVideoPageState.currentState?.scrollToTop();
    setState(() {
      tabSelectionIndex = _tabController.index;
    });
  }

  void _handleTabViewScroll() {
    final index = _tabController.animation!.value.round();
    if (tabSelectionIndex != index) {
      setState(() {
        tabSelectionIndex = index;
      });
    }
  }

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

  final CarouselController _carouselController = CarouselController();
  int _carouselInitialIndex = 0;
  void jumpToIndexCarouselPage(int index) {
    _carouselController.animateToPage(index);
  }

  dynamic Function(int, CarouselPageChangedReason)? carouselCallbackFunction(
      index, reason) {
    setState(() {
      _carouselInitialIndex = index;
    });
    return null;
  }

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  int _myCourseNum = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_handleTabViewScroll);
    _tabController.addListener(_handleTabSelection);
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
      Column(
        children: [
          // 使用 AnimatedOpacity 来动态改变透明度
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                KeepAliveWrapper(
                    child: StoreCourseLivePage(
                        key: _storeCourseLivePageState,
                        scrollCallBack: scrollCallBack)),
                KeepAliveWrapper(
                    child: StoreCourseVideoPage(
                        key: _storeCourseVideoPageState,
                        scrollCallBack: scrollCallBack)),
              ],
            ),
          )
        ],
      ),
      Positioned(
          top: _scrollDistance + 36 + mediaQuerySafeInfo.top + 12,
          left: 0,
          right: 0,
          child: Visibility(
              visible: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                        height: 50, // TabBar高度
                        color: Colors.white,
                        child: TabBar(
                          dividerHeight: 0,
                          tabAlignment: TabAlignment.start,
                          padding: const EdgeInsets.all(0),
                          isScrollable: true, // 设置为true以启用横向滚动
                          indicatorPadding: EdgeInsets.zero, // 设置指示器的内边距为零
                          onTap: (index) {
                            // 切换时滚动到顶部
                            _storeCourseLivePageState.currentState
                                ?.scrollToTop();
                            _storeCourseVideoPageState.currentState
                                ?.scrollToTop();
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
                          indicatorColor:
                              const Color.fromRGBO(255, 255, 255, 1),
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
                      ))
                    ],
                  ),
                  const Divider(
                    height: 2,
                    color: Color.fromRGBO(243, 243, 244, 1),
                  )
                ],
              ))),
    ]));
  }
}
