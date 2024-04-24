import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sens_healthy/app/models/store_model.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/api/store_client_provider.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import '../../../components/slide_transition_x.dart';
import '../../../components/scale_button.dart';
import '../../controllers/store_controller.dart';
import '../../../components/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../components/number_select.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';

class StoreEquipmentDetailPage extends StatefulWidget {
  const StoreEquipmentDetailPage({super.key});

  @override
  State<StoreEquipmentDetailPage> createState() =>
      _StoreEquipmentDetailPageState();
}

class _StoreEquipmentDetailPageState extends State<StoreEquipmentDetailPage>
    with SingleTickerProviderStateMixin {
  final StoreController storeController = Get.put(StoreController());
  late TabController _tabController;
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  final GlobalKey<NumberSelectState> _numberSelectStateKey = GlobalKey();

  List<GalleryExampleItem> galleryItems = [];

  int tabIndex = 0;

  int modelIndex = 0;

  int _counter = 1;

  double totalCount = 0;
  double totalDiscount = 0;

  void handleChangeChooseModel(int index) {
    if (modelIndex == index) {
      return;
    }
    setState(() {
      _counter = storeEquipmentInModelList[index].inventory <= 0 ? 0 : 1;
      _numberSelectStateKey.currentState?.resetValue(
          valueNew: storeEquipmentInModelList[index].inventory <= 0 ? 0 : 1);
      modelIndex = index;
    });
    getModelMultiFigureCarouse();

    handleCalculateTotal();
  }

  void handleChangeCounter(int value) {
    setState(() {
      _counter = value;
    });
    handleCalculateTotal();
  }

  void handleCalculateTotal() {
    if (modelIndex <= storeEquipmentInModelList.length - 1) {
      setState(() {
        totalCount = double.parse(storeEquipmentInModelList[modelIndex].price) *
            _counter;
        totalDiscount = double.parse(
                storeEquipmentInModelList[modelIndex].is_discount == 1
                    ? storeEquipmentInModelList[modelIndex].discount!
                    : storeEquipmentInModelList[modelIndex].price) *
            _counter;
      });
    } else {
      setState(() {
        totalCount = 0;
        totalDiscount = 0;
      });
    }
  }

  void handleChangeTab(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  List<String> carouselData = [];

  List<String> longFigureList = [];

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

  void getModelMultiFigureCarouse() {
    if (carouselData.isNotEmpty) {
      _carouselController.jumpToPage(0);
    }
    if (storeEquipmentInModelList.isNotEmpty) {
      final String carouselDataGetString =
          storeEquipmentInModelList[modelIndex].multi_figure;
      final List<String> carouselDataGet = carouselDataGetString.split(',');
      setState(() {
        carouselData = [...carouselDataGet];
      });
    }
  }

  void getEquipmentLongFigureList() {
    final List<String> longFigureListGet =
        storeEquipmentDetail.long_figure.split(',');
    final List<GalleryExampleItem> galleryItemsGet = [];
    longFigureListGet.asMap().forEach((key, value) {
      galleryItemsGet.add(GalleryExampleItem(
          id: key.toString(),
          resource: '${globalController.cdnBaseUrl}/$value',
          isSvg: false,
          canBeDownloaded: false,
          imageType: 'network'));
    });

    setState(() {
      longFigureList = [...longFigureListGet];
      galleryItems = [...galleryItemsGet];
    });
  }

  bool _readyLoad = false;

  late final String dataId;

  StoreEquipmentTypeModel storeEquipmentDetail =
      StoreEquipmentTypeModel.fromJson(null);

  List<StoreEquipmentInModelTypeModel> storeEquipmentInModelList = [];

  //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final List<String> equipmentTypeList = ['康复训练器材', '康复理疗设备', '康复治疗师工具'];

  void getDetailData() {
    storeClientProvider.getEquipmentByIdAction(dataId).then((result) {
      if (result.code == 200) {
        final equipmentNew = result.data!;
        storeClientProvider
            .getModelsByEquipmentIdAction(dataId)
            .then((resultIn) {
          if (resultIn.code == 200) {
            final modelsNew = resultIn.data!;
            setState(() {
              storeEquipmentDetail = equipmentNew;
              storeEquipmentInModelList = [...modelsNew];
              _readyLoad = true;
              handleCalculateTotal();
            });
            getModelMultiFigureCarouse();
            getEquipmentLongFigureList();
          }
        });
      }
    });
  }

  void handleGoBack() {
    Get.back();
  }

  bool descriptionReadMore = false;

  void handleChangeDescriptionReadMore() {
    setState(() {
      descriptionReadMore = !descriptionReadMore;
    });
  }

  bool isRichTextGreaterThan12LinesDescription(int maxLines, double width) {
    final TextSpan richTextIn = TextSpan(
      children: [
        TextSpan(
          text: storeEquipmentDetail.description,
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 15,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final TextPainter textPainter = TextPainter(
      text: richTextIn,
      textDirection: ui.TextDirection.ltr,
      maxLines: maxLines, // 限制最大行数为12行
    );
    textPainter.layout(maxWidth: width);
    return textPainter.didExceedMaxLines;
  }

  bool isRichTextGreaterThanLines(String text, int maxLines, double width) {
    final TextSpan richTextIn = TextSpan(
      children: [
        TextSpan(
          text: text,
          style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 15,
              fontWeight: FontWeight.normal),
        )
      ],
    );
    final TextPainter textPainter = TextPainter(
      text: richTextIn,
      textDirection: ui.TextDirection.ltr,
      maxLines: maxLines, // 限制最大行数为12行
    );
    textPainter.layout(maxWidth: width);
    return textPainter.didExceedMaxLines;
  }

  bool addChartDisabled = false;

  void loadChartsNum() {
    storeClientProvider.getEquipmentChartListAction().then((value) {
      storeController.setStoreEquipmentChartNum(
          value.data != null ? value.data!.length : 0);
    });
  }

  void handleAddToChart() {
    setState(() {
      addChartDisabled = true;
    });
    storeClientProvider
        .addEquipmentChartAction(storeEquipmentDetail.id,
            storeEquipmentInModelList[modelIndex].id, _counter)
        .then((value) {
      loadChartsNum();
      setState(() {
        addChartDisabled = false;
      });
      if (value.code != 200) {
        showToast(value.message);
      } else {
        showToast('已添加至购物车');
      }
    }).catchError((e) {
      showToast('添加失败, 请稍后再试');
    });
  }

  void handleGoToOrder() {
    if (totalCount == 0) {
      return;
    }
    List<String> modelsIdsList = [];
    List<int> addNumsList = [];
    List<String> userIdsList = [];
    List<StoreEquipmentTypeModel> equipmentsList = [];
    modelsIdsList.add(storeEquipmentInModelList[modelIndex].id);
    addNumsList.add(_counter);
    userIdsList.add(userController.userInfo.id);
    equipmentsList.add(storeEquipmentDetail);
    Get.toNamed('store_equipment_order', arguments: {
      'models': modelsIdsList,
      'addNums': addNumsList,
      'userIds': userIdsList,
      'equipments': equipmentsList
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    dataId = Get.arguments['equipmentId'];
    getDetailData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

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

    Widget skeleton() {
      return Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 4 * 3,
          child: Shimmer.fromColors(
            baseColor: const Color.fromRGBO(229, 229, 229, 1),
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: mediaQuerySizeInfo.width,
              height: mediaQuerySizeInfo.width / 4 * 3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          width: mediaQuerySizeInfo.width,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 26,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 120,
                    height: 26,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 180,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 140,
                height: 18,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 140,
                height: 18,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 180,
                    height: 18,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 80,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: mediaQuerySizeInfo.width - 24,
                height: 300,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: mediaQuerySizeInfo.width - 24,
                    height: 400,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 80,
                height: 20,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: mediaQuerySizeInfo.width - 24,
                height: 300,
                child: Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(229, 229, 229, 1),
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: mediaQuerySizeInfo.width - 24,
                    height: 400,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]);
    }

    return Scaffold(
      body: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Stack(
            children: [
              (_readyLoad && storeEquipmentDetail.id.isEmpty
                  ? Container(
                      width: mediaQuerySizeInfo.width,
                      margin: const EdgeInsets.only(top: 200),
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
                                  color: Color.fromRGBO(224, 222, 223, 1),
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              (!_readyLoad
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: skeleton(),
                    )
                  : const SizedBox.shrink()),
              (storeEquipmentDetail.id.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              12, mediaQuerySafeInfo.top + 12, 12, 12),
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
                                const Text('器械详情',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 24,
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
                            child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    child: CarouselSlider(
                                        carouselController: _carouselController,
                                        items: carouselData.map((i) {
                                          final String coverGet =
                                              '${globalController.cdnBaseUrl}/$i';
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: GestureDetector(
                                                    child: Stack(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: coverGet,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
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
                                          onPageChanged:
                                              carouselCallbackFunction,
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
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: List.generate(
                                                      carouselData.length,
                                                      (index) {
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
                                                                    .fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1)
                                                                : const Color
                                                                    .fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0.5),
                                                      ),
                                                    );
                                                  })),
                                            )
                                          ]))
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 12, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          storeEquipmentDetail.title,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: '康复器械 · ',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text: equipmentTypeList[
                                                      storeEquipmentDetail
                                                          .equipment_type],
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          9))),
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.zuixingengxin,
                                                      size: 14,
                                                      color: 'rgb(255,255,255)',
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    '${storeEquipmentInModelList.isNotEmpty ? storeEquipmentInModelList[modelIndex].frequency_num : 0}已购买',
                                                    style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: storeEquipmentDetail
                                                      .description,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: '当前选择型号: ',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                      width: 6), // 设置间距为10
                                                ),
                                                TextSpan(
                                                  text: storeEquipmentInModelList
                                                          .isNotEmpty
                                                      ? storeEquipmentInModelList[
                                                              modelIndex]
                                                          .title
                                                      : '',
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          212, 68, 69, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: '单价: ',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(
                                                      width: storeEquipmentInModelList
                                                                  .isNotEmpty &&
                                                              storeEquipmentInModelList[
                                                                          modelIndex]
                                                                      .is_discount ==
                                                                  1
                                                          ? 6
                                                          : 0), // 设置间距为10
                                                ),
                                                storeEquipmentInModelList
                                                            .isNotEmpty &&
                                                        storeEquipmentInModelList[
                                                                    modelIndex]
                                                                .is_discount ==
                                                            1
                                                    ? TextSpan(
                                                        text:
                                                            '¥${storeEquipmentInModelList[modelIndex].price}',
                                                        style: const TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationThickness:
                                                                2,
                                                            decorationColor:
                                                                Color.fromRGBO(
                                                                    200,
                                                                    200,
                                                                    200,
                                                                    1),
                                                            color:
                                                                Color.fromRGBO(
                                                                    200,
                                                                    200,
                                                                    200,
                                                                    1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : const TextSpan(
                                                        text: null),
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                      width: 6), // 设置间距为10
                                                ),
                                                storeEquipmentInModelList
                                                        .isNotEmpty
                                                    ? TextSpan(
                                                        text:
                                                            '¥${storeEquipmentInModelList[modelIndex].is_discount == 1 ? storeEquipmentInModelList[modelIndex].discount : storeEquipmentInModelList[modelIndex].price}',
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    212,
                                                                    68,
                                                                    69,
                                                                    1),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : const TextSpan(text: null)
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        NumberSelect(
                                            disabled:
                                                storeEquipmentInModelList[
                                                            modelIndex]
                                                        .inventory <=
                                                    0,
                                            key: _numberSelectStateKey,
                                            min: storeEquipmentInModelList[
                                                            modelIndex]
                                                        .inventory <=
                                                    0
                                                ? 0
                                                : 1,
                                            max: 10,
                                            onValueChange: handleChangeCounter,
                                            currentValue: _counter),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Wrap(
                                            spacing: 8.0, // 水平间距
                                            runSpacing: 0, // 垂直间距
                                            children: List.generate(
                                                storeEquipmentInModelList
                                                    .length, (int index) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    handleChangeChooseModel(
                                                        index),
                                                child: Chip(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          3, 0, 3, 0),
                                                  avatar:
                                                      storeEquipmentInModelList[
                                                                      index]
                                                                  .is_discount ==
                                                              1
                                                          ? Container(
                                                              height: 24,
                                                              width: 24,
                                                              color: const Color
                                                                  .fromRGBO(209,
                                                                  120, 47, 1),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  '折',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            )
                                                          : null,
                                                  side: BorderSide(
                                                      color: storeEquipmentInModelList[index]
                                                                  .inventory >
                                                              0
                                                          ? (index == modelIndex
                                                              ? const Color.fromRGBO(
                                                                  212,
                                                                  68,
                                                                  69,
                                                                  1)
                                                              : const Color.fromRGBO(
                                                                  233,
                                                                  234,
                                                                  235,
                                                                  1))
                                                          : (index == modelIndex
                                                              ? const Color.fromRGBO(
                                                                  66, 66, 66, 1)
                                                              : const Color
                                                                  .fromRGBO(
                                                                  244,
                                                                  244,
                                                                  245,
                                                                  1))),
                                                  backgroundColor:
                                                      storeEquipmentInModelList[
                                                                      index]
                                                                  .inventory >
                                                              0
                                                          ? (index == modelIndex
                                                              ? const Color
                                                                  .fromRGBO(212,
                                                                  68, 69, 1)
                                                              : const Color
                                                                  .fromRGBO(233,
                                                                  234, 235, 1))
                                                          : (index == modelIndex
                                                              ? const Color
                                                                  .fromRGBO(
                                                                  66, 66, 66, 1)
                                                              : const Color
                                                                  .fromRGBO(244,
                                                                  244, 245, 1)),
                                                  labelStyle: TextStyle(
                                                      decoration:
                                                          storeEquipmentInModelList[index]
                                                                      .inventory >
                                                                  0
                                                              ? TextDecoration
                                                                  .none
                                                              : TextDecoration
                                                                  .lineThrough,
                                                      decorationThickness: 2,
                                                      decorationColor: index ==
                                                              modelIndex
                                                          ? Colors.white
                                                          : const Color.fromRGBO(
                                                              188, 190, 194, 1),
                                                      color: storeEquipmentInModelList[
                                                                      index]
                                                                  .inventory >
                                                              0
                                                          ? (index == modelIndex
                                                              ? Colors.white
                                                              : Colors.black)
                                                          : index == modelIndex
                                                              ? Colors.white
                                                              : const Color.fromRGBO(
                                                                  188,
                                                                  190,
                                                                  194,
                                                                  1),
                                                      fontSize: 14,
                                                      fontWeight: index ==
                                                              modelIndex
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                                  label: Text(
                                                      storeEquipmentInModelList[
                                                              index]
                                                          .title),
                                                ),
                                              );
                                            })),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SizedBox(
                                          height: 36,
                                          child: TabBar(
                                              tabAlignment: TabAlignment.start,
                                              padding: const EdgeInsets.all(0),
                                              isScrollable:
                                                  true, // 设置为true以启用横向滚动
                                              onTap: (index) {
                                                if (index == 1) {
                                                  // 切换时滚动到顶部
                                                  //_painQuestionPageState.currentState?.scrollToTop();
                                                }
                                                handleChangeTab(index);
                                              },
                                              indicatorPadding: EdgeInsets
                                                  .zero, // 设置指示器的内边距为零
                                              indicator: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Color.fromRGBO(211,
                                                        66, 67, 1), // 底部边框颜色
                                                    width: 3, // 底部边框宽度
                                                  ),
                                                ),
                                              ),
                                              labelColor: const Color.fromRGBO(
                                                  211, 66, 67, 1),
                                              indicatorColor:
                                                  const Color.fromRGBO(
                                                      211, 66, 67, 1),
                                              controller: _tabController,
                                              tabs: const [
                                                Tab(
                                                  child: Text('型号信息'),
                                                ),
                                                Tab(
                                                  child: Text('描述'),
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          transitionBuilder: (Widget child,
                                                  Animation<double>
                                                      animation) =>
                                              SlideTransitionX(
                                            direction:
                                                AxisDirection.left, //右入左出
                                            position: animation,
                                            child: child,
                                          ),
                                          child: IndexedStack(
                                              key: ValueKey<int>(
                                                  tabIndex), // add this line
                                              index: tabIndex,
                                              children: [
                                                Visibility(
                                                    visible: tabIndex == 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 12, 12, 12),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: RichText(
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: storeEquipmentInModelList
                                                                          .isNotEmpty
                                                                      ? storeEquipmentInModelList[
                                                                              modelIndex]
                                                                          .parameter
                                                                      : '',
                                                                  style:
                                                                      const TextStyle(
                                                                          height:
                                                                              1.5, // 设置行高为字体大小的1.5倍
                                                                          color: Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    )),
                                                Visibility(
                                                    visible: tabIndex == 1,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          12, 12, 12, 12),
                                                      child: Column(
                                                        children: [
                                                          RichText(
                                                              maxLines:
                                                                  descriptionReadMore
                                                                      ? 9999
                                                                      : 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: storeEquipmentInModelList
                                                                            .isNotEmpty
                                                                        ? storeEquipmentInModelList[modelIndex]
                                                                            .description
                                                                        : '',
                                                                    style: const TextStyle(
                                                                        height: 1.5, // 设置行高为字体大小的1.5倍
                                                                        color: Color.fromRGBO(0, 0, 0, 1),
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.normal),
                                                                  )
                                                                ],
                                                              )),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          (isRichTextGreaterThanLines(
                                                                  storeEquipmentInModelList[
                                                                          modelIndex]
                                                                      .description,
                                                                  12,
                                                                  mediaQuerySizeInfo
                                                                          .width -
                                                                      24)
                                                              ? GestureDetector(
                                                                  onTap:
                                                                      handleChangeDescriptionReadMore,
                                                                  child: (!descriptionReadMore
                                                                      ? const Text(
                                                                          '阅读更多...',
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(211, 66, 67, 1),
                                                                              fontSize: 14),
                                                                        )
                                                                      : const Text(
                                                                          '收起',
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(211, 66, 67, 1),
                                                                              fontSize: 14),
                                                                        )),
                                                                )
                                                              : const SizedBox
                                                                  .shrink()),
                                                        ],
                                                      ),
                                                    ))
                                              ]),
                                        ),
                                      )
                                    ])),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                child: Column(
                                  children: List.generate(longFigureList.length,
                                      (index) {
                                    return GestureDetector(
                                      onTap: () => open(context, index),
                                      child: SizedBox(
                                        width: mediaQuerySizeInfo.width - 24,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${globalController.cdnBaseUrl}/${longFigureList[index]}',
                                          width: mediaQuerySizeInfo.width - 24,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            )
                          ],
                        )),
                        (storeEquipmentDetail.id.isNotEmpty
                            ? Column(
                                children: [
                                  const Divider(
                                    height: 2,
                                    color: Color.fromRGBO(233, 234, 235, 1),
                                  ),
                                  Container(
                                    width: mediaQuerySizeInfo.width,
                                    padding: EdgeInsets.fromLTRB(0, 16, 0,
                                        16 + mediaQuerySafeInfo.bottom),
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ScaleButton(
                                          onTab: handleAddToChart,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: const BoxDecoration(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(18))),
                                            child: Center(
                                              child: IconFont(
                                                IconNames.gouwuche,
                                                size: 24,
                                                color: '#fff',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 36,
                                          height: 36,
                                        ),
                                        storeEquipmentInModelList.isNotEmpty &&
                                                storeEquipmentInModelList[
                                                            modelIndex]
                                                        .inventory <=
                                                    0
                                            ? Container(
                                                height: 36,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 0),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        244, 244, 245, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                18))),
                                                child: const Center(
                                                  child: Text(
                                                    '库存不足无法购买',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            188, 190, 194, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: handleGoToOrder,
                                                child: Container(
                                                  height: 36,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 12, 0),
                                                  decoration:
                                                      const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  211,
                                                                  66,
                                                                  67,
                                                                  1),
                                                              Color.fromRGBO(
                                                                  211,
                                                                  66,
                                                                  67,
                                                                  0.8),
                                                              Color.fromRGBO(
                                                                  211,
                                                                  66,
                                                                  67,
                                                                  0.6)
                                                            ], // 渐变的起始和结束颜色
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          18))),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        '立即购买',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                      (totalCount ==
                                                              totalDiscount
                                                          ? Text(
                                                              '¥$totalCount',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              '¥$totalCount',
                                                              style: const TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationThickness:
                                                                      2,
                                                                  decorationColor:
                                                                      Color.fromRGBO(
                                                                          200,
                                                                          200,
                                                                          200,
                                                                          1),
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          200,
                                                                          200,
                                                                          200,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      (totalCount !=
                                                              totalDiscount
                                                          ? Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 12,
                                                                  height: 12,
                                                                ),
                                                                Text(
                                                                  '¥$totalDiscount',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            )
                                                          : const SizedBox
                                                              .shrink())
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink())
                      ],
                    )
                  : const SizedBox.shrink()),
            ],
          )),
    );
  }
}
