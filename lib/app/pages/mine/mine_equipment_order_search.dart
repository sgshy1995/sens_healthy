import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../iconfont/icon_font.dart';
import '../../../components/keep_alive_wrapper.dart';
import '../../controllers/store_controller.dart';
import '../../controllers/user_controller.dart';
import '../../providers/api/store_client_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import './mine_equipment_order_in.dart';

class MineEquipmentOrderSearchPage extends StatefulWidget {
  const MineEquipmentOrderSearchPage({super.key});
  @override
  State<MineEquipmentOrderSearchPage> createState() =>
      _MineEquipmentOrderSearchPageState();
}

class _MineEquipmentOrderSearchPageState
    extends State<MineEquipmentOrderSearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MineEquipmentOrderInPageState>
      _mineEquipmentOrderInPageState =
      GlobalKey<MineEquipmentOrderInPageState>();
  final StoreClientProvider storeClientProvider =
      Get.put(StoreClientProvider());
  final StoreController storeController = Get.put(StoreController());
  final UserController userController = Get.put(UserController());

  bool ifHasRebuy = false;

  int chartNum = 0;

  void handleGoBack() {
    Get.back(result: ifHasRebuy ? 'rebuy' : 'success');
  }

  void handleSearch({bool ifSetToHistory = true}) async {
    if (ifSetToHistory &&
        searchContentValue != null &&
        searchContentValue!.isNotEmpty &&
        !searchHistoryList.contains(searchContentValue)) {
      setState(() {
        searchHistoryList.insert(0, searchContentValue!);
        storeController
            .pushStoreEquipmentOrderSearchHistory(searchContentValue!);
        prefs.setStringList(
            'store_equipment_order_search_history', searchHistoryList);
      });
    }

    if (!_readySearch) {
      setState(() {
        _readySearch = true;
      });
    } else {
      setState(() {
        _mineEquipmentOrderInPageState.currentState?.readyLoad = false;
        _mineEquipmentOrderInPageState.currentState?.initPagination();
        _mineEquipmentOrderInPageState.currentState?.keywordGet =
            searchContentValue ?? '';
        _mineEquipmentOrderInPageState.currentState?.onRefresh();
      });
    }
  }

  final FocusNode _focusNode = FocusNode();

  final TextEditingController _textController = TextEditingController();
  List<String> searchHistoryList = [];
  bool _readySearch = false;
  bool inputEnabled = true;
  String? searchContentValue;
  late SharedPreferences prefs;

  void getHistoryList() async {
    // Obtain shared preferences.
    prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    List<String>? searchHistoryListGet =
        prefs.getStringList('store_equipment_order_search_history');
    if (searchHistoryListGet != null) {
      storeController.setStoreEquipmentOrderSearchHistory(searchHistoryList);
      setState(() {
        searchHistoryList = searchHistoryListGet;
      });
    }
  }

  void clearHistoryList() async {
    await prefs.remove('store_equipment_order_search_history');
    storeController.setStoreEquipmentOrderSearchHistory([]);
    setState(() {
      searchHistoryList = [];
    });
  }

  void changeSearchContent(String? value) {
    setState(() {
      searchContentValue = value;
    });
  }

  void handleChooseHistory(String item) {
    _textController.text = item;
    changeSearchContent(item);
    handleSearch(ifSetToHistory: false);
  }

  void showDetailCallback() {
    setState(() {
      _mineEquipmentOrderInPageState.currentState?.readyLoad = false;
      _mineEquipmentOrderInPageState.currentState?.initPagination();

      _mineEquipmentOrderInPageState.currentState?.onRefresh();
    });
  }

  void rebuyCallback() {
    setState(() {
      ifHasRebuy = true;
    });
    showDetailCallback();
  }

  @override
  void initState() {
    super.initState();
    getHistoryList();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
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
                            SizedBox(
                              height: mediaQuerySafeInfo.top + 12 + 36 + 12,
                            ),
                            Expanded(
                              child: MineEquipmentOrderInPage(
                                key: _mineEquipmentOrderInPageState,
                                keyword: searchContentValue,
                                showDetailCallback: showDetailCallback,
                                rebuyCallback: rebuyCallback,
                                userId: userController.userInfo.id,
                              ),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: searchHistoryList.isNotEmpty
                                              ? InkWell(
                                                  onTap: clearHistoryList,
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shanchu,
                                                      size: 24,
                                                      color: 'rgb(0,0,0)',
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    searchHistoryList.isNotEmpty
                                        ? Wrap(
                                            spacing: 8.0, // 间距
                                            runSpacing: 4.0, // 行间距
                                            children: List.generate(
                                                searchHistoryList.length,
                                                (index) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    handleChooseHistory(
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
                                          )
                                        : Container(
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
                                                    '暂无搜索历史',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            224, 222, 223, 1),
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 12,
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
                                    handleSearch();
                                  },
                                  autofocus:
                                      true, // 设置为 true，使 TextField 自动获取焦点
                                  focusNode: _focusNode,
                                  onTapOutside: (PointerDownEvent p) {
                                    // 点击外部区域时取消焦点
                                    _focusNode.unfocus();
                                  },
                                  controller: _textController,
                                  maxLines: 1,
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
                                    hintText: '搜索您的订单信息 ...',
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
                                    handleSearch();
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
        ]),
      ),
    );
  }
}
