import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/appointment_model.dart';
import '../../providers/api/appointment_client_provider.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

import 'package:timezone/timezone.dart' as tz;

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

class MineDoctorTimePage extends StatefulWidget {
  const MineDoctorTimePage({super.key});

  @override
  State<MineDoctorTimePage> createState() => _MineDoctorTimePageState();
}

class _MineDoctorTimePageState extends State<MineDoctorTimePage> {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final AppointmentClientProvider appointmentClientProvider =
      Get.put(AppointmentClientProvider());

  final CalendarController _calendarController = CalendarController();

  List<LecturerTimeTypeModel> lecturerTimesList = [];

  Future<String?> loadInfo() {
    Completer<String?> completer = Completer();
    appointmentClientProvider.findManyLecturerTimesByJwtAction().then((result) {
      if (result.code == 200) {
        setState(() {
          lecturerTimesList = result.data!;
        });
        generateDataSource();
        completer.complete('success');
        hideLoading();
      } else {
        completer.completeError('error');
        showToast(result.message);
        hideLoading();
      }
    }).catchError((e) {
      completer.completeError('error');
      showToast('获取信息失败');
      hideLoading();
    });
    return completer.future;
  }

  void generateDataSource() {
    List<Appointment> appointments = <Appointment>[];
    List<CalendarResource> resources = <CalendarResource>[];
    List.generate(lecturerTimesList.length, (index) {
      appointments.add(Appointment(
          startTime: DateTime.parse(lecturerTimesList[index].start_time),
          endTime: DateTime.parse(lecturerTimesList[index].end_time),
          isAllDay: false,
          subject: lecturerTimesList[index].if_booked == 0 ? '未预约' : '已预约',
          color: lecturerTimesList[index].if_booked == 0
              ? const Color.fromRGBO(45, 195, 174, 1)
              : Colors.pink,
          startTimeZone: 'Asia/Shanghai',
          endTimeZone: 'Asia/Shanghai',
          location: 'Asia/Shanghai',
          notes: 'Hello World',
          id: lecturerTimesList[index]));

      // resources.add(CalendarResource(
      //     displayName: 'John', id: '0001', color: Colors.red));
      // resources.add(CalendarResource(
      //     displayName: 'Sgs', id: '0002', color: Colors.pink));
    });
    setState(() {
      dataSource = DataSource(appointments, resources);
    });
  }

  void handleEditTime(Appointment item) {
    showLoading('请稍后...');
    appointmentClientProvider
        .getLecturerTimeByIdAction((item.id as LecturerTimeTypeModel).id)
        .then((result) {
      if (result.code == 200 && result.data != null) {
        final LecturerTimeTypeModel lecturerTimeInfo = result.data!;
        final int findIndex = lecturerTimesList
            .indexWhere((element) => element.id == lecturerTimeInfo.id);
        setState(() {
          lecturerTimesList[findIndex] = lecturerTimeInfo;
        });
        generateDataSource();
        hideLoading();
        if (lecturerTimeInfo.if_booked == 1) {
          showToast('该时间段已被预约');
          return;
        }
        showBoardDateTimePicker(
          initialDate: item.startTime,
          context: context,
          pickerType: DateTimePickerType.datetime,
          options: BoardDateTimeOptions(
              boardTitle:
                  '修改预约时间 ${DateFormat('MM-dd HH:mm').format(item.startTime)}',
              pickerSubTitles: const BoardDateTimeItemTitles(
                  year: '年', month: '月', day: '日', hour: '时', minute: '分'),
              backgroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              languages: const BoardPickerLanguages(
                locale: 'zh',
                today: '今天',
                tomorrow: '明天',
                now: '现在',
              )),
        ).then((value) {
          if (value != null) {
            String formattedDateStart =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
            String formattedDateEnd = DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(value.add(const Duration(hours: 1)));
            showLoading('请稍后...');
            appointmentClientProvider.createLecturerTimeAction({
              'start_time': formattedDateStart,
              'end_time': formattedDateEnd
            }).then((result) {
              if (result.code == 200) {
                loadInfo().then((resultIn) {
                  hideLoading();
                  showToast('预约时间已修改');
                }).catchError((eIn) {
                  hideLoading();
                });
              } else {
                hideLoading();
                showToast(result.message);
              }
            }).catchError((e) {
              hideLoading();
              showToast('添加失败, 请稍后再试');
            });
          }
        });
      } else {
        showToast(result.message);
        hideLoading();
      }
    }).catchError((e) {
      showToast('获取信息失败');
      hideLoading();
    });
  }

  void handleDeleteTime(Appointment item) {}

  String showType = 'month';

  void changeType() {
    _calendarController.view =
        showType == 'month' ? CalendarView.timelineDay : CalendarView.month;
    setState(() {
      showType = showType == 'month' ? 'timelineDay' : 'month';
    });
  }

  void handleGoBack() {
    Get.back();
  }

  void handleGotoExplain() {
    Get.toNamed('mine_doctor_time_explain');
  }

  DataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    List<CalendarResource> resources = <CalendarResource>[];
    appointments.add(Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 2)),
        isAllDay: false,
        subject: 'Meeting',
        color: Colors.blue,
        resourceIds: <Object>['0001'],
        startTimeZone: '',
        endTimeZone: ''));

    appointments.add(Appointment(
        startTime: DateTime.now().add(Duration(hours: 2)),
        endTime: DateTime.now().add(Duration(hours: 3)),
        isAllDay: false,
        subject: 'Meeting',
        color: Colors.orange,
        resourceIds: <Object>['0002'],
        startTimeZone: '',
        endTimeZone: ''));

    resources.add(
        CalendarResource(displayName: 'John', id: '0001', color: Colors.red));
    resources.add(
        CalendarResource(displayName: 'Sgs', id: '0002', color: Colors.pink));

    return DataSource(appointments, resources);
  }

  DateTime minimumDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateTime maximumDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 55);

  void handleAddTime() {
    showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      options: const BoardDateTimeOptions(
          boardTitle: '添加预约时间',
          pickerSubTitles: BoardDateTimeItemTitles(
              year: '年', month: '月', day: '日', hour: '时', minute: '分'),
          backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          languages: BoardPickerLanguages(
            locale: 'zh',
            today: '今天',
            tomorrow: '明天',
            now: '现在',
          )),
    ).then((value) {
      if (value != null) {
        String formattedDateStart = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(value)));
        String formattedDateEnd = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateTime.parse(DateFormat('yyyy-MM-dd HH:mm')
                .format(value.add(const Duration(hours: 1)))));
        handleShowReceiveDialog(
            startTime: formattedDateStart, endTime: formattedDateEnd);
      }
    });
  }

  void handleShowReceiveDialog(
      {required String startTime, required String endTime}) {
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
                    const Text(
                      '您即将添加的预约时间段为',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(startTime))} - ${DateFormat('HH:mm').format(DateTime.parse(endTime))}',
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('请确认您已阅读并悉知',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: handleGotoExplain,
                          child: const Text('《 面对面康复课程预约时间说明 》',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  decorationColor:
                                      Color.fromRGBO(211, 66, 67, 1),
                                  color: Color.fromRGBO(211, 66, 67, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
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
                          const EdgeInsets.fromLTRB(12, 0, 12, 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side:
                                  BorderSide(color: Colors.black, width: 1)))),
                  onPressed: () {
                    // 点击确认按钮时执行的操作
                    Navigator.of(context).pop();
                    // 在这里执行你的操作
                    handleConfirmAddTime(
                        startTime: startTime, endTime: endTime);
                  },
                  child: const Text(
                    '我已悉知并确认',
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

  void handleConfirmAddTime(
      {required String startTime, required String endTime}) {
    showLoading('请稍后...');
    appointmentClientProvider.createLecturerTimeAction(
        {'start_time': startTime, 'end_time': endTime}).then((result) {
      if (result.code == 200) {
        loadInfo().then((resultIn) {
          hideLoading();
          showToast('预约时间已添加');
        }).catchError((eIn) {
          hideLoading();
        });
      } else {
        hideLoading();
        showToast(result.message);
      }
    }).catchError((e) {
      hideLoading();
      showToast('添加失败, 请稍后再试');
    });
  }

  void handleShowDeleteDialog(Appointment item) {
    showLoading('请稍后...');
    appointmentClientProvider
        .getLecturerTimeByIdAction((item.id as LecturerTimeTypeModel).id)
        .then((result) {
      if (result.code == 200 && result.data != null) {
        final LecturerTimeTypeModel lecturerTimeInfo = result.data!;
        final int findIndex = lecturerTimesList
            .indexWhere((element) => element.id == lecturerTimeInfo.id);
        setState(() {
          lecturerTimesList[findIndex] = lecturerTimeInfo;
        });
        generateDataSource();
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
                          '${DateFormat('yyyy-MM-dd HH:mm').format(item.startTime)} - ${DateFormat('HH:mm').format(item.endTime)}',
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        lecturerTimeInfo.if_booked == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '该时间段已被预约',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 31, 47, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          lecturerTimeInfo.patient_course_info!
                                                      .outer_cancel_num <
                                                  1
                                              ? Text(
                                                  '当前系列课程剩余 ${1 - lecturerTimeInfo.patient_course_info!.outer_cancel_num} 次无责取消机会',
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 31, 47, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    31,
                                                                    47,
                                                                    1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )),
                                        ],
                                      ))
                                    ],
                                  )
                                ],
                              )
                            : const SizedBox.shrink()
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
                      child: Text(
                        lecturerTimeInfo.if_booked == 1 ? '我已知悉并确认' : '确认',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
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

  void handleConfirmDeleteTime(Appointment item) {
    showLoading('请稍后...');
    appointmentClientProvider
        .deleteOneLecturerTimeAction(id: (item.id as LecturerTimeTypeModel).id)
        .then((result) {
      if (result.code == 200) {
        loadInfo().then((resultIn) {
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

  void handleReloadInfo() {
    showLoading('请稍后...');
    loadInfo().then((resultIn) {
      hideLoading();
    }).catchError((eIn) {
      hideLoading();
    });
  }

  DataSource? dataSource;

  @override
  void initState() {
    super.initState();
    showLoading('请稍后...');
    loadInfo();
    //dataSource = _getCalendarDataSource();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.white,
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
              child: SizedBox(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 24,
                      child: InkWell(
                        onTap: handleGoBack,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconFont(
                            IconNames.fanhui,
                            size: 24,
                            color: '#000',
                          ),
                        ),
                      ),
                    ),
                    const Text('预约时间管理',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Container(
                        width: 80,
                        height: 24,
                        color: Colors.white,
                        child: InkWell(
                          onTap: handleGotoExplain,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconFont(
                              IconNames.tanhao,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
              color: Color.fromRGBO(233, 234, 235, 1),
            ),
            Expanded(
              child: SfDateRangePickerTheme(
                data: const SfDateRangePickerThemeData(
                    backgroundColor: Colors.white,
                    headerBackgroundColor: Colors.white),
                child: SfCalendar(
                  controller: _calendarController,
                  allowAppointmentResize: false,
                  resourceViewSettings:
                      const ResourceViewSettings(showAvatar: false),
                  dataSource: dataSource,
                  todayHighlightColor: const Color.fromRGBO(211, 66, 67, 1),
                  todayTextStyle:
                      const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  viewHeaderStyle: const ViewHeaderStyle(
                      backgroundColor: Colors.white,
                      dateTextStyle: TextStyle(color: Colors.black),
                      dayTextStyle: TextStyle(color: Colors.black)),
                  headerStyle: const CalendarHeaderStyle(
                      backgroundColor: Color.fromRGBO(222, 222, 222, 1)),
                  backgroundColor: Colors.white,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  showTodayButton: true,
                  allowViewNavigation: false,
                  showCurrentTimeIndicator: true,
                  showWeekNumber: false,
                  view: CalendarView.month,
                  initialSelectedDate: DateTime.now(),
                  selectionDecoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(33, 33, 33, 1))),
                  appointmentTimeTextFormat: 'HH:mm',
                  appointmentBuilder: (BuildContext context,
                      CalendarAppointmentDetails detail) {
                    return showType == 'month'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(detail.appointments.length,
                                (index) {
                              return Container(
                                height: 72,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: detail.appointments
                                        .toList()[index]
                                        .color,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                padding: const EdgeInsets.all(12),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          detail.appointments
                                              .toList()[index]
                                              .subject,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                                  text: DateFormat('HH:mm')
                                                      .format(detail
                                                          .appointments
                                                          .toList()[index]
                                                          .startTime),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                      width: 6), // 设置间距为10
                                                ),
                                                const TextSpan(
                                                  text: '-',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                      width: 6), // 设置间距为10
                                                ),
                                                TextSpan(
                                                  text: DateFormat('HH:mm')
                                                      .format(detail
                                                          .appointments
                                                          .toList()[index]
                                                          .endTime),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Row(
                                          children: [
                                            (detail.appointments
                                                                .toList()[index]
                                                                .id
                                                            as LecturerTimeTypeModel)
                                                        .if_booked ==
                                                    0
                                                ? Container(
                                                    width: 24,
                                                    height: 24,
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          handleEditTime(detail
                                                              .appointments
                                                              .toList()[index]),
                                                      child: Center(
                                                        child: IconFont(
                                                          IconNames.bianji,
                                                          size: 20,
                                                          color: '#fff',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              margin: const EdgeInsets.only(
                                                  left: 12),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () =>
                                                    handleShowDeleteDialog(
                                                        detail.appointments
                                                            .toList()[index]),
                                                child: Center(
                                                  child: IconFont(
                                                    IconNames.shanchu,
                                                    size: 20,
                                                    color: '#fff',
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            }),
                          )
                        : Column(
                            children: List.generate(detail.appointments.length,
                                (index) {
                              return Container(
                                height: 72,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: detail.appointments
                                        .toList()[index]
                                        .color,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      detail.appointments
                                          .toList()[index]
                                          .subject,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        ((detail.appointments.toList()[index].id
                                                        as LecturerTimeTypeModel)
                                                    .if_booked ==
                                                0
                                            ? Container(
                                                width: 20,
                                                height: 20,
                                                margin: const EdgeInsets.only(
                                                    right: 6),
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () => handleEditTime(
                                                      detail.appointments
                                                          .toList()[index]),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.bianji,
                                                      size: 20,
                                                      color: '#fff',
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => handleShowDeleteDialog(
                                                detail.appointments
                                                    .toList()[index]),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.shanchu,
                                                size: 20,
                                                color: '#fff',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                          );
                  },
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                      showAgenda: true,
                      agendaViewHeight: -1,
                      appointmentDisplayCount: 99,
                      agendaStyle: AgendaStyle(
                          appointmentTextStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      agendaItemHeight: 72),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    timelineAppointmentHeight: 74,
                    timeIntervalHeight: 72,
                    startHour: 0,
                    endHour: 24,
                    nonWorkingDays: <int>[],
                    timeFormat: 'HH:mm',
                  ),
                  timeZone: 'Asia/Shanghai',
                ),
              ),
            )
          ],
        ),
        Positioned(
          bottom: mediaQuerySafeInfo.bottom + 12,
          right: 120,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: InkWell(
              onTap: changeType,
              child: Center(
                child: IconFont(
                  IconNames.qiehuan,
                  size: 16,
                  color: '#fff',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: mediaQuerySafeInfo.bottom + 12,
          right: 72,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: InkWell(
              onTap: handleReloadInfo,
              child: Center(
                child: IconFont(
                  IconNames.shuaxin,
                  size: 16,
                  color: '#fff',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: mediaQuerySafeInfo.bottom + 12,
          right: 12,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: InkWell(
              onTap: handleAddTime,
              child: Center(
                child: IconFont(
                  IconNames.tianjia,
                  size: 24,
                  color: '#fff',
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
