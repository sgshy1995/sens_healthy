import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../iconfont/icon_font.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/data_model.dart';
import '../../models/pain_model.dart';
import 'package:flutter/services.dart';
import '../../../components/keep_alive_wrapper.dart';
import './pain_search_all.dart';
import './pain_search_major.dart';

class PainSearchPage extends StatefulWidget {
  const PainSearchPage({super.key});

  @override
  State<PainSearchPage> createState() => _PainSearchPageState();
}

class _PainSearchPageState extends State<PainSearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<PainSearchAllPageState> _painSearchAllPageState =
      GlobalKey<PainSearchAllPageState>();
  final GlobalKey<PainSearchMajorPageState> _painSearchMajorPageState =
      GlobalKey<PainSearchMajorPageState>();

  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());
  late TabController _tabController;
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

  int allNum = 0;
  int majorNum = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getHistoryList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _textController.dispose();
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  void handleGoBack() {
    Get.back();
  }

  void showDetailCallback() {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  void allSearchNumberCallback(int num) {
    setState(() {
      allNum = num;
    });
  }

  void majorSearchNumberCallback(int num) {
    setState(() {
      majorNum = num;
    });
  }

  void getHistoryList() async {
    // Obtain shared preferences.
    prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    List<String>? searchHistoryListGet =
        prefs.getStringList('pain_search_history');
    if (searchHistoryListGet != null) {
      globalController.setPainSearchHistory(searchHistoryList);
      setState(() {
        searchHistoryList = searchHistoryListGet;
      });
    }
  }

  void clearHistoryList() async {
    await prefs.remove('pain_search_history');
    globalController.setPainSearchHistory([]);
    setState(() {
      searchHistoryList = [];
    });
  }

  void changeSearchContent(String? value) {
    setState(() {
      searchContentValue = value;
    });
  }

  void handleChooseHistory(BuildContext context, String item) {
    _textController.text = item;
    changeSearchContent(item);
    handleSearch(context, ifSetToHistory: false);
  }

  void handleSearch(BuildContext context, {bool ifSetToHistory = true}) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    if (ifSetToHistory &&
        searchContentValue != null &&
        searchContentValue!.isNotEmpty &&
        !searchHistoryList.contains(searchContentValue)) {
      setState(() {
        searchHistoryList.insert(0, searchContentValue!);
        globalController.pushPainSearchHistory(searchContentValue!);
        prefs.setStringList('pain_search_history', searchHistoryList);
      });
    }

    if (!_readySearch) {
      setState(() {
        _readySearch = true;
      });
      painClientProvider
          .getPainQuestionsByCustomAction(
              keyword: searchContentValue ?? '', pageNo: 1, hasMajor: true)
          .then((value) {
        final totalCount = value.data.totalCount;
        setState(() {
          majorNum = totalCount;
        });
      }).catchError((e) {});
    } else {
      setState(() {
        _painSearchAllPageState.currentState?.readyLoad = false;
        _painSearchAllPageState.currentState?.initPagination();
        _painSearchAllPageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painSearchAllPageState.currentState?.onRefresh();

        _painSearchMajorPageState.currentState?.readyLoad = false;
        _painSearchMajorPageState.currentState?.initPagination();
        _painSearchMajorPageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painSearchMajorPageState.currentState?.onRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 36 + mediaQuerySafeInfo.top + 12,
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: Container(
              height: 36 + mediaQuerySafeInfo.top + 12,
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(243, 243, 244, 1), // 底部边框颜色
                    width: 0, // 底部边框宽度
                  ),
                ),
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color.fromRGBO(233, 234, 235, 1)),
                    child: TextField(
                      onSubmitted: (String value) {
                        // 在用户按下确定键或完成输入时调用
                        // 点击外部区域时取消焦点
                        handleSearch(context);
                      },
                      autofocus: true, // 设置为 true，使 TextField 自动获取焦点
                      enabled: inputEnabled,
                      controller: _textController,
                      maxLines: 6,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        fontSize: 15, // 设置字体大小为20像素
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                        fillColor: const Color.fromRGBO(233, 234, 235, 1),
                        filled: true, // 使用图标
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(233, 234, 235, 1)),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(233, 234, 235, 1)),
                          borderRadius: BorderRadius.circular(10), // 设置圆角大小
                        ),
                        focusedBorder: OutlineInputBorder(
                          // 聚焦状态下边框样式
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(233, 234, 235, 1)),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        hintText: '搜索话题 / 问答 ...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                        handleSearch(context);
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
          (_readySearch
              ? Expanded(
                  child: Column(
                  children: [
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
                          Tab(text: '全部 (${allNum > 99 ? '99+' : allNum})'),
                          Tab(
                              text:
                                  '有专业答复 (${majorNum > 99 ? '99+' : majorNum})')
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(243, 243, 244, 1),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          KeepAliveWrapper(
                              child: PainSearchAllPage(
                                  key: _painSearchAllPageState,
                                  keyword: searchContentValue,
                                  searchNumberCallback: allSearchNumberCallback,
                                  showDetailCallback: showDetailCallback)),
                          KeepAliveWrapper(
                              child: PainSearchMajorPage(
                                  key: _painSearchMajorPageState,
                                  keyword: searchContentValue,
                                  searchNumberCallback:
                                      majorSearchNumberCallback,
                                  showDetailCallback: showDetailCallback)),
                        ],
                      ),
                    )
                  ],
                ))
              : Expanded(
                  child: Column(
                  children: [
                    Container(
                      height: 12,
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
                                                fontWeight: FontWeight.bold),
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
                                            searchHistoryList.length, (index) {
                                          return GestureDetector(
                                            onTap: () => handleChooseHistory(
                                                context,
                                                searchHistoryList[index]),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      margin: const EdgeInsets.only(left: 6),
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
                                  children: List.generate(searchWantList.length,
                                      (index) {
                                    return GestureDetector(
                                      onTap: () => handleChooseHistory(
                                          context, searchWantList[index]),
                                      child: Chip(
                                        side: BorderSide.none,
                                        backgroundColor: const Color.fromRGBO(
                                            233, 234, 235, 1),
                                        labelStyle: const TextStyle(
                                            color: Colors.black, fontSize: 14),
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
    );
  }
}
