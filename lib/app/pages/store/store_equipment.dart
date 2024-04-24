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
import './store_equipment_in.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class StoreEquipmentPage extends StatefulWidget {
  const StoreEquipmentPage({super.key, required this.scrollCallBack});

  final ScrollCallback scrollCallBack;

  @override
  State<StoreEquipmentPage> createState() => StoreEquipmentPageState();
}

class StoreEquipmentPageState extends State<StoreEquipmentPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<StoreEquipmentInPageState> _storeEquipmentInPageHotState =
      GlobalKey<StoreEquipmentInPageState>();
  final GlobalKey<StoreEquipmentInPageState>
      _storeEquipmentInPageDiscountState =
      GlobalKey<StoreEquipmentInPageState>();
  final GlobalKey<StoreEquipmentInPageState> _storeEquipmentInPageAllState =
      GlobalKey<StoreEquipmentInPageState>();
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());

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
    _storeEquipmentInPageHotState.currentState?.scrollToTop();
    _storeEquipmentInPageDiscountState.currentState?.scrollToTop();
    _storeEquipmentInPageAllState.currentState?.scrollToTop();
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

  bool _readyLoad = false;

  List<StoreEquipmentTypeModel> carouselData = [];

  Future<String> getEquipmentsCarouse() {
    Completer<String> completer = Completer();
    storeClientProvider.getCarouselEquipmentsAction().then((value) {
      final carouselDataGet = value.data!;
      setState(() {
        carouselData = [...carouselDataGet];
        _readyLoad = true;
      });
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  int _myCourseNum = 0;

  void _scrollListener() {
    setState(() {
      _scrollDistance = _scrollController.offset;
      widget.scrollCallBack(_scrollDistance);
      if (_scrollDistance < 0) {
        _rotationAngle = _scrollDistance > -_headerTriggerDistance
            ? (0 - _scrollDistance) / _headerTriggerDistance * 360
            : 360;
      } else {
        _rotationAngle = 0;
      }
    });
  }

  void onRefresh() {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getLiveCourses(page: 1);
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
      result = await getLiveCourses();
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

  Future getLiveCourses({int? page}) {
    return Future(() => null);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _tabController.animation!.addListener(_handleTabViewScroll);
    _tabController.addListener(_handleTabSelection);
    getEquipmentsCarouse();
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
                    child: StoreEquipmentInPage(
                        ifUseCarousel: false,
                        hotOrder: 1,
                        key: _storeEquipmentInPageHotState,
                        scrollCallBack: scrollCallBack)),
                KeepAliveWrapper(
                    child: StoreEquipmentInPage(
                        ifUseCarousel: false,
                        hasDiscount: 1,
                        key: _storeEquipmentInPageDiscountState,
                        scrollCallBack: scrollCallBack)),
                KeepAliveWrapper(
                    child: StoreEquipmentInPage(
                        key: _storeEquipmentInPageAllState,
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
                            _storeEquipmentInPageHotState.currentState
                                ?.scrollToTop();
                            _storeEquipmentInPageDiscountState.currentState
                                ?.scrollToTop();
                            _storeEquipmentInPageAllState.currentState
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
                                        IconNames.remen,
                                        size: 20,
                                        color: 'rgb(221,66,101)',
                                      ),
                                    ),
                                  ),
                                  const Text('热门')
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
                                        IconNames.zhekou,
                                        size: 20,
                                        color: 'rgb(97,59,208)',
                                      ),
                                    ),
                                  ),
                                  const Text('折扣')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                              child: Row(
                                children: [Text('全部')],
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
