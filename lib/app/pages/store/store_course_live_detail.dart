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
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/api/store_client_provider.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class StoreCourseLiveDetailPage extends StatefulWidget {
  const StoreCourseLiveDetailPage({super.key});

  @override
  State<StoreCourseLiveDetailPage> createState() =>
      _StoreCourseLiveDetailPageState();
}

class _StoreCourseLiveDetailPageState extends State<StoreCourseLiveDetailPage> {
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  bool _readyLoad = false;

  late final String dataId;

  StoreLiveCourseTypeModel storeLiveCourseDetail = StoreLiveCourseTypeModel(
      id: '',
      title: '',
      cover: '',
      description: '',
      course_type: 0,
      live_num: 0,
      frequency_num: 0,
      price: '',
      is_discount: 0,
      discount: null,
      discount_validity: null,
      carousel: 0,
      publish_time: '',
      status: 0,
      created_at: '',
      updated_at: '');

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

  void getDetailData() {
    storeClientProvider.getCourseLiveByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final painQuestionNew = result.data!;
        setState(() {
          storeLiveCourseDetail = painQuestionNew;
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

  bool descriptionReadMore = false;

  void handleChangeDescriptionReadMore() {
    setState(() {
      descriptionReadMore = !descriptionReadMore;
    });
  }

  bool isRichTextGreaterThan12LinesDescription(int maxLines, double width) {
    final TextSpan richTextIn = TextSpan(
      children: [
        TextSpan(
          text: storeLiveCourseDetail.description,
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
    super.initState();
    dataId = Get.arguments['courseId'];
    getDetailData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    Widget skeleton() {
      return Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 4 * 3,
          child: Shimmer.fromColors(
            baseColor: const Color.fromRGBO(229, 229, 229, 1),
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: mediaQuerySizeInfo.width,
              height: mediaQuerySizeInfo.width / 4 * 3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          width: mediaQuerySizeInfo.width,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 26,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 120,
                    height: 26,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 180,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 140,
                height: 18,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 140,
                height: 18,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 80,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: mediaQuerySizeInfo.width - 24,
                height: 300,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: mediaQuerySizeInfo.width - 24,
                    height: 400,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 80,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: mediaQuerySizeInfo.width - 24,
                height: 300,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: mediaQuerySizeInfo.width - 24,
                    height: 400,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]);
    }

    return Scaffold(
      body: AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              (_readyLoad && storeLiveCourseDetail.id.isEmpty
                  ? Container(
                      width: mediaQuerySizeInfo.width,
                      margin: const EdgeInsets.only(top: 200),
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
                  : const SizedBox.shrink()),
              (!_readyLoad
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: skeleton(),
                    )
                  : const SizedBox.shrink()),
              (storeLiveCourseDetail.id.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 4 * 3,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width / 4 * 3,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${globalController.cdnBaseUrl}/${storeLiveCourseDetail.cover}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                    top: mediaQuerySafeInfo.top + 16,
                                    left: 16,
                                    child: GestureDetector(
                                      onTap: handleGoBack,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.7),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.fanhui,
                                            size: 24,
                                            color: '#fff',
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 12, 12,
                                24 + 16 + 16 + mediaQuerySafeInfo.bottom + 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 26,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(203, 174, 241, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            margin:
                                                const EdgeInsets.only(right: 4),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.live_fill,
                                                size: 20,
                                                color: 'rgb(151,63,247)',
                                              ),
                                            ),
                                          ),
                                          const Text('面对面康复指导',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      151, 63, 247, 1),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                    (storeLiveCourseDetail.is_discount == 1
                                        ? Container(
                                            height: 26,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    224, 115, 37, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 0, 12, 0),
                                            child: const Center(
                                              child: Text('折扣',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          )
                                        : const SizedBox.shrink())
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  storeLiveCourseDetail.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '直播课 · ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        TextSpan(
                                          text: courseTypeList[
                                              storeLiveCourseDetail
                                                  .course_type],
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9))),
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.kecheng,
                                              size: 14,
                                              color: 'rgb(255,255,255)',
                                            ),
                                          ),
                                        ),
                                        Text(
                                            '${storeLiveCourseDetail.live_num}次直播',
                                            style: const TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 12,
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(9))),
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.zuixingengxin,
                                              size: 14,
                                              color: 'rgb(255,255,255)',
                                            ),
                                          ),
                                        ),
                                        Text(
                                            '${storeLiveCourseDetail.frequency_num}已购买',
                                            style: const TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                const Text(
                                  '课程信息',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    maxLines: descriptionReadMore ? 9999 : 12,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              storeLiveCourseDetail.description,
                                          style: const TextStyle(
                                              height: 1.5, // 设置行高为字体大小的1.5倍
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                (isRichTextGreaterThan12LinesDescription(
                                        12, mediaQuerySizeInfo.width - 24)
                                    ? GestureDetector(
                                        onTap: handleChangeDescriptionReadMore,
                                        child: (!descriptionReadMore
                                            ? const Text(
                                                '阅读更多...',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        211, 66, 67, 1),
                                                    fontSize: 14),
                                              )
                                            : const Text(
                                                '收起',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        211, 66, 67, 1),
                                                    fontSize: 14),
                                              )),
                                      )
                                    : const SizedBox.shrink()),
                                const SizedBox(
                                  height: 24,
                                ),
                                const Text(
                                  '直播课程',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '直播规则: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text:
                                              '${storeLiveCourseDetail.live_num}次。',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '直播授课时间: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text: '1小时/次。',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '课程有效期: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text: '自购买之日起，一年内有效。',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '直播方式: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text:
                                              '面对面直播指导，由康复专家现场连线教学；全面、专业地解答您的问题！',
                                          style: TextStyle(
                                              height: 1.5, // 设置行高为字体大小的1.5倍
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '预约: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text: '需提前预约时间。',
                                          style: TextStyle(
                                              height: 1.5, // 设置行高为字体大小的1.5倍
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
              (!_readyLoad || storeLiveCourseDetail.id.isEmpty
                  ? Positioned(
                      top: mediaQuerySafeInfo.top + 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: handleGoBack,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 24,
                              color: '#fff',
                            ),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()),
              (storeLiveCourseDetail.id.isNotEmpty
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          const Divider(
                            height: 2,
                            color: Color.fromRGBO(233, 234, 235, 1),
                          ),
                          Container(
                            width: mediaQuerySizeInfo.width,
                            padding: EdgeInsets.fromLTRB(
                                0, 16, 0, 16 + mediaQuerySafeInfo.bottom),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Center(
                                    child: IconFont(
                                      IconNames.gouwuche,
                                      size: 24,
                                      color: '#fff',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 36,
                                  height: 36,
                                ),
                                Container(
                                  height: 36,
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(211, 66, 67, 1),
                                          Color.fromRGBO(211, 66, 67, 0.8),
                                          Color.fromRGBO(211, 66, 67, 0.6)
                                        ], // 渐变的起始和结束颜色
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Row(
                                    children: [
                                      const Text(
                                        '立即购买',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                        height: 12,
                                      ),
                                      (storeLiveCourseDetail.is_discount == 0
                                          ? Text(
                                              '¥${storeLiveCourseDetail.price}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              '¥${storeLiveCourseDetail.price}',
                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationThickness: 2,
                                                  decorationColor:
                                                      Color.fromRGBO(
                                                          200, 200, 200, 1),
                                                  color: Color.fromRGBO(
                                                      200, 200, 200, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      (storeLiveCourseDetail.is_discount == 1
                                          ? Row(
                                              children: [
                                                const SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                ),
                                                Text(
                                                  '¥${storeLiveCourseDetail.discount}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                  : const SizedBox.shrink())
            ],
          )),
    );
  }
}
