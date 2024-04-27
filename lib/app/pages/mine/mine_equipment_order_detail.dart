import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/store_model.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:shimmer/shimmer.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../components/long_press_menu.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './menus/mine_record_menu.dart';
import './menus/mine_live_course_order_menu.dart';
import './menus/mine_video_course_order_menu.dart';
import './menus/mine_equipment_order_menu.dart';
import './menus/mine_manage_menu.dart';
import './menus/mine_doctor_menu.dart';
import './menus/mine_professional_tool_menu.dart';
import './menus/mine_help_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class DialogText extends ValueNotifier<String> {
  DialogText(super.value);

  void update(String newValue) {
    value = newValue;
    notifyListeners();
  }
}

class MineEquipmentOrderDetailPage extends StatefulWidget {
  const MineEquipmentOrderDetailPage({super.key});

  @override
  State<MineEquipmentOrderDetailPage> createState() =>
      _MineEquipmentOrderDetailPageState();
}

class _MineEquipmentOrderDetailPageState
    extends State<MineEquipmentOrderDetailPage> with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());

  //是否修改了订单
  bool ifConfirmReceive = false;

  //详细信息
  StoreEquipmentOrderTypeModel storeEquipmentOrderDetail =
      StoreEquipmentOrderTypeModel.fromJson(null);

  late String dataId;

  String? userIdLocal;

  late AnimationController _rotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  double _scrollDistance = 0;

  void handleGoBack() {
    Get.back(result: ifConfirmReceive ? 'success' : '');
  }

  Future<String?> loadInfo() async {
    Completer<String?> completer = Completer();
    storeClientProvider
        .findEquipmentOrderByOrderNoAction(dataId)
        .then((result) {
      if (result.code == 200 && result.data != null) {
        print('success');
        final StoreEquipmentOrderTypeModel storeEquipmentOrderDetailGet =
            result.data!;
        setState(() {
          storeEquipmentOrderDetail = storeEquipmentOrderDetailGet;
        });
        completer.complete('success');
      } else {
        print('error');
        completer.completeError('error');
      }
    }).catchError((e) {
      print('e $e');
      completer.completeError(e);
    });

    return completer.future;
  }

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

  String formatNumberToThousandsSeparator(double number) {
    NumberFormat formatter = NumberFormat("#,###.##");
    return formatter.format(number);
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // 滚动位置为顶部
      duration: const Duration(milliseconds: 300), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  void handleGotoEquipmentDetail(String equipmentId) {
    Get.toNamed('store_equipment_detail',
        arguments: {'equipmentId': equipmentId});
  }

  void handleRebuy() {
    showLoading('请稍后...');
    storeClientProvider
        .getEquipmentsWithModelsAction(storeEquipmentOrderDetail.equipment_ids)
        .then((result) {
      if (result.data == null || result.data!.isEmpty) {
        hideLoading();
        showToast('所有器材均已下架，无法再次购买');
      } else {
        bool ifHasChange = false;

        //详情中的器材列表
        final List<StoreEquipmentTypeModel> equipmentsOrigin =
            storeEquipmentOrderDetail.equipment!;
        //详情中的型号Id集合列表
        final List<String> modelIdsOrigin =
            storeEquipmentOrderDetail.model_ids.split(',');
        //接口获取新的集合列表
        final List<StoreEquipmentTypeModel> equipmentsGet = result.data!;
        //接口获取新的型号展开列表
        final List<StoreEquipmentInModelTypeModel> allModelsGet = [];
        List.generate(equipmentsGet.length, (index) {
          List.generate(equipmentsGet[index].models!.length, (indexIn) {
            allModelsGet.add(equipmentsGet[index].models![indexIn]);
          });
        });
        //详情中的添加数量列表
        final List<int> addNumsList = storeEquipmentOrderDetail.order_nums
            .split(',')
            .map((e) => int.parse(e))
            .toList();
        //最终的器材列表
        List<StoreEquipmentTypeModel> equipmentsFinalList = [];
        //最终的器材id列表
        List<String> equipmentIds = [];
        //最终的型号id列表
        List<String> modelIds = [];
        //最终的添加数量id列表
        List<int> addNums = [];
        //最终的user_id列表
        List<String> userIds = [];
        List.generate(equipmentsOrigin.length, (index) {
          final StoreEquipmentTypeModel? findEquipment =
              equipmentsGet.firstWhereOrNull(
                  (element) => element.id == equipmentsOrigin[index].id);
          //如果器材不存在，表示可能已经下架或删除
          if (findEquipment == null) {
            ifHasChange = true;
          } else {
            List.generate(equipmentsOrigin[index].models!.length, (indexIn) {
              //找到的接口获取的型号信息
              final StoreEquipmentInModelTypeModel? findModel =
                  allModelsGet.firstWhereOrNull((element) =>
                      element.id ==
                      equipmentsOrigin[index].models![indexIn].id);
              //如果型号不存在，表示可能已经下架或删除
              if (findModel == null) {
                ifHasChange = true;
              }
              //如果型号已经没有库存，无法购买
              else if (findModel.inventory == 0) {
                ifHasChange = true;
              }
              //型号存在且库存大于0，需要进行判断是否库存数满足购买数量，并进行标记提醒
              else {
                equipmentsFinalList.add(findEquipment);
                equipmentIds.add(equipmentsOrigin[index].id);
                modelIds.add(equipmentsOrigin[index].models![indexIn].id);
                userIds.add(userController.userInfo.id);
                final int modelIndex = modelIdsOrigin
                    .indexWhere((modelId) => modelId == findModel.id);
                if (addNumsList[modelIndex] <= findModel.inventory) {
                  addNums.add(addNumsList[modelIndex]);
                } else {
                  addNums.add(findModel.inventory);
                }
              }
            });
          }
        });

        hideLoading();
        if (equipmentsFinalList.isEmpty) {
          showToast('所有器材均已下架，无法再次购买');
        } else {
          if (ifHasChange) {
            showToast('有器材型号发生变化，请核对');
          }
          Get.toNamed('store_equipment_order', arguments: {
            'models': modelIds,
            'addNums': addNums,
            'userIds': userIds,
            'equipments': equipmentsFinalList
          })!
              .then((value) {
            if (value == 'success') {
              Get.back(result: 'rebuy');
            }
          });
        }
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

  void handleShowReceiveDialog() {
    if (storeEquipmentOrderDetail.courier_info!.status != 3) {
      startTimer();
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
                (storeEquipmentOrderDetail.courier_info!.status != 3
                    ? const Text(
                        '注意: 物流信息显示快件还未签收。',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 31, 47, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    : const SizedBox.shrink()),
                (storeEquipmentOrderDetail.courier_info!.status != 3
                    ? const SizedBox(
                        height: 12,
                      )
                    : const SizedBox.shrink()),
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
                          '确定要收货吗？',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '请确保您已收到货无误。',
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
                              // 点击确认按钮时执行的操作
                              Navigator.of(context).pop();
                              // 在这里执行你的操作
                              handleConfirmReceive();
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
                              handleConfirmReceive();
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

  void handleConfirmReceive() {
    showLoading('请稍后...');
    storeClientProvider
        .receiveOrderShipmentAction(storeEquipmentOrderDetail.order_no)
        .then((result) {
      if (result.code == 200) {
        loadInfo().then((resultIn) {
          setState(() {
            ifConfirmReceive = true;
          });
          hideLoading();
          showToast('已确认收货');
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
    dataId = Get.arguments['equipmentOrderNo'];
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

  void _onRefresh() async {
    // monitor network fetch
    String? result;
    try {
      result = await loadInfo();
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

  void handleCopyCourierNumber() {
    // 复制文本到剪贴板
    Clipboard.setData(
        ClipboardData(text: storeEquipmentOrderDetail.courier_number!));
    // 显示通知
    showToast('已复制');
  }

  //支付方式 0 余额支付 1 微信支付 2 支付宝支付 3 Apple支付/其他
  static final List<String> paymentTypeList = [
    '余额支付',
    '微信支付',
    '支付宝支付',
    '其他方式支付'
  ];

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  static final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];

  //订单状态 6 已退货 5 退货中 4 已收货 3 已发货 2 待发货 1 待支付 0 取消/关闭
  static final List<String> equipmentOrderStatusList = [
    '取消/关闭',
    '待支付',
    '待发货',
    '已发货',
    '已收货',
    '退货中',
    '已退货'
  ];

  static final List<String> equipmentOrderCourierInfoStatusList = [
    "揽件",
    "在途中",
    "正在派件",
    "已签收",
    "派送失败",
    "疑难件",
    "退件签收"
  ];

  bool ifShowMoreInfo = false;

  void handleChangeIfShowMoreInfo() {
    setState(() {
      ifShowMoreInfo = !ifShowMoreInfo;
    });
  }

  void handleHelp() {
    showToast('该商品暂不支持售后');
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel(); // 取消定时器
    }
    _rotateController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                  height: 16,
                  width: 120,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 16,
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 120,
                  width: mediaQuerySizeInfo.width - 24,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(229, 229, 229, 1),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
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
        body: Column(children: [
      Container(
        color: Colors.white,
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
              const Text('订单详情',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 24, height: 24)
            ],
          ),
        ),
      ),
      const Divider(
        height: 2,
        color: Color.fromRGBO(233, 234, 235, 1),
      ),
      Expanded(
          child: storeEquipmentOrderDetail.id.isNotEmpty
              ? RefreshConfiguration(
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
                              child:
                                  storeEquipmentOrderDetail.status == 3 ||
                                          storeEquipmentOrderDetail.status == 4
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              const Text(
                                                '物流信息',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: storeEquipmentOrderDetail
                                                                .courier_info !=
                                                            null &&
                                                        storeEquipmentOrderDetail
                                                            .courier_info!
                                                            .courier_content
                                                            .list
                                                            .isNotEmpty
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                  width: 32,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    width: 32,
                                                                    imageUrl: storeEquipmentOrderDetail
                                                                        .courier_info!
                                                                        .courier_content
                                                                        .logo,
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  )),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Text(
                                                                storeEquipmentOrderDetail
                                                                    .courier_info!
                                                                    .courier_content
                                                                    .expName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Text(
                                                                storeEquipmentOrderDetail
                                                                    .courier_number!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                width: 24,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    handleCopyCourierNumber,
                                                                child: SizedBox(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child: Center(
                                                                    child:
                                                                        IconFont(
                                                                      IconNames
                                                                          .fuzhi,
                                                                      size: 20,
                                                                      color:
                                                                          'rgb(0,0,0)',
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Text(
                                                              '状态: ${equipmentOrderCourierInfoStatusList[storeEquipmentOrderDetail.courier_info!.status]}',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                List.generate(
                                                                    ifShowMoreInfo
                                                                        ? storeEquipmentOrderDetail
                                                                            .courier_info!
                                                                            .courier_content
                                                                            .list
                                                                            .length
                                                                        : 1,
                                                                    (index) =>
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: 14,
                                                                              height: 14,
                                                                              margin: const EdgeInsets.only(right: 12, top: 4),
                                                                              decoration: BoxDecoration(color: index == 0 ? const Color.fromRGBO(211, 66, 67, 1) : const Color.fromRGBO(136, 136, 136, 1), borderRadius: const BorderRadius.all(Radius.circular(7))),
                                                                            ),
                                                                            Expanded(
                                                                                child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                RichText(
                                                                                    textAlign: TextAlign.left,
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: storeEquipmentOrderDetail.courier_info!.courier_content.list[index].status,
                                                                                          style: TextStyle(color: index == 0 ? const Color.fromRGBO(0, 0, 0, 1) : const Color.fromRGBO(136, 136, 136, 1), fontSize: 14, fontWeight: FontWeight.normal),
                                                                                        )
                                                                                      ],
                                                                                    )),
                                                                                const SizedBox(
                                                                                  height: 6,
                                                                                ),
                                                                                RichText(
                                                                                    textAlign: TextAlign.left,
                                                                                    text: TextSpan(
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: storeEquipmentOrderDetail.courier_info!.courier_content.list[index].time,
                                                                                          style: const TextStyle(color: Color.fromRGBO(136, 136, 136, 1), fontSize: 13, fontWeight: FontWeight.normal),
                                                                                        )
                                                                                      ],
                                                                                    )),
                                                                                const SizedBox(
                                                                                  height: 12,
                                                                                ),
                                                                              ],
                                                                            ))
                                                                          ],
                                                                        )),
                                                          ),
                                                          storeEquipmentOrderDetail
                                                                      .courier_info!
                                                                      .courier_content
                                                                      .list
                                                                      .length >
                                                                  1
                                                              ? Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          handleChangeIfShowMoreInfo,
                                                                      child:
                                                                          Container(
                                                                        width: mediaQuerySizeInfo.width -
                                                                            24 -
                                                                            24,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              width: 20,
                                                                              height: 20,
                                                                              margin: const EdgeInsets.only(right: 12),
                                                                              child: Center(
                                                                                child: IconFont(
                                                                                  ifShowMoreInfo ? IconNames.shouqi : IconNames.xiala,
                                                                                  size: 20,
                                                                                  color: 'rgb(0,0,0)',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              ifShowMoreInfo ? '收起' : '显示全部',
                                                                              style: const TextStyle(color: Colors.black, fontSize: 14),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : const SizedBox
                                                                  .shrink()
                                                        ],
                                                      )
                                                    : Center(
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
                                                              '暂无物流信息',
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
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const Text(
                                      '配送地址信息',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        storeEquipmentOrderDetail
                                                            .shipping_address,
                                                    style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  storeEquipmentOrderDetail
                                                      .shipping_name,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                  storeEquipmentOrderDetail
                                                      .shipping_phone,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const Text(
                                      '商品清单',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Column(
                                      children: List.generate(
                                          storeEquipmentOrderDetail.equipment !=
                                                  null
                                              ? storeEquipmentOrderDetail
                                                  .equipment!.length
                                              : 0, (index) {
                                        final modelIdsList =
                                            storeEquipmentOrderDetail.model_ids
                                                .split(',');
                                        final orderPricesList =
                                            storeEquipmentOrderDetail
                                                .order_prices
                                                .split(',');
                                        final addNumsList =
                                            storeEquipmentOrderDetail.order_nums
                                                .split(',');
                                        return GestureDetector(
                                          onTap: () =>
                                              handleGotoEquipmentDetail(
                                                  storeEquipmentOrderDetail
                                                      .equipment![index].id),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: EdgeInsets.only(
                                                bottom: index !=
                                                        storeEquipmentOrderDetail
                                                                .equipment!
                                                                .length -
                                                            1
                                                    ? 12
                                                    : 0),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                              BorderRadius
                                                                  .circular(
                                                                      8), // 设置圆角
                                                          child: Image(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        width: 120,
                                                        height: 120 / 4 * 3,
                                                        imageUrl:
                                                            '${globalController.cdnBaseUrl}/${storeEquipmentOrderDetail.equipment![index].cover}',
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: storeEquipmentOrderDetail
                                                                      .equipment![
                                                                          index]
                                                                      .title,
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
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
                                                        Text(
                                                            equipmentTypeList[
                                                                storeEquipmentOrderDetail
                                                                    .equipment![
                                                                        index]
                                                                    .equipment_type],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13))
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                const Text(
                                                  '已购买型号',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      storeEquipmentOrderDetail
                                                                  .equipment![
                                                                      index]
                                                                  .models !=
                                                              null
                                                          ? storeEquipmentOrderDetail
                                                              .equipment![index]
                                                              .models!
                                                              .length
                                                          : 0,
                                                      (indexIn) => Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            64,
                                                                        height:
                                                                            64,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8), // 设置圆角
                                                                            child:
                                                                                Image(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          width:
                                                                              64,
                                                                          height:
                                                                              64,
                                                                          imageUrl:
                                                                              '${globalController.cdnBaseUrl}/${storeEquipmentOrderDetail.equipment![index].models![indexIn].multi_figure.split(',')[0]}',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            storeEquipmentOrderDetail.equipment![index].models![indexIn].title,
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontSize: 14),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            '¥ ${formatNumberToThousandsSeparator(double.parse(orderPricesList[modelIdsList.indexWhere((element) => element == storeEquipmentOrderDetail.equipment![index].models![indexIn].id)]))}',
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    'x ${addNumsList[modelIdsList.indexWhere((element) => element == storeEquipmentOrderDetail.equipment![index].models![indexIn].id)]}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  )
                                                                ],
                                                              ),
                                                              (indexIn !=
                                                                      storeEquipmentOrderDetail
                                                                          .equipment![
                                                                              index]
                                                                          .models!
                                                                          .length
                                                                  ? const SizedBox(
                                                                      height:
                                                                          12,
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink())
                                                            ],
                                                          )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const Text(
                                      '订单信息',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '订单编号:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  child: LongPressMenu(
                                                copyContent:
                                                    storeEquipmentOrderDetail
                                                        .order_no,
                                                child: RichText(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              storeEquipmentOrderDetail
                                                                  .order_no,
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        )
                                                      ],
                                                    )),
                                              ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '支付流水号:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                  child: LongPressMenu(
                                                copyContent:
                                                    storeEquipmentOrderDetail
                                                        .payment_no,
                                                child: RichText(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              storeEquipmentOrderDetail
                                                                  .payment_no,
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        )
                                                      ],
                                                    )),
                                              ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '下单时间:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  storeEquipmentOrderDetail
                                                      .order_time,
                                                  style:
                                                      const TextStyle(
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '支付时间:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  storeEquipmentOrderDetail
                                                      .payment_time,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '支付方式:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  paymentTypeList[
                                                      storeEquipmentOrderDetail
                                                          .payment_type],
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                '支付金额:',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  '¥ ${formatNumberToThousandsSeparator(double.parse(storeEquipmentOrderDetail.payment_num.isNotEmpty ? storeEquipmentOrderDetail.payment_num : '0'))}',
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 12),
                            )
                          ])))
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: skeleton(),
                )),
      (storeEquipmentOrderDetail.id.isNotEmpty
          ? Column(
              children: [
                const Divider(
                  height: 2,
                  color: Color.fromRGBO(233, 234, 235, 1),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      12, 12, 12, 12 + mediaQuerySafeInfo.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        equipmentOrderStatusList[
                            storeEquipmentOrderDetail.status],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: (storeEquipmentOrderDetail.status == 3 ||
                                    storeEquipmentOrderDetail.status == 4)
                                ? const Color.fromRGBO(211, 66, 67, 1)
                                : const Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: handleHelp,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: const Center(
                                child: Text(
                                  '售后服务',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                          (storeEquipmentOrderDetail.status == 3
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    GestureDetector(
                                      onTap: handleShowReceiveDialog,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 12, 0),
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color.fromRGBO(211, 66, 67, 1),
                                              Color.fromRGBO(211, 66, 67, 0.8),
                                              Color.fromRGBO(211, 66, 67, 0.7)
                                            ], // 渐变的起始和结束颜色
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '确认收货',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink()),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: handleRebuy,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              height: 32,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromRGBO(211, 66, 67, 1),
                                    Color.fromRGBO(211, 66, 67, 0.8),
                                    Color.fromRGBO(211, 66, 67, 0.7)
                                  ], // 渐变的起始和结束颜色
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text(
                                  '再次购买',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          : const SizedBox.shrink())
    ]));
  }
}
