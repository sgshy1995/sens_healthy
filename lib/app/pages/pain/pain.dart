import 'package:flutter/material.dart';
import '../../../iconfont/icon_font.dart';
import './pain_question.dart';

class PainPage extends StatefulWidget {
  const PainPage({super.key});

  @override
  _PainPageState createState() => _PainPageState();
}

class _PainPageState extends State<PainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<PainQuestionPageState> _painQuestionPageState =
      GlobalKey<PainQuestionPageState>();

  final ScrollController _scrollController = ScrollController();
  bool _isAppBarFloating = false;

  late TabController _tabController;
  double _opacity = 1.0; // 初始透明度
  double _scrollDistance = 0; // 初始滚动位置

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

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

  void scrollSignToBottom() {
    // 下滑
    _scrollController.jumpTo(0);
  }

  void _handleScroll() {
    // 计算滚动位置百分比
    double percentage = _scrollController.offset / (36 + 12);
    // 根据百分比计算透明度
    double opacity = 1.0 - percentage;
    // 更新透明度
    setState(() {
      _opacity = opacity.clamp(0.0, 1.0); // 限制透明度在 0.0 到 1.0 之间
    });

    if (_scrollController.offset > (36 + 12) && !_isAppBarFloating) {
      setState(() {
        _isAppBarFloating = true;
      });
    } else if (_scrollController.offset <= (36 + 12) && _isAppBarFloating) {
      setState(() {
        _isAppBarFloating = false;
      });
    }
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
    print('Tab index: ${_tabController.index}');
    scrollToTop();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // 滚动位置为顶部
      duration: const Duration(milliseconds: 300), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // 使用 AnimatedOpacity 来动态改变透明度
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PainQuestionPage(scrollCallBack: scrollCallBack),
                    Center(child: Text('Tab 2 content'))
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
                                  color: Color.fromRGBO(
                                      243, 243, 244, 1), // 底部边框颜色
                                  width: 0, // 底部边框宽度
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: 36,
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Color.fromRGBO(233, 234, 235, 1)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.sousuo,
                                            size: 18,
                                            color: 'rgb(75,77,81)',
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                          child: Text(
                                        '搜索话题 / 问答 ...',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(75, 77, 81, 1),
                                            fontSize: 14),
                                      ))
                                    ],
                                  ),
                                )),
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      margin: const EdgeInsets.only(
                                          right: 12, left: 18),
                                      child: Center(
                                        child: IconFont(
                                          IconNames.kabao,
                                          size: 20,
                                          color: 'rgb(0,0,0)',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 36,
                                      height: 36,
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
                      Container(
                        height: 50, // TabBar高度
                        color: Colors.white,
                        child: TabBar(
                          indicator: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromRGBO(211, 66, 67, 1), // 底部边框颜色
                                width: 3, // 底部边框宽度
                              ),
                            ),
                          ),
                          labelColor: const Color.fromRGBO(211, 66, 67, 1),
                          indicatorColor: const Color.fromRGBO(211, 66, 67, 1),
                          controller: _tabController,
                          tabs: const [Tab(text: '伤痛问答'), Tab(text: '康复资讯')],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Color.fromRGBO(243, 243, 244, 1),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
