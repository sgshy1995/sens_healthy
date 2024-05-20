import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/appointment_model.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:shimmer/shimmer.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import '../../providers/api/appointment_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MineDoctorPage extends StatefulWidget {
  const MineDoctorPage({super.key});

  @override
  State<MineDoctorPage> createState() => _MineDoctorPageState();
}

class _MineDoctorPageState extends State<MineDoctorPage>
    with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());

  late AnimationController _rotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  double _scrollDistance = 0;

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

  //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final List<String> courseTypeList = ['运动康复', '神经康复', '产后康复', '术后康复'];

  List<BookTypeModel> bookList = [];

  bool _readyLoad = false;

  AuthenticateTypeModel authenticateInfo = AuthenticateTypeModel.fromJson(null);

  Future<String?> loadInfo() async {
    Completer<String?> completer = Completer();
    userClientProvider.findOneAuthenticateByUserIdAction().then((result) {
      if (result.code == 200 && result.data != null) {
        setState(() {
          authenticateInfo = result.data!;
        });
        completer.complete('success');
      } else {
        completer.completeError('error');
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  Future<String?> loadBooks() async {
    Completer<String?> completer = Completer();
    appointmentClientProvider
        .findManyBooksReadyBookedAction(userController.userInfo.id)
        .then((result) {
      if (result.code == 200) {
        setState(() {
          bookList = result.data!;
        });
        completer.complete('success');
      } else {
        completer.completeError('error');
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  void _onRefresh() async {
    // monitor network fetch
    List<String?> result;
    try {
      result = await Future.wait([loadInfo(), loadBooks()]);
      setState(() {
        _readyLoad = true;
      });
      _refreshController.refreshCompleted();
      if (result.every((element) => element == 'success')) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (e) {
      setState(() {
        _readyLoad = true;
      });
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void handleGoBack() {
    Get.back();
  }

  void handleGotoTimeManage() {
    Get.toNamed('mine_doctor_time')!.then((value) {
      _onRefresh();
    });
  }

  void handleShowDeleteDialog(BookTypeModel item) {
    showLoading('请稍后...');
    appointmentClientProvider.getOneBookByIdAction(item.id).then((result) {
      if (result.code == 200 && result.data != null) {
        final BookTypeModel bookInfo = result.data!;
        final int findIndex =
            bookList.indexWhere((element) => element.id == bookInfo.id);
        setState(() {
          bookList[findIndex] = bookInfo;
        });
        hideLoading();
        if (bookInfo.room_info != null) {
          showToast('该预约已开始，无法取消');
          return;
        }
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            '取消预约',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          '您确定取消以下预约时间段吗?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(bookInfo.book_start_time))} - ${DateFormat('HH:mm').format(DateTime.parse(bookInfo.book_end_time))}',
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      color: 'rgb(255, 31, 47)',
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '该时间段已被预约',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 31, 47, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    bookInfo.patient_course_info!
                                                .outer_cancel_num <
                                            1
                                        ? Text(
                                            '当前系列课程剩余 ${1 - bookInfo.patient_course_info!.outer_cancel_num} 次无责取消机会',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 31, 47, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : RichText(
                                            maxLines: 3,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.left,
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '如您取消, 按约定您将额外承担一次该课程的直播',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 31, 47, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )),
                                  ],
                                ))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: 18,
                    //       height: 18,
                    //       margin: const EdgeInsets.only(right: 4),
                    //       child: Center(
                    //         child: IconFont(
                    //           IconNames.jingshi,
                    //           size: 14,
                    //           color: '#000',
                    //         ),
                    //       ),
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text('请确认您已阅读并悉知',
                    //             style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold)),
                    //         GestureDetector(
                    //           onTap: handleGotoExplain,
                    //           child: const Text('《 面对面康复课程预约时间说明 》',
                    //               style: TextStyle(
                    //                   decoration: TextDecoration.underline,
                    //                   decorationThickness: 2,
                    //                   decorationColor:
                    //                       Color.fromRGBO(211, 66, 67, 1),
                    //                   color: Color.fromRGBO(211, 66, 67, 1),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold)),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                actions: <Widget>[
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(12, 0, 12, 0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  side: BorderSide(
                                      color: Colors.black, width: 1)))),
                      onPressed: () {
                        // 点击确认按钮时执行的操作
                        Navigator.of(context).pop();
                        // 在这里执行你的操作
                        handleConfirmDeleteTime(item);
                      },
                      child: const Text(
                        '我已知悉并确认',
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
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
      } else {
        showToast(result.message);
        hideLoading();
      }
    }).catchError((e) {
      showToast('获取信息失败, 请稍后再试');
      hideLoading();
    });
  }

  void handleConfirmDeleteTime(BookTypeModel item) {
    showLoading('请稍后...');
    appointmentClientProvider
        .deleteOneLecturerTimeAction(id: item.lecturer_time_id)
        .then((result) {
      if (result.code == 200) {
        loadBooks().then((resultIn) {
          hideLoading();
          showToast('预约时间已取消');
        }).catchError((eIn) {
          hideLoading();
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

  void handleShowPatientUserInfoDialog(BookTypeModel item) {
    showLoading('请稍后...');
    userClientProvider
        .getInfoByUserIdAction(item.patient_user_info!.id)
        .then((result) {
      if (result.code == 200 && result.data != null) {
        final UserInfoTypeModel userInfo = result.data!;
        hideLoading();
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            '患者信息',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: (item.patient_user_info!.avatar == null)
                              ? const CircleAvatar(
                                  radius: 16,
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.webp'),
                                )
                              : CircleAvatar(
                                  backgroundColor:
                                      const Color.fromRGBO(254, 251, 254, 1),
                                  radius: 16,
                                  backgroundImage: CachedNetworkImageProvider(
                                      '${globalController.cdnBaseUrl}/${item.patient_user_info!.avatar}'),
                                ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '姓名/昵称',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const WidgetSpan(
                                            child: SizedBox(
                                          width: 4,
                                        )),
                                        TextSpan(
                                          text: item.patient_user_info!.name ??
                                              '赴康云用户',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                              ],
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '性别',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const WidgetSpan(
                                            child: SizedBox(
                                          width: 4,
                                        )),
                                        TextSpan(
                                          text:
                                              item.patient_user_info!.gender ==
                                                      1
                                                  ? '男'
                                                  : item.patient_user_info!
                                                              .gender ==
                                                          0
                                                      ? '女'
                                                      : '未知',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                              ],
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '年龄',
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const WidgetSpan(
                                            child: SizedBox(
                                          width: 4,
                                        )),
                                        TextSpan(
                                          text: '${userInfo.age ?? '未知'}',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
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
                        userInfo.injury_history == null
                            ? const Text(
                                '伤痛档案未维护',
                                style: TextStyle(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    handleGotoPatientRecord(item.user_id),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 32,
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 0),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                              width: 1, color: Colors.black)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('查看伤痛档案',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            margin:
                                                const EdgeInsets.only(left: 4),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.qianjin,
                                                size: 14,
                                                color: '#000',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: 18,
                    //       height: 18,
                    //       margin: const EdgeInsets.only(right: 4),
                    //       child: Center(
                    //         child: IconFont(
                    //           IconNames.jingshi,
                    //           size: 14,
                    //           color: '#000',
                    //         ),
                    //       ),
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Text('请确认您已阅读并悉知',
                    //             style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold)),
                    //         GestureDetector(
                    //           onTap: handleGotoExplain,
                    //           child: const Text('《 面对面康复课程预约时间说明 》',
                    //               style: TextStyle(
                    //                   decoration: TextDecoration.underline,
                    //                   decorationThickness: 2,
                    //                   decorationColor:
                    //                       Color.fromRGBO(211, 66, 67, 1),
                    //                   color: Color.fromRGBO(211, 66, 67, 1),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold)),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                actions: <Widget>[
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(12, 0, 12, 0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  side: BorderSide(
                                      color: Colors.black, width: 1)))),
                      onPressed: () {
                        // 点击确认按钮时执行的操作
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '确认',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  )
                ],
              );
            });
          },
        );
      } else {
        showToast(result.message);
        hideLoading();
      }
    }).catchError((e) {
      showToast('获取信息失败, 请稍后再试');
      hideLoading();
    });
  }

  void handleGotoPatientRecord(String userId) {
    Get.toNamed('/mine_doctor_patient_record', arguments: {'userId': userId});
  }

  void handleGotoCenterLive(String roomId) {
    Get.toNamed('/center_live_lecturer', arguments: {'roomId': roomId})!
        .then((value) {
      _onRefresh();
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

    _scrollController.addListener(_scrollListener);
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
  void dispose() {
    _rotateController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
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

    return Scaffold(
        body: Stack(children: [
      Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(211, 66, 67, 0.2),
              Color.fromRGBO(211, 66, 67, 0.1),
              Color.fromRGBO(211, 66, 67, 0)
            ], // 渐变的起始和结束颜色
          )),
          child: Column(children: [
            SizedBox(
              height: mediaQuerySafeInfo.top,
            ),
            Container(
              height: 24,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: handleGoBack,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Center(
                      child: IconFont(
                        IconNames.fanhui,
                        size: 16,
                        color: 'rgb(255,255,255)',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: RefreshConfiguration(
                    headerTriggerDistance: 60.0,
                    enableScrollWhenRefreshCompleted: true,
                    child: SmartRefresher(
                        physics: const ClampingScrollPhysics(), // 禁止回弹效果
                        enablePullDown: true,
                        enablePullUp: false,
                        header: CustomHeader(
                            builder: buildHeader,
                            onOffsetChange: (offset) {
                              //do some ani
                            }),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Stack(
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GetBuilder<UserController>(
                                                builder: (controller) {
                                                  return Container(
                                                    width: 54,
                                                    height: 54,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 18),
                                                    child: (userController
                                                                .userInfo
                                                                .avatar ==
                                                            null)
                                                        ? const CircleAvatar(
                                                            radius: 27,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/avatar.webp'),
                                                          )
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    254,
                                                                    251,
                                                                    254,
                                                                    1),
                                                            radius: 27,
                                                            backgroundImage:
                                                                CachedNetworkImageProvider(
                                                                    '${globalController.cdnBaseUrl}/${userController.userInfo.avatar}'),
                                                          ),
                                                  );
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  RichText(
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: '欢迎您,',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          const WidgetSpan(
                                                              child: SizedBox(
                                                            width: 6,
                                                          )),
                                                          TextSpan(
                                                            text:
                                                                authenticateInfo
                                                                    .name,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  RichText(
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: '@',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          TextSpan(
                                                            text: authenticateInfo
                                                                .organization,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: handleGotoTimeManage,
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 44,
                                                        height: 44,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 12),
                                                        decoration: const BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            22))),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames
                                                                  .yuyueshijian_doctor,
                                                              size: 24),
                                                        ),
                                                      ),
                                                      const Text(
                                                        '预约时间',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          22))),
                                                      child: Center(
                                                        child: IconFont(
                                                            IconNames
                                                                .shoukequanxian_doctor,
                                                            size: 24),
                                                      ),
                                                    ),
                                                    const Text(
                                                      '授课权限',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          22))),
                                                      child: Center(
                                                        child: IconFont(
                                                            IconNames
                                                                .shangwuhezuo_doctor,
                                                            size: 24),
                                                      ),
                                                    ),
                                                    const Text(
                                                      '商务合作',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          const Text(
                                            '已预约课程',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          !_readyLoad
                                              ? skeleton()
                                              : bookList.isNotEmpty
                                                  ? Column(
                                                      children: List.generate(
                                                          bookList.length,
                                                          (index) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            18,
                                                                        height:
                                                                            18,
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                4),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              IconFont(
                                                                            IconNames.zuixingengxin,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                'rgb(195,77,73)',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                          maxLines:
                                                                              1,
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          text:
                                                                              TextSpan(
                                                                            children: [
                                                                              const TextSpan(
                                                                                text: '时间:',
                                                                                style: TextStyle(color: Color.fromRGBO(195, 77, 73, 1), fontSize: 14, fontWeight: FontWeight.normal),
                                                                              ),
                                                                              const WidgetSpan(
                                                                                  child: SizedBox(
                                                                                width: 6,
                                                                              )),
                                                                              TextSpan(
                                                                                text: '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(bookList[index].book_start_time))} - ${DateFormat('HH:mm').format(DateTime.parse(bookList[index].book_end_time))}',
                                                                                style: const TextStyle(color: Color.fromRGBO(195, 77, 73, 1), fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                decoration: const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            233,
                                                                            233,
                                                                            233,
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100 /
                                                                              4 *
                                                                              3,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8), // 设置圆角
                                                                          child:
                                                                              Image(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        width:
                                                                            100,
                                                                        height: 100 /
                                                                            4 *
                                                                            3,
                                                                        imageUrl:
                                                                            '${globalController.cdnBaseUrl}/${bookList[index].course_info!.cover}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        RichText(
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.left,
                                                                            text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: bookList[index].course_info!.title,
                                                                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                        const SizedBox(
                                                                          height:
                                                                              6,
                                                                        ),
                                                                        RichText(
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.left,
                                                                            text: TextSpan(
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: courseTypeList[bookList[index].course_info!.course_type],
                                                                                  style: const TextStyle(color: Color.fromRGBO(33, 33, 33, 1), fontSize: 14, fontWeight: FontWeight.normal),
                                                                                )
                                                                              ],
                                                                            )),
                                                                        const SizedBox(
                                                                          height:
                                                                              6,
                                                                        ),
                                                                        RichText(
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.left,
                                                                            text: TextSpan(
                                                                              children: [
                                                                                const TextSpan(
                                                                                  text: '课程次数:',
                                                                                  style: TextStyle(color: Color.fromRGBO(33, 33, 33, 1), fontSize: 14, fontWeight: FontWeight.normal),
                                                                                ),
                                                                                const WidgetSpan(
                                                                                    child: SizedBox(
                                                                                  width: 6,
                                                                                )),
                                                                                TextSpan(
                                                                                  text: '${bookList[index].patient_course_info!.learn_num} / ${bookList[index].patient_course_info!.course_live_num}',
                                                                                  style: const TextStyle(color: Color.fromRGBO(33, 33, 33, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                )
                                                                              ],
                                                                            ))
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            24,
                                                                        height:
                                                                            24,
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                8),
                                                                        child: (bookList[index].patient_user_info!.avatar ==
                                                                                null)
                                                                            ? const CircleAvatar(
                                                                                radius: 12,
                                                                                backgroundImage: AssetImage('assets/images/avatar.webp'),
                                                                              )
                                                                            : CircleAvatar(
                                                                                backgroundColor: const Color.fromRGBO(254, 251, 254, 1),
                                                                                radius: 12,
                                                                                backgroundImage: CachedNetworkImageProvider('${globalController.cdnBaseUrl}/${bookList[index].patient_user_info!.avatar}'),
                                                                              ),
                                                                      ),
                                                                      Text(
                                                                        bookList[index].patient_user_info!.name ??
                                                                            '赴康云用户',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              13,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //handleShowPatientUserInfoDialog
                                                                  GestureDetector(
                                                                    onTap: () =>
                                                                        handleShowPatientUserInfoDialog(
                                                                            bookList[index]),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          24,
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          8,
                                                                          0,
                                                                          8,
                                                                          0),
                                                                      decoration: const BoxDecoration(
                                                                          color: Color.fromRGBO(
                                                                              233,
                                                                              233,
                                                                              233,
                                                                              1),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                14,
                                                                            height:
                                                                                14,
                                                                            margin:
                                                                                const EdgeInsets.only(right: 4),
                                                                            child:
                                                                                Center(
                                                                              child: IconFont(
                                                                                IconNames.jingshi,
                                                                                size: 14,
                                                                                color: '#000',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Text(
                                                                            '患者信息',
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontSize: 13),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              bookList[index]
                                                                          .room_info ==
                                                                      null
                                                                  ? Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            //handleShowDeleteDialog
                                                                            GestureDetector(
                                                                              onTap: () => handleShowDeleteDialog(bookList[index]),
                                                                              child: Container(
                                                                                height: 32,
                                                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                                                decoration: const BoxDecoration(color: Color.fromRGBO(230, 65, 57, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      margin: const EdgeInsets.only(right: 4),
                                                                                      child: Center(
                                                                                        child: IconFont(
                                                                                          IconNames.quxiao_circle,
                                                                                          size: 18,
                                                                                          color: '#fff',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const Text(
                                                                                      '取消预约',
                                                                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            //handleGotoCenterLive
                                                                            GestureDetector(
                                                                              onTap: () => handleGotoCenterLive(bookList[index].room_info!.id),
                                                                              child: Container(
                                                                                height: 32,
                                                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                                                                decoration: const BoxDecoration(color: Color.fromRGBO(140, 68, 238, 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                child: Row(
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
                                                                                    const Text(
                                                                                      '进入直播间',
                                                                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    )
                                                  : Container(
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 48),
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
                                                              '您没有被预约的课程哦~',
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
                                                    )
                                        ]),
                                    Positioned(
                                        top: 18,
                                        left: 36,
                                        child: GetBuilder<UserController>(
                                            builder: (controller) {
                                          return (controller
                                                      .userInfo.identity ==
                                                  1
                                              ? Container(
                                                  width: 24,
                                                  height: 24,
                                                  margin: const EdgeInsets.only(
                                                      left: 0),
                                                  child: Center(
                                                    child: IconFont(
                                                        IconNames
                                                            .guanfangrenzheng,
                                                        size: 24),
                                                  ),
                                                )
                                              : const SizedBox.shrink());
                                        }))
                                  ],
                                ),
                              ))
                            ]))))
          ]))
    ]));
  }
}
