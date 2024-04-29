import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../providers/api/user_client_provider.dart';
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
import './menus/mine_doctor_enter_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List bookList = [];

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

  void handleGoBack() {
    Get.back();
  }

  void handleGotoTimeManage() {
    Get.toNamed('mine_doctor_time');
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
                                          Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 48),
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
                                                    '您没有被预约的课程哦~',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            224, 222, 223, 1),
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
