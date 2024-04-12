import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import '../../models/store_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

class StoreCourseChartPage extends StatefulWidget {
  const StoreCourseChartPage({super.key});

  @override
  State<StoreCourseChartPage> createState() => _StoreCourseChartPageState();
}

class _StoreCourseChartPageState extends State<StoreCourseChartPage> {
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final UserController userController = GetInstance().find<UserController>();
  final StoreController storeController = GetInstance().find<StoreController>();
  bool _readyLoad = false;

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

  List<StoreCourseChartTypeModel> courseChartList = [];

  List<bool> courseChartCheckList = [];

  List<String> courseChartChooseList = [];

  double totalCount = 0;

  double totalDiscount = 0;

  bool checkAll = false;

  void handleCheckItem(bool? newValue, int index) {
    List<bool> courseChartCheckListGet = [...courseChartCheckList];
    bool checkAllGet = checkAll;

    courseChartCheckListGet[index] = newValue!;
    checkAllGet = courseChartCheckListGet.every((element) => element);

    final double totalCountGet =
        handleCalculateCounts(courseChartCheckListGet)[0];
    final double totalDiscountGet =
        handleCalculateCounts(courseChartCheckListGet)[1];

    setState(() {
      courseChartCheckList = [...courseChartCheckListGet];
      checkAll = checkAllGet;
      totalCount = totalCountGet;
      totalDiscount = totalDiscountGet;
    });
  }

  void handleCheckAll(bool? newValue) {
    if (courseChartList.isEmpty) {
      return;
    }
    bool checkAllGet = newValue!;
    List<bool> courseChartCheckListGet = [...courseChartCheckList];

    if (checkAllGet) {
      List.generate(courseChartCheckListGet.length, (index) {
        courseChartCheckListGet[index] = true;
      });
    } else {
      List.generate(courseChartCheckListGet.length, (index) {
        courseChartCheckListGet[index] = false;
      });
    }

    final double totalCountGet =
        handleCalculateCounts(courseChartCheckListGet)[0];
    final double totalDiscountGet =
        handleCalculateCounts(courseChartCheckListGet)[1];

    setState(() {
      courseChartCheckList = [...courseChartCheckListGet];
      checkAll = checkAllGet;
      totalCount = totalCountGet;
      totalDiscount = totalDiscountGet;
    });
  }

  List<double> handleCalculateCounts(List<bool> courseChartCheckListGet) {
    double totalCountGet = 0;
    double totalDiscountGet = 0;

    List.generate(courseChartList.length, (index) {
      if (courseChartCheckListGet[index]) {
        totalCountGet += (courseChartList[index].add_course_type == 1
            ? double.parse(courseChartList[index].course_live_info!.price)
            : double.parse(courseChartList[index].course_video_info!.price));
        totalDiscountGet += (courseChartList[index].add_course_type == 1
            ? double.parse(
                courseChartList[index].course_live_info!.is_discount == 1
                    ? courseChartList[index].course_live_info!.discount!
                    : courseChartList[index].course_live_info!.price)
            : double.parse(
                courseChartList[index].course_video_info!.is_discount == 1
                    ? courseChartList[index].course_video_info!.discount!
                    : courseChartList[index].course_video_info!.price));
      }
    });

    return [totalCountGet, totalDiscountGet];
  }

  void loadCharts({bool ifNeedCheck = false}) {
    List<String> courseChartCheckeHistoryIdsList = [];
    if (ifNeedCheck) {
      List.generate(courseChartCheckList.length, (index) {
        if (courseChartCheckList[index]) {
          courseChartCheckeHistoryIdsList.add(courseChartList[index].id);
        }
      });
    }
    storeClientProvider.getCourseChartListAction().then((value) {
      storeController
          .setStoreCourseChartNum(value.data != null ? value.data!.length : 0);
      List<bool> courseChartCheckListGet = [];
      List<StoreCourseChartTypeModel> courseChartListGet = value.data ?? [];
      List.generate(courseChartListGet.length, (index) {
        courseChartCheckListGet.add(false);
      });

      if (ifNeedCheck) {
        List.generate(courseChartListGet.length, (index) {
          if (courseChartCheckeHistoryIdsList
              .contains(courseChartListGet[index].id)) {
            courseChartCheckListGet[index] = true;
          }
        });
        if (courseChartCheckListGet.every((element) => element)) {
          setState(() {
            checkAll = true;
          });
        }
      }

      setState(() {
        courseChartCheckList = [...courseChartCheckListGet];
        courseChartList = [...courseChartListGet];
        _readyLoad = true;
      });

      final double totalCountGet =
          handleCalculateCounts(courseChartCheckListGet)[0];
      final double totalDiscountGet =
          handleCalculateCounts(courseChartCheckListGet)[1];

      setState(() {
        totalCount = totalCountGet;
        totalDiscount = totalDiscountGet;
      });
    });
  }

  void handleGoToLiveDetail(String courseId) {
    Get.toNamed('/store_course_live_detail', arguments: {'courseId': courseId});
  }

  void handleGoToVideoDetail(String courseId) {
    Get.toNamed('/store_course_video_detail',
        arguments: {'courseId': courseId});
  }

  void handleGoBack() {
    Get.back();
  }

  void showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8), // 设置顶部边缘为直角
            ),
          ),
          title: null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 4),
                    child: Center(
                      child: IconFont(
                        IconNames.jingshi,
                        size: 14,
                        color: '#000',
                      ),
                    ),
                  ),
                  const Text(
                    '您确定要清空课程购物车吗？',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                  handleClearCourseChart();
                },
                child: const Text(
                  '确认',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                },
                child: const Text(
                  '取消',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleClearCourseChart() {
    showLoading('请稍后...');
    storeClientProvider.deleteCourseChartsByUserAction().then((value) {
      setState(() {
        _readyLoad = false;
        courseChartCheckList = [];
        courseChartList = [];
        courseChartChooseList = [];
      });
      hideLoading();
      if (value.code == 200) {
        loadCharts();
      } else {
        showToast(value.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败，请稍后再试');
    });
  }

  void handleDeleteChartItem(StoreCourseChartTypeModel item) {
    storeClientProvider.deleteCourseChartByIdAction(item.id).then((value) {
      if (value.code == 200) {
        loadCharts(ifNeedCheck: true);
      } else {
        showToast(value.message);
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
    });
  }

  void handleGoToOrder() {
    if (totalCount == 0) {
      return;
    }
    List<String> chartIdsList = [];
    List<Map<String, dynamic>> courseIdsList = [];
    List.generate(courseChartCheckList.length, (index) {
      if (courseChartCheckList[index]) {
        courseIdsList.add({
          'id': courseChartList[index].course_id,
          'type': courseChartList[index].add_course_type
        });
        chartIdsList.add(courseChartList[index].id);
      }
    });
    Get.toNamed('store_course_order',
            arguments: {'course': courseIdsList, 'chart': chartIdsList})!
        .then((value) {
      if (value == 'success') {
        loadCharts(ifNeedCheck: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadCharts();
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
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 36,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Shimmer.fromColors(
                baseColor: const Color.fromRGBO(229, 229, 229, 1),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 44,
                  height: 14,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                children: List.generate(
                    10,
                    (index) => Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 150,
                              width: mediaQuerySizeInfo.width - 24,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromRGBO(229, 229, 229, 1),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 44,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )),
              ),
            )
          ],
        ),
      );
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
              const Text('课程购物车',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 24,
                height: 24,
                child: courseChartList.isNotEmpty
                    ? InkWell(
                        onTap: showClearDialog,
                        child: Center(
                          child: IconFont(
                            IconNames.qingkong,
                            size: 24,
                            color: '#000',
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
      const Divider(
        height: 2,
        color: Color.fromRGBO(233, 234, 235, 1),
      ),
      (courseChartList.isNotEmpty
          ? Container(
              height: 36,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              color: const Color.fromRGBO(244, 244, 244, 1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '已选择 ${courseChartCheckList.where((check) => check).toList().length} 件课程商品',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : const SizedBox.shrink()),
      Expanded(
          child: (courseChartList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: courseChartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Slidable(
                          key: ValueKey(index),
                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                flex: 1,
                                onPressed: (BuildContext context) =>
                                    handleDeleteChartItem(
                                        courseChartList[index]),
                                backgroundColor:
                                    const Color.fromRGBO(254, 32, 52, 1),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: '删除',
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 32,
                                    height: 32,
                                    child: Checkbox(
                                      side:
                                          const BorderSide(color: Colors.black),
                                      fillColor: courseChartCheckList[index]
                                          ? MaterialStateProperty.all(
                                              Colors.black)
                                          : MaterialStateProperty.all(
                                              Colors.transparent),
                                      checkColor: Colors.white,
                                      value: courseChartCheckList[index],
                                      onChanged: (bool? newValue) =>
                                          handleCheckItem(newValue, index),
                                    ),
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () => courseChartList[index]
                                                .add_course_type ==
                                            1
                                        ? handleGoToLiveDetail(
                                            courseChartList[index].course_id)
                                        : handleGoToVideoDetail(
                                            courseChartList[index].course_id),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                height: 120 / 4 * 3,
                                                child: CachedNetworkImage(
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // 设置圆角
                                                    child: Image(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  width: 120,
                                                  height: 120 / 4 * 3,
                                                  imageUrl:
                                                      '${globalController.cdnBaseUrl}/${courseChartList[index].add_course_type == 1 ? courseChartList[index].course_live_info!.cover : courseChartList[index].course_video_info!.cover}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                                width: 12,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  (courseChartList[index]
                                                              .add_course_type ==
                                                          1
                                                      ? Container(
                                                          height: 20,
                                                          decoration: const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      203,
                                                                      174,
                                                                      241,
                                                                      1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  6, 0, 6, 0),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
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
                                                                  child:
                                                                      IconFont(
                                                                    IconNames
                                                                        .live_fill,
                                                                    size: 16,
                                                                    color:
                                                                        'rgb(151,63,247)',
                                                                  ),
                                                                ),
                                                              ),
                                                              const Text('直播课',
                                                                  style: TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          151,
                                                                          63,
                                                                          247,
                                                                          1),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 20,
                                                          decoration: const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      172,
                                                                      202,
                                                                      239,
                                                                      1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  6, 0, 6, 0),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 12),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
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
                                                                  child:
                                                                      IconFont(
                                                                    IconNames
                                                                        .live_fill,
                                                                    size: 16,
                                                                    color:
                                                                        'rgb(69,141,229)',
                                                                  ),
                                                                ),
                                                              ),
                                                              const Text('视频课',
                                                                  style: TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          69,
                                                                          141,
                                                                          229,
                                                                          1),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                            ],
                                                          ),
                                                        )),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                          text: courseChartList[
                                                                          index]
                                                                      .add_course_type ==
                                                                  1
                                                              ? courseChartList[
                                                                      index]
                                                                  .course_live_info!
                                                                  .title
                                                              : courseChartList[
                                                                      index]
                                                                  .course_video_info!
                                                                  .title,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14))),
                                                  const SizedBox(
                                                    height: 4,
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
                                                                '${courseChartList[index].add_course_type == 1 ? '面对面康复指导' : '专业能力提升'} · ',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          TextSpan(
                                                            text: courseChartList[
                                                                            index]
                                                                        .add_course_type ==
                                                                    1
                                                                ? courseTypeList[
                                                                    courseChartList[
                                                                            index]
                                                                        .course_live_info!
                                                                        .course_type]
                                                                : courseTypeList[
                                                                    courseChartList[
                                                                            index]
                                                                        .course_video_info!
                                                                        .course_type],
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
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
                                                  RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${courseChartList[index].add_course_type == 1 ? '直播次数' : '视频数'}: ',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '${courseChartList[index].add_course_type == 1 ? courseChartList[index].course_live_info!.live_num : courseChartList[index].course_video_info!.video_num}',
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ((courseChartList[index]
                                                                  .add_course_type ==
                                                              1 &&
                                                          courseChartList[index]
                                                                  .course_live_info!
                                                                  .is_discount ==
                                                              1) ||
                                                      (courseChartList[index]
                                                                  .add_course_type ==
                                                              0 &&
                                                          courseChartList[index]
                                                                  .course_video_info!
                                                                  .is_discount ==
                                                              1)
                                                  ? Container(
                                                      height: 24,
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              1)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
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
                                                                      .pic_discount,
                                                                  size: 18),
                                                            ),
                                                          ),
                                                          (courseChartList[
                                                                          index]
                                                                      .add_course_type ==
                                                                  1
                                                              ? Text(
                                                                  courseChartList[index]
                                                                              .course_live_info!
                                                                              .is_discount ==
                                                                          1
                                                                      ? '折扣 -${(((double.parse(courseChartList[index].course_live_info!.price) - double.parse(courseChartList[index].course_live_info!.discount!)) / double.parse(courseChartList[index].course_live_info!.price)) * 100).round()}%'
                                                                      : "",
                                                                  style: const TextStyle(
                                                                      color: Color.fromRGBO(
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
                                                              : Text(
                                                                  courseChartList[index]
                                                                              .course_video_info!
                                                                              .is_discount ==
                                                                          1
                                                                      ? '折扣 -${(((double.parse(courseChartList[index].course_video_info!.price) - double.parse(courseChartList[index].course_video_info!.discount!)) / double.parse(courseChartList[index].course_video_info!.price)) * 100).round()}%'
                                                                      : "",
                                                                  style: const TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          209,
                                                                          120,
                                                                          47,
                                                                          1),
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ))
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 12,
                                                      width: 12,
                                                    )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: courseChartList[index]
                                                            .add_course_type ==
                                                        1
                                                    ? [
                                                        (courseChartList[index]
                                                                    .course_live_info!
                                                                    .is_discount ==
                                                                0
                                                            ? Text(
                                                                '¥${courseChartList[index].course_live_info!.price}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                '¥${courseChartList[index].course_live_info!.price}',
                                                                style: const TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    decorationThickness:
                                                                        2,
                                                                    decorationColor:
                                                                        Color.fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        (courseChartList[index]
                                                                    .course_live_info!
                                                                    .is_discount ==
                                                                1
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 12,
                                                                    height: 12,
                                                                  ),
                                                                  Text(
                                                                    '¥${courseChartList[index].course_live_info!.discount}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            197,
                                                                            124,
                                                                            63,
                                                                            1),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              )
                                                            : const SizedBox
                                                                .shrink())
                                                      ]
                                                    : [
                                                        (courseChartList[index]
                                                                    .course_video_info!
                                                                    .is_discount ==
                                                                0
                                                            ? Text(
                                                                '¥${courseChartList[index].course_video_info!.price}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                '¥${courseChartList[index].course_video_info!.price}',
                                                                style: const TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    decorationThickness:
                                                                        2,
                                                                    decorationColor:
                                                                        Color.fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            200,
                                                                            200,
                                                                            200,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        (courseChartList[index]
                                                                    .course_video_info!
                                                                    .is_discount ==
                                                                1
                                                            ? Row(
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 12,
                                                                    height: 12,
                                                                  ),
                                                                  Text(
                                                                    '¥${courseChartList[index].course_video_info!.discount}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            197,
                                                                            124,
                                                                            63,
                                                                            1),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              )
                                                            : const SizedBox
                                                                .shrink())
                                                      ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              (index != courseChartList.length - 1
                                  ? const Divider(
                                      height: 2,
                                      color: Color.fromRGBO(233, 234, 235, 1),
                                    )
                                  : const SizedBox.shrink())
                            ],
                          ),
                        );
                      }),
                )
              : _readyLoad
                  ? Center(
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
                          '购物车空空如也~',
                          style: TextStyle(
                              color: Color.fromRGBO(224, 222, 223, 1),
                              fontSize: 14),
                        )
                      ],
                    ))
                  : skeleton())),
      (courseChartList.isNotEmpty
          ? Column(
              children: [
                const Divider(
                  height: 2,
                  color: Color.fromRGBO(233, 234, 235, 1),
                ),
                Container(
                  width: mediaQuerySizeInfo.width,
                  padding: EdgeInsets.fromLTRB(
                      0, 16, 0, 16 + mediaQuerySafeInfo.bottom),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: Checkbox(
                              isError: true,
                              side: BorderSide(
                                  color: courseChartList.isNotEmpty
                                      ? Colors.black
                                      : const Color.fromRGBO(191, 192, 196, 1)),
                              fillColor: checkAll
                                  ? MaterialStateProperty.all(Colors.black)
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                              checkColor: Colors.white,
                              value: checkAll,
                              onChanged: handleCheckAll,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => handleCheckAll(!checkAll),
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 4,
                                  width: 4,
                                ),
                                Text(
                                  '全选',
                                  style: TextStyle(
                                      color: courseChartList.isNotEmpty
                                          ? Colors.black
                                          : const Color.fromRGBO(
                                              191, 192, 196, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 36,
                        height: 36,
                      ),
                      GestureDetector(
                        onTap: handleGoToOrder,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          decoration: totalCount != 0
                              ? const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromRGBO(211, 66, 67, 1),
                                      Color.fromRGBO(211, 66, 67, 0.8),
                                      Color.fromRGBO(211, 66, 67, 0.6)
                                    ], // 渐变的起始和结束颜色
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)))
                              : const BoxDecoration(
                                  color: Color.fromRGBO(244, 244, 245, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                          child: Row(
                            children: [
                              Text(
                                '立即下单',
                                style: TextStyle(
                                    color: totalCount != 0
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            188, 190, 194, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              (totalCount != 0
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                        ),
                                        (totalCount == totalDiscount
                                            ? Text(
                                                '¥$totalCount',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                '¥$totalCount',
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        (totalCount != totalDiscount
                                            ? Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    '¥$totalDiscount',
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
                                    )
                                  : const SizedBox.shrink())
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : const SizedBox.shrink())
    ]));
  }
}
