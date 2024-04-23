import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/user_client_provider.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import '../../models/store_model.dart';
import '../../models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/data_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './mine_address_publish.dart';

class MineAddressPage extends StatefulWidget {
  const MineAddressPage({super.key});

  @override
  State<MineAddressPage> createState() => _MineAddressPageState();
}

class _MineAddressPageState extends State<MineAddressPage>
    with TickerProviderStateMixin {
  // 创建一个滚动控制器
  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();
  final UserController userController = GetInstance().find<UserController>();
  final StoreController storeController = GetInstance().find<StoreController>();
  bool _readyLoad = false;

  late final bool ifCanSelect;

  late final String? selectId;

  /* RefreshController */
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  double _scrollDistance = 0.0;

  List<AddressInfoTypeModel> addressList = [];

  late AnimationController _RotateController;
  late Animation<double> _animation;

  double _rotationAngle = 0;
  double _headerTriggerDistance = 60;

  List<bool> addressCheckList = [];

  void handleGoBack() {
    Get.back();
  }

  Future<String> getAddressesList() {
    Completer<String> completer = Completer();

    userClientProvider.getAddressListByJWTAction().then((result) {
      List<bool> addressCheckListGet = [];
      List<AddressInfoTypeModel> addressListGet = result.data ?? [];
      List.generate(addressListGet.length, (index) {
        addressCheckListGet.add(selectId == null
            ? userController.info.default_address_id == addressListGet[index].id
            : selectId == addressListGet[index].id);
      });
      setState(() {
        _readyLoad = true;
        addressList = [...addressListGet];
        addressCheckList = [...addressCheckListGet];
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
      result = await getAddressesList();
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

  void handleGoToPublish({Map? form}) {
    Get.toNamed('mine_address_publish', arguments: {'form': form})!
        .then((value) {
      if (value == 'success') {
        _onRefresh();
      }
    });
    // Get.to(
    //   PainQuestionPublishPage(),
    //   transition: Transition.downToUp,
    // );
  }

  void handleCheckItem(bool? newValue, int index) {
    if (addressCheckList[index]) {
      return;
    }

    List<bool> addressCheckListGet =
        List.generate(addressCheckList.length, (index) => false);
    addressCheckListGet[index] = true;
    setState(() {
      addressCheckList = [...addressCheckListGet];
    });

    Get.back<AddressInfoTypeModel?>(result: addressList[index]);
  }

  void handleConfirmDelete(int index) {
    showLoading('请稍后...');

    userClientProvider
        .deleteAddressByIdAction(addressList[index].id)
        .then((result) {
      if (result.code == 200) {
        userClientProvider.getInfoByJWTAction().then((resultIn) {
          if (resultIn.code == 200 && resultIn.data != null) {
            userController.setInfo(resultIn.data!);
            getAddressesList().then((value) {
              hideLoading();
              if (value != 'success') {
                showToast('操作失败, 请稍后再试');
              }
            });
          } else {
            hideLoading();
            showToast(resultIn.message);
          }
        }).catchError((e) {
          hideLoading();
          showToast('操作失败, 请稍后再试');
        });
      }
    });
  }

  void handleSetDefaultItem(int index) {
    if (userController.info.default_address_id == addressList[index].id) {
      return;
    }
    showLoading('请稍后...');

    userClientProvider.updateInfoByJwtAction(
        {'default_address_id': addressList[index].id}).then((result) {
      if (result.code == 200) {
        userClientProvider.getInfoByJWTAction().then((resultIn) {
          if (resultIn.code == 200 && resultIn.data != null) {
            userController.setInfo(resultIn.data!);
            getAddressesList().then((value) {
              hideLoading();
              if (value != 'success') {
                showToast('操作失败, 请稍后再试');
              }
            });
          } else {
            hideLoading();
            showToast(resultIn.message);
          }
        }).catchError((e) {
          hideLoading();
          showToast('操作失败, 请稍后再试');
        });
      }
    });
  }

  void handleEditItem(int index) {
    Map<String, dynamic> form = {
      'addressId': addressList[index].id,
      'userId': addressList[index].user_id,
      'addressName': addressList[index].name,
      'addressPhone': addressList[index].phone,
      'detailText': addressList[index].detail_text,
      'addressInputLocation': addressList[index]
          .all_text
          .substring(addressList[index].detail_text.length),
      'provinceCode': addressList[index].province_code,
      'cityCode': addressList[index].city_code,
      'areaCode': addressList[index].area_code,
      'choosedTag': addressList[index].tag
    };
    handleGoToPublish(form: form);
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
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
                  const Text(
                    '您确定要删除该地址吗？',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
                onPressed: () {
                  // 点击确认按钮时执行的操作
                  Navigator.of(context).pop();
                  // 在这里执行你的操作
                  handleConfirmDelete(index);
                },
                child: const Text(
                  '确认',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
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
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 1), width: 1)))),
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
      },
    );
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
                  (index) => Container(
                        height: 120,
                        width: mediaQuerySizeInfo.width,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromRGBO(229, 229, 229, 1),
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: mediaQuerySizeInfo.width - 24,
                            height: 120 - 24,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.white,
                            ),
                          ),
                        ),
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
              const Text('地址管理',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 36,
                height: 24,
                child: GestureDetector(
                  onTap: handleGoToPublish,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '添加',
                      style: TextStyle(
                          color: Color.fromRGBO(211, 66, 67, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
            enablePullUp: false,
            header: CustomHeader(
                builder: buildHeader,
                onOffsetChange: (offset) {
                  //do some ani
                }),
            onRefresh: _onRefresh,
            child: CustomScrollView(controller: _scrollController, slivers: [
              SliverToBoxAdapter(
                child: (addressList.isEmpty && _readyLoad)
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
                                '您还没有添加地址',
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
                      childCount: addressList.length, (context, index) {
                return Slidable(
                  key: ValueKey(addressList[index].id),
                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    extentRatio: 0.8,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        onPressed: (BuildContext context) =>
                            handleSetDefaultItem(index),
                        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
                        foregroundColor: Colors.white,
                        icon: Icons.favorite,
                        label: '设为默认',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) =>
                            handleEditItem(index),
                        backgroundColor: const Color.fromRGBO(97, 113, 177, 1),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: '编辑',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) =>
                            showDeleteDialog(index),
                        backgroundColor: const Color.fromRGBO(254, 32, 52, 1),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '删除',
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: ifCanSelect
                            ? () => handleCheckItem(true, index)
                            : null,
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ifCanSelect
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            right: 12, top: 0),
                                        width: 32,
                                        height: 32,
                                        child: Checkbox(
                                          side: const BorderSide(
                                              color: Colors.black),
                                          fillColor: ((selectId == null &&
                                                      addressList[index].id ==
                                                          userController.info
                                                              .default_address_id) ||
                                                  (selectId != null &&
                                                      addressList[index].id ==
                                                          selectId))
                                              ? MaterialStateProperty.all(
                                                  Colors.black)
                                              : MaterialStateProperty.all(
                                                  Colors.transparent),
                                          checkColor: Colors.white,
                                          value: addressCheckList[index],
                                          onChanged: (bool? newValue) =>
                                              handleCheckItem(newValue, index),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              addressList[index].name,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                              width: 12,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 16,
                                                  height: 16,
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.phone_fill,
                                                      size: 16,
                                                      color: '#000',
                                                    ),
                                                  ),
                                                ),
                                                Text(addressList[index].phone,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                              width: 12,
                                            ),
                                            (addressList[index].tag != null
                                                ? Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(6, 0, 6, 0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black)),
                                                    child: Text(
                                                      addressList[index].tag!,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    ),
                                                  )
                                                : const SizedBox.shrink())
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              margin: const EdgeInsets.only(
                                                  right: 4, top: 2),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.dizhi_fill,
                                                  size: 16,
                                                  color: '#000',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: RichText(
                                                    maxLines: 99,
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: addressList[index]
                                                            .all_text,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 14))))
                                          ],
                                        )
                                      ],
                                    ),
                                    (addressList[index].id ==
                                            userController
                                                .info.default_address_id
                                        ? Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              width: 44,
                                              height: 44,
                                              margin: const EdgeInsets.only(
                                                  right: 0),
                                              child: Center(
                                                child: IconFont(
                                                  IconNames.moren_fill,
                                                  size: 44,
                                                  color: '#000',
                                                ),
                                              ),
                                            ))
                                        : const SizedBox.shrink())
                                  ],
                                ))
                              ],
                            )),
                      ),
                      (index != addressList.length - 1
                          ? const Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Divider(
                                height: 2,
                                color: Color.fromRGBO(233, 234, 235, 1),
                              ),
                            )
                          : const SizedBox.shrink())
                    ],
                  ),
                );
              }))
            ])),
      ))
    ]));
  }
}
