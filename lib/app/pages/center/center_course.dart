import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sens_healthy/components/loading.dart';
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
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/appointment_client_provider.dart';
import '../../models/appointment_model.dart';

class DialogText extends ValueNotifier<String> {
  DialogText(super.value);

  void update(String newValue) {
    value = newValue;
    notifyListeners();
  }
}

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class CenterCoursePage extends StatefulWidget {
  CenterCoursePage({super.key, required this.scrollCallBack});

  late ScrollCallback scrollCallBack;

  @override
  State<CenterCoursePage> createState() => CenterCoursePageState();
}

class CenterCoursePageState extends State<CenterCoursePage>
    with SingleTickerProviderStateMixin {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  /* 数据信息 */
  bool _readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<PatientCourseTypeModel>>
      patientCourseDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    setState(() {
      patientCourseDataPagination = DataPaginationInModel(
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

  Future<String> getPatientCourses({int? page}) {
    Completer<String> completer = Completer();
    appointmentClientProvider
        .getPatientCoursesPaginationAction(
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
          patientCourseDataPagination.data = valueGet;
        } else {
          patientCourseDataPagination.data.addAll(valueGet);
        }
        patientCourseDataPagination.pageNo = pageNo;
        patientCourseDataPagination.pageSize = pageSize;
        patientCourseDataPagination.totalPage = totalPage;
        patientCourseDataPagination.totalCount = totalCount;
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
      result = await getPatientCourses(page: 1);
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
      result = await getPatientCourses();
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

  void handleGotoTimePage(PatientCourseTypeModel item) {
    Get.toNamed('center_course_time', arguments: {
      'patientCourseId': item.id,
      'type': 'add',
      'bookHistoryUserId': item.book_history_user_id
    })!
        .then((value) {
      if (value == 'success') {
        scrollToTop();
        setState(() {
          _readyLoad = false;
        });
        initPagination();
        _onRefresh();
      }
    });
  }

  void handleGotoTimePageWithChange(PatientCourseTypeModel item) {
    Get.toNamed('center_course_time', arguments: {
      'patientCourseId': item.id,
      'type': 'edit',
      'bookHistoryUserId': item.book_history_user_id
    })!
        .then((value) {
      if (value == 'success') {
        scrollToTop();
        setState(() {
          _readyLoad = false;
        });
        initPagination();
        _onRefresh();
      }
    });
  }

  bool isCooling = false;

  int coolNumber = 3;

  Timer? timer;

  void startTimer() {
    try {
      timer?.cancel(); // 取消定时器
    } catch (e) {}
    setState(() {
      isCooling = true;
      coolNumber = 3;
      dialogText.update(coolNumber.toString());
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timerIn) {
      if (coolNumber > 0) {
        setState(() {
          coolNumber -= 1;
          dialogText.update(coolNumber.toString());
        });
      } else {
        if (timer != null) {
          timer!.cancel(); // 取消定时器
        }
        setState(() {
          coolNumber = 3;
          isCooling = false;
        });
      }
    });
  }

  DialogText dialogText = DialogText('3');

  void handleShowCancelDialog(PatientCourseTypeModel item) {
    if (item.cancel_num >= 2) {
      return;
    }
    startTimer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 4),
                      child: Center(
                        child: IconFont(
                          IconNames.live_fill,
                          size: 16,
                          color: 'rgb(0,0,0)',
                        ),
                      ),
                    ),
                    Text(
                      item.course_info!.title,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '注意: 您的该课程还有 ${2 - item.cancel_num} 次取消机会。',
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 31, 47, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '确定要取消预约吗？该操作不可撤销。',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            actions: <Widget>[
              ValueListenableBuilder<String>(
                valueListenable: dialogText,
                builder: (BuildContext context, String value, Widget? child) {
                  return value != '0'
                      ? SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(188, 188, 188, 1)),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        side: BorderSide(
                                            color: Color.fromRGBO(
                                                188, 188, 188, 1),
                                            width: 1)))),
                            onPressed: () {
                              if (isCooling) {
                                return;
                              }
                            },
                            child: Text(
                              '确认 · $value',
                              style: const TextStyle(
                                  color: Color.fromRGBO(225, 225, 225, 1),
                                  fontSize: 14),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        side: BorderSide(
                                            color: Colors.black, width: 1)))),
                            onPressed: () {
                              if (isCooling) {
                                return;
                              }
                              // 点击确认按钮时执行的操作
                              Navigator.of(context).pop();
                              // 在这里执行你的操作
                              handleConfirmCancelBook(item);
                            },
                            child: const Text(
                              '确认',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        );
                },
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side: BorderSide(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  width: 1)))),
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
        });
      },
    );
  }

  void handleConfirmCancelBook(PatientCourseTypeModel item) {
    showLoading('请稍后...');
    appointmentClientProvider
        .deleteOneBookByIdAction(
            id: item.book_info!.id, canceledReason: '用户手动取消')
        .then((result) {
      if (result.code == 200) {
        appointmentClientProvider
            .getPatientCourseByIdAction(item.id)
            .then((resultIn) {
          if (resultIn.code == 200 && resultIn.data != null) {
            hideLoading();
            final int findIndex = patientCourseDataPagination.data
                .indexWhere((element) => element.id == item.id);
            setState(() {
              patientCourseDataPagination.data[findIndex] = resultIn.data!;
            });
            showToast('您已取消预约');
          } else {
            hideLoading();
            showToast(resultIn.message);
          }
        }).catchError((eIn) {
          hideLoading();
          showToast('获取课程失败, 请稍后再试');
        });
      } else {
        hideLoading();
        showToast(result.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败, 请稍后再试');
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
    if (timer != null) {
      timer!.cancel(); // 取消定时器
    }
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
                        if (patientCourseDataPagination.data.isEmpty) {
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
                            child: (patientCourseDataPagination.data.isEmpty &&
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
                                    patientCourseDataPagination.data.length,
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
                                                          '${globalController.cdnBaseUrl}/${patientCourseDataPagination.data[index].course_info?.cover}',
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
                                                                text: patientCourseDataPagination
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
                                                                    patientCourseDataPagination
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
                                                                text: '课程次数:',
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
                                                                    '${patientCourseDataPagination.data[index].course_live_num}',
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
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 18,
                                                        width:
                                                            mediaQuerySizeInfo
                                                                    .width -
                                                                24 -
                                                                24 -
                                                                60 -
                                                                12,
                                                        decoration: const BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    233,
                                                                    234,
                                                                    235,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Container(
                                                            height: 18,
                                                            width: (mediaQuerySizeInfo
                                                                        .width -
                                                                    24 -
                                                                    24 -
                                                                    60 -
                                                                    12) /
                                                                (patientCourseDataPagination
                                                                    .data[index]
                                                                    .course_live_num) *
                                                                (patientCourseDataPagination
                                                                    .data[index]
                                                                    .learn_num),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      begin: Alignment
                                                                          .centerLeft,
                                                                      end: Alignment
                                                                          .centerRight,
                                                                      colors: [
                                                                        Color.fromRGBO(
                                                                            211,
                                                                            66,
                                                                            67,
                                                                            1),
                                                                        Color.fromRGBO(
                                                                            211,
                                                                            66,
                                                                            67,
                                                                            0.85),
                                                                        Color.fromRGBO(
                                                                            211,
                                                                            66,
                                                                            67,
                                                                            0.7)
                                                                      ], // 渐变的起始和结束颜色
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  SizedBox(
                                                    width: 60,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          textAlign:
                                                              TextAlign.right,
                                                          '${patientCourseDataPagination.data[index].learn_num} / ${patientCourseDataPagination.data[index].course_live_num}',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      33,
                                                                      33,
                                                                      33,
                                                                      1),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              (patientCourseDataPagination
                                                          .data[index]
                                                          .book_info ==
                                                      null
                                                  ? Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              handleGotoTimePage(
                                                                  patientCourseDataPagination
                                                                          .data[
                                                                      index]),
                                                          child: Container(
                                                            height: 32,
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    12,
                                                                    0,
                                                                    12,
                                                                    0),
                                                            decoration: const BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        97,
                                                                        192,
                                                                        174,
                                                                        1),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
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
                                                                          right:
                                                                              4),
                                                                  child: Center(
                                                                    child:
                                                                        IconFont(
                                                                      IconNames
                                                                          .zuixingengxin,
                                                                      size: 18,
                                                                      color:
                                                                          '#fff',
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Center(
                                                                  child: Text(
                                                                    '时间预约',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
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
                                                                      .zuixingengxin,
                                                                  size: 18,
                                                                  color:
                                                                      'rgb(195,77,73)',
                                                                ),
                                                              ),
                                                            ),
                                                            RichText(
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                text: TextSpan(
                                                                  children: [
                                                                    const TextSpan(
                                                                      text:
                                                                          '已预约:',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              195,
                                                                              77,
                                                                              73,
                                                                              1),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    const WidgetSpan(
                                                                        child:
                                                                            SizedBox(
                                                                      width: 6,
                                                                    )),
                                                                    TextSpan(
                                                                      text:
                                                                          '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(patientCourseDataPagination.data[index].book_info!.book_start_time))} - ${DateFormat('HH:mm').format(DateTime.parse(patientCourseDataPagination.data[index].book_info!.book_end_time))}',
                                                                      style: const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              195,
                                                                              77,
                                                                              73,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        (DateTime.parse(patientCourseDataPagination
                                                                            .data[
                                                                                index]
                                                                            .book_info!
                                                                            .book_start_time)
                                                                        .difference(DateTime
                                                                            .now())
                                                                        .inMinutes >=
                                                                    30 &&
                                                                (patientCourseDataPagination
                                                                            .data[
                                                                                index]
                                                                            .book_info!
                                                                            .change_num <
                                                                        1 ||
                                                                    patientCourseDataPagination
                                                                            .data[
                                                                                index]
                                                                            .cancel_num <
                                                                        2) &&
                                                                patientCourseDataPagination
                                                                        .data[
                                                                            index]
                                                                        .room_info ==
                                                                    null)
                                                            ? Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      patientCourseDataPagination.data[index].book_info!.change_num <
                                                                              1
                                                                          ? GestureDetector(
                                                                              onTap: () => handleGotoTimePageWithChange(patientCourseDataPagination.data[index]),
                                                                              child: Container(
                                                                                height: 32,
                                                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                                                decoration: const BoxDecoration(color: Color.fromRGBO(33, 33, 33, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      margin: const EdgeInsets.only(right: 4),
                                                                                      child: Center(
                                                                                        child: IconFont(
                                                                                          IconNames.zuixingengxin,
                                                                                          size: 18,
                                                                                          color: '#fff',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const Center(
                                                                                      child: Text(
                                                                                        '修改预约时间',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                      patientCourseDataPagination.data[index].book_info!.change_num <
                                                                              1
                                                                          ? const SizedBox(
                                                                              width: 12,
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                      patientCourseDataPagination.data[index].cancel_num <
                                                                              2
                                                                          ? GestureDetector(
                                                                              onTap: () => handleShowCancelDialog(patientCourseDataPagination.data[index]),
                                                                              child: Container(
                                                                                height: 32,
                                                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                                                decoration: const BoxDecoration(color: Color.fromRGBO(232, 69, 54, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      margin: const EdgeInsets.only(right: 4),
                                                                                      child: Center(
                                                                                        child: IconFont(
                                                                                          IconNames.zuixingengxin,
                                                                                          size: 18,
                                                                                          color: '#fff',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const Center(
                                                                                      child: Text(
                                                                                        '取消预约',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink()
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            : const SizedBox
                                                                .shrink(),
                                                        patientCourseDataPagination
                                                                    .data[index]
                                                                    .room_info !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              32,
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              12,
                                                                              0,
                                                                              12,
                                                                              0),
                                                                          decoration: const BoxDecoration(
                                                                              color: Color.fromRGBO(140, 68, 238, 1),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                width: 18,
                                                                                height: 18,
                                                                                margin: const EdgeInsets.only(right: 4),
                                                                                child: Center(
                                                                                  child: IconFont(
                                                                                    IconNames.live_fill,
                                                                                    size: 18,
                                                                                    color: '#fff',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const Center(
                                                                                child: Text(
                                                                                  '进入直播间',
                                                                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            : const SizedBox
                                                                .shrink()
                                                      ],
                                                    ))
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
