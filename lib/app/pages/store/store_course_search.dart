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

class StoreCourseSearchPage extends StatefulWidget {
  const StoreCourseSearchPage({super.key});
  @override
  State<StoreCourseSearchPage> createState() => _StoreCourseSearchPageState();
}

class _StoreCourseSearchPageState extends State<StoreCourseSearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<StoreCourseSearchLivePageState> _storeCourseLivePageState =
      GlobalKey<StoreCourseSearchLivePageState>();
  final GlobalKey<StoreCourseSearchVideoPageState> _storeCourseVideoPageState =
      GlobalKey<StoreCourseSearchVideoPageState>();
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final StoreController storeController = Get.put(StoreController());
  late TabController _tabController;
  double _opacity = 1.0; // 初始透明度
  double _scrollDistance = 0; // 初始滚动位置

  final FocusNode _focusNode = FocusNode();

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

  void handleSearch({bool ifSetToHistory = true}) async {
    if (ifSetToHistory &&
        searchContentValue != null &&
        searchContentValue!.isNotEmpty &&
        !searchHistoryList.contains(searchContentValue)) {
      setState(() {
        searchHistoryList.insert(0, searchContentValue!);
        storeController.pushStoreCourseSearchHistory(searchContentValue!);
        prefs.setStringList('store_course_search_history', searchHistoryList);
      });
    }

    if (!_readySearch) {
      setState(() {
        _readySearch = true;
      });
    } else {
      setState(() {
        _storeCourseLivePageState.currentState?.readyLoad = false;
        _storeCourseLivePageState.currentState?.initPagination();
        _storeCourseLivePageState.currentState?.keywordGet =
            searchContentValue ?? '';
        _storeCourseLivePageState.currentState?.onRefresh();

        _storeCourseVideoPageState.currentState?.readyLoad = false;
        _storeCourseVideoPageState.currentState?.initPagination();
        _storeCourseVideoPageState.currentState?.keywordGet =
            searchContentValue ?? '';
        _storeCourseVideoPageState.currentState?.onRefresh();
      });
    }
  }

  final TextEditingController _textController = TextEditingController();
  List<String> searchHistoryList = [];
  bool _readySearch = false;
  bool inputEnabled = true;
  String? searchContentValue;
  late SharedPreferences prefs;

  final List<String> searchWantList = [
    '髋关节疼痛',
    '膝关节损伤',
    '肩关节受伤',
    '腰椎间盘突出',
    '踝关节扭伤',
    'X/O型腿矫正',
    '颈椎病',
    '慢性腰痛',
    '肌肉拉伤',
    '韧带损伤',
    '肌肉疲劳',
    '筋膜炎',
    '骨折康复',
    '关节退化',
    '运动过度损伤',
    '动作不良康复',
    '姿势矫正',
    '术后康复',
    '退行性疾病康复',
    '运动损伤预防',
  ];

  void getHistoryList() async {
    // Obtain shared preferences.
    prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    List<String>? searchHistoryListGet =
        prefs.getStringList('store_course_search_history');
    if (searchHistoryListGet != null) {
      storeController.setStoreCourseSearchHistory(searchHistoryList);
      setState(() {
        searchHistoryList = searchHistoryListGet;
      });
    }
  }

  void clearHistoryList() async {
    await prefs.remove('store_course_search_history');
    storeController.setStoreCourseSearchHistory([]);
    setState(() {
      searchHistoryList = [];
    });
  }

  void changeSearchContent(String? value) {
    setState(() {
      searchContentValue = value;
    });
  }

  void handleChooseHistory(String item) {
    _textController.text = item;
    changeSearchContent(item);
    handleSearch(ifSetToHistory: false);
    Future.delayed(const Duration(milliseconds: 10), () {
      _focusNode.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    getHistoryList();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_handleTabViewScroll);
    _tabController.addListener(_handleTabSelection);
    loadChartsNum();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: _readySearch
            ? const Color.fromRGBO(254, 251, 254, 1)
            : Colors.white,
        child: Stack(children: [
          Column(
            children: [
              // 使用 AnimatedOpacity 来动态改变透明度
              (_readySearch
                  ? Expanded(
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
                                          keyword: searchContentValue)),
                                  KeepAliveWrapper(
                                      child: StoreCourseSearchVideoPage(
                                          key: _storeCourseVideoPageState,
                                          scrollCallBack: scrollCallBack,
                                          keyword: searchContentValue)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                    )
                  : Expanded(
                      child: Column(
                      children: [
                        Container(
                          height: mediaQuerySafeInfo.top + 12 + 36 + 12,
                          color: Colors.white,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                            child: Column(
                              children: [
                                (searchHistoryList.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '搜索历史',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: InkWell(
                                                  onTap: clearHistoryList,
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shanchu,
                                                      size: 24,
                                                      color: 'rgb(0,0,0)',
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Wrap(
                                            spacing: 8.0, // 间距
                                            runSpacing: 4.0, // 行间距
                                            children: List.generate(
                                                searchHistoryList.length,
                                                (index) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    handleChooseHistory(
                                                        searchHistoryList[
                                                            index]),
                                                child: Chip(
                                                  side: BorderSide.none,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          233, 234, 235, 1),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                  label: Text(
                                                      searchHistoryList[index]),
                                                ),
                                              );
                                            }),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      )
                                    : const SizedBox.shrink()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '猜你想搜',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          child: InkWell(
                                            onTap: clearHistoryList,
                                            child: Center(
                                              child: IconFont(
                                                IconNames.cainixihuan,
                                                size: 24,
                                                color: 'rgb(195,77,73)',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Wrap(
                                      spacing: 8.0, // 间距
                                      runSpacing: 4.0, // 行间距
                                      children: List.generate(
                                          searchWantList.length, (index) {
                                        return GestureDetector(
                                          onTap: () => handleChooseHistory(
                                              searchWantList[index]),
                                          child: Chip(
                                            side: BorderSide.none,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    233, 234, 235, 1),
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            label: Text(searchWantList[index]),
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    )))
            ],
          ),
          (_readySearch
              ? Positioned(
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
                                            margin:
                                                const EdgeInsets.only(right: 4),
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
                                            margin:
                                                const EdgeInsets.only(right: 4),
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
                      )))
              : const SizedBox.shrink()),
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
                            decoration: _readySearch
                                ? const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(
                                            243, 243, 244, 1), // 底部边框颜色
                                        width: 0, // 底部边框宽度
                                      ),
                                    ),
                                  )
                                : null,
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 18),
                                  child: GestureDetector(
                                    onTap: handleGoBack,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.fanhui,
                                        size: 20,
                                        color: 'rgb(0,0,0)',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Color.fromRGBO(233, 234, 235, 1)),
                                  child: TextField(
                                    onSubmitted: (String value) {
                                      // 在用户按下确定键或完成输入时调用
                                      // 点击外部区域时取消焦点
                                      Future.delayed(
                                          const Duration(milliseconds: 10), () {
                                        _focusNode.unfocus();
                                      });
                                      handleSearch();
                                    },
                                    autofocus:
                                        true, // 设置为 true，使 TextField 自动获取焦点
                                    focusNode: _focusNode,
                                    onTapOutside: (PointerDownEvent p) {
                                      // 点击外部区域时取消焦点
                                      _focusNode.unfocus();
                                    },
                                    controller: _textController,
                                    maxLines: 6,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      fontSize: 15, // 设置字体大小为20像素
                                    ),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 15),
                                      fillColor: const Color.fromRGBO(
                                          233, 234, 235, 1),
                                      filled: true, // 使用图标
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                233, 234, 235, 1)),
                                        borderRadius:
                                            BorderRadius.circular(4), // 设置圆角大小
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                233, 234, 235, 1)),
                                        borderRadius:
                                            BorderRadius.circular(10), // 设置圆角大小
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        // 聚焦状态下边框样式
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                233, 234, 235, 1)),
                                        borderRadius:
                                            BorderRadius.circular(4), // 设置圆角大小
                                      ),
                                      hintText: '搜索您感兴趣的 ...',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 6.0,
                                              horizontal: 12.0), // 增加垂直内边距来增加高度
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    keyboardType: TextInputType.text,
                                    onChanged: changeSearchContent,
                                  ),
                                )),
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(left: 18),
                                  child: InkWell(
                                    onTap: () {
                                      // 点击外部区域时取消焦点
                                      handleSearch();
                                    },
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
                        ),
                      ),
                    ],
                  ))),
          (_readySearch
              ? Positioned(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                  ))
              : const SizedBox.shrink()),
          (_readySearch
              ? (Obx(() => storeController.storeCourseChartNum > 0
                  ? Positioned(
                      bottom: 56,
                      right: 18,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
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
              : const SizedBox.shrink())
        ]),
      ),
    );
  }
}
