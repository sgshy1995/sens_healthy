import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../iconfont/icon_font.dart';
import '../../../components/long_press_menu.dart';
import '../../models/user_model.dart';
import '../../providers/api/user_client_provider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class MineBalanceDetailInPage extends StatefulWidget {
  final int? recent;

  const MineBalanceDetailInPage({super.key, this.recent});

  @override
  State<MineBalanceDetailInPage> createState() =>
      MineBalanceDetailInPageState();
}

class MineBalanceDetailInPageState extends State<MineBalanceDetailInPage>
    with TickerProviderStateMixin {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  late String keywordCanChange;

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // 滚动位置为顶部
      duration: const Duration(milliseconds: 300), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  /* 数据信息 */
  bool readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<TopUpOrderTypeModel>> topUpOrderDataPagination =
      DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    topUpOrderDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  late AnimationController _rotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  Future<String?> checkUserId() async {
    Completer<String?> completer = Completer();
    if (userController.userInfo.id.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId != null) {
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  Future<String> getTopUpOrders({int? page}) async {
    Completer<String> completer = Completer();
    final String? userIdGet = await checkUserId();
    if (userIdGet != null && userIdGet.isNotEmpty) {
      userClientProvider
          .getTopUpOrdersWithPaginationAction(
              userId: userIdGet,
              pageNo: page ?? _currentPageNo + 1,
              recent: widget.recent)
          .then((value) {
        final valueGet = value.data.data;
        final pageNo = value.data.pageNo;
        final pageSize = value.data.pageSize;
        final totalPage = value.data.totalPage;
        final totalCount = value.data.totalCount;
        setState(() {
          _currentPageNo = pageNo;
          if (pageNo == 1) {
            topUpOrderDataPagination.data = valueGet;
          } else {
            topUpOrderDataPagination.data.addAll(valueGet);
          }
          topUpOrderDataPagination.pageNo = pageNo;
          topUpOrderDataPagination.pageSize = pageSize;
          topUpOrderDataPagination.totalPage = totalPage;
          topUpOrderDataPagination.totalCount = totalCount;
          readyLoad = true;
        });
        completer.complete(pageNo == totalPage ? 'no-data' : 'success');
      }).catchError((e) {
        completer.completeError(e);
      });
    } else {
      completer.completeError('error');
    }

    return completer.future;
  }

  void _scrollListener() {
    setState(() {
      _scrollDistance = _scrollController.offset;
      if (_scrollDistance < 0) {
        _rotationAngle = _scrollDistance > -_headerTriggerDistance
            ? (0 - _scrollDistance) / _headerTriggerDistance * 360
            : 360;
      } else {
        _rotationAngle = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _scrollController.addListener(_scrollListener);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 一圈的弧度值，这里表示一圈的角度为360度
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _rotateController.dispose();
  }

  void onRefresh() {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getTopUpOrders(page: 1);
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
      result = await getTopUpOrders();
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

  final Key linkKey = GlobalKey();

  String formatNumberToThousandsSeparator(double number) {
    NumberFormat formatter = NumberFormat("#,###.##");
    return formatter.format(number);
  }

  EdgeInsets safePadding = MediaQuery.of(Get.context!).padding;

  Widget buildHeader(BuildContext context, RefreshStatus? mode) {
    return Container(
      color: Colors.transparent,
      height: _headerTriggerDistance,
      child: Center(
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
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    Widget skeleton() {
      return Column(
        children: List.generate(10, (int index) {
          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Container(
              width: mediaQuerySizeInfo.width - 24,
              height: 100,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Shimmer.fromColors(
                baseColor: const Color.fromRGBO(229, 229, 229, 1),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: mediaQuerySizeInfo.width - 24,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: RefreshConfiguration(
            headerTriggerDistance: 60.0,
            enableScrollWhenRefreshCompleted:
                true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
            child: SmartRefresher(
                physics: const ClampingScrollPhysics(), // 禁止回弹效果
                enablePullDown: readyLoad,
                enablePullUp: readyLoad,
                header: CustomHeader(
                    builder: buildHeader,
                    onOffsetChange: (offset) {
                      //do some ani
                    }),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget? body;
                    if (topUpOrderDataPagination.data.isEmpty) {
                      body = null;
                    } else if (mode == LoadStatus.idle) {
                      body = const Text(
                        "上拉加载",
                        style: TextStyle(
                            color: Color.fromRGBO(73, 69, 79, 1), fontSize: 14),
                      );
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
                      body = const Text("加载失败，请重试",
                          style: TextStyle(
                              color: Color.fromRGBO(73, 69, 79, 1),
                              fontSize: 14));
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("继续加载更多",
                          style: TextStyle(
                              color: Color.fromRGBO(73, 69, 79, 1),
                              fontSize: 14));
                    } else {
                      body = const Text("没有更多内容了~",
                          style: TextStyle(
                              color: Color.fromRGBO(73, 69, 79, 1),
                              fontSize: 14));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
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
                    (readyLoad && topUpOrderDataPagination.data.isNotEmpty
                        ? const SliverToBoxAdapter()
                        : const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          )),
                    SliverToBoxAdapter(
                      child: (topUpOrderDataPagination.data.isEmpty &&
                              readyLoad)
                          ? Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 48),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        'assets/images/empty.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const Text(
                                      '暂无内容',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(224, 222, 223, 1),
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                    ),
                    SliverToBoxAdapter(
                      child: !readyLoad ? skeleton() : null,
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                      final TopUpOrderTypeModel itemData =
                          topUpOrderDataPagination.data[i];
                      // 获取当前时间
                      DateTime nowTime = DateTime.now();
                      // 格式化日期
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(nowTime);
                      String formattedYearDate =
                          DateFormat('yyyy').format(nowTime);
                      // 获取问题时间
                      DateTime orderTime =
                          DateTime.parse(itemData.payment_time);
                      // 格式化日期
                      String formattedDateOrder =
                          DateFormat('yyyy-MM-dd').format(orderTime);
                      String formattedYearDateOrder =
                          DateFormat('yyyy').format(orderTime);
                      final String showOrderTime;
                      if (formattedDate == formattedDateOrder) {
                        String formattedMinutesDateOrder =
                            DateFormat('HH:mm').format(orderTime);
                        showOrderTime = '$formattedMinutesDateOrder 今天';
                      } else if (formattedYearDate == formattedYearDateOrder) {
                        String formattedMonthsAndMinutesDateOrder =
                            DateFormat('HH:mm MM/dd').format(orderTime);
                        showOrderTime = formattedMonthsAndMinutesDateOrder;
                      } else {
                        String formattedYearsAndMonthsAndMinutesDateOrder =
                            DateFormat('HH:mm yy/MM/dd').format(orderTime);
                        showOrderTime =
                            formattedYearsAndMonthsAndMinutesDateOrder;
                      }

                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (i != 0
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        child: const Divider(
                                          height: 2,
                                          color:
                                              Color.fromRGBO(233, 234, 235, 1),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      )),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (itemData.payment_type != 0
                                        ? SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: Center(
                                              child: IconFont(
                                                  IconNames.top_up_order,
                                                  size: 36),
                                            ),
                                          )
                                        : itemData.created_reason == '购买课程'
                                            ? SizedBox(
                                                width: 36,
                                                height: 36,
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.course_order,
                                                      size: 36),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 36,
                                                height: 36,
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.equipment_order,
                                                      size: 36),
                                                ),
                                              )),
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              itemData.payment_type != 0
                                                  ? '单笔充值'
                                                  : (itemData.created_reason !=
                                                          null
                                                      ? '${itemData.created_reason}消费'
                                                      : '单笔消费'),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            (itemData.payment_type == 1
                                                ? Container(
                                                    width: 24,
                                                    height: 24,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Center(
                                                      child: IconFont(
                                                          IconNames
                                                              .zhifu_weixin,
                                                          size: 24),
                                                    ),
                                                  )
                                                : itemData.payment_type == 2
                                                    ? Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: const EdgeInsets
                                                            .only(left: 12),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames
                                                                  .zhifu_zhifubao,
                                                              size: 24),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink())
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          showOrderTime,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: const Center(
                                                child: Text(
                                                  '订',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                              height: 4,
                                            ),
                                            LongPressMenu(
                                              copyContent: itemData.order_no,
                                              child: RichText(
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: itemData.order_no,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: const Center(
                                                child: Text(
                                                  '交',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                              height: 4,
                                            ),
                                            LongPressMenu(
                                              copyContent: itemData.payment_no,
                                              child: RichText(
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            itemData.payment_no,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: 32,
                              right: 24,
                              child: itemData.payment_type != 0
                                  ? RichText(
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: '¥',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    115, 170, 102, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const WidgetSpan(
                                              child: SizedBox(
                                            width: 6,
                                          )),
                                          TextSpan(
                                            text:
                                                '+${formatNumberToThousandsSeparator(double.parse(itemData.payment_num))}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    115, 170, 102, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ))
                                  : RichText(
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: '¥',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    161, 74, 70, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const WidgetSpan(
                                              child: SizedBox(
                                            width: 6,
                                          )),
                                          TextSpan(
                                            text:
                                                formatNumberToThousandsSeparator(
                                                    double.parse(
                                                        itemData.payment_num)),
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    161, 74, 70, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )))
                        ],
                      );
                    }, childCount: topUpOrderDataPagination.data.length))
                  ],
                )),
          ))
        ],
      ),
    );
  }
}
