import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
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

class MineBalancePage extends StatefulWidget {
  const MineBalancePage({super.key});

  @override
  State<MineBalancePage> createState() => _MineBalancePageState();
}

class _MineBalancePageState extends State<MineBalancePage>
    with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

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
    Get.back();
  }

  Future<String?> checkUserId() async {
    Completer<String?> completer = Completer();
    if (userController.userInfo.id.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId != null) {
        setState(() {
          userIdLocal = userId;
        });
        completer.complete(userId);
      } else {
        completer.completeError('error');
      }
    } else {
      completer.complete(userController.userInfo.id);
    }
    return completer.future;
  }

  Future<String?> loadInfos() async {
    Completer<String?> completer = Completer();
    if (userController.token.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Future.wait([userClientProvider.getInfoByJWTAction()]).then((valuesIn) {
          if (valuesIn[0].code == 200 && valuesIn[0].data != null) {
            userController.setInfo(valuesIn[0].data!);
            completer.complete('success');
          } else {
            completer.completeError('error');
          }
        }).catchError((e) {
          completer.completeError(e);
        });
      });
    } else {
      completer.complete('first-load-not-need-refresh');
    }

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

  List<String> payList = [
    '100',
    '300',
    '500',
    '1000',
    '3000',
    '5000',
    '10000',
    '30000'
  ];

  int paySelectIndex = 3;

  void handleChangePaySelectIndex(int index) {
    setState(() {
      paySelectIndex = index;
    });
  }

  bool checkWeixin = true;
  bool checkZhifubao = false;

  AddressInfoTypeModel? selectAddressInfo;

  void handleCheckWeixin(bool? newValue) {
    setState(() {
      checkWeixin = true;
      checkZhifubao = false;
    });
  }

  void handleCheckZhifubao(bool? newValue) {
    setState(() {
      checkWeixin = false;
      checkZhifubao = true;
    });
  }

  void handleConfirmPay() {
    showLoading(checkWeixin
        ? '模拟调取微信支付...'
        : checkZhifubao
            ? '模拟调取支付宝支付...'
            : '其他方式支付中...');
    Future.delayed(const Duration(milliseconds: 2000), () {
      hideLoading();
      showLoading('请稍后...');
      userClientProvider
          .addBalanceByUserIdAction(
              payList[paySelectIndex], checkWeixin ? 1 : 2)
          .then((result) {
        if (result.code == 200) {
          userClientProvider.getInfoByJWTAction().then((resultIn) {
            if (resultIn.code == 200 && resultIn.data != null) {
              userController.setInfo(resultIn.data!);
              hideLoading();
              Get.toNamed('/store_course_order_result', arguments: {
                'result': 'success',
                'orderNo': result.data!.order_no,
                'paymentType': checkWeixin ? 'weixin' : 'zhifubao',
                'total': result.data!.payment_num
              })!
                  .then((value) {
                scrollToTop();
              });
            } else {
              hideLoading();
              showToast(result.message);
            }
          }).catchError((e) {
            hideLoading();
            showToast('请求失败, 请稍后再试');
          });
        } else {
          hideLoading();
          showToast(result.message);
        }
      }).catchError((e) {
        hideLoading();
        showToast('请求失败, 请稍后再试');
      });
    });
  }

  void handleGotoBalanceDetail() {
    Get.toNamed('mine_balance_detail');
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

  void _onRefresh() async {
    // monitor network fetch
    Future.wait([loadInfos()]);
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
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

    final double itemWidthOrHeight =
        (mediaQuerySizeInfo.width - 24 - 12 * 3) / 4;

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
              const Text('余额管理',
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
                  child:
                      CustomScrollView(controller: _scrollController, slivers: [
                    SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
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
                                          Radius.circular(12))),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '账户余额',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        GetBuilder<UserController>(
                                            builder: (controller) => RichText(
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '¥',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    const WidgetSpan(
                                                        child: SizedBox(
                                                      width: 6,
                                                    )),
                                                    TextSpan(
                                                      text: controller
                                                              .info
                                                              .balance
                                                              .isNotEmpty
                                                          ? formatNumberToThousandsSeparator(
                                                              double.parse(
                                                                  controller
                                                                      .info
                                                                      .balance))
                                                          : '0',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ))),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: handleGotoBalanceDetail,
                                      child: Row(
                                        children: [
                                          const Text(
                                            '明细',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            width: 16,
                                            height: 16,
                                            margin:
                                                const EdgeInsets.only(left: 6),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.qianjin,
                                                size: 16,
                                                color: 'rgb(255, 255, 255)',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    bottom: 12,
                                    left: 12,
                                    child: SizedBox(
                                      width: mediaQuerySizeInfo.width - 24 - 24,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            margin:
                                                const EdgeInsets.only(right: 6),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.tanhao,
                                                size: 16,
                                                color: 'rgb(255, 255, 255)',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: RichText(
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '账户余额只可在本软件中用于线上购买课程、器材等消费, 暂不支持提现或变现。',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              '选择充值金额',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                        ])),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    // 交叉轴子项数量
                                    mainAxisSpacing: 12, // 主轴间距
                                    crossAxisSpacing: 12, // 交叉轴间距
                                    childAspectRatio: 1,
                                    mainAxisExtent: itemWidthOrHeight,
                                    maxCrossAxisExtent: itemWidthOrHeight),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero, // 设置为零边距
                            shrinkWrap: true,
                            itemCount: payList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => handleChangePaySelectIndex(index),
                                child: Container(
                                  width: itemWidthOrHeight,
                                  height: itemWidthOrHeight,
                                  decoration: BoxDecoration(
                                      color: paySelectIndex == index
                                          ? const Color.fromRGBO(0, 0, 0, 1)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          color: paySelectIndex == index
                                              ? const Color.fromRGBO(0, 0, 0, 1)
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                          width: 1)),
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '¥',
                                            style: TextStyle(
                                                color: paySelectIndex == index
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                            height: 2,
                                          ),
                                          Text(
                                            formatNumberToThousandsSeparator(
                                                double.parse(payList[index])),
                                            style: TextStyle(
                                                color: paySelectIndex == index
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 18),
                        child: RichText(
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '已选择充值金额',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                const WidgetSpan(
                                    child: SizedBox(
                                  width: 6,
                                )),
                                const TextSpan(
                                  text: '¥',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                const WidgetSpan(
                                    child: SizedBox(
                                  width: 6,
                                )),
                                TextSpan(
                                  text: formatNumberToThousandsSeparator(
                                      double.parse(payList[paySelectIndex])),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              '选择支付方式',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        handleCheckWeixin(!checkWeixin),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    12), // 设置顶部边缘为直角
                                              ),
                                            ),
                                            side: const BorderSide(
                                                color: Colors.black),
                                            fillColor: checkWeixin
                                                ? MaterialStateProperty.all(
                                                    Colors.black)
                                                : MaterialStateProperty.all(
                                                    Colors.transparent),
                                            checkColor: Colors.white,
                                            value: checkWeixin,
                                            onChanged: handleCheckWeixin,
                                          ),
                                        ),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.zhifu_weixin,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          '微信支付',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        handleCheckZhifubao(!checkZhifubao),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    12), // 设置顶部边缘为直角
                                              ),
                                            ),
                                            side: const BorderSide(
                                                color: Colors.black),
                                            fillColor: checkZhifubao
                                                ? MaterialStateProperty.all(
                                                    Colors.black)
                                                : MaterialStateProperty.all(
                                                    Colors.transparent),
                                            checkColor: Colors.white,
                                            value: checkZhifubao,
                                            onChanged: handleCheckZhifubao,
                                          ),
                                        ),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: Center(
                                            child: IconFont(
                                              IconNames.zhifu_zhifubao,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          '支付宝支付',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: InkWell(
                              onTap: handleConfirmPay,
                              child: Container(
                                height: 44,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: const Center(
                                  child: Text(
                                    '确认支付',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 12 + mediaQuerySafeInfo.bottom,
                      ),
                    )
                  ]))))
    ]));
  }
}
