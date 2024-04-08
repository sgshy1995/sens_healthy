import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'dart:math';

// 定义回调函数类型
typedef ShowDetailCallback = void Function();
typedef SearchNumberCallback = void Function(int num);

class PainSearchMajorPage extends StatefulWidget {
  final String? keyword;
  late ShowDetailCallback showDetailCallback;
  late SearchNumberCallback searchNumberCallback;

  PainSearchMajorPage(
      {super.key,
      this.keyword,
      required this.showDetailCallback,
      required this.searchNumberCallback});

  @override
  PainSearchMajorPageState createState() => PainSearchMajorPageState();
}

class PainSearchMajorPageState extends State<PainSearchMajorPage>
    with TickerProviderStateMixin {
  final PainClientProvider painClientProvider =
      GetInstance().find<PainClientProvider>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  late String keywordCanChange;

  void scrollToTop() {
    _scrollController.animateTo(
      0.0, // 滚动位置为顶部
      duration: const Duration(milliseconds: 300), // 动画持续时间
      curve: Curves.easeInOut, // 动画曲线
    );
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  /* 数据信息 */
  bool readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<PainQuestionTypeModel>>
      painQuestionDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    painQuestionDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  /* 点赞、收藏 状态 */
  bool _likeLoading = false;
  bool _collectLoading = false;

  /* 点赞方法 */
  void handleClickLike(String id) {
    if (_likeLoading || _collectLoading) {
      return;
    }
    final int index = painQuestionDataPagination.data
        .indexWhere((element) => element.id == id);
    final painQuestionGet = painQuestionDataPagination.data[index];
    final List<String> likeIdsList = painQuestionGet.like_user_ids != null
        ? painQuestionGet.like_user_ids!.split(',').toSet().toList()
        : [];
    updatePainQuestionLike(
        id, likeIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionLike(String id, int status) {
    setState(() {
      _likeLoading = true;
    });
    painClientProvider.updateQuestionLikeAction(id, status).then((result) {
      if (result.code == 200) {
        final int index = painQuestionDataPagination.data
            .indexWhere((element) => element.id == id);
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDataPagination.data[index] = painQuestionNew;
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
  void handleClickCollect(String id) {
    if (_collectLoading || _likeLoading) {
      return;
    }
    final int index = painQuestionDataPagination.data
        .indexWhere((element) => element.id == id);
    final painQuestionGet = painQuestionDataPagination.data[index];
    final List<String> collectIdsList = painQuestionGet.collect_user_ids != null
        ? painQuestionGet.collect_user_ids!.split(',').toSet().toList()
        : [];
    updatePainQuestionCollect(
        id, collectIdsList.contains(userController.userInfo.id) ? 0 : 1);
  }

  void updatePainQuestionCollect(String id, int status) {
    setState(() {
      _collectLoading = true;
    });
    painClientProvider.updateQuestionCollectAction(id, status).then((result) {
      if (result.code == 200) {
        final int index = painQuestionDataPagination.data
            .indexWhere((element) => element.id == id);
        painClientProvider.getQuestionByIdAction(id).then((result1) {
          if (result1.code == 200) {
            final painQuestionNew = result1.data!;
            setState(() {
              painQuestionDataPagination.data[index] = painQuestionNew;
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

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  final CarouselController _carouselController = CarouselController();
  int _carouselInitialIndex = 0;
  void jumpToIndexCarouselPage(int index) {
    _carouselController.animateToPage(index);
  }

  dynamic Function(int, CarouselPageChangedReason)? carouselCallbackFunction(
      index, reason) {
    setState(() {
      _carouselInitialIndex = index;
    });
    return null;
  }

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  int _myCourseNum = 4;

  Future<String> getPainQuestions({int? page}) {
    Completer<String> completer = Completer();
    painClientProvider
        .getPainQuestionsByCustomAction(
            keyword: widget.keyword,
            pageNo: page ?? _currentPageNo + 1,
            hasMajor: true)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount; // 生成 0 到 100 的随机数
      widget.searchNumberCallback(totalCount);
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          painQuestionDataPagination.data = valueGet;
        } else {
          painQuestionDataPagination.data.addAll(valueGet);
        }
        painQuestionDataPagination.pageNo = pageNo;
        painQuestionDataPagination.pageSize = pageSize;
        painQuestionDataPagination.totalPage = totalPage;
        painQuestionDataPagination.totalCount = totalCount;
        readyLoad = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keywordCanChange = widget.keyword ?? '';
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
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    _RotateController.dispose();
    // painClientProvider.dispose();
    // userController.dispose();
    // globalController.dispose();
  }

  void onRefresh() {
    _onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    String result;
    try {
      result = await getPainQuestions(page: 1);
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
      result = await getPainQuestions();
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

  final Key linkKey = GlobalKey();

  EdgeInsets safePadding = MediaQuery.of(Get.context!).padding;

  void handleGoToDetail(String questionId) {
    Get.toNamed('/pain_question_detail', arguments: {'questionId': questionId})
        ?.then((value) {
      widget.showDetailCallback();
    });
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
    final double itemWidth = (mediaQuerySizeInfo.width - 36) / 2;
    final double itemHeight = (mediaQuerySizeInfo.width - 36) / 2 / 2;

    final double itemWidthAndHeight =
        (mediaQuerySizeInfo.width - 24 - 8 - 8) / 3;

    Widget skeleton() {
      return Column(
        children: List.generate(10, (int index) {
          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(22))),
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
                            height: 14,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            margin: const EdgeInsets.only(right: 12),
                            child: Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(229, 229, 229, 1),
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
                        ),
                        Container(
                          width: 60,
                          height: 14,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          margin: const EdgeInsets.only(right: 12),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromRGBO(229, 229, 229, 1),
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 60,
                              height: 14,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    margin: const EdgeInsets.only(right: 0),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromRGBO(229, 229, 229, 1),
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 18),
                  child: Stack(
                    children: [
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // 交叉轴子项数量
                                  mainAxisSpacing: 0, // 主轴间距
                                  crossAxisSpacing: 8, // 交叉轴间距
                                  childAspectRatio: 1,
                                  mainAxisExtent: itemWidthAndHeight),
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero, // 设置为零边距
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(229, 229, 229, 1),
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.white,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 14,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 14,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 24),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 14,
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromRGBO(229, 229, 229, 1),
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 0),
                        width: 24,
                        height: 24,
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromRGBO(229, 229, 229, 1),
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: RefreshConfiguration(
            headerTriggerDistance: 60.0,
            enableScrollWhenRefreshCompleted:
                true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
            child: SmartRefresher(
                physics: const ClampingScrollPhysics(), // 禁止回弹效果
                enablePullDown: readyLoad,
                enablePullUp: readyLoad,
                header: CustomHeader(
                    builder: buildHeader,
                    onOffsetChange: (offset) {
                      //do some ani
                    }),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget? body;
                    if (painQuestionDataPagination.data.isEmpty) {
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
                // child: ListView.builder(
                //   controller: _scrollController,
                //   itemBuilder: (c, i) => i == 0
                //       ? Container(
                //           height: mediaQuerySafeInfo.top + 12 + 50 + 12 + 12 + 12,
                //           color: Colors.white,
                //         )
                //       : SizedBox(
                //           height: 100,
                //           child: Card(child: Center(child: Text(items[i]))),
                //         ),
                //   itemCount: items.length,
                // ),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    (readyLoad && painQuestionDataPagination.data.isNotEmpty
                        ? const SliverToBoxAdapter()
                        : const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          )),
                    SliverToBoxAdapter(
                      child: (painQuestionDataPagination.data.isEmpty &&
                              readyLoad)
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
                                          color:
                                              Color.fromRGBO(224, 222, 223, 1),
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
                      child: !readyLoad ? skeleton() : null,
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                      final PainQuestionTypeModel itemData =
                          painQuestionDataPagination.data[i];
                      final String name = itemData.anonymity == 1
                          ? '匿名用户'
                          : itemData.name != null
                              ? itemData.name!
                              : '赴康云用户';
                      // 获取当前时间
                      DateTime nowTime = DateTime.now();
                      // 格式化日期
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(nowTime);
                      String formattedYearDate =
                          DateFormat('yyyy').format(nowTime);
                      // 获取问题时间
                      DateTime questionTime =
                          DateTime.parse(itemData.question_time);
                      // 格式化日期
                      String formattedDateQuestion =
                          DateFormat('yyyy-MM-dd').format(questionTime);
                      String formattedYearDateQuestion =
                          DateFormat('yyyy').format(questionTime);
                      final String showQuestionTime;
                      if (formattedDate == formattedDateQuestion) {
                        String formattedMinutesDateQuestion =
                            DateFormat('HH:mm').format(questionTime);
                        showQuestionTime = '$formattedMinutesDateQuestion 今天';
                      } else if (formattedYearDate ==
                          formattedYearDateQuestion) {
                        String formattedMonthsAndMinutesDateQuestion =
                            DateFormat('HH:mm MM/dd').format(questionTime);
                        showQuestionTime =
                            formattedMonthsAndMinutesDateQuestion;
                      } else {
                        String formattedYearsAndMonthsAndMinutesDateQuestion =
                            DateFormat('HH:mm yy/MM/dd').format(questionTime);
                        showQuestionTime =
                            formattedYearsAndMonthsAndMinutesDateQuestion;
                      }

                      final String painType = itemData.pain_type;
                      final String description = itemData.description;

                      List<String> imagesList = [];
                      if (itemData.image_data != null) {
                        imagesList =
                            itemData.image_data!.split(',').toSet().toList();
                      }
                      final List<GalleryExampleItem> galleryItems =
                          imagesList.map((e) {
                        return GalleryExampleItem(
                            id: e,
                            resource: '${globalController.cdnBaseUrl}/$e',
                            isSvg: false);
                      }).toList();

                      void open(BuildContext context, final int index) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  GalleryPhotoViewWrapper(
                                    galleryItems: galleryItems,
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    initialIndex: index,
                                    scrollDirection: Axis.horizontal,
                                  ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              }),
                        );
                      }

                      final List<String> likeIdsList = itemData.like_user_ids !=
                              null
                          ? itemData.like_user_ids!.split(',').toSet().toList()
                          : [];
                      final bool readyLike =
                          likeIdsList.contains(userController.userInfo.id);

                      final List<String> collectIdsList =
                          itemData.collect_user_ids != null
                              ? itemData.collect_user_ids!
                                  .split(',')
                                  .toSet()
                                  .toList()
                              : [];
                      final bool readyCollect =
                          collectIdsList.contains(userController.userInfo.id);

                      return InkWell(
                        onTap: () => handleGoToDetail(itemData.id),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (i != 0
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 0),
                                      child: const Divider(
                                        height: 2,
                                        color: Color.fromRGBO(233, 234, 235, 1),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    )),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: (itemData.anonymity == 1 ||
                                            itemData.avatar == null)
                                        ? const CircleAvatar(
                                            radius: 22,
                                            backgroundImage: AssetImage(
                                                'assets/images/avatar.webp'),
                                          )
                                        : CircleAvatar(
                                            radius: 22,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    '${globalController.cdnBaseUrl}/${itemData.avatar}'),
                                          ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 1)),
                                        ),
                                      ),
                                      Text(
                                        showQuestionTime,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Color.fromRGBO(
                                                102, 102, 102, 1)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '#$painType#',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  0, 102, 204, 1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 6), // 设置间距为10
                                        ),
                                        TextSpan(
                                          text: description,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 12,
                                    bottom: imagesList.isNotEmpty ? 18 : 0),
                                child: Stack(
                                  children: [
                                    imagesList.length >= 2
                                        ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        imagesList.length >= 3
                                                            ? 3
                                                            : 2, // 交叉轴子项数量
                                                    mainAxisSpacing: 0, // 主轴间距
                                                    crossAxisSpacing:
                                                        8, // 交叉轴间距
                                                    childAspectRatio: 1,
                                                    mainAxisExtent:
                                                        itemWidthAndHeight),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero, // 设置为零边距
                                            shrinkWrap: true,
                                            itemCount:
                                                imagesList.length >= 3 ? 3 : 2,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return index == 2
                                                  ? Container(
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${globalController.cdnBaseUrl}/${imagesList[index]}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : GestureDetector(
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
                                        : (imagesList.isNotEmpty &&
                                                imagesList[0].isNotEmpty)
                                            ? GestureDetector(
                                                onTap: () => open(context, 0),
                                                child: Hero(
                                                  tag: galleryItems[0].id,
                                                  child: SizedBox(
                                                    width: mediaQuerySizeInfo
                                                            .width /
                                                        7 *
                                                        5,
                                                    height: mediaQuerySizeInfo
                                                            .width /
                                                        7 *
                                                        5 /
                                                        16 *
                                                        9,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          '${globalController.cdnBaseUrl}/${imagesList[0]}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: imagesList.length > 3
                                            ? GestureDetector(
                                                onTap: () => open(context, 2),
                                                child: Hero(
                                                  tag: galleryItems[2].id,
                                                  child: Container(
                                                    width: itemWidthAndHeight,
                                                    height: itemWidthAndHeight,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.5),
                                                    child: Center(
                                                        child: Text(
                                                      '+${imagesList.length - 3}',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ))
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 24),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () => handleClickLike(
                                                    itemData.id),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  width: 24,
                                                  height: 24,
                                                  child: readyLike
                                                      ? IconFont(
                                                          IconNames.dianzan_1,
                                                          size: 24,
                                                          color:
                                                              'rgb(211,66,67)',
                                                        )
                                                      : IconFont(
                                                          IconNames.dianzan,
                                                          size: 24,
                                                          color: '#000',
                                                        ),
                                                ),
                                              ),
                                              Text(
                                                '${itemData.like_num > 99 ? '99+' : itemData.like_num}',
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 24),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () => handleClickCollect(
                                                    itemData.id),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  width: 24,
                                                  height: 24,
                                                  child: readyCollect
                                                      ? IconFont(
                                                          IconNames.shoucang_1,
                                                          size: 24,
                                                          color:
                                                              'rgb(252,189,84)',
                                                        )
                                                      : IconFont(
                                                          IconNames.shoucang,
                                                          size: 24,
                                                          color: '#000',
                                                        ),
                                                ),
                                              ),
                                              Text(
                                                '${itemData.collect_num > 99 ? '99+' : itemData.collect_num}',
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 24),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                width: 24,
                                                height: 24,
                                                child: IconFont(
                                                  IconNames.xiaoxi,
                                                  size: 24,
                                                  color: '#000',
                                                ),
                                              ),
                                              Text(
                                                '${itemData.reply_num > 99 ? '99+' : itemData.reply_num}',
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: IconFont(
                                        IconNames.fenxiang,
                                        size: 24,
                                        color: '#000',
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }, childCount: painQuestionDataPagination.data.length))
                  ],
                )),
          ))
        ],
      ),
    );
  }

  // 1.5.0后,应该没有必要加这一行了
  // @override
  // void dispose() {
  // TODO: implement dispose
  //   _refreshController.dispose();
//    super.dispose();
//  }
}
