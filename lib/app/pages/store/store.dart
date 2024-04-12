import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import './store_course.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import './store_course_search.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final StoreController storeController = GetInstance().find<StoreController>();
  final GlobalKey<StoreCoursePageState> _storeCoursePageState =
      GlobalKey<StoreCoursePageState>();
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

  void handleGoToChart() {
    Get.toNamed('store_course_chart');
  }

  void loadChartsNum() {
    storeClientProvider.getCourseChartListAction().then((value) {
      storeController
          .setStoreCourseChartNum(value.data != null ? value.data!.length : 0);
    });
  }

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];
  int? courseTypeChoose;
  void handleChooseCourseType(int index) {
    Get.back();
    Get.toNamed('/store_course_section',
        arguments: {'courseTypeChoose': index});
  }

  void handleGoToSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const StoreCourseSearchPage(),
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

  @override
  void initState() {
    super.initState();
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  KeepAliveWrapper(
                      child: StoreCoursePage(
                          key: _storeCoursePageState,
                          scrollCallBack: scrollCallBack)),
                  KeepAliveWrapper(child: Container()),
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(
                                          right: 12, left: 6),
                                      child: GestureDetector(
                                        onTap: () {
                                          // 打开抽屉
                                          _scaffoldKey.currentState
                                              ?.openDrawer();
                                        },
                                        child: Center(
                                          child: IconFont(
                                            IconNames.liebiaoxingshi,
                                            size: 20,
                                            color: 'rgb(0,0,0)',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(right: 0),
                                      child: GestureDetector(
                                        onTap: handleGoToSearch,
                                        child: Center(
                                          child: IconFont(
                                            IconNames.sousuo,
                                            size: 20,
                                            color: 'rgb(0,0,0)',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: 36, // TabBar高度
                                color: Colors.white,
                                child: TabBar(
                                  dividerHeight: 0,
                                  tabAlignment: TabAlignment.center,
                                  padding: const EdgeInsets.all(0),
                                  isScrollable: true, // 设置为true以启用横向滚动
                                  indicatorPadding:
                                      EdgeInsets.zero, // 设置指示器的内边距为零
                                  onTap: (index) {
                                    if (index == 1) {
                                      // 切换时滚动到顶部
                                      _storeCoursePageState.currentState
                                          ?.scrollToTop();
                                    }
                                  },
                                  indicator: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 1), // 底部边框颜色
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
                                  tabs: const [Text('专业课程'), Text('康复器械')],
                                ),
                              )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(
                                        right: 12, left: 0),
                                    // child: Center(
                                    //   child: IconFont(
                                    //     IconNames.dingdan,
                                    //     size: 20,
                                    //     color: 'rgb(0,0,0)',
                                    //   ),
                                    // ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(right: 6),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.xiaoxizhongxin,
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
