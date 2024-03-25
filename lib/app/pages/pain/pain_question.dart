import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../iconfont/icon_font.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class PainQuestionPage extends StatefulWidget {
  PainQuestionPage({super.key, required this.scrollCallBack});

  late ScrollCallback scrollCallBack;

  @override
  PainQuestionPageState createState() => PainQuestionPageState();
}

class PainQuestionPageState extends State<PainQuestionPage>
    with TickerProviderStateMixin {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);

    _RotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 一圈的弧度值，这里表示一圈的角度为360度
    ).animate(_RotateController);
  }

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

  bool isAtTop = false;
  bool isAtBottom = false;

  void changeIsAtTop(isAtTopNew) {
    setState(() {
      isAtTop = isAtTopNew;
    });
  }

  void changeIsAtBottom(isAtBottomNew) {
    setState(() {
      isAtBottom = isAtBottomNew;
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  final Key linkKey = GlobalKey();

  EdgeInsets safePadding = MediaQuery.of(Get.context!).padding;

  Widget buildHeader(BuildContext context, RefreshStatus? mode) {
    return Container(
      color: Colors.white,
      height: _headerTriggerDistance,
      child: Center(
          // child: Text(
          //     mode == RefreshStatus.idle
          //         ? "下拉刷新"
          //         : mode == RefreshStatus.refreshing
          //             ? "刷新中..."
          //             : mode == RefreshStatus.canRefresh
          //                 ? "可以松手了!"
          //                 : mode == RefreshStatus.completed
          //                     ? "刷新成功!"
          //                     : "刷新失败",
          //     style: TextStyle(color: Colors.black))),
          child:
              (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh)
                  ? Transform.rotate(
                      angle: _rotationAngle * (3.14159 / 180),
                      child: IconFont(
                        IconNames.shuaxin,
                        size: 28,
                        color: '#333',
                      ),
                    )
                  : const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color.fromRGBO(33, 33, 33, 1),
                            strokeWidth: 2),
                      ),
                    )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: mediaQuerySafeInfo.top +
                12 +
                12 +
                12 +
                50 +
                12 -
                (_scrollDistance < 0
                    ? 0
                    : _scrollDistance < (36 + 12)
                        ? _scrollDistance
                        : (36 + 12)),
            color: Colors.white,
          ),
          Expanded(
              child: RefreshConfiguration(
            headerTriggerDistance: 60.0,
            enableScrollWhenRefreshCompleted:
                true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
            child: SmartRefresher(
                physics: const ClampingScrollPhysics(), // 禁止回弹效果
                enablePullDown: true,
                enablePullUp: true,
                header: CustomHeader(
                    builder: buildHeader,
                    onOffsetChange: (offset) {
                      //do some ani
                    }),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("上拉加载");
                    } else if (mode == LoadStatus.loading) {
                      body = const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Color.fromRGBO(33, 33, 33, 1),
                              strokeWidth: 2),
                        ),
                      );
                    } else if (mode == LoadStatus.failed) {
                      body = Text("加载失败！点击重试！");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("继续加载更多");
                    } else {
                      body = Text("没有更多数据了!");
                    }
                    return Container(
                      height: 40.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                // child: ListView.builder(
                //   controller: _scrollController,
                //   itemBuilder: (c, i) => i == 0
                //       ? Container(
                //           height: mediaQuerySafeInfo.top + 12 + 50 + 12 + 12 + 12,
                //           color: Colors.white,
                //         )
                //       : SizedBox(
                //           height: 100,
                //           child: Card(child: Center(child: Text(items[i]))),
                //         ),
                //   itemCount: items.length,
                // ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.pink,
                        height: 0,
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (c, i) => SizedBox(
                                  height: 100,
                                  child: Card(
                                      child: Center(child: Text(items[i]))),
                                ),
                            childCount: items.length))
                  ],
                )),
          ))
        ],
      ),
    );
  }

  // 1.5.0后,应该没有必要加这一行了
  // @override
  // void dispose() {
  // TODO: implement dispose
  //   _refreshController.dispose();
//    super.dispose();
//  }
}
