import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../cache/token_manager.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../iconfont/icon_font.dart';
import '../../models/data_model.dart';
import '../../models/major_mode.dart';
import '../../models/prescription_model.dart';
import '../../providers/api/major_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../components/video.dart';
import 'dart:math';
import 'dart:ui' as ui;
import '../../../components/slide_transition_x.dart';

class CenterMajorDetailPage extends StatefulWidget {
  const CenterMajorDetailPage({super.key});

  @override
  State<CenterMajorDetailPage> createState() => _CenterMajorDetailPageState();
}

class _CenterMajorDetailPageState extends State<CenterMajorDetailPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  final GlobalController globalController = Get.put(GlobalController());
  final MajorClientProvider majorClientProvider =
      Get.put(MajorClientProvider());
  final UserController userController = Get.put(UserController());

  GlobalKey<VideoPlayerModuleState> videoPlayerModuleState =
      GlobalKey<VideoPlayerModuleState>();

  late String dataId;

  Duration? playHistory;

  String? durationString;

  void videoPlayCallback(String durationStringGet) {
    durationString = durationStringGet;
  }

  void videoIsInitializedCallback() {
    if (playHistory != null) {
      videoPlayerModuleState.currentState!.videoPlayerController!
          .seekTo(playHistory!); //初始位置
      setState(() {
        playHistory = null;
      });
    }
  }

  int tabIndex = 0;

  bool descriptionReadMore = false;
  bool gistReadMore = false;

  void handleChangeDescriptionReadMore() {
    setState(() {
      descriptionReadMore = !descriptionReadMore;
    });
  }

  void handleChangeGistReadMore() {
    setState(() {
      gistReadMore = !gistReadMore;
    });
  }

  int currentVideoIndex = 0;

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

  MajorCourseTypeModel majorCourseDetail = MajorCourseTypeModel.fromJson(null);
  bool _readyLoad = false;

  void getDetailData() {
    majorClientProvider.findOneMajorCourseByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final detailNew = result.data!;
        setState(() {
          majorCourseDetail = detailNew;
          setState(() {
            _readyLoad = true;
          });
        });
      }
    });
  }

  void handleGoBack() {
    Get.back();
  }

  void handleShare() {}

  void handleChangeTab(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  //判断行数
  bool isRichTextGreaterThan12LinesDescription(int maxLines, double width) {
    // 获取文本方向
    final TextSpan richTextIn = TextSpan(
      children: [
        TextSpan(
          text: majorCourseDetail
              .course_info!.videos![currentVideoIndex].description,
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 15,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final TextPainter textPainter = TextPainter(
      text: richTextIn,
      textDirection: ui.TextDirection.ltr, // 使用 TextDirection.ltr
      maxLines: maxLines, // 限制最大行数为12行
    );
    textPainter.layout(maxWidth: width);
    return textPainter.didExceedMaxLines;
  }

  bool isRichTextGreaterThan12LinesGist(int maxLines, double width) {
    final TextSpan richTextIn = TextSpan(
      children: [
        TextSpan(
          text: majorCourseDetail.course_info!.videos![currentVideoIndex].gist,
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 15,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final TextPainter textPainter = TextPainter(
      text: richTextIn,
      textDirection: ui.TextDirection.ltr,
      maxLines: maxLines, // 限制最大行数为12行
    );
    textPainter.layout(maxWidth: width);
    return textPainter.didExceedMaxLines;
  }

  void updateMajorCourseInfo(String id) async {
    if (id.isNotEmpty &&
        durationString != null &&
        (durationString != '00:00:00' || currentVideoIndex != 0)) {
      // Obtain shared preferences.
      await TokenManager.savePlayIndex(currentVideoIndex);
      await TokenManager.savePlayHistory(durationString ?? '00:00:00');
    }
  }

  void handleChooseVideoIndex(int index) {
    Get.back();
    if (currentVideoIndex != index) {
      setState(() {
        currentVideoIndex = index;
        descriptionReadMore = false;
        gistReadMore = false;
      });
      _tabController.animateTo(0);
      setState(() {
        tabIndex = 0;
      });
      videoPlayerModuleState.currentState!.updateVideoUrl(
          '${globalController.cdnBaseUrl}/${majorCourseDetail.course_info!.videos![currentVideoIndex].source}'); //初始位置
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    dataId = Get.arguments['majorCourseId'];
    if (Get.arguments['currentVideoIndex'] != null) {
      currentVideoIndex = Get.arguments['currentVideoIndex'];
    }
    if (Get.arguments['playHistory'] != null) {
      final List<int> playHistoryList = (Get.arguments['playHistory'] as String)
          .split(':')
          .map((e) => int.parse(e))
          .toList();
      playHistory = Duration(
          hours: playHistoryList[0],
          seconds: playHistoryList[1],
          milliseconds: playHistoryList[2] * 1000);
    }
    getDetailData();
  }

  @override
  void dispose() {
    updateMajorCourseInfo(majorCourseDetail.id);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    final String videoPath = majorCourseDetail.id.isNotEmpty
        ? '${globalController.cdnBaseUrl}/${majorCourseDetail.course_info!.videos![currentVideoIndex].source}'
        : '';

    final String description = majorCourseDetail.id.isNotEmpty
        ? majorCourseDetail.course_info!.videos![currentVideoIndex].description
        : '';

    final String? gist = majorCourseDetail.id.isNotEmpty
        ? majorCourseDetail.course_info!.videos![currentVideoIndex].gist
        : '';

    Widget skeleton() {
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: mediaQuerySizeInfo.width / 16 * 9,
              width: mediaQuerySizeInfo.width,
              child: Shimmer.fromColors(
                baseColor: const Color.fromRGBO(229, 229, 229, 1),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: mediaQuerySizeInfo.width / 16 * 9,
                  height: mediaQuerySizeInfo.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(229, 229, 229, 1),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 200,
                          height: 20,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(229, 229, 229, 1),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 240,
                          height: 26,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(229, 229, 229, 1),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 180,
                          height: 18,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 36,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 36,
                            width: 12,
                          ),
                          Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 36,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(229, 229, 229, 1),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: mediaQuerySizeInfo.width - 24,
                          height: 800,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),
                      )
                    ]))
          ]);
    }

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          width: mediaQuerySizeInfo.width / 4 * 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero, // 设置顶部边缘为直角
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            height: double.infinity,
            color: const Color.fromRGBO(254, 251, 254, 1),
            child: SingleChildScrollView(
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
                            IconNames.video_fill,
                            size: 20,
                            color: 'rgb(0,0,0)',
                          ),
                        ),
                      ),
                      const Text('视频列表',
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
                    children: List.generate(
                        majorCourseDetail.id.isNotEmpty
                            ? majorCourseDetail.course_info!.videos!.length
                            : 0, (index) {
                      return GestureDetector(
                        onTap: () => handleChooseVideoIndex(index),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: currentVideoIndex == index
                                          ? const Color.fromRGBO(211, 66, 67, 1)
                                          : Colors.white)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80 / 4 * 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${globalController.cdnBaseUrl}/${majorCourseDetail.course_info!.videos![index].cover}',
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80 / 4 * 3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                        width: 12,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: majorCourseDetail
                                                        .course_info!
                                                        .videos![index]
                                                        .title,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: majorCourseDetail
                                                        .course_info!
                                                        .videos![index]
                                                        .time_length,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  RichText(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: majorCourseDetail.course_info!
                                                .videos![index].description,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            currentVideoIndex == index
                                ? Positioned(
                                    right: 4,
                                    top: 4,
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: Center(
                                        child: IconFont(
                                          IconNames.bofangzhong,
                                          size: 14,
                                          color: 'rgb(211, 66, 67)',
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: mediaQuerySafeInfo.bottom + 12,
                  )
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    12, mediaQuerySafeInfo.top + 12, 12, 12),
                child: SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: handleGoBack,
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: mediaQuerySizeInfo.width - 36 - 36 - 12 - 12,
                        child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: majorCourseDetail.id.isNotEmpty
                                      ? majorCourseDetail.course_info!.title
                                      : '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: null,
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 2,
                color: Color.fromRGBO(233, 234, 235, 1),
              ),
              (!_readyLoad
                  ? Expanded(
                      child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: skeleton(),
                    ))
                  : majorCourseDetail.id.isNotEmpty
                      ? Expanded(
                          child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: mediaQuerySizeInfo.width / 16 * 9,
                                      width: mediaQuerySizeInfo.width,
                                      child: VideoPlayerModule(
                                          key: videoPlayerModuleState,
                                          //seekDuration: playHistory,
                                          url: videoPath,
                                          videoIsInitializedCallback:
                                              videoIsInitializedCallback,
                                          videoPlayCallback: videoPlayCallback),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              majorCourseDetail
                                                  .course_info!
                                                  .videos![currentVideoIndex]
                                                  .title,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 2, 8, 2),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        211, 66, 67, 0.3),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: Text(
                                                  courseTypeList[
                                                      majorCourseDetail
                                                          .course_info!
                                                          .course_type],
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        211, 66, 67, 1),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  '预计耗时 ${majorCourseDetail.course_info!.videos![currentVideoIndex].time_length}',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        144, 144, 144, 1),
                                                    fontSize: 14,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            height: 36,
                                            child: TabBar(
                                                tabAlignment:
                                                    TabAlignment.start,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                isScrollable:
                                                    true, // 设置为true以启用横向滚动
                                                onTap: (index) {
                                                  if (index == 1) {
                                                    // 切换时滚动到顶部
                                                    //_painQuestionPageState.currentState?.scrollToTop();
                                                  }
                                                  handleChangeTab(index);
                                                },
                                                indicatorPadding: EdgeInsets
                                                    .zero, // 设置指示器的内边距为零
                                                indicator: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Color.fromRGBO(211,
                                                          66, 67, 1), // 底部边框颜色
                                                      width: 3, // 底部边框宽度
                                                    ),
                                                  ),
                                                ),
                                                labelColor:
                                                    const Color.fromRGBO(
                                                        211, 66, 67, 1),
                                                indicatorColor:
                                                    const Color.fromRGBO(
                                                        211, 66, 67, 1),
                                                controller: _tabController,
                                                tabs: const [
                                                  Tab(
                                                    child: Text('介绍'),
                                                  ),
                                                  Tab(
                                                    child: Text('要点'),
                                                  )
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                        child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            transitionBuilder: (Widget child,
                                                    Animation<double>
                                                        animation) =>
                                                SlideTransitionX(
                                                  child: child,
                                                  direction:
                                                      AxisDirection.left, //右入左出
                                                  position: animation,
                                                ),
                                            child: IndexedStack(
                                              // This key causes the AnimatedSwitcher to interpret this as a "new"
                                              // child each time the count changes, so that it will begin its animation
                                              // when the count changes.
                                              key: ValueKey<int>(
                                                  tabIndex), // add this line
                                              index: tabIndex,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 12, 0),
                                                  child: Column(
                                                    children: [
                                                      (description.isNotEmpty
                                                          ? RichText(
                                                              maxLines:
                                                                  descriptionReadMore
                                                                      ? 9999
                                                                      : 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: majorCourseDetail
                                                                        .course_info!
                                                                        .videos![
                                                                            currentVideoIndex]
                                                                        .description,
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  )
                                                                ],
                                                              ))
                                                          : Container(
                                                              width:
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      24,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 24),
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/empty.png',
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      '暂无内容',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              224,
                                                                              222,
                                                                              223,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      (description.isNotEmpty &&
                                                              isRichTextGreaterThan12LinesDescription(
                                                                  12,
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      24)
                                                          ? GestureDetector(
                                                              onTap:
                                                                  handleChangeDescriptionReadMore,
                                                              child: (!descriptionReadMore
                                                                  ? const Text(
                                                                      '阅读更多...',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : const Text(
                                                                      '收起',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )),
                                                            )
                                                          : const SizedBox
                                                              .shrink()),
                                                      SizedBox(
                                                        height:
                                                            mediaQuerySafeInfo
                                                                    .bottom +
                                                                12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 12, 0),
                                                  child: Column(
                                                    children: [
                                                      (gist != null &&
                                                              gist.isNotEmpty
                                                          ? RichText(
                                                              maxLines:
                                                                  gistReadMore
                                                                      ? 9999
                                                                      : 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: majorCourseDetail
                                                                        .course_info!
                                                                        .videos![
                                                                            currentVideoIndex]
                                                                        .description,
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  )
                                                                ],
                                                              ))
                                                          : Container(
                                                              width:
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      24,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 24),
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/empty.png',
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      '暂无内容',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              224,
                                                                              222,
                                                                              223,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      (gist != null &&
                                                              gist.isNotEmpty &&
                                                              isRichTextGreaterThan12LinesGist(
                                                                  12,
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      24)
                                                          ? GestureDetector(
                                                              onTap:
                                                                  handleChangeGistReadMore,
                                                              child: (!gistReadMore
                                                                  ? const Text(
                                                                      '阅读更多...',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : const Text(
                                                                      '收起',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                    )),
                                                            )
                                                          : const SizedBox
                                                              .shrink()),
                                                      SizedBox(
                                                        height:
                                                            mediaQuerySafeInfo
                                                                    .bottom +
                                                                12,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                            ]))
                      : Expanded(
                          child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        )))
            ]),
            Positioned(
                bottom: mediaQuerySafeInfo.bottom + 24,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    // 打开抽屉
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(158, 158, 158, 0.3),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: IconFont(
                              IconNames.shipinliebiao,
                              size: 20,
                              color: 'rgb(255,255,255)',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${majorCourseDetail.id.isNotEmpty ? majorCourseDetail.course_info!.video_num : '0'}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
