import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../../iconfont/icon_font.dart';
import '../../providers/api/store_client_provider.dart';
import '../../models/store_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../components/gallery_photo_view_wrapper.dart';
import '../../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

// 定义回调函数类型
typedef ShowDetailCallback = void Function();

class MineEquipmentOrderInPage extends StatefulWidget {
  final String? keyword;
  final ShowDetailCallback showDetailCallback;
  final ShowDetailCallback rebuyCallback;

  final String userId;

  final int? status;

  const MineEquipmentOrderInPage(
      {super.key,
      this.keyword,
      required this.userId,
      this.status,
      required this.showDetailCallback,
      required this.rebuyCallback});

  @override
  State<MineEquipmentOrderInPage> createState() =>
      MineEquipmentOrderInPageState();
}

class MineEquipmentOrderInPageState extends State<MineEquipmentOrderInPage>
    with TickerProviderStateMixin {
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

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
  DataPaginationInModel<List<StoreEquipmentOrderTypeModel>>
      painQuestionDataPagination = DataPaginationInModel(
          data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);

  void initPagination() {
    painQuestionDataPagination = DataPaginationInModel(
        data: [], pageNo: 1, pageSize: 10, totalPage: 0, totalCount: 0);
  }

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

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

  Future<String> getPainQuestions({int? page}) {
    Completer<String> completer = Completer();
    storeClientProvider
        .findManyEquipmentOrdersWithPaginationAction(
            keyword: keywordGet,
            pageNo: page ?? _currentPageNo + 1,
            userId: widget.userId,
            status: widget.status)
        .then((value) {
      final valueGet = value.data.data;
      final pageNo = value.data.pageNo;
      final pageSize = value.data.pageSize;
      final totalPage = value.data.totalPage;
      final totalCount = value.data.totalCount;
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

  String? keywordGet;

  @override
  void initState() {
    super.initState();
    keywordGet = widget.keyword;
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

  void handleGoToDetail(String equipmentOrderNo) {
    Get.toNamed('/mine_equipment_order_detail',
        arguments: {'equipmentOrderNo': equipmentOrderNo})?.then((value) {
      if (value == 'success') {
        widget.showDetailCallback();
      } else if (value == 'rebuy') {
        widget.rebuyCallback();
      }
    });
  }

  String formatNumberToThousandsSeparator(double number) {
    NumberFormat formatter = NumberFormat("#,###.##");
    return formatter.format(number);
  }

  void handleRebuy(StoreEquipmentOrderTypeModel storeEquipmentOrderDetail) {
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
              scrollToTop();
              widget.rebuyCallback();
            }
          });
        }
      }
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
                  height: 240,
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
                ),
                const SizedBox(
                  height: 12,
                ),
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
                                      '没有订单信息',
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
                      final StoreEquipmentOrderTypeModel itemData =
                          painQuestionDataPagination.data[i];

                      final List<StoreEquipmentTypeModel> itemDataEquipments =
                          itemData.equipment ?? [];

                      final List<String> modelIdsList =
                          itemData.model_ids.split(',');

                      final List<String> addNumsList =
                          itemData.order_nums.split(',');

                      return InkWell(
                        onTap: () => handleGoToDetail(itemData.order_no),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          equipmentOrderStatusList[
                                              itemData.status],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: (itemData.status == 3 ||
                                                      itemData.status == 4)
                                                  ? const Color.fromRGBO(
                                                      211, 66, 67, 1)
                                                  : const Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                itemDataEquipments.length,
                                                (index) => Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 24),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            height: 120 / 4 * 3,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8), // 设置圆角
                                                                child: Image(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              width: 120,
                                                              height:
                                                                  120 / 4 * 3,
                                                              imageUrl:
                                                                  '${globalController.cdnBaseUrl}/${itemDataEquipments[index].cover}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          SizedBox(
                                                            width: 120,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                RichText(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    text: TextSpan(
                                                                        text: itemDataEquipments[index]
                                                                            .title,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 14))),
                                                                const SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: List.generate(
                                                                      itemDataEquipments[index].models != null ? (itemDataEquipments[index].models!.length > 2 ? 3 : itemDataEquipments[index].models!.length) : 0,
                                                                      (indexIn) => indexIn <= 1
                                                                          ? Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: RichText(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, text: TextSpan(text: itemDataEquipments[index].models![indexIn].title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13))),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text('x${addNumsList[modelIdsList.indexWhere((element) => element == itemDataEquipments[index].models![indexIn].id)]}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13))
                                                                              ],
                                                                            )
                                                                          : Text('...其余${3 - itemDataEquipments[index].models!.length}种', style: const TextStyle(color: Color.fromRGBO(140, 140, 140, 1), fontWeight: FontWeight.normal, fontSize: 13))),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                          ),
                                        )),
                                        Container(
                                          height: itemDataEquipments.every(
                                                  (element) =>
                                                      element.models!.length <=
                                                      1)
                                              ? 160
                                              : itemDataEquipments.every(
                                                      (element) =>
                                                          element
                                                              .models!.length <=
                                                          2)
                                                  ? 176
                                                  : 192,
                                          constraints: const BoxConstraints(
                                            minWidth: 90, // 设置最小宽度为100
                                          ),
                                          margin:
                                              const EdgeInsets.only(left: 0),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(33, 33,
                                                    33, 0.5), // 设置阴影颜色和透明度
                                                offset: Offset(
                                                    -5, 0), // 设置阴影的偏移量，向左偏移5个像素
                                                blurRadius: 3, // 设置阴影的模糊半径
                                                spreadRadius:
                                                    -6, // 设置阴影的扩散半径为负值，只向左侧扩散
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '¥${formatNumberToThousandsSeparator(double.parse(itemData.payment_num))}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                  '${itemData.equipment != null ? itemData.equipment!.length : 0}种器材',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                  '共${itemData.order_total_num}件',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    (itemData.status == 3 &&
                                            itemData.courier_info != null &&
                                            itemData.courier_info!
                                                .courier_content.list.isNotEmpty
                                        ? const SizedBox(
                                            height: 12,
                                          )
                                        : const SizedBox.shrink()),
                                    (itemData.status == 3 &&
                                            itemData.courier_info != null &&
                                            itemData.courier_info!
                                                .courier_content.list.isNotEmpty
                                        ? Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    246, 246, 246, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: RichText(
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: itemData
                                                          .courier_info!
                                                          .courier_content
                                                          .list[0]
                                                          .time,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    const WidgetSpan(
                                                        child: SizedBox(
                                                      width: 12,
                                                    )),
                                                    TextSpan(
                                                      text: itemData
                                                          .courier_info!
                                                          .courier_content
                                                          .list[0]
                                                          .status,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ],
                                                )),
                                          )
                                        : const SizedBox.shrink()),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () => handleGoToDetail(
                                              itemData.order_no),
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 0, 12, 0),
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '查看详情',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        GestureDetector(
                                          onTap: () => handleRebuy(itemData),
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 0, 12, 0),
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color.fromRGBO(
                                                      211, 66, 67, 1),
                                                  Color.fromRGBO(
                                                      211, 66, 67, 0.8),
                                                  Color.fromRGBO(
                                                      211, 66, 67, 0.7)
                                                ], // 渐变的起始和结束颜色
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '再次购买',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
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
