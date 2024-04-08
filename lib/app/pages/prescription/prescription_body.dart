import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../iconfont/icon_font.dart';
import '../../models/data_model.dart';
import '../../models/prescription_model.dart';
import '../../providers/api/prescription_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrescriptionBody extends StatefulWidget {
  final int? part;
  final int? symptoms;
  final int? phase;
  final int? hotOrder;
  const PrescriptionBody(
      {super.key, this.part, this.symptoms, this.phase, this.hotOrder});

  @override
  State<PrescriptionBody> createState() => PrescriptionBodyState();
}

class PrescriptionBodyState extends State<PrescriptionBody>
    with TickerProviderStateMixin {
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final PrescriptionClientProvider prescriptionClientProvider =
      GetInstance().find<PrescriptionClientProvider>();
  final UserController userController = GetInstance().find<UserController>();

  late int? partGet;
  late int? symptomsGet;
  late int? phaseGet;

  /* 数据信息 */
  bool readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<PrescriptionTypeModel>>
      prescriptionDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    prescriptionDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

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

    partGet = widget.part;
    symptomsGet = widget.symptoms;
    phaseGet = widget.phase;

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

  Future<String> getPrescriptions({int? page}) {
    Completer<String> completer = Completer();
    prescriptionClientProvider
        .getPrescriptionsByCustomAction(
            part: partGet,
            pageNo: page ?? _currentPageNo + 1,
            phase: phaseGet,
            hotOrder: widget.hotOrder,
            symptoms: symptomsGet)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          prescriptionDataPagination.data = valueGet;
        } else {
          prescriptionDataPagination.data.addAll(valueGet);
        }
        prescriptionDataPagination.pageNo = pageNo;
        prescriptionDataPagination.pageSize = pageSize;
        prescriptionDataPagination.totalPage = totalPage;
        prescriptionDataPagination.totalCount = totalCount;
        readyLoad = true;
      });
      completer.complete(pageNo == totalPage ? 'no-data' : 'success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  void onRefresh() {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getPrescriptions(page: 1);
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
      result = await getPrescriptions();
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

  EdgeInsets safePadding = MediaQuery.of(Get.context!).padding;

  void handleGoToDetail(String prescriptionId) {
    Get.toNamed('/prescription_detail',
        arguments: {'prescriptionId': prescriptionId})?.then((value) {});
  }

  Widget buildHeader(BuildContext context, RefreshStatus? mode) {
    return Container(
      color: Colors.transparent,
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
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    final double itemWidthOrHeight =
        (mediaQuerySizeInfo.width - 18 - 18 - 18) / 2;

    Widget skeleton() {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                // 交叉轴子项数量
                mainAxisSpacing: 18, // 主轴间距
                crossAxisSpacing: 18, // 交叉轴间距
                childAspectRatio: 1,
                mainAxisExtent: itemWidthOrHeight,
                maxCrossAxisExtent: itemWidthOrHeight),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero, // 设置为零边距
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: itemWidthOrHeight,
                height: itemWidthOrHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  width: itemWidthOrHeight,
                  height: itemWidthOrHeight,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.only(right: 0),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: itemWidthOrHeight,
                      height: itemWidthOrHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
        body: Column(children: [
      Expanded(
        child: RefreshConfiguration(
          headerTriggerDistance: 60.0,
          enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabB
          child: SmartRefresher(
              controller: _refreshController,
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
                  if (prescriptionDataPagination.data.isEmpty) {
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
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: CustomScrollView(controller: _scrollController, slivers: [
                SliverToBoxAdapter(
                  child: (prescriptionDataPagination.data.isEmpty && readyLoad)
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
                                      color: Color.fromRGBO(224, 222, 223, 1),
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
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            // 交叉轴子项数量
                            mainAxisSpacing: 18, // 主轴间距
                            crossAxisSpacing: 18, // 交叉轴间距
                            childAspectRatio: 1,
                            mainAxisExtent: itemWidthOrHeight,
                            maxCrossAxisExtent: itemWidthOrHeight),
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero, // 设置为零边距
                        shrinkWrap: true,
                        itemCount: prescriptionDataPagination.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String watchNumShow = (prescriptionDataPagination
                                          .data[index].watch_num >
                                      1000 &&
                                  prescriptionDataPagination
                                          .data[index].watch_num <=
                                      10000)
                              ? '${(prescriptionDataPagination.data[index].watch_num / 1000).floor()}k+'
                              : (prescriptionDataPagination
                                              .data[index].watch_num >
                                          10000 &&
                                      prescriptionDataPagination
                                              .data[index].watch_num <=
                                          100000)
                                  ? '${(prescriptionDataPagination.data[index].watch_num / 10000).floor()}k+'
                                  : '${prescriptionDataPagination.data[index].watch_num}';

                          return GestureDetector(
                            onTap: () => handleGoToDetail(
                                prescriptionDataPagination.data[index].id),
                            child: Container(
                              width: itemWidthOrHeight,
                              height: itemWidthOrHeight,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
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
                                          borderRadius: BorderRadius.circular(
                                              10.0), // 设置圆角
                                          child: Image(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        width: itemWidthOrHeight,
                                        height: itemWidthOrHeight,
                                        imageUrl:
                                            '${globalController.cdnBaseUrl}/${prescriptionDataPagination.data[index].cover}',
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.7),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                    text:
                                                        prescriptionDataPagination
                                                            .data[index].title,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14))),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                    text:
                                                        '预计耗时 ${prescriptionDataPagination.data[index].time_length}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12))),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 2, 8, 2),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 4),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames.nandu,
                                                              size: 18,
                                                              color: prescriptionDataPagination
                                                                          .data[
                                                                              index]
                                                                          .difficulty ==
                                                                      5
                                                                  ? 'rgb(217,75,22)'
                                                                  : prescriptionDataPagination
                                                                              .data[index]
                                                                              .difficulty ==
                                                                          4
                                                                      ? 'rgb(237,114,31)'
                                                                      : prescriptionDataPagination.data[index].difficulty == 3
                                                                          ? 'rgb(255,177,47)'
                                                                          : prescriptionDataPagination.data[index].difficulty == 2
                                                                              ? 'rgb(255,204,54)'
                                                                              : 'rgb(255,222,103)'),
                                                        ),
                                                      ),
                                                      Text(
                                                          '难度${prescriptionDataPagination.data[index].difficulty}',
                                                          style: TextStyle(
                                                              color: prescriptionDataPagination
                                                                          .data[
                                                                              index]
                                                                          .difficulty ==
                                                                      5
                                                                  ? const Color
                                                                      .fromRGBO(
                                                                      217,
                                                                      75,
                                                                      22,
                                                                      1)
                                                                  : prescriptionDataPagination.data[index].difficulty ==
                                                                          4
                                                                      ? const Color.fromRGBO(
                                                                          237,
                                                                          114,
                                                                          31,
                                                                          1)
                                                                      : prescriptionDataPagination.data[index].difficulty ==
                                                                              3
                                                                          ? const Color.fromRGBO(
                                                                              255,
                                                                              177,
                                                                              47,
                                                                              1)
                                                                          : prescriptionDataPagination.data[index].difficulty == 2
                                                                              ? const Color.fromRGBO(255, 204, 54, 1)
                                                                              : const Color.fromRGBO(255, 222, 103, 1),
                                                              fontSize: 12))
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 2, 8, 2),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 4),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames
                                                                  .yanjing_fill,
                                                              size: 18,
                                                              color:
                                                                  'rgb(255,255,255)'),
                                                        ),
                                                      ),
                                                      Text(watchNumShow,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ])),
        ),
      )
    ]));
  }
}
