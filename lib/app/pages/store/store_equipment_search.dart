import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import './store_equipment_in.dart';

class StoreEquipmentSearchPage extends StatefulWidget {
  const StoreEquipmentSearchPage({super.key});
  @override
  State<StoreEquipmentSearchPage> createState() =>
      _StoreEquipmentSearchPageState();
}

class _StoreEquipmentSearchPageState extends State<StoreEquipmentSearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<StoreEquipmentInPageState> _storeEquipmentInPageState =
      GlobalKey<StoreEquipmentInPageState>();
  final StoreClientProvider storeClientProvider =
      GetInstance().find<StoreClientProvider>();
  final StoreController storeController = GetInstance().find<StoreController>();

  int chartNum = 0;

  void handleGoToSearch() {}

  void handleGoToChart() {
    Get.toNamed('store_equipment_chart');
  }

  void loadChartsNum() {
    storeClientProvider.getEquipmentChartListAction().then((value) {
      storeController.setStoreEquipmentChartNum(
          value.data != null ? value.data!.length : 0);
    });
  }

  void handleGoBack() {
    Get.back();
  }

  void handleSearch(BuildContext context, {bool ifSetToHistory = true}) async {
    if (FocusScope.of(_scaffoldKey.currentContext!).hasFocus) {
      FocusScope.of(_scaffoldKey.currentContext!).unfocus();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (FocusScope.of(_scaffoldKey.currentContext!).hasFocus) {
        FocusScope.of(_scaffoldKey.currentContext!).unfocus();
      }
    });

    if (ifSetToHistory &&
        searchContentValue != null &&
        searchContentValue!.isNotEmpty &&
        !searchHistoryList.contains(searchContentValue)) {
      setState(() {
        searchHistoryList.insert(0, searchContentValue!);
        storeController.pushStoreEquipmentSearchHistory(searchContentValue!);
        prefs.setStringList(
            'store_equipment_search_history', searchHistoryList);
      });
    }

    if (!_readySearch) {
      setState(() {
        _readySearch = true;
      });
    } else {
      setState(() {
        _storeEquipmentInPageState.currentState?.readyLoad = false;
        _storeEquipmentInPageState.currentState?.initPagination();
        _storeEquipmentInPageState.currentState?.keywordGet =
            searchContentValue ?? '';
        _storeEquipmentInPageState.currentState?.onRefresh();
      });
    }
  }

  final TextEditingController _textController = TextEditingController();
  List<String> searchHistoryList = [];
  bool _readySearch = false;
  bool inputEnabled = true;
  String? searchContentValue;
  late SharedPreferences prefs;

  final List<String> searchWantList = [
    '哑铃',
    '弹力绳',
    '平衡球',
    '瑜伽垫',
    '体操球',
    '体力车',
    '步态训练器',
    '平衡板',
    '抗阻带',
    '椭圆机',
    '平衡垫',
    '体力球',
    '抗阻器械',
    '康复轮椅',
    '泡沫滚筒',
    '肌力训练器',
    '平衡训练器',
    '抗重训练器',
    '徒手器械'
  ];

  void getHistoryList() async {
    // Obtain shared preferences.
    prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    List<String>? searchHistoryListGet =
        prefs.getStringList('store_equipment_search_history');
    if (searchHistoryListGet != null) {
      storeController.setStoreEquipmentSearchHistory(searchHistoryList);
      setState(() {
        searchHistoryList = searchHistoryListGet;
      });
    }
  }

  void clearHistoryList() async {
    await prefs.remove('store_equipment_search_history');
    storeController.setStoreEquipmentSearchHistory([]);
    setState(() {
      searchHistoryList = [];
    });
  }

  void changeSearchContent(String? value) {
    setState(() {
      searchContentValue = value;
    });
  }

  void handleChooseHistory(BuildContext context, String item) {
    _textController.text = item;
    changeSearchContent(item);
    handleSearch(context, ifSetToHistory: false);
  }

  @override
  void initState() {
    super.initState();
    getHistoryList();
    loadChartsNum();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: _readySearch
            ? const Color.fromRGBO(254, 251, 254, 1)
            : Colors.white,
        child: Stack(children: [
          Column(
            children: [
              // 使用 AnimatedOpacity 来动态改变透明度
              (_readySearch
                  ? Expanded(
                      child: Stack(children: [
                        Column(
                          children: [
                            // 使用 AnimatedOpacity 来动态改变透明度
                            Expanded(
                              child: StoreEquipmentInPage(
                                  ifUseCarousel: false,
                                  key: _storeEquipmentInPageState,
                                  keyword: searchContentValue),
                            )
                          ],
                        ),
                      ]),
                    )
                  : Expanded(
                      child: Column(
                      children: [
                        Container(
                          height: mediaQuerySafeInfo.top + 12 + 36 + 12,
                          color: Colors.white,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                            child: Column(
                              children: [
                                (searchHistoryList.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '搜索历史',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: InkWell(
                                                  onTap: clearHistoryList,
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shanchu,
                                                      size: 24,
                                                      color: 'rgb(0,0,0)',
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Wrap(
                                            spacing: 8.0, // 间距
                                            runSpacing: 4.0, // 行间距
                                            children: List.generate(
                                                searchHistoryList.length,
                                                (index) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    handleChooseHistory(
                                                        context,
                                                        searchHistoryList[
                                                            index]),
                                                child: Chip(
                                                  side: BorderSide.none,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          233, 234, 235, 1),
                                                  labelStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                  label: Text(
                                                      searchHistoryList[index]),
                                                ),
                                              );
                                            }),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      )
                                    : const SizedBox.shrink()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '猜你想搜',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          child: InkWell(
                                            onTap: clearHistoryList,
                                            child: Center(
                                              child: IconFont(
                                                IconNames.cainixihuan,
                                                size: 24,
                                                color: 'rgb(195,77,73)',
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Wrap(
                                      spacing: 8.0, // 间距
                                      runSpacing: 4.0, // 行间距
                                      children: List.generate(
                                          searchWantList.length, (index) {
                                        return GestureDetector(
                                          onTap: () => handleChooseHistory(
                                              context, searchWantList[index]),
                                          child: Chip(
                                            side: BorderSide.none,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    233, 234, 235, 1),
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            label: Text(searchWantList[index]),
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    )))
            ],
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Visibility(
                  visible: true,
                  child: Column(
                    children: [
                      Container(
                        height: 36 + mediaQuerySafeInfo.top + 12,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: Container(
                          height: 36 + mediaQuerySafeInfo.top + 12,
                          padding: EdgeInsets.fromLTRB(
                              12, mediaQuerySafeInfo.top + 12, 12, 0),
                          decoration: null,
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 18),
                                child: GestureDetector(
                                  onTap: handleGoBack,
                                  child: Center(
                                    child: IconFont(
                                      IconNames.fanhui,
                                      size: 20,
                                      color: 'rgb(0,0,0)',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromRGBO(233, 234, 235, 1)),
                                child: TextField(
                                  onSubmitted: (String value) {
                                    // 在用户按下确定键或完成输入时调用
                                    // 点击外部区域时取消焦点
                                    handleSearch(context);
                                  },
                                  autofocus:
                                      true, // 设置为 true，使 TextField 自动获取焦点
                                  enabled: inputEnabled,
                                  controller: _textController,
                                  maxLines: 6,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: const TextStyle(
                                    fontSize: 15, // 设置字体大小为20像素
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 15),
                                    fillColor:
                                        const Color.fromRGBO(233, 234, 235, 1),
                                    filled: true, // 使用图标
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(233, 234, 235, 1)),
                                      borderRadius:
                                          BorderRadius.circular(4), // 设置圆角大小
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(233, 234, 235, 1)),
                                      borderRadius:
                                          BorderRadius.circular(10), // 设置圆角大小
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // 聚焦状态下边框样式
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(233, 234, 235, 1)),
                                      borderRadius:
                                          BorderRadius.circular(4), // 设置圆角大小
                                    ),
                                    hintText: '搜索您感兴趣的 ...',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 12.0), // 增加垂直内边距来增加高度
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20)
                                  ],
                                  keyboardType: TextInputType.text,
                                  onChanged: changeSearchContent,
                                ),
                              )),
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(left: 18),
                                child: InkWell(
                                  onTap: () {
                                    // 点击外部区域时取消焦点
                                    handleSearch(context);
                                  },
                                  child: Center(
                                    child: IconFont(
                                      IconNames.sousuo,
                                      size: 20,
                                      color: 'rgb(0,0,0)',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: _readySearch ? 12 : 0,
                        color: Colors.white,
                      ),
                      (_readySearch
                          ? const Divider(
                              height: 2,
                              color: Color.fromRGBO(243, 243, 244, 1),
                            )
                          : const SizedBox.shrink())
                    ],
                  ))),
          (_readySearch
              ? Positioned(
                  bottom: 24,
                  right: 24,
                  child: InkWell(
                    onTap: handleGoToChart,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(158, 158, 158, 0.3),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Color.fromRGBO(211, 66, 67, 1),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Center(
                        child: IconFont(
                          IconNames.gouwuche,
                          size: 24,
                          color: 'rgb(255,255,255)',
                        ),
                      ),
                    ),
                  ))
              : const SizedBox.shrink()),
          (_readySearch
              ? (Obx(() => storeController.storeEquipmentChartNum > 0
                  ? Positioned(
                      bottom: 56,
                      right: 18,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        child: Center(
                          child: Text(
                            '${storeController.storeEquipmentChartNum.value}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()))
              : const SizedBox.shrink())
        ]),
      ),
    );
  }
}
