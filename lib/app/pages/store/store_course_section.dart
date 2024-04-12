import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import './store_course_search_live.dart';
import './store_course_search_video.dart';

class StoreCourseSectionPage extends StatefulWidget {
  const StoreCourseSectionPage({super.key});
  @override
  State<StoreCourseSectionPage> createState() => _StoreCourseSectionPageState();
}

class _StoreCourseSectionPageState extends State<StoreCourseSectionPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<StoreCourseSearchLivePageState> _storeCourseLivePageState =
      GlobalKey<StoreCourseSearchLivePageState>();
  final GlobalKey<StoreCourseSearchVideoPageState> _storeCourseVideoPageState =
      GlobalKey<StoreCourseSearchVideoPageState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final StoreController storeController = GetInstance().find<StoreController>();
  late TabController _tabController;
  double _opacity = 1.0; // 初始透明度
  double _scrollDistance = 0; // 初始滚动位置

  int tabSelectionIndex = 0;

  int chartNum = 0;

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

  void handleGoToSearch() {}

  void handleGoToChart() {
    Get.toNamed('store_course_chart');
  }

  void loadChartsNum() {
    storeClientProvider.getCourseChartListAction().then((value) {
      storeController
          .setStoreCourseChartNum(value.data != null ? value.data!.length : 0);
    });
  }

  void handleGoBack() {
    Get.back();
  }

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];
  int? courseTypeChoose;
  void handleChooseCourseType(int? index) {
    setState(() {
      courseTypeChoose = index;
    });
    Get.back();
    reLoadChildren(index);
  }

  void reLoadChildren(int? index) {
    _storeCourseLivePageState.currentState?.readyLoad = false;
    _storeCourseLivePageState.currentState?.initPagination();
    _storeCourseLivePageState.currentState?.courseTypeGet = index;
    _storeCourseLivePageState.currentState?.onRefresh();

    _storeCourseVideoPageState.currentState?.readyLoad = false;
    _storeCourseVideoPageState.currentState?.initPagination();
    _storeCourseVideoPageState.currentState?.courseTypeGet = index;
    _storeCourseVideoPageState.currentState?.onRefresh();
  }

  void handleClearChoose() {
    setState(() {
      courseTypeChoose = null;
    });
    reLoadChildren(null);
  }

  void handleSearch(BuildContext context, {bool ifSetToHistory = true}) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments['courseTypeChoose'] != null) {
      courseTypeChoose = Get.arguments['courseTypeChoose'];
    }
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_handleTabViewScroll);
    _tabController.addListener(_handleTabSelection);
    loadChartsNum();
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
      key: _scaffoldKey,
      drawer: Drawer(
        width: 240,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.zero, // 设置顶部边缘为直角
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          height: double.infinity,
          color: const Color.fromRGBO(254, 251, 254, 1),
          child: Column(
            children: [
              SizedBox(
                height: mediaQuerySafeInfo.top + 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 12, left: 6),
                    child: Center(
                      child: IconFont(
                        IconNames.liebiaoxingshi,
                        size: 20,
                        color: 'rgb(0,0,0)',
                      ),
                    ),
                  ),
                  const Text('选择课程分类',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                children: List.generate(courseTypeList.length, (index) {
                  return SizedBox(
                    height: 64,
                    child: GestureDetector(
                      onTap: () => handleChooseCourseType(index),
                      child: Center(
                        child: (courseTypeChoose != index
                            ? Text(
                                courseTypeList[index],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Center(
                                      child: IconFont(IconNames.duigou,
                                          size: 18, color: 'rgb(209,80,54)'),
                                    ),
                                  ),
                                  Text(
                                    courseTypeList[index],
                                    style: const TextStyle(
                                        color: Color.fromRGBO(209, 80, 54, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                      ),
                    ),
                  );
                }),
              ),
              GestureDetector(
                onTap: () {
                  handleClearChoose();
                  Get.back();
                },
                child: SizedBox(
                  height: 64,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: const Text(
                        '清空选择',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Column(
          children: [
            // 使用 AnimatedOpacity 来动态改变透明度
            Expanded(
              child: Stack(children: [
                Column(
                  children: [
                    // 使用 AnimatedOpacity 来动态改变透明度
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          KeepAliveWrapper(
                              child: StoreCourseSearchLivePage(
                                  key: _storeCourseLivePageState,
                                  scrollCallBack: scrollCallBack,
                                  courseType: courseTypeChoose)),
                          KeepAliveWrapper(
                              child: StoreCourseSearchVideoPage(
                                  key: _storeCourseVideoPageState,
                                  scrollCallBack: scrollCallBack,
                                  courseType: courseTypeChoose)),
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
                                    indicatorPadding:
                                        EdgeInsets.zero, // 设置指示器的内边距为零
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
                                          color: Color.fromRGBO(
                                              211, 66, 67, 1), // 底部边框颜色
                                          width: 3, // 底部边框宽度
                                        ),
                                      ),
                                    ),
                                    unselectedLabelColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    labelColor:
                                        const Color.fromRGBO(211, 66, 67, 1),
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
                                              margin: const EdgeInsets.only(
                                                  right: 4),
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
                                              margin: const EdgeInsets.only(
                                                  right: 4),
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
              ]),
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
                                color:
                                    Color.fromRGBO(243, 243, 244, 1), // 底部边框颜色
                                width: 0, // 底部边框宽度
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                child: GestureDetector(
                                  onTap: handleGoBack,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(
                                        right: 12, left: 6),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.fanhui,
                                        size: 20,
                                        color: 'rgb(0,0,0)',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                                width: 24,
                              ),
                              Expanded(
                                  child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 7, 12, 7),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromRGBO(233, 234, 235, 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('已选择',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontSize: 13,
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        // 打开抽屉
                                        _scaffoldKey.currentState?.openDrawer();
                                      },
                                      child: (courseTypeChoose != null
                                          ? Text(
                                              courseTypeList[courseTypeChoose!],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ))
                                          : const Text('全部分类',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ))),
                                    ),
                                    (courseTypeChoose != null
                                        ? GestureDetector(
                                            onTap: handleClearChoose,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 2, 4, 2),
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.7),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6))),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    child: Center(
                                                      child: IconFont(
                                                          IconNames.guanbi,
                                                          size: 12,
                                                          color:
                                                              'rgb(255, 255, 255)'),
                                                    ),
                                                  ),
                                                  const Text('清空选择',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 2, 4, 2),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    233, 234, 235, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: Center(
                                                    child: IconFont(
                                                        IconNames.guanbi,
                                                        size: 12,
                                                        color:
                                                            'rgb(233,234,235)'),
                                                  ),
                                                ),
                                                const Text('清空选择',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          233, 234, 235, 1),
                                                      fontSize: 13,
                                                    ))
                                              ],
                                            ),
                                          ))
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
        Positioned(
            bottom: 24,
            right: 24,
            child: InkWell(
              onTap: handleGoToChart,
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
                    IconNames.gouwuche,
                    size: 24,
                    color: 'rgb(255,255,255)',
                  ),
                ),
              ),
            )),
        (Obx(() => storeController.storeCourseChartNum > 0
            ? Positioned(
                bottom: 56,
                right: 18,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Center(
                    child: Text(
                      '${storeController.storeCourseChartNum.value}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
            : const SizedBox.shrink()))
      ]),
    );
  }
}
