import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../iconfont/icon_font.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/data_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../controllers/notification_controller.dart';
import '../../providers/api/notification_client_provider.dart';
import '../../models/notification_model.dart';

class NotificationSayPage extends StatefulWidget {
  const NotificationSayPage({super.key});

  @override
  State<NotificationSayPage> createState() => _NotificationSayPageState();
}

class _NotificationSayPageState extends State<NotificationSayPage>
    with TickerProviderStateMixin {
  // 创建一个滚动控制器
  final GlobalController globalController = Get.put(GlobalController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final NotificationClientProvider notificationClientProvider =
      Get.put(NotificationClientProvider());
  final UserController userController = Get.put(UserController());
  final StoreController storeController = Get.put(StoreController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  late final bool ifCanSelect;

  late final String? selectId;

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  /* 数据信息 */
  bool _readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<PainNotificationTypeModel>>
      painNotificationDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  List<bool> addressCheckList = [];

  void handleGoBack() {
    Get.back();
  }

  Future<String> getPainNotifications({int? page}) {
    Completer<String> completer = Completer();
    notificationClientProvider
        .findManyPainNotifications(
            userId: userController.userInfo.id,
            notificationType: 'say',
            pageNo: page ?? _currentPageNo + 1)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          painNotificationDataPagination.data = valueGet;
        } else {
          painNotificationDataPagination.data.addAll(valueGet);
        }
        painNotificationDataPagination.pageNo = pageNo;
        painNotificationDataPagination.pageSize = pageSize;
        painNotificationDataPagination.totalPage = totalPage;
        painNotificationDataPagination.totalCount = totalCount;
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
      if (_scrollDistance < 0) {
        _rotationAngle = _scrollDistance > -_headerTriggerDistance
            ? (0 - _scrollDistance) / _headerTriggerDistance * 360
            : 360;
      } else {
        _rotationAngle = 0;
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getPainNotifications(page: 1);
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
      result = await getPainNotifications();
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

  void handleGotoPainQestionDetail(PainNotificationTypeModel item) {
    Get.toNamed('/pain_question_detail', arguments: {
      'questionId': item.question_id,
      'painNotificationId': item.id
    })!
        .then((value) {
      notificationClientProvider
          .findOnePainNotificationByIdAction(item.id)
          .then((result) {
        if (result.code == 200 && result.data != null) {
          final findIndex = painNotificationDataPagination.data
              .indexWhere((element) => element.id == item.id);
          setState(() {
            painNotificationDataPagination.data[findIndex] = result.data!;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments['ifCanSelect'] != null) {
      ifCanSelect = Get.arguments['ifCanSelect'];
    } else {
      ifCanSelect = false;
    }

    if (Get.arguments != null && Get.arguments['selectId'] != null) {
      selectId = Get.arguments['selectId'];
    } else {
      selectId = null;
    }

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
    _scrollController.dispose();
    _refreshController.dispose();
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
      return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
              children: List.generate(
                  16,
                  (index) => Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 80,
                            width: mediaQuerySizeInfo.width,
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(229, 229, 229, 1),
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: mediaQuerySizeInfo.width - 24,
                                height: 80,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))));
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
                width: 36,
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
              const Text('答复/评论',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 36,
                height: 24,
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
          child: RefreshConfiguration(
        headerTriggerDistance: 60.0,
        enableScrollWhenRefreshCompleted:
            true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        child: SmartRefresher(
            controller: _refreshController,
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
                if (painNotificationDataPagination.data.isEmpty) {
                  body = null;
                } else if (mode == LoadStatus.idle) {
                  body = const Text(
                    "上拉加载",
                    style: TextStyle(
                        color: Color.fromRGBO(73, 69, 79, 1), fontSize: 14),
                  );
                } else if (mode == LoadStatus.loading) {
                  body = const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Color.fromRGBO(33, 33, 33, 1), strokeWidth: 2),
                    ),
                  );
                } else if (mode == LoadStatus.failed) {
                  body = const Text("加载失败，请重试",
                      style: TextStyle(
                          color: Color.fromRGBO(73, 69, 79, 1), fontSize: 14));
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("继续加载更多",
                      style: TextStyle(
                          color: Color.fromRGBO(73, 69, 79, 1), fontSize: 14));
                } else {
                  body = const Text("没有更多内容了~",
                      style: TextStyle(
                          color: Color.fromRGBO(73, 69, 79, 1), fontSize: 14));
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Center(child: body),
                );
              },
            ),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: CustomScrollView(controller: _scrollController, slivers: [
              SliverToBoxAdapter(
                child:
                    (painNotificationDataPagination.data.isEmpty && _readyLoad)
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
                                    '没有消息~',
                                    style: TextStyle(
                                        color: Color.fromRGBO(224, 222, 223, 1),
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
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: painNotificationDataPagination.data.length,
                      (context, index) {
                final PainNotificationTypeModel item =
                    painNotificationDataPagination.data[index];
                // 获取当前时间
                DateTime nowTime = DateTime.now();
                // 格式化日期
                String formattedDate = DateFormat('yyyy-MM-dd').format(nowTime);
                String formattedYearDate = DateFormat('yyyy').format(nowTime);
                // 获取发布时间
                DateTime publishTime = DateTime.parse(item.publish_time);
                // 格式化日期
                String formattedDatePublish =
                    DateFormat('yyyy-MM-dd').format(publishTime);
                String formattedYearDatePublish =
                    DateFormat('yyyy').format(publishTime);
                final String showPublishTime;
                if (formattedDate == formattedDatePublish) {
                  String formattedMinutesDatePublish =
                      DateFormat('HH:mm').format(publishTime);
                  showPublishTime = '$formattedMinutesDatePublish 今天';
                } else if (formattedYearDate == formattedYearDatePublish) {
                  String formattedMonthsAndMinutesDatePublish =
                      DateFormat('HH:mm MM/dd').format(publishTime);
                  showPublishTime = formattedMonthsAndMinutesDatePublish;
                } else {
                  String formattedYearsAndMonthsAndMinutesDatePublish =
                      DateFormat('HH:mm yy/MM/dd').format(publishTime);
                  showPublishTime =
                      formattedYearsAndMonthsAndMinutesDatePublish;
                }

                List<String> imagesList = [];
                if (item.notification_type == 0 &&
                    item.question_info != null &&
                    item.question_info!.image_data != null &&
                    item.question_info!.image_data!.isNotEmpty) {
                  imagesList = item.question_info!.image_data!
                      .split(',')
                      .toSet()
                      .toList();
                } else if (item.notification_type == 1 &&
                    item.reply_info != null &&
                    item.reply_info!.image_data != null) {
                  imagesList =
                      item.reply_info!.image_data!.split(',').toSet().toList();
                } else if (item.notification_type == 11 &&
                    item.comment_info != null &&
                    item.comment_info!.image_data != null) {
                  imagesList = item.comment_info!.image_data!
                      .split(',')
                      .toSet()
                      .toList();
                }

                String content = '';
                if (item.notification_type == 0 && item.question_info != null) {
                  content = item.question_info!.description;
                } else if (item.notification_type == 1 &&
                    item.question_info != null &&
                    item.reply_info != null) {
                  content = item.reply_info!.reply_content;
                } else if (item.notification_type == 11 &&
                    item.question_info != null &&
                    item.comment_to_info != null) {
                  content = item.comment_to_info!.comment_content;
                }

                String sayContent = '';
                if (item.notification_type == 0 && item.reply_info != null) {
                  sayContent = item.reply_info!.reply_content;
                } else if (item.notification_type == 1 &&
                    item.comment_info != null) {
                  sayContent = item.comment_info!.comment_content;
                } else if (item.notification_type == 11 &&
                    item.comment_info != null) {
                  sayContent = item.comment_info!.comment_content;
                }

                return Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => handleGotoPainQestionDetail(item),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: item.from_user_info!.avatar == null
                                          ? const CircleAvatar(
                                              radius: 22,
                                              backgroundImage: AssetImage(
                                                  'assets/images/avatar.webp'),
                                            )
                                          : CircleAvatar(
                                              radius: 22,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      '${globalController.cdnBaseUrl}/${item.from_user_info!.avatar}'))),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.from_user_info!.name ??
                                                    '赴康云用户',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1)),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${item.notification_type == 0 ? '答复了您的问题' : item.notification_type == 1 ? '评论了您的答复' : '回复了您的评论'} $showPublishTime',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromRGBO(
                                                        102, 102, 102, 1)),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: sayContent,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          )),
                                          Container(
                                            width: 64,
                                            constraints: const BoxConstraints(
                                              minHeight: 48, // 设置最小宽度为100
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  246, 246, 246, 1),
                                            ),
                                            child: imagesList.isNotEmpty
                                                ? SizedBox(
                                                    width: 64 - 12,
                                                    height: 48 - 12,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${globalController.cdnBaseUrl}/${imagesList[0]}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : RichText(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: content,
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      102,
                                                                      102,
                                                                      102,
                                                                      1),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    )),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      index !=
                                              painNotificationDataPagination
                                                      .data.length -
                                                  1
                                          ? const Divider(
                                              height: 2,
                                              color: Color.fromRGBO(
                                                  233, 234, 235, 1),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                          item.read != 1
                              ? Positioned(
                                  left: 42,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        color: Color.fromRGBO(230, 94, 90, 1)),
                                  ))
                              : const SizedBox.shrink()
                        ],
                      )
                    ],
                  ),
                );
              }))
            ])),
      ))
    ]));
  }
}
