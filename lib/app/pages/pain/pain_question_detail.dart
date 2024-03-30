import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../providers/api/pain_client_provider.dart';
import '../../models/pain_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // 如果已经滚动到底部，禁止底部回弹
    if (position.extentAfter == 0.0 && velocity > 0.0) {
      return super.createBallisticSimulation(position, 0.0);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}

class PainQuestionDetailPage extends StatefulWidget {
  const PainQuestionDetailPage({super.key});

  @override
  State<PainQuestionDetailPage> createState() => _PainQuestionDetailPageState();
}

class _PainQuestionDetailPageState extends State<PainQuestionDetailPage> {
  final PainClientProvider painClientProvider =
      GetInstance().find<PainClientProvider>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool _readyLoad = false;

  String dataId = '';

  PainQuestionTypeModel painQuestionDetail = PainQuestionTypeModel(
      id: '',
      user_id: '',
      avatar: null,
      name: null,
      has_major: 0,
      pain_type: '',
      description: '',
      injury_history: '',
      question_time: '',
      like_num: 0,
      like_user_ids: null,
      reply_num: 0,
      collect_num: 0,
      collect_user_ids: null,
      anonymity: 0,
      image_data: null,
      location: null,
      status: 0,
      created_at: '',
      updated_at: '');

  void handleGoBack() {
    Get.back();
  }

  void _onLoading() async {
    // monitor network fetch
  }

  void getDetailData() {
    painClientProvider.getQuestionByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final painQuestionNew = result.data!;
        setState(() {
          painQuestionDetail = painQuestionNew;
          setState(() {
            _readyLoad = true;
          });
        });
      }
    });
    ;
  }

  /* 点赞、收藏 状态 */
  bool _likeLoading = false;
  bool _collectLoading = false;

  /* 点赞方法 */
  void handleClickLike() {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final List<String> likeIdsList = painQuestionDetail.like_user_ids != null
        ? painQuestionDetail.like_user_ids!.split(',').toSet().toList()
        : [];
    updatePainQuestionLike(painQuestionDetail.id,
        likeIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionLike(String id, int status) {
    setState(() {
      _likeLoading = true;
    });
    painClientProvider.updateQuestionLikeAction(id, status).then((result) {
      if (result.code == 200) {
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDetail = painQuestionNew;
              showToast(status == 1 ? '已点赞' : '已取消点赞');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _likeLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _likeLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _likeLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _likeLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _likeLoading = false;
        });
      });
    });
  }

  /* 收藏方法 */
  void handleClickCollect() {
    if (_collectLoading || _likeLoading) {
      return;
    }
    final List<String> collectIdsList =
        painQuestionDetail.collect_user_ids != null
            ? painQuestionDetail.collect_user_ids!.split(',').toSet().toList()
            : [];
    updatePainQuestionCollect(painQuestionDetail.id,
        collectIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionCollect(String id, int status) {
    setState(() {
      _collectLoading = true;
    });
    painClientProvider.updateQuestionCollectAction(id, status).then((result) {
      if (result.code == 200) {
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDetail = painQuestionNew;
              showToast(status == 1 ? '已收藏' : '已取消收藏');
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _collectLoading = false;
                });
              });
            });
          } else {
            showToast(result1.message);
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _collectLoading = false;
              });
            });
          }
        }).catchError((e1) {
          showToast('操作失败，请稍后再试');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _collectLoading = false;
            });
          });
        });
      } else {
        showToast(result.message);
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _collectLoading = false;
          });
        });
      }
    }).catchError((e) {
      showToast('操作失败，请稍后再试');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _collectLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataId = Get.arguments['questionId'];
    getDetailData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    final String name = painQuestionDetail.anonymity == 1
        ? '匿名用户'
        : painQuestionDetail.name != null
            ? painQuestionDetail.name!
            : '赴康云用户';

    String showQuestionTime = '';

    if (_readyLoad) {
      // 获取当前时间
      DateTime nowTime = DateTime.now();
      // 格式化日期
      String formattedDate = DateFormat('yyyy-MM-dd').format(nowTime);
      String formattedYearDate = DateFormat('yyyy').format(nowTime);
      // 获取问题时间
      DateTime questionTime = DateTime.parse(painQuestionDetail.question_time);
      // 格式化日期
      String formattedDateQuestion =
          DateFormat('yyyy-MM-dd').format(questionTime);
      String formattedYearDateQuestion =
          DateFormat('yyyy').format(questionTime);
      if (formattedDate == formattedDateQuestion) {
        String formattedMinutesDateQuestion =
            DateFormat('HH:mm').format(questionTime);
        showQuestionTime = '$formattedMinutesDateQuestion 今天';
      } else if (formattedYearDate == formattedYearDateQuestion) {
        String formattedMonthsAndMinutesDateQuestion =
            DateFormat('HH:mm MM/dd').format(questionTime);
        showQuestionTime = formattedMonthsAndMinutesDateQuestion;
      } else {
        String formattedYearsAndMonthsAndMinutesDateQuestion =
            DateFormat('HH:mm yy/MM/dd').format(questionTime);
        showQuestionTime = formattedYearsAndMonthsAndMinutesDateQuestion;
      }
    }

    final String painType = painQuestionDetail.pain_type;
    final String description = painQuestionDetail.description;
    final String location = painQuestionDetail.location ?? '未知地点';
    final String injuryHistory = painQuestionDetail.injury_history;

    List<String> imagesList = [];
    if (painQuestionDetail.image_data != null) {
      imagesList = painQuestionDetail.image_data!.split(',').toSet().toList();
    }
    final List<GalleryExampleItem> galleryItems = imagesList.map((e) {
      return GalleryExampleItem(
          id: '$e-detail',
          resource: '${globalController.cdnBaseUrl}/$e',
          isSvg: false);
    }).toList();

    final double itemWidthOnly = mediaQuerySizeInfo.width - 24;

    final List<String> likeIdsList = painQuestionDetail.like_user_ids != null
        ? painQuestionDetail.like_user_ids!.split(',').toSet().toList()
        : [];
    final bool readyLike = likeIdsList.contains(userController.userInfo.id);

    final List<String> collectIdsList =
        painQuestionDetail.collect_user_ids != null
            ? painQuestionDetail.collect_user_ids!.split(',').toSet().toList()
            : [];
    final bool readyCollect =
        collectIdsList.contains(userController.userInfo.id);

    void open(BuildContext context, final int index) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GalleryPhotoViewWrapper(
            galleryItems: galleryItems,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
        ),
      );
    }

    void handleReportItem() {
      Get.back();
    }

    void handleCancelItem() {
      Get.back();
    }

    void handleShare() {
      if (!_readyLoad) {
        return;
      }
    }

    void showMoreItems() {
      if (!_readyLoad) {
        return;
      }
      showModalBottomSheet(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero, // 设置顶部边缘为直角
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 0, 24, mediaQuerySafeInfo.bottom),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: handleReportItem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.tanhao,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('举报',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleCancelItem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.guanbi,
                                    size: 20,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ) // Your form widget here
                    ));
          });
    }

    Widget skeleton() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            margin: const EdgeInsets.only(right: 12),
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(229, 229, 229, 1),
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child: Container(
                                  width: 44,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 44,
                                      height: 15,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                child: Container(
                                  width: 72,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 72,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          width: 64,
                          height: 15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 64,
                              height: 15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12, top: 12),
                        child: Container(
                          width: mediaQuerySizeInfo.width - 24,
                          height: 15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: mediaQuerySizeInfo.width - 24,
                              height: 15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          width: 64,
                          height: 15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 64,
                              height: 15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12, top: 12),
                        child: Container(
                          width: mediaQuerySizeInfo.width - 24,
                          height: 100,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: mediaQuerySizeInfo.width - 24,
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          width: 64,
                          height: 15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 64,
                              height: 15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12, top: 12),
                        child: Container(
                          width: mediaQuerySizeInfo.width - 24,
                          height: 100,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: mediaQuerySizeInfo.width - 24,
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          width: 64,
                          height: 15,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 64,
                              height: 15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    // 交叉轴子项数量
                                    mainAxisSpacing: 8, // 主轴间距
                                    crossAxisSpacing: 0, // 交叉轴间距
                                    childAspectRatio: 1,
                                    mainAxisExtent: itemWidthOnly / 4 * 3,
                                    maxCrossAxisExtent: itemWidthOnly),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero, // 设置为零边距
                            shrinkWrap: true,
                            itemCount: 9,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  margin: const EdgeInsets.only(right: 0),
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
            child: SizedBox(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: handleGoBack,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: IconFont(
                              IconNames.fanhui,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 44,
                        height: 32,
                      )
                    ],
                  ),
                  const Text('问答详情',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: handleShare,
                          child: Center(
                            child: IconFont(
                              IconNames.fenxiang,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: showMoreItems,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: IconFont(
                              IconNames.gengduo,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: Color.fromRGBO(233, 234, 235, 1),
          ),
          _readyLoad
              ? Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: RefreshConfiguration(
                          headerTriggerDistance: 60.0,
                          enableScrollWhenRefreshCompleted:
                              true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
                          child: SmartRefresher(
                              physics: const CustomScrollPhysics(), // 禁止回弹效果
                              enablePullDown: false,
                              enablePullUp: true,
                              footer: CustomFooter(
                                builder:
                                    (BuildContext context, LoadStatus? mode) {
                                  Widget? body;
                                  if (painQuestionDetail.id.isEmpty ||
                                      painQuestionDetail.reply_num == 0) {
                                    body = null;
                                  } else if (mode == LoadStatus.idle) {
                                    body = const Text(
                                      "上拉加载",
                                      style: TextStyle(
                                          color: Color.fromRGBO(33, 33, 33, 1),
                                          fontSize: 14),
                                    );
                                  } else if (mode == LoadStatus.loading) {
                                    body = const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color:
                                                Color.fromRGBO(33, 33, 33, 1),
                                            strokeWidth: 2),
                                      ),
                                    );
                                  } else if (mode == LoadStatus.failed) {
                                    body = const Text("加载失败，请重试",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(33, 33, 33, 1),
                                            fontSize: 14));
                                  } else if (mode == LoadStatus.canLoading) {
                                    body = const Text("继续加载更多",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(33, 33, 33, 1),
                                            fontSize: 14));
                                  } else {
                                    body = const Text("没有更多内容了~",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(33, 33, 33, 1),
                                            fontSize: 14));
                                  }
                                  return SizedBox(
                                    height: 40.0,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onLoading: _onLoading,
                              child: CustomScrollView(slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: (painQuestionDetail
                                                              .anonymity ==
                                                          1 ||
                                                      painQuestionDetail
                                                              .avatar ==
                                                          null)
                                                  ? const CircleAvatar(
                                                      radius: 22,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/avatar.webp'),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 22,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              '${globalController.cdnBaseUrl}/${painQuestionDetail.avatar}'),
                                                    ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 0),
                                                  child: Text(
                                                    name,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      showQuestionTime,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromRGBO(
                                                              102,
                                                              102,
                                                              102,
                                                              1)),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              6, 0, 6, 0),
                                                      child: Text(
                                                        '·',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromRGBO(
                                                                    102,
                                                                    102,
                                                                    102,
                                                                    1)),
                                                      ),
                                                    ),
                                                    Text(
                                                      location,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromRGBO(
                                                              102,
                                                              102,
                                                              102,
                                                              1)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('伤痛类型',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(painType,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        const Text('问题描述',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(description,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        const Text('诊疗史',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 12),
                                          child: Text(injuryHistory,
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ),
                                        (imagesList.isNotEmpty &&
                                                imagesList[0].isNotEmpty
                                            ? const Text('影像资料',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : const SizedBox.shrink()),
                                        Padding(
                                          padding: (imagesList.isNotEmpty &&
                                                  imagesList[0].isNotEmpty)
                                              ? const EdgeInsets.fromLTRB(
                                                  0, 12, 0, 12)
                                              : const EdgeInsets.all(0),
                                          child: (imagesList.isNotEmpty &&
                                                  imagesList[0].isNotEmpty)
                                              ? GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                          // 交叉轴子项数量
                                                          mainAxisSpacing:
                                                              8, // 主轴间距
                                                          crossAxisSpacing:
                                                              0, // 交叉轴间距
                                                          childAspectRatio: 1,
                                                          mainAxisExtent:
                                                              itemWidthOnly /
                                                                  4 *
                                                                  3,
                                                          maxCrossAxisExtent:
                                                              itemWidthOnly),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding:
                                                      EdgeInsets.zero, // 设置为零边距
                                                  shrinkWrap: true,
                                                  itemCount: imagesList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return GestureDetector(
                                                      onTap: () =>
                                                          open(context, index),
                                                      child: Hero(
                                                        tag: galleryItems[index]
                                                            .id,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                '${globalController.cdnBaseUrl}/${imagesList[index]}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : const SizedBox.shrink(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 12, 0, 24),
                                          child: Text(
                                              '全部答伤 · ${painQuestionDetail.reply_num}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        (painQuestionDetail.reply_num == 0
                                            ? SizedBox(
                                                width:
                                                    mediaQuerySizeInfo.width -
                                                        24,
                                                height: 120,
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
                                                        '暂无答伤内容',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
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
                                            : Container())
                                      ],
                                    ),
                                  ),
                                )
                              ])))),
                )
              : Expanded(
                  child: skeleton(),
                ),
          _readyLoad
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(232, 232, 232, 1),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.fromLTRB(
                          12, 18, 12, mediaQuerySafeInfo.bottom + 18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 36,
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(242, 242, 242, 1)),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '我想说...',
                                    style: TextStyle(
                                        color: Color.fromRGBO(102, 102, 102, 1),
                                        fontSize: 15),
                                  ),
                                ),
                              )),
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    margin: const EdgeInsets.only(
                                        right: 18, left: 18),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 0),
                                          child: IconFont(
                                            IconNames.xiaoxi,
                                            size: 24,
                                            color: '#000',
                                          ),
                                        ),
                                        Text(
                                          painQuestionDetail.reply_num > 99
                                              ? '99+'
                                              : '${painQuestionDetail.reply_num}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: handleClickLike,
                                    child: Container(
                                      width: 36,
                                      margin: const EdgeInsets.only(right: 18),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 0),
                                            child: IconFont(
                                              readyLike
                                                  ? IconNames.dianzan_1
                                                  : IconNames.dianzan,
                                              size: 24,
                                              color: readyLike
                                                  ? 'rgb(211,66,67)'
                                                  : '#000',
                                            ),
                                          ),
                                          Text(
                                            painQuestionDetail.like_num > 99
                                                ? '99+'
                                                : '${painQuestionDetail.like_num}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: handleClickCollect,
                                    child: Container(
                                      width: 36,
                                      margin: const EdgeInsets.only(right: 0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 0),
                                            child: IconFont(
                                              readyCollect
                                                  ? IconNames.shoucang_1
                                                  : IconNames.shoucang,
                                              size: 24,
                                              color: readyCollect
                                                  ? 'rgb(252,189,84)'
                                                  : '#000',
                                            ),
                                          ),
                                          Text(
                                            painQuestionDetail.collect_num > 99
                                                ? '99+'
                                                : '${painQuestionDetail.collect_num}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
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
                    )
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
