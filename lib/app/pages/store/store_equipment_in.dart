import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/app/models/store_model.dart';
import 'package:sens_healthy/components/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../providers/api/store_client_provider.dart';
import '../../../components/scale_button.dart';
import '../../controllers/store_controller.dart';

// 定义回调函数类型
typedef ScrollCallback = void Function(double scrollDistance);

class StoreEquipmentInPage extends StatefulWidget {
  StoreEquipmentInPage(
      {super.key,
      this.scrollCallBack,
      this.ifUseCarousel = true,
      this.equipmentType,
      this.hotOrder,
      this.hasDiscount,
      this.keyword});

  final ScrollCallback? scrollCallBack;

  final String? keyword;

  final bool ifUseCarousel;

  final int? equipmentType;

  final int? hotOrder;

  final int? hasDiscount;

  @override
  State<StoreEquipmentInPage> createState() => StoreEquipmentInPageState();
}

class StoreEquipmentInPageState extends State<StoreEquipmentInPage>
    with SingleTickerProviderStateMixin {
  final StoreController storeController = Get.put(StoreController());
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  late int? equipmentTypeGet;
  late String? keywordGet;

  /* 数据信息 */
  bool readyLoad = false;
  int _currentPageNo = 1;
  DataPaginationInModel<List<StoreEquipmentTypeModel>> equipmentDataPagination =
      DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  List<StoreEquipmentTypeModel> carouselData = [];

  void initPagination() {
    equipmentDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];

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

  int _myCourseNum = 0;

  Future<String> getEquipments({int? page}) {
    Completer<String> completer = Completer();
    storeClientProvider
        .getEquipmentsAction(
            pageNo: page ?? _currentPageNo + 1,
            hotOrder: widget.hotOrder,
            hasDiscount: widget.hasDiscount,
            equipmentType: equipmentTypeGet,
            keyword: keywordGet)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
      setState(() {
        _currentPageNo = pageNo;
        if (pageNo == 1) {
          equipmentDataPagination.data = valueGet;
        } else {
          equipmentDataPagination.data.addAll(valueGet);
        }
        equipmentDataPagination.pageNo = pageNo;
        equipmentDataPagination.pageSize = pageSize;
        equipmentDataPagination.totalPage = totalPage;
        equipmentDataPagination.totalCount = totalCount;
        readyLoad = true;
      });
      completer.complete(pageNo == totalPage ? 'no-data' : 'success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  Future<String> getEquipmentsCarouse() {
    Completer<String> completer = Completer();
    storeClientProvider.getCarouselEquipmentsAction().then((value) {
      final carouselDataGet = value.data!;
      setState(() {
        carouselData = [...carouselDataGet];
        readyLoad = true;
      });
      completer.complete('success');
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  void _scrollListener() {
    setState(() {
      _scrollDistance = _scrollController.offset;
      if (widget.scrollCallBack != null) {
        widget.scrollCallBack!(_scrollDistance);
      }
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
      result = await getEquipments(page: 1);
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
      result = await getEquipments();
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

  void handleGoToDetail(String equipmentId) {
    Get.toNamed('/store_equipment_detail',
        arguments: {'equipmentId': equipmentId});
  }

  bool addChartDisabled = false;

  void loadChartsNum() {
    storeClientProvider.getEquipmentChartListAction().then((value) {
      storeController.setStoreEquipmentChartNum(
          value.data != null ? value.data!.length : 0);
    });
  }

  @override
  void initState() {
    super.initState();

    equipmentTypeGet = widget.equipmentType;
    keywordGet = widget.keyword;

    getEquipmentsCarouse();
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

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;
    final double itemWidthOrHeight =
        (mediaQuerySizeInfo.width - 18 - 18 - 18) / 2;

    Widget skeleton() {
      return Container();
    }

    return Scaffold(
        body: Column(
      children: [
        Container(
          height: mediaQuerySafeInfo.top +
              12 +
              12 +
              12 +
              (widget.scrollCallBack != null ? 50 : 14) +
              12 -
              (_scrollDistance < 0
                  ? 0
                  : _scrollDistance < (36 + 12)
                      ? _scrollDistance
                      : (36 + 12)),
          color: Colors.white,
        ),
        Expanded(
          child: RefreshConfiguration(
              headerTriggerDistance: 60.0,
              enableScrollWhenRefreshCompleted:
                  true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
              child: SmartRefresher(
                  physics: const ClampingScrollPhysics(), // 禁止回弹效果
                  enablePullDown: true,
                  enablePullUp: true,
                  header: CustomHeader(
                      builder: buildHeader,
                      onOffsetChange: (offset) {
                        //do some ani
                      }),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget? body;
                      if (equipmentDataPagination.data.isEmpty) {
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
                  child:
                      CustomScrollView(controller: _scrollController, slivers: [
                    SliverToBoxAdapter(
                      child: Visibility(
                          visible: widget.ifUseCarousel,
                          child: Stack(
                            children: [
                              SizedBox(
                                child: CarouselSlider(
                                    carouselController: _carouselController,
                                    items: carouselData.map((i) {
                                      final String coverGet =
                                          '${globalController.cdnBaseUrl}/${i.cover}';
                                      final String discountPercent =
                                          i.has_discount == 1 ? '有折扣' : "";
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    handleGoToDetail(i.id),
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: CachedNetworkImage(
                                                        imageUrl: coverGet,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                    Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        bottom: 36,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  height: 32,
                                                                  padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                      24,
                                                                      0,
                                                                      24,
                                                                      0),
                                                                  decoration: const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        i.title,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      (i.has_discount ==
                                                                              1
                                                                          ? Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 18,
                                                                                  height: 18,
                                                                                  margin: const EdgeInsets.only(right: 4, left: 12),
                                                                                  child: Center(
                                                                                    child: IconFont(IconNames.pic_discount, size: 18),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  discountPercent,
                                                                                  style: const TextStyle(color: Color.fromRGBO(209, 120, 47, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                )
                                                                              ],
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink())
                                                                    ],
                                                                  ))
                                                            ]))
                                                  ],
                                                ),
                                              ));
                                        },
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: false,
                                      enlargeFactor: 0.3,
                                      onPageChanged: carouselCallbackFunction,
                                      scrollDirection: Axis.horizontal,
                                    )),
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 12,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 14,
                                          width: 24 +
                                              carouselData.length * 12 +
                                              (carouselData.length - 1) * 8,
                                          decoration: const BoxDecoration(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: List.generate(
                                                  carouselData.length, (index) {
                                                return InkWell(
                                                  onTap: () =>
                                                      jumpToIndexCarouselPage(
                                                          index),
                                                  child: Container(
                                                    width: 12,
                                                    height:
                                                        _carouselInitialIndex ==
                                                                index
                                                            ? 4
                                                            : 3,
                                                    margin: EdgeInsets.only(
                                                        right: index !=
                                                                carouselData
                                                                        .length -
                                                                    1
                                                            ? 8
                                                            : 0),
                                                    color:
                                                        _carouselInitialIndex ==
                                                                index
                                                            ? const Color
                                                                .fromRGBO(255,
                                                                255, 255, 1)
                                                            : const Color
                                                                .fromRGBO(255,
                                                                255, 255, 0.5),
                                                  ),
                                                );
                                              })),
                                        )
                                      ]))
                            ],
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: (equipmentDataPagination.data.isEmpty && readyLoad)
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
                    SliverToBoxAdapter(
                      child: equipmentDataPagination.data.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '全部器械 · ${equipmentDataPagination.data.length}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : null,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    // 交叉轴子项数量
                                    mainAxisSpacing: 18, // 主轴间距
                                    crossAxisSpacing: 18, // 交叉轴间距
                                    childAspectRatio: 1,
                                    mainAxisExtent:
                                        itemWidthOrHeight / 4 * 3 + 60,
                                    maxCrossAxisExtent: itemWidthOrHeight),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero, // 设置为零边距
                            shrinkWrap: true,
                            itemCount: equipmentDataPagination.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String frequencyNumShow = (equipmentDataPagination
                                              .data[index].frequency_total_num >
                                          1000 &&
                                      equipmentDataPagination.data[index]
                                              .frequency_total_num <=
                                          10000)
                                  ? '${(equipmentDataPagination.data[index].frequency_total_num / 1000).floor()}k+'
                                  : (equipmentDataPagination.data[index]
                                                  .frequency_total_num >
                                              10000 &&
                                          equipmentDataPagination.data[index]
                                                  .frequency_total_num <=
                                              100000)
                                      ? '${(equipmentDataPagination.data[index].frequency_total_num / 10000).floor()}k+'
                                      : '${equipmentDataPagination.data[index].frequency_total_num}';

                              final String discountPercentItem =
                                  equipmentDataPagination
                                              .data[index].has_discount ==
                                          1
                                      ? '有折扣'
                                      : "";

                              return GestureDetector(
                                onTap: () => handleGoToDetail(
                                    equipmentDataPagination.data[index].id),
                                child: Container(
                                  width: itemWidthOrHeight,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // 设置圆角
                                              child: Image(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: itemWidthOrHeight,
                                            height: itemWidthOrHeight / 4 * 3,
                                            imageUrl:
                                                '${globalController.cdnBaseUrl}/${equipmentDataPagination.data[index].cover}',
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          top: itemWidthOrHeight / 4 * 3 - 32,
                                          right: 8,
                                          child: Row(
                                            children: [
                                              (equipmentDataPagination
                                                          .data[index]
                                                          .has_discount ==
                                                      1
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          height: 24,
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  4, 0, 4, 0),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0.7)),
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
                                                                  child: IconFont(
                                                                      IconNames
                                                                          .pic_discount,
                                                                      size: 18),
                                                                ),
                                                              ),
                                                              Text(
                                                                discountPercentItem,
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            209,
                                                                            120,
                                                                            47,
                                                                            1),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                          width: 12,
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()),
                                              Container(
                                                height: 24,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.7)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        text: TextSpan(
                                                            text:
                                                                '已售 $frequencyNumShow',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12))),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      Positioned(
                                        right: 0,
                                        left: 0,
                                        top: itemWidthOrHeight / 4 * 3,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            equipmentDataPagination
                                                                .data[index]
                                                                .title,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: equipmentTypeList[
                                                            equipmentDataPagination
                                                                .data[index]
                                                                .equipment_type],
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    33,
                                                                    33,
                                                                    1),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ]))),
        )
      ],
    ));
  }
}
