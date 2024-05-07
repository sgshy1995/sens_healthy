import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sens_healthy/components/loading.dart';
import '../../cache/token_manager.dart';
import '../../models/appointment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../iconfont/icon_font.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/app/models/store_model.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/major_mode.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/major_client_provider.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class CenterMajorPage extends StatefulWidget {
  CenterMajorPage({super.key, required this.scrollCallBack});

  late ScrollCallback scrollCallBack;

  @override
  State<CenterMajorPage> createState() => CenterMajorPageState();
}

class CenterMajorPageState extends State<CenterMajorPage>
    with SingleTickerProviderStateMixin {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final MajorClientProvider majorClientProvider =
      Get.put(MajorClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  /* 数据信息 */
  bool _readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<MajorCourseTypeModel>> majorCourseDataPagination =
      DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    setState(() {
      majorCourseDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
    });
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

  Future<String> getMajorCourses({int? page}) {
    Completer<String> completer = Completer();
    majorClientProvider
        .findManyMajorCoursesAction(
            pageNo: page ?? _currentPageNo + 1,
            userId: userController.userInfo.id)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          majorCourseDataPagination.data = valueGet;
        } else {
          majorCourseDataPagination.data.addAll(valueGet);
        }
        majorCourseDataPagination.pageNo = pageNo;
        majorCourseDataPagination.pageSize = pageSize;
        majorCourseDataPagination.totalPage = totalPage;
        majorCourseDataPagination.totalCount = totalCount;
        _readyLoad = true;
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
      result = await getMajorCourses(page: 1);
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
      result = await getMajorCourses();
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

  void handleGotoDetailPage(MajorCourseTypeModel item) async {
    await TokenManager.savePlayIndex(null);
    await TokenManager.savePlayHistory(null);
    Get.toNamed('center_major_detail', arguments: {
      'majorCourseId': item.id,
      'currentVideoIndex': item.recent_num,
      'playHistory': item.recent_progress
    })!
        .then((value) {
      showLoading('请稍后...');
      Future.delayed(const Duration(milliseconds: 500), () async {
        // Obtain shared preferences.
        final int? playIndex = await TokenManager.getPlayIndex();
        final String? playHistory = await TokenManager.getPlayHistory();
        print('接收到的playIndex $playIndex');
        print('接收到的playHistory $playHistory');
        if (playIndex != null && playHistory != null) {
          majorClientProvider.updatePatientCourseAction({
            'id': item.id,
            'recent_num': playIndex,
            'recent_progress': playHistory
          }).then((result) async {
            if (result.code == 200) {
              final int findIndex = majorCourseDataPagination.data
                  .indexWhere((element) => element.id == item.id);
              await TokenManager.savePlayIndex(null);
              await TokenManager.savePlayHistory(null);
              majorClientProvider
                  .findOneMajorCourseByIdAction(item.id)
                  .then((resultIn) {
                if (resultIn.code == 200 && resultIn.data != null) {
                  final MajorCourseTypeModel majorCourseGet = resultIn.data!;
                  setState(() {
                    majorCourseDataPagination.data[findIndex] = majorCourseGet;
                  });
                }
                hideLoading();
              }).catchError((eIn) {
                hideLoading();
              });
            } else {
              hideLoading();
            }
          }).catchError((e) {
            hideLoading();
          });
        } else {
          hideLoading();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
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

  List<PatientCourseTypeModel> patientCoursesList = [];
  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    final double itemWidthOrHeight = (mediaQuerySizeInfo.width - 24 - 24) / 3;

    Widget skeleton() {
      return Column(
        children: List.generate(10, (int index) {
          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 160,
                  width: mediaQuerySizeInfo.width - 24,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 240,
                      width: mediaQuerySizeInfo.width - 24,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      );
    }

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            height: mediaQuerySafeInfo.top +
                12 +
                12 +
                12 +
                50 +
                24 +
                24 +
                12 +
                12 -
                (_scrollDistance < 0
                    ? 0
                    : _scrollDistance < (44 + 24)
                        ? _scrollDistance
                        : (44 + 24)),
            color: Colors.transparent,
          ),
          Expanded(
            child: RefreshConfiguration(
                headerTriggerDistance: 60.0,
                enableScrollWhenRefreshCompleted:
                    true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
                child: SmartRefresher(
                    physics: const ClampingScrollPhysics(), // 禁止回弹效果
                    enablePullDown: _readyLoad,
                    enablePullUp: _readyLoad,
                    header: CustomHeader(
                        builder: buildHeader,
                        onOffsetChange: (offset) {
                          //do some ani
                        }),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget? body;
                        if (majorCourseDataPagination.data.isEmpty) {
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
                    child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: (majorCourseDataPagination.data.isEmpty &&
                                    _readyLoad)
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
                                                color: Color.fromRGBO(
                                                    224, 222, 223, 1),
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
                            child: !_readyLoad ? skeleton() : null,
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                              color: Colors.transparent,
                              child: Column(
                                children: List.generate(
                                    majorCourseDataPagination.data.length,
                                    (index) => Container(
                                          padding: const EdgeInsets.all(12),
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: itemWidthOrHeight,
                                                    height: itemWidthOrHeight /
                                                        4 *
                                                        3,
                                                    child: CachedNetworkImage(
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8), // 设置圆角
                                                        child: Image(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      width: itemWidthOrHeight,
                                                      height:
                                                          itemWidthOrHeight /
                                                              4 *
                                                              3,
                                                      imageUrl:
                                                          '${globalController.cdnBaseUrl}/${majorCourseDataPagination.data[index].course_info?.cover}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: majorCourseDataPagination
                                                                    .data[index]
                                                                    .course_info!
                                                                    .title,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      RichText(
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: courseTypeList[
                                                                    majorCourseDataPagination
                                                                        .data[
                                                                            index]
                                                                        .course_info!
                                                                        .course_type],
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              )
                                                            ],
                                                          )),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      RichText(
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text: '视频数:',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              const WidgetSpan(
                                                                  child:
                                                                      SizedBox(
                                                                width: 6,
                                                              )),
                                                              TextSpan(
                                                                text:
                                                                    '${majorCourseDataPagination.data[index].course_info!.video_num}',
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            33,
                                                                            33,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        handleGotoDetailPage(
                                                            majorCourseDataPagination
                                                                .data[index]),
                                                    child: Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 0, 12, 0),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              69, 142, 230, 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 18,
                                                            height: 18,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 4),
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .guankan,
                                                                size: 18,
                                                                color: '#fff',
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              majorCourseDataPagination
                                                                          .data[
                                                                              index]
                                                                          .recent_num ==
                                                                      null
                                                                  ? '开始学习'
                                                                  : '继续学习',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  majorCourseDataPagination
                                                              .data[index]
                                                              .recent_num !=
                                                          null
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              width: 14,
                                                              height: 14,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 4),
                                                              child: Center(
                                                                child: IconFont(
                                                                  IconNames
                                                                      .guankanlishi,
                                                                  size: 14,
                                                                  color:
                                                                      'rgb(153,153,153)',
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '第${(majorCourseDataPagination.data[index].recent_num ?? 0) + 1}节 ${majorCourseDataPagination.data[index].recent_progress}',
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          153,
                                                                          153,
                                                                          153,
                                                                          1),
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                              ),
                            ),
                          )
                        ]))),
          )
        ],
      ),
    );
  }
}
