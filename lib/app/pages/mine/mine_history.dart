import 'dart:async';

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
import './history/pain_search_history.dart';
import './history/pain_search_history_reply.dart';

class MineHistoryPage extends StatefulWidget {
  const MineHistoryPage({super.key});

  @override
  State<MineHistoryPage> createState() => _MineHistoryPageState();
}

class _MineHistoryPageState extends State<MineHistoryPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<PainSearchHistoryPageState> _painHistoryQuestionPageState =
      GlobalKey<PainSearchHistoryPageState>();
  final GlobalKey<PainSearchHistoryReplyPageState> _painHistoryReplyPageState =
      GlobalKey<PainSearchHistoryReplyPageState>();
  final GlobalKey<PainSearchHistoryPageState> _painHistoryCollectPageState =
      GlobalKey<PainSearchHistoryPageState>();
  final GlobalKey<PainSearchHistoryPageState> _painHistoryLikePageState =
      GlobalKey<PainSearchHistoryPageState>();

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

  int questionNum = 0;
  int replyNum = 0;
  int collectNum = 0;
  int likeNum = 0;

  int initialIndex = 0;

  final FocusNode _focusNode = FocusNode();

  Future<int?> loadMyAskCounts(String userId) {
    Completer<int?> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(
            userId: userId, keyword: searchContentValue)
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
        .getPainRepliesWithQuestionDetailByCustomAction(
            userId: userId, keyword: searchContentValue)
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
        .getPainQuestionsByCustomAction(
            collectUserId: userId, keyword: searchContentValue)
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
        .getPainQuestionsByCustomAction(
            likeUserId: userId, keyword: searchContentValue)
        .then((result) {
      completer.complete(result.data.totalCount);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  Future<String?> loadCounts() async {
    Completer<String?> completer = Completer();
    Future.delayed(const Duration(milliseconds: 100), () async {
      // 等待所有异步任务完成
      final List<int?> results = await Future.wait([
        loadMyAskCounts(userController.userInfo.id),
        loadMyReplyCounts(userController.userInfo.id),
        loadMyCollectCounts(userController.userInfo.id),
        loadMyLikeCounts(userController.userInfo.id)
      ]);

      results.asMap().forEach((index, value) {
        setState(() {
          questionNum = results[0] ?? 0;
          replyNum = results[1] ?? 0;
          collectNum = results[2] ?? 0;
          likeNum = results[3] ?? 0;
        });
      });
    }).then((value) {
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments['initialIndex'] != null) {
      initialIndex = Get.arguments['initialIndex'];
    }
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(_handleTabSelection);
    loadCounts();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  void handleGoBack() {
    Get.back();
  }

  void showDetailCallback() {}

  void questionNumberCallback(int num) {
    setState(() {
      questionNum = num;
    });
  }

  void replyNumberCallback(int num) {
    setState(() {
      replyNum = num;
    });
  }

  void collectNumberCallback(int num) {
    setState(() {
      collectNum = num;
    });
  }

  void likeNumberCallback(int num) {
    setState(() {
      likeNum = num;
    });
  }

  void changeSearchContent(String? value) {
    setState(() {
      searchContentValue = value;
    });
  }

  void handleSearch() async {
    setState(() {
      _painHistoryQuestionPageState.currentState?.readyLoad = false;
      _painHistoryQuestionPageState.currentState?.initPagination();

      _painHistoryReplyPageState.currentState?.readyLoad = false;
      _painHistoryReplyPageState.currentState?.initPagination();

      _painHistoryCollectPageState.currentState?.readyLoad = false;
      _painHistoryCollectPageState.currentState?.initPagination();

      _painHistoryLikePageState.currentState?.readyLoad = false;
      _painHistoryLikePageState.currentState?.initPagination();
    });
    loadCounts().then((result) {
      setState(() {
        _painHistoryQuestionPageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painHistoryQuestionPageState.currentState?.onRefresh();

        _painHistoryReplyPageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painHistoryReplyPageState.currentState?.onRefresh();

        _painHistoryCollectPageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painHistoryCollectPageState.currentState?.onRefresh();

        _painHistoryLikePageState.currentState?.keywordCanChange =
            searchContentValue ?? '';
        _painHistoryLikePageState.currentState?.onRefresh();
      });
    });
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
                      focusNode: _focusNode,
                      onTapOutside: (PointerDownEvent p) {
                        // 点击外部区域时取消焦点
                        _focusNode.unfocus();
                      },
                      onSubmitted: (String value) {
                        // 在用户按下确定键或完成输入时调用
                        // 点击外部区域时取消焦点
                        handleSearch();
                      },
                      autofocus: false, // 设置为 true，使 TextField 自动获取焦点
                      controller: _textController,
                      maxLines: 1,
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
          Expanded(
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
                    Tab(text: '提问 (${questionNum > 99 ? '99+' : questionNum})'),
                    Tab(text: '回答 (${replyNum > 99 ? '99+' : replyNum})'),
                    Tab(text: '收藏 (${collectNum > 99 ? '99+' : collectNum})'),
                    Tab(text: '点赞 (${likeNum > 99 ? '99+' : likeNum})')
                  ],
                ),
              ),
              const Divider(
                height: 2,
                color: Color.fromRGBO(243, 243, 244, 1),
              ),
              Expanded(
                child: GetBuilder<UserController>(
                  builder: (controller) => TabBarView(
                    controller: _tabController,
                    children: [
                      KeepAliveWrapper(
                          child: PainSearchHistoryPage(
                        key: _painHistoryQuestionPageState,
                        keyword: searchContentValue,
                        searchNumberCallback: questionNumberCallback,
                        showDetailCallback: showDetailCallback,
                        heroPrefixKey: 'question',
                        userId: controller.userInfo.id,
                      )),
                      KeepAliveWrapper(
                          child: PainSearchHistoryReplyPage(
                        key: _painHistoryReplyPageState,
                        keyword: searchContentValue,
                        searchNumberCallback: replyNumberCallback,
                        showDetailCallback: showDetailCallback,
                        heroPrefixKey: 'reply',
                        userId: controller.userInfo.id,
                      )),
                      KeepAliveWrapper(
                          child: PainSearchHistoryPage(
                        key: _painHistoryCollectPageState,
                        keyword: searchContentValue,
                        searchNumberCallback: collectNumberCallback,
                        showDetailCallback: showDetailCallback,
                        heroPrefixKey: 'collect',
                        collectUserId: controller.userInfo.id,
                      )),
                      KeepAliveWrapper(
                          child: PainSearchHistoryPage(
                        key: _painHistoryLikePageState,
                        keyword: searchContentValue,
                        searchNumberCallback: likeNumberCallback,
                        showDetailCallback: showDetailCallback,
                        heroPrefixKey: 'like',
                        likeUserId: controller.userInfo.id,
                      )),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
