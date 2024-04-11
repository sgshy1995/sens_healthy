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
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/scale_button.dart';
import '../../providers/api/store_client_provider.dart';
import '../../controllers/store_controller.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class StoreCourseSearchVideoPage extends StatefulWidget {
  StoreCourseSearchVideoPage(
      {super.key, required this.scrollCallBack, this.courseType, this.keyword});

  late int? courseType;
  late String? keyword;

  late ScrollCallback scrollCallBack;

  @override
  State<StoreCourseSearchVideoPage> createState() =>
      StoreCourseSearchVideoPageState();
}

class StoreCourseSearchVideoPageState extends State<StoreCourseSearchVideoPage>
    with SingleTickerProviderStateMixin {
  final StoreController storeController = GetInstance().find<StoreController>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  late int? courseTypeGet;
  late String? keywordGet;

  /* 数据信息 */
  bool readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<StoreVideoCourseTypeModel>>
      videoCourseDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    videoCourseDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

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

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  int _myCourseNum = 0;

  Future<String> getVideoCourses({int? page}) {
    Completer<String> completer = Completer();
    storeClientProvider
        .getVideoCoursesByCustomAction(
            pageNo: page ?? _currentPageNo + 1,
            keyword: keywordGet,
            courseType: courseTypeGet)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          videoCourseDataPagination.data = valueGet;
        } else {
          videoCourseDataPagination.data.addAll(valueGet);
        }
        videoCourseDataPagination.pageNo = pageNo;
        videoCourseDataPagination.pageSize = pageSize;
        videoCourseDataPagination.totalPage = totalPage;
        videoCourseDataPagination.totalCount = totalCount;
        readyLoad = true;
      });
      completer.complete(pageNo == totalPage ? 'no-data' : 'success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
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

  void onRefresh() {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getVideoCourses(page: 1);
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
      result = await getVideoCourses();
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

  bool addChartDisabled = false;

  void loadChartsNum() {
    storeClientProvider.getCourseChartListAction().then((value) {
      storeController
          .setStoreCourseChartNum(value.data != null ? value.data!.length : 0);
    });
  }

  void handleAddToChart(StoreVideoCourseTypeModel item) {
    setState(() {
      addChartDisabled = true;
    });
    storeClientProvider.createCourseChartAction(item.id, 0).then((value) {
      loadChartsNum();
      setState(() {
        addChartDisabled = false;
      });
      if (value.code != 200) {
        showToast(value.message);
      }
    }).catchError((e) {
      showToast('添加失败, 请稍后再试');
    });
  }

  void handleGoToDetail(String courseId) {
    Get.toNamed('/store_course_video_detail',
        arguments: {'courseId': courseId});
  }

  @override
  void initState() {
    super.initState();

    courseTypeGet = widget.courseType;
    keywordGet = widget.keyword;

    _onRefresh();
    _scrollController.addListener(_scrollListener);

    _RotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 一圈的弧度值，这里表示一圈的角度为360度
    ).animate(_RotateController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    _RotateController.dispose();
    super.dispose();
  }

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
    final double itemWidthOrHeight =
        (mediaQuerySizeInfo.width - 18 - 18 - 18) / 2;

    Widget skeleton() {
      return Container();
    }

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
                      Widget? body;
                      if (videoCourseDataPagination.data.isEmpty) {
                        body = null;
                      } else if (mode == LoadStatus.idle) {
                        body = const Text(
                          "上拉加载",
                          style: TextStyle(
                              color: Color.fromRGBO(73, 69, 79, 1),
                              fontSize: 14),
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
                  child:
                      CustomScrollView(controller: _scrollController, slivers: [
                    SliverToBoxAdapter(
                      child: (videoCourseDataPagination.data.isEmpty &&
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
                    SliverToBoxAdapter(
                      child: (videoCourseDataPagination.data.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '搜索结果 · ${videoCourseDataPagination.data.length}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : null),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    // 交叉轴子项数量
                                    mainAxisSpacing: 18, // 主轴间距
                                    crossAxisSpacing: 18, // 交叉轴间距
                                    childAspectRatio: 1,
                                    mainAxisExtent:
                                        itemWidthOrHeight / 4 * 3 + 100,
                                    maxCrossAxisExtent: itemWidthOrHeight),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero, // 设置为零边距
                            shrinkWrap: true,
                            itemCount: videoCourseDataPagination.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String frequencyNumShow = (videoCourseDataPagination
                                              .data[index].frequency_num >
                                          1000 &&
                                      videoCourseDataPagination
                                              .data[index].frequency_num <=
                                          10000)
                                  ? '${(videoCourseDataPagination.data[index].frequency_num / 1000).floor()}k+'
                                  : (videoCourseDataPagination
                                                  .data[index].frequency_num >
                                              10000 &&
                                          videoCourseDataPagination
                                                  .data[index].frequency_num <=
                                              100000)
                                      ? '${(videoCourseDataPagination.data[index].frequency_num / 10000).floor()}k+'
                                      : '${videoCourseDataPagination.data[index].frequency_num}';

                              final String discountPercentItem =
                                  videoCourseDataPagination
                                              .data[index].is_discount ==
                                          1
                                      ? '-${(((double.parse(videoCourseDataPagination.data[index].price) - double.parse(videoCourseDataPagination.data[index].discount!)) / double.parse(videoCourseDataPagination.data[index].price)) * 100).round()}%'
                                      : "";

                              return GestureDetector(
                                onTap: () => handleGoToDetail(
                                    videoCourseDataPagination.data[index].id),
                                child: Container(
                                  width: itemWidthOrHeight,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // 设置圆角
                                              child: Image(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: itemWidthOrHeight,
                                            height: itemWidthOrHeight / 4 * 3,
                                            imageUrl:
                                                '${globalController.cdnBaseUrl}/${videoCourseDataPagination.data[index].cover}',
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          top: itemWidthOrHeight / 4 * 3 - 32,
                                          right: 8,
                                          child: Row(
                                            children: [
                                              (videoCourseDataPagination
                                                          .data[index]
                                                          .is_discount ==
                                                      1
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          height: 24,
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  4, 0, 4, 0),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.7)),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 18,
                                                                height: 18,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            4),
                                                                child: Center(
                                                                  child: IconFont(
                                                                      IconNames
                                                                          .pic_discount,
                                                                      size: 18),
                                                                ),
                                                              ),
                                                              Text(
                                                                discountPercentItem,
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            209,
                                                                            120,
                                                                            47,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()),
                                              Container(
                                                height: 24,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.7)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        text: TextSpan(
                                                            text:
                                                                '已售 $frequencyNumShow',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12))),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      Positioned(
                                        right: 0,
                                        left: 0,
                                        top: itemWidthOrHeight / 4 * 3,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            videoCourseDataPagination
                                                                .data[index]
                                                                .title,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: '专业能力提升 · ',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    33,
                                                                    33,
                                                                    1),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      TextSpan(
                                                        text: courseTypeList[
                                                            videoCourseDataPagination
                                                                .data[index]
                                                                .course_type],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    33,
                                                                    33,
                                                                    1),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '视频数: ${videoCourseDataPagination.data[index].video_num}',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    33,
                                                                    33,
                                                                    1),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              (videoCourseDataPagination
                                                          .data[index]
                                                          .is_discount ==
                                                      0
                                                  ? RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '¥ ${videoCourseDataPagination.data[index].price}',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ))
                                                  : RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '¥ ${videoCourseDataPagination.data[index].price}',
                                                            style: const TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        200,
                                                                        200,
                                                                        200,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const WidgetSpan(
                                                            child: SizedBox(
                                                                width:
                                                                    6), // 设置间距为10
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '¥ ${videoCourseDataPagination.data[index].discount}',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        209,
                                                                        120,
                                                                        47,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 6,
                                          right: 6,
                                          child: ScaleButton(
                                            disabled: addChartDisabled,
                                            onTab: () => handleAddToChart(
                                                videoCourseDataPagination
                                                    .data[index]),
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          158, 158, 158, 0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Color.fromRGBO(
                                                      211, 66, 67, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.tianjia,
                                                  size: 16,
                                                  color: 'rgb(255,255,255)',
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ]))),
        )
      ],
    ));
  }
}
