import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../iconfont/icon_font.dart';
import '../../models/prescription_model.dart';
import '../../providers/api/prescription_client_provider.dart';
import './prescription_section.dart';
import './prescription_body.dart';
import '../../../components/keep_alive_wrapper.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});
  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<PrescriptionBodyState> _prescriptionBodyState =
      GlobalKey<PrescriptionBodyState>();
  final GlobalController globalController = Get.put(GlobalController());
  final PrescriptionClientProvider prescriptionClientProvider =
      Get.put(PrescriptionClientProvider());
  final UserController userController = Get.put(UserController());
  late TabController _tabController;

  String? rehabilitationOne;
  String? rehabilitationTwo;
  String? rehabilitationThree;

  String? rehabilitation;
  String? part;
  String? symptoms;
  String? phase;

  String? rehabilitationShow;
  String? partShow;
  String? symptomsShow;
  String? phaseShow;

  final List<String> tabsList = ['热门', '最新', '', '', ''];

  void handleClearSelect() {
    setState(() {
      rehabilitation = null;
      part = null;
      symptoms = null;
      phase = null;
      rehabilitationShow = null;
      partShow = null;
      symptomsShow = null;
      phaseShow = null;
    });
  }

  void _handleTabSelection() {
    // 在这里处理标签的点击事件
  }

  List<PrescriptionTagTypeModel> prescriptionTagList = [];

  void loadData() {
    prescriptionClientProvider.findManyPrescriptionTagsAction().then((result) {
      final List<PrescriptionTagTypeModel> prescriptionTagListGet =
          result.data!;
      setState(() {
        prescriptionTagList = prescriptionTagListGet;
      });
      final List<PrescriptionTagTypeModel> prescriptionTagListGetRoot =
          prescriptionTagListGet.where((i) => i.parent_id == '0').toList();
      prescriptionTagListGetRoot
          .sort((a, b) => a.priority.compareTo(b.priority));
      if (prescriptionTagListGetRoot.isNotEmpty) {
        setState(() {
          tabsList[2] = prescriptionTagListGetRoot[0].title;
          rehabilitationOne = prescriptionTagListGetRoot[0].id;
        });
      }
      if (prescriptionTagListGetRoot.length > 1) {
        setState(() {
          tabsList[3] = prescriptionTagListGetRoot[1].title;
          rehabilitationTwo = prescriptionTagListGetRoot[1].id;
        });
      }
      if (prescriptionTagListGetRoot.length > 2) {
        setState(() {
          tabsList[4] = prescriptionTagListGetRoot[2].title;
          rehabilitationThree = prescriptionTagListGetRoot[2].id;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showSectionPage() {
    Navigator.push<Map<String, dynamic>>(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PrescriptionSectionPage(
                rehabilitation: rehabilitation,
                part: part,
                symptoms: symptoms,
                phase: phase,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              )
                  .chain(CurveTween(curve: Curves.easeInOut))
                  .animate(curvedAnimation),
              child: child,
            );
          }),
    ).then((value) {
      if (value != null) {
        print(value);
        if (rehabilitation != null ||
            part != null ||
            symptoms != null ||
            phase != null) {
          _prescriptionBodyState.currentState?.readyLoad = false;
          _prescriptionBodyState.currentState?.initPagination();
          _prescriptionBodyState.currentState?.rehabilitationGet =
              value['rehabilitation'];
          _prescriptionBodyState.currentState?.partGet = value['part'];
          _prescriptionBodyState.currentState?.symptomsGet = value['symptoms'];
          _prescriptionBodyState.currentState?.phaseGet = value['phase'];
          _prescriptionBodyState.currentState?.onRefresh();
        }
        setState(() {
          rehabilitation = value['rehabilitation'];
          rehabilitationShow = value['rehabilitationShow'];
          part = value['part'];
          partShow = value['partShow'];
          symptoms = value['symptoms'];
          symptomsShow = value['symptomsShow'];
          phase = value['phase'];
          phaseShow = value['phaseShow'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ((part == null && symptoms == null && phase == null)
              ? Container(
                  height: 36 + mediaQuerySafeInfo.top + 12,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Container(
                    height: 36 + mediaQuerySafeInfo.top + 12,
                    padding: EdgeInsets.fromLTRB(
                        12, mediaQuerySafeInfo.top + 12, 12, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(243, 243, 244, 1), // 底部边框颜色
                          width: 0, // 底部边框宽度
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(233, 234, 235, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: InkWell(
                            onTap: showSectionPage,
                            child: Center(
                              child: Row(
                                children: [
                                  IconFont(IconNames.fenlei, size: 20),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('精准定位',
                                        style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          ((rehabilitation == null &&
                  part == null &&
                  symptoms == null &&
                  phase == null)
              ? Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      height: 50,
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.all(0),
                        isScrollable: true, // 设置为true以启用横向滚动
                        onTap: (index) {
                          if (index == 1) {
                            // 切换时滚动到顶部
                            //_painQuestionPageState.currentState?.scrollToTop();
                          }
                        },
                        indicatorPadding: EdgeInsets.zero, // 设置指示器的内边距为零
                        indicator: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(211, 66, 67, 1), // 底部边框颜色
                              width: 3, // 底部边框宽度
                            ),
                          ),
                        ),
                        unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 1),
                        labelColor: const Color.fromRGBO(211, 66, 67, 1),
                        indicatorColor: const Color.fromRGBO(211, 66, 67, 1),
                        controller: _tabController,
                        tabs: List.generate(tabsList.length, (index) {
                          return tabsList[index].isNotEmpty
                              ? Tab(
                                  child: index == 0
                                      ? Row(
                                          children: [
                                            Container(
                                              width: 18,
                                              height: 18,
                                              margin: const EdgeInsets.only(
                                                  right: 4),
                                              child: GestureDetector(
                                                child: Center(
                                                  child: IconFont(IconNames.hot,
                                                      size: 18,
                                                      color:
                                                          'rgb(211, 66, 67)'),
                                                ),
                                              ),
                                            ),
                                            Text(tabsList[index])
                                          ],
                                        )
                                      : Text(tabsList[index]),
                                )
                              : const SizedBox.shrink();
                        }),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(243, 243, 244, 1),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          const KeepAliveWrapper(
                              child: PrescriptionBody(
                            hotOrder: 1,
                          )),
                          const KeepAliveWrapper(child: PrescriptionBody()),
                          rehabilitationOne != null
                              ? KeepAliveWrapper(
                                  child: PrescriptionBody(
                                  rehabilitation: rehabilitationOne,
                                ))
                              : const SizedBox.shrink(),
                          rehabilitationTwo != null
                              ? KeepAliveWrapper(
                                  child: PrescriptionBody(
                                  rehabilitation: rehabilitationTwo,
                                ))
                              : const SizedBox.shrink(),
                          rehabilitationThree != null
                              ? KeepAliveWrapper(
                                  child: PrescriptionBody(
                                  rehabilitation: rehabilitationThree,
                                ))
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ))
              : Expanded(
                  child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.fromLTRB(
                          12, 12 + mediaQuerySafeInfo.top, 12, 12),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color.fromRGBO(233, 234, 235, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('已选择',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 13,
                                    )),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: showSectionPage,
                              child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: phaseShow != null
                                            ? '$rehabilitationShow / $partShow / $symptomsShow / $phaseShow'
                                            : symptomsShow != null
                                                ? '$rehabilitationShow / $partShow / $symptomsShow'
                                                : partShow != null
                                                    ? '$rehabilitationShow / $partShow'
                                                    : '$rehabilitationShow',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  )),
                            )),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: handleClearSelect,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          child: Center(
                                            child: IconFont(IconNames.guanbi,
                                                size: 12,
                                                color: 'rgb(255, 255, 255)'),
                                          ),
                                        ),
                                        const Text('清空',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(243, 243, 244, 1),
                    ),
                    Expanded(
                        child: KeepAliveWrapper(
                            child: PrescriptionBody(
                      key: _prescriptionBodyState,
                      rehabilitation: rehabilitation,
                      part: part,
                      symptoms: symptoms,
                      phase: phase,
                    )))
                  ],
                )))
        ],
      ),
    );
  }
}
