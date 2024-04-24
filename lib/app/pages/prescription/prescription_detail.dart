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
import '../../../components/video.dart';
import 'dart:math';
import 'dart:ui' as ui;
import '../../../components/slide_transition_x.dart';

class PrescriptionDetailPage extends StatefulWidget {
  const PrescriptionDetailPage({super.key});

  @override
  State<PrescriptionDetailPage> createState() => _PrescriptionDetailPageState();
}

class _PrescriptionDetailPageState extends State<PrescriptionDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalController globalController = Get.put(GlobalController());
  final PrescriptionClientProvider prescriptionClientProvider =
      Get.put(PrescriptionClientProvider());
  final UserController userController = Get.put(UserController());
  late String dataId;

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

  List<String> partList = ['肩关节', '肘关节', '腕关节', '髋关节', '膝关节', '踝关节', '脊柱'];

  List<String> symptomsList = ['疼痛', '肿胀', '活动受限', '弹响'];

  List<String> phaseList = ['0-2周', '3-6周', '6-12周', '12周以后'];

  PrescriptionTypeModel prescriptionDetail = PrescriptionTypeModel(
      id: '',
      title: '',
      cover: '',
      prescription_type: 1,
      watch_num: 0,
      prescription_video: null,
      prescription_content: null,
      description: '',
      gist: null,
      difficulty: 1,
      time_length: '',
      part: 0,
      symptoms: 0,
      phase: 0,
      publish_time: '',
      status: 0,
      created_at: '',
      updated_at: '');
  bool _readyLoad = false;

  void getDetailData() {
    prescriptionClientProvider.getPrescriptionByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final prescriptionNew = result.data!;
        setState(() {
          prescriptionDetail = prescriptionNew;
          setState(() {
            _readyLoad = true;
          });
        });
        if (prescriptionNew.id.isNotEmpty) {
          prescriptionClientProvider
              .addPrescriptionWatchNumAction(dataId)
              .then((result1) {
            if (result.code == 200) {
              setState(() {
                prescriptionDetail.watch_num += 1;
              });
            }
          });
        }
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
          text: prescriptionDetail.description,
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
          text: prescriptionDetail.gist,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    dataId = Get.arguments['prescriptionId'];
    getDetailData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    final String videoPath =
        '${globalController.cdnBaseUrl}/${prescriptionDetail.prescription_video}';

    final String description = prescriptionDetail.description;

    final String? gist = prescriptionDetail.gist;

    final String watchNumShow = (prescriptionDetail.watch_num > 1000 &&
            prescriptionDetail.watch_num <= 10000)
        ? '${(prescriptionDetail.watch_num / 1000).floor()}k+'
        : (prescriptionDetail.watch_num > 10000 &&
                prescriptionDetail.watch_num <= 100000)
            ? '${(prescriptionDetail.watch_num / 10000).floor()}k+'
            : '${prescriptionDetail.watch_num}';

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
        body: Column(children: [
      Container(
        padding: EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
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
              const Text('康复处方信息',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 24,
                height: 24,
                child: InkWell(
                  onTap: handleShare,
                  child: Center(
                    child: IconFont(
                      IconNames.fenxiang,
                      size: 24,
                      color: '#000',
                    ),
                  ),
                ),
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
          : prescriptionDetail.id.isNotEmpty
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
                              child: VideoPlayerModule(url: videoPath),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prescriptionDetail.title,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                            prescriptionDetail.difficulty,
                                            (index) {
                                          return SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Center(
                                              child: IconFont(IconNames.nandu,
                                                  size: 18,
                                                  color: prescriptionDetail
                                                              .difficulty ==
                                                          5
                                                      ? 'rgb(217,75,22)'
                                                      : prescriptionDetail
                                                                  .difficulty ==
                                                              4
                                                          ? 'rgb(237,114,31)'
                                                          : prescriptionDetail
                                                                      .difficulty ==
                                                                  3
                                                              ? 'rgb(255,177,47)'
                                                              : prescriptionDetail
                                                                          .difficulty ==
                                                                      2
                                                                  ? 'rgb(255,204,54)'
                                                                  : 'rgb(255,222,103)'),
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                        width: 6,
                                      ),
                                      Text('难度${prescriptionDetail.difficulty}',
                                          style: TextStyle(
                                              color: prescriptionDetail
                                                          .difficulty ==
                                                      5
                                                  ? const Color.fromRGBO(
                                                      217, 75, 22, 1)
                                                  : prescriptionDetail
                                                              .difficulty ==
                                                          4
                                                      ? const Color.fromRGBO(
                                                          237, 114, 31, 1)
                                                      : prescriptionDetail
                                                                  .difficulty ==
                                                              3
                                                          ? const Color.fromRGBO(
                                                              255, 177, 47, 1)
                                                          : prescriptionDetail
                                                                      .difficulty ==
                                                                  2
                                                              ? const Color
                                                                  .fromRGBO(255,
                                                                  204, 54, 1)
                                                              : const Color
                                                                  .fromRGBO(255,
                                                                  222, 103, 1),
                                              fontSize: 14)),
                                      const SizedBox(
                                        height: 18,
                                        width: 6,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 8, 2),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                211, 66, 67, 0.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Text(
                                          partList[prescriptionDetail.part],
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(211, 66, 67, 1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 8, 2),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                211, 66, 67, 0.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Text(
                                          symptomsList[
                                              prescriptionDetail.symptoms],
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(211, 66, 67, 1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 8, 2),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                211, 66, 67, 0.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Text(
                                          phaseList[prescriptionDetail.phase],
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(211, 66, 67, 1),
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
                                          '预计耗时 ${prescriptionDetail.time_length}',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                144, 144, 144, 1),
                                            fontSize: 14,
                                          )),
                                      const SizedBox(
                                        height: 18,
                                        width: 18,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Center(
                                              child: IconFont(
                                                  IconNames.yanjing_fill,
                                                  size: 18,
                                                  color: 'rgb(144, 144, 144)'),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 18,
                                            width: 2,
                                          ),
                                          Text(watchNumShow,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    144, 144, 144, 1),
                                                fontSize: 14,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 36,
                                    child: TabBar(
                                        tabAlignment: TabAlignment.start,
                                        padding: const EdgeInsets.all(0),
                                        isScrollable: true, // 设置为true以启用横向滚动
                                        onTap: (index) {
                                          if (index == 1) {
                                            // 切换时滚动到顶部
                                            //_painQuestionPageState.currentState?.scrollToTop();
                                          }
                                          handleChangeTab(index);
                                        },
                                        indicatorPadding:
                                            EdgeInsets.zero, // 设置指示器的内边距为零
                                        indicator: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  211, 66, 67, 1), // 底部边框颜色
                                              width: 3, // 底部边框宽度
                                            ),
                                          ),
                                        ),
                                        labelColor: const Color.fromRGBO(
                                            211, 66, 67, 1),
                                        indicatorColor: const Color.fromRGBO(
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
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (Widget child,
                                            Animation<double> animation) =>
                                        SlideTransitionX(
                                          child: child,
                                          direction: AxisDirection.left, //右入左出
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
                                          padding: const EdgeInsets.fromLTRB(
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
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                prescriptionDetail
                                                                    .description,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          )
                                                        ],
                                                      ))
                                                  : Container(
                                                      width: mediaQuerySizeInfo
                                                              .width -
                                                          24,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 24),
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/empty.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            const Text(
                                                              '暂无内容',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          224,
                                                                          222,
                                                                          223,
                                                                          1),
                                                                  fontSize: 14),
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
                                                      child:
                                                          (!descriptionReadMore
                                                              ? const Text(
                                                                  '阅读更多...',
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
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
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              211,
                                                                              66,
                                                                              67,
                                                                              1),
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                    )
                                                  : const SizedBox.shrink()),
                                              SizedBox(
                                                height:
                                                    mediaQuerySafeInfo.bottom +
                                                        12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 0),
                                          child: Column(
                                            children: [
                                              (gist != null && gist.isNotEmpty
                                                  ? RichText(
                                                      maxLines: gistReadMore
                                                          ? 9999
                                                          : 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                prescriptionDetail
                                                                    .gist,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          )
                                                        ],
                                                      ))
                                                  : Container(
                                                      width: mediaQuerySizeInfo
                                                              .width -
                                                          24,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 24),
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/empty.png',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            const Text(
                                                              '暂无内容',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          224,
                                                                          222,
                                                                          223,
                                                                          1),
                                                                  fontSize: 14),
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
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          211,
                                                                          66,
                                                                          67,
                                                                          1),
                                                                  fontSize: 14),
                                                            )
                                                          : const Text(
                                                              '收起',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          211,
                                                                          66,
                                                                          67,
                                                                          1),
                                                                  fontSize: 14),
                                                            )),
                                                    )
                                                  : const SizedBox.shrink()),
                                              SizedBox(
                                                height:
                                                    mediaQuerySafeInfo.bottom +
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
    ]));
  }
}
