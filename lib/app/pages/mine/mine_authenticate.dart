import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:shimmer/shimmer.dart';
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
import './mine_authenticate_publish.dart';

class MineAuthenticatePage extends StatefulWidget {
  const MineAuthenticatePage({super.key});

  @override
  State<MineAuthenticatePage> createState() => _MineAuthenticatePageState();
}

class _MineAuthenticatePageState extends State<MineAuthenticatePage>
    with TickerProviderStateMixin {
  final UserController userController = Get.put(UserController());
  final GlobalController globalController = Get.put(GlobalController());
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

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
      setState(() {
        _readyLoad = true;
      });
    }).catchError((e) {
      completer.completeError(e);
      setState(() {
        _readyLoad = true;
      });
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

  bool _readyLoad = false;

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

  void handleStartAuth() {
    Get.toNamed('/mine_authenticate_publish')!.then((value) {
      if (value == 'success') {
        _readyLoad = false;
        authenticateInfo = AuthenticateTypeModel.fromJson(null);
        _onRefresh();
      }
    });
  }

  void handleReAuth() {
    Get.toNamed('/mine_authenticate_publish',
            arguments: {'authId': authenticateInfo.id})!
        .then((value) {
      if (value == 'success') {
        _readyLoad = false;
        authenticateInfo = AuthenticateTypeModel.fromJson(null);
        _onRefresh();
      }
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
              const Text('专业认证管理',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              // GestureDetector(
              //   onTap: handleStartAuth,
              //   child: Container(
              //     width: 80,
              //     height: 24,
              //     color: Colors.white,
              //     child: const Align(
              //       alignment: Alignment.centerRight,
              //       child: Text(
              //         '发起认证',
              //         style: TextStyle(
              //             color: Color.fromRGBO(211, 66, 67, 1),
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // )
              (authenticateInfo.id.isEmpty && _readyLoad)
                  ? GestureDetector(
                      onTap: handleStartAuth,
                      child: Container(
                        width: 80,
                        height: 24,
                        color: Colors.white,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '发起认证',
                            style: TextStyle(
                                color: Color.fromRGBO(211, 66, 67, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : authenticateInfo.status == 1
                      ? GestureDetector(
                          onTap: handleReAuth,
                          child: Container(
                            width: 80,
                            height: 24,
                            color: Colors.white,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '重新认证',
                                style: TextStyle(
                                    color: Color.fromRGBO(211, 66, 67, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 24,
                          color: Colors.white,
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
      Expanded(
          child: _readyLoad
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
                              child: authenticateInfo.id.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (authenticateInfo.status == 3
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: const EdgeInsets
                                                            .only(right: 12),
                                                        child: Center(
                                                          child: IconFont(
                                                            IconNames
                                                                .renzhenglishi,
                                                            size: 24,
                                                            color: '#000',
                                                          ),
                                                        ),
                                                      ),
                                                      const Text('您已认证为专业医师',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  )
                                                : const SizedBox.shrink()),
                                            (authenticateInfo.status == 3
                                                ? const SizedBox(
                                                    height: 12,
                                                  )
                                                : const SizedBox.shrink()),
                                            RichText(
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '提交时间:',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    const WidgetSpan(
                                                        child: SizedBox(
                                                      width: 6,
                                                    )),
                                                    TextSpan(
                                                      text: authenticateInfo
                                                          .created_at,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                )),
                                            (authenticateInfo.status == 3
                                                ? const SizedBox(
                                                    height: 12,
                                                  )
                                                : const SizedBox.shrink()),
                                            (authenticateInfo.status == 3
                                                ? RichText(
                                                    maxLines: 2,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: '有效期:',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                          text: authenticateInfo
                                                                      .validity_time ==
                                                                  null
                                                              ? ''
                                                              : (DateTime.parse(authenticateInfo
                                                                              .validity_time!)
                                                                          .difference(DateTime
                                                                              .now())
                                                                          .inDays >=
                                                                      365 * 5
                                                                  ? '长期有效'
                                                                  : authenticateInfo
                                                                      .validity_time!),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ))
                                                : const SizedBox.shrink()),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            RichText(
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '状态:',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    const WidgetSpan(
                                                        child: SizedBox(
                                                      width: 6,
                                                    )),
                                                    TextSpan(
                                                      text: authenticateInfo
                                                                  .status ==
                                                              3
                                                          ? '正常'
                                                          : authenticateInfo
                                                                      .status ==
                                                                  2
                                                              ? '待审核'
                                                              : authenticateInfo
                                                                          .status ==
                                                                      1
                                                                  ? '驳回'
                                                                  : '失效',
                                                      style: TextStyle(
                                                          color: authenticateInfo
                                                                      .status ==
                                                                  3
                                                              ? const Color
                                                                  .fromRGBO(
                                                                  49, 163, 78, 1)
                                                              : authenticateInfo
                                                                          .status ==
                                                                      2
                                                                  ? Colors.black
                                                                  : authenticateInfo
                                                                              .status ==
                                                                          1
                                                                      ? const Color
                                                                          .fromRGBO(
                                                                          234,
                                                                          71,
                                                                          56,
                                                                          1)
                                                                      : const Color
                                                                          .fromRGBO(
                                                                          234,
                                                                          71,
                                                                          56,
                                                                          1),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )),
                                            (authenticateInfo.status == 1
                                                ? const SizedBox(
                                                    height: 12,
                                                  )
                                                : const SizedBox.shrink()),
                                            (authenticateInfo.status == 1
                                                ? RichText(
                                                    maxLines: 2,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: '审核反馈结果:',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                          text: authenticateInfo
                                                                  .audit_info ??
                                                              '',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ))
                                                : const SizedBox.shrink()),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
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
                                              '您还没有发起认证',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      224, 222, 223, 1),
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          ])))
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: skeleton(),
                ))
    ]));
  }
}
