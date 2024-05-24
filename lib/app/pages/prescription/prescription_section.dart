import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../components/slide_transition_x.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../iconfont/icon_font.dart';
import '../../models/data_model.dart';
import '../../models/prescription_model.dart';
import '../../providers/api/prescription_client_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrescriptionSectionPage extends StatefulWidget {
  final String? rehabilitation;
  final String? part;
  final String? symptoms;
  final String? phase;
  const PrescriptionSectionPage(
      {super.key, this.rehabilitation, this.part, this.symptoms, this.phase});

  @override
  State<PrescriptionSectionPage> createState() =>
      _PrescriptionSectionPageState();
}

class _PrescriptionSectionPageState extends State<PrescriptionSectionPage> {
  final PrescriptionClientProvider prescriptionClientProvider =
      Get.put(PrescriptionClientProvider());

  late String? rehabilitationGet;
  late String? partGet;
  late String? symptomsGet;
  late String? phaseGet;

  List<PrescriptionTagTypeModel> rehabilitationList = [];

  List<PrescriptionTagTypeModel> partList = [];

  List<PrescriptionTagTypeModel> symptomsList = [];

  List<PrescriptionTagTypeModel> phaseList = [];

  bool canConfirmCheck = false;

  int stepIndex = 0;

  void handleChooseRehabilitation(PrescriptionTagTypeModel item) {
    setState(() {
      rehabilitationGet = item.id;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      handleNextStep();
    });
  }

  void handleChoosePart(PrescriptionTagTypeModel item) {
    setState(() {
      partGet = item.id;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      handleNextStep();
    });
  }

  void handleChooseSymptoms(PrescriptionTagTypeModel item) {
    setState(() {
      symptomsGet = item.id;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      handleNextStep();
    });
  }

  void handleChoosePhase(PrescriptionTagTypeModel item) {
    setState(() {
      phaseGet = item.id;
    });
    checkIfCanPublish();
  }

  void checkIfCanPublish() {
    bool canConfirmCheckGet = true;
    //是否可以继续选择部位
    if (stepIndex == 0 &&
        (rehabilitationGet == null ||
            prescriptionTagList
                .where((i) => i.parent_id == rehabilitationGet)
                .toList()
                .isNotEmpty)) {
      canConfirmCheckGet = false;
    }
    //是否可以继续选择问题
    else if (stepIndex == 1 &&
        (partGet == null ||
            prescriptionTagList
                .where((i) => i.parent_id == partGet)
                .toList()
                .isNotEmpty)) {
      canConfirmCheckGet = false;
    }
    //是否可以继续选择阶段
    else if (stepIndex == 2 &&
        (symptomsGet == null ||
            prescriptionTagList
                .where((i) => i.parent_id == symptomsGet)
                .toList()
                .isNotEmpty)) {
      canConfirmCheckGet = false;
    }

    setState(() {
      canConfirmCheck = canConfirmCheckGet;
    });
  }

  void handleNextStep() {
    if (stepIndex == 0 &&
        prescriptionTagList
            .where((i) => i.parent_id == rehabilitationGet)
            .toList()
            .isNotEmpty) {
      setState(() {
        stepIndex = 1;
        partList = prescriptionTagList
            .where((i) => i.parent_id == rehabilitationGet)
            .toList();
        partList.sort((a, b) => a.priority.compareTo(b.priority));
      });
    } else if (stepIndex == 1 &&
        prescriptionTagList
            .where((i) => i.parent_id == partGet)
            .toList()
            .isNotEmpty) {
      setState(() {
        stepIndex = 2;
        symptomsList =
            prescriptionTagList.where((i) => i.parent_id == partGet).toList();
        symptomsList.sort((a, b) => a.priority.compareTo(b.priority));
      });
    } else if (stepIndex == 2 &&
        prescriptionTagList
            .where((i) => i.parent_id == symptomsGet)
            .toList()
            .isNotEmpty) {
      setState(() {
        stepIndex = 3;
        phaseList = prescriptionTagList
            .where((i) => i.parent_id == symptomsGet)
            .toList();
        phaseList.sort((a, b) => a.priority.compareTo(b.priority));
      });
    }
    checkIfCanPublish();
  }

  void handlePreStep() {
    setState(() {
      stepIndex = stepIndex - 1;
    });
    if (stepIndex == 0) {
      setState(() {
        partGet = null;
      });
    } else if (stepIndex == 1) {
      setState(() {
        symptomsGet = null;
      });
    } else if (stepIndex == 2) {
      setState(() {
        phaseGet = null;
      });
    }
    checkIfCanPublish();
  }

  void handlePublish() {
    if (!canConfirmCheck) {
      return;
    }
    Get.back<Map<String, dynamic>>(result: {
      'rehabilitation': rehabilitationGet,
      'rehabilitationShow': rehabilitationGet != null
          ? prescriptionTagList[prescriptionTagList
                  .indexWhere((i) => i.id == rehabilitationGet)]
              .title
          : null,
      'part': partGet,
      'partShow': partGet != null
          ? prescriptionTagList[
                  prescriptionTagList.indexWhere((i) => i.id == partGet)]
              .title
          : null,
      'symptoms': symptomsGet,
      'symptomsShow': symptomsGet != null
          ? prescriptionTagList[
                  prescriptionTagList.indexWhere((i) => i.id == symptomsGet)]
              .title
          : null,
      'phase': phaseGet,
      'phaseShow': phaseGet != null
          ? prescriptionTagList[
                  prescriptionTagList.indexWhere((i) => i.id == phaseGet)]
              .title
          : null,
    });
  }

  bool readyLoad = false;

  List<PrescriptionTagTypeModel> prescriptionTagList = [];

  void loadData() {
    prescriptionClientProvider.findManyPrescriptionTagsAction().then((result) {
      final List<PrescriptionTagTypeModel> prescriptionTagListGet =
          result.data!;
      setState(() {
        prescriptionTagList = prescriptionTagListGet;
        rehabilitationList =
            prescriptionTagListGet.where((i) => i.parent_id == '0').toList();
        rehabilitationList.sort((a, b) => a.priority.compareTo(b.priority));
        if (rehabilitationGet != null) {
          partList = prescriptionTagListGet
              .where((i) => i.parent_id == rehabilitationGet)
              .toList();
          partList.sort((a, b) => a.priority.compareTo(b.priority));
        }
        if (partGet != null) {
          symptomsList = prescriptionTagListGet
              .where((i) => i.parent_id == partGet)
              .toList();
          symptomsList.sort((a, b) => a.priority.compareTo(b.priority));
        }
        if (symptomsGet != null) {
          phaseList = prescriptionTagListGet
              .where((i) => i.parent_id == symptomsGet)
              .toList();
          phaseList.sort((a, b) => a.priority.compareTo(b.priority));
        }
        readyLoad = true;
      });
      checkIfCanPublish();
    });
  }

  @override
  void initState() {
    super.initState();
    rehabilitationGet = widget.rehabilitation;
    partGet = widget.part;
    symptomsGet = widget.symptoms;
    phaseGet = widget.phase;
    if (phaseGet != null) {
      stepIndex = 3;
    } else if (symptomsGet != null) {
      stepIndex = 2;
    } else if (partGet != null) {
      stepIndex = 1;
    }
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleGoBack() {
    Get.back();
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
            Container(
              padding:
                  EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
              child: SizedBox(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    stepIndex == 0
                        ? GestureDetector(
                            onTap: handleGoBack,
                            child: SizedBox(
                              width: 56,
                              height: 24,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconFont(
                                  IconNames.fanhui,
                                  size: 24,
                                  color: '#000',
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: handlePreStep,
                            child: const SizedBox(
                              width: 56,
                              height: 24,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '上一步',
                                  style: TextStyle(
                                      color: Color.fromRGBO(211, 66, 67, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                    Text(
                        stepIndex == 0
                            ? '请选择复健类型'
                            : stepIndex == 1
                                ? '请选择部位'
                                : stepIndex == 2
                                    ? '请选择问题'
                                    : '请选择阶段',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    canConfirmCheck
                        ? (((stepIndex == 0 && rehabilitationGet != null) ||
                                (stepIndex == 1 && partGet != null) ||
                                (stepIndex == 2 && symptomsGet != null) ||
                                (stepIndex == 3 && phaseGet != null))
                            ? InkWell(
                                onTap: handlePublish,
                                child: const SizedBox(
                                  width: 56,
                                  height: 24,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '确定',
                                      style: TextStyle(
                                          color: Color.fromRGBO(211, 66, 67, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 56,
                                height: 24,
                                child: null,
                              ))
                        : const SizedBox(
                            width: 56,
                            height: 24,
                            child: null,
                          ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
              color: Color.fromRGBO(233, 234, 235, 1),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: !readyLoad
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              strokeWidth: 2),
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                SlideTransitionX(
                                  direction: AxisDirection.left, //右入左出
                                  position: animation,
                                  child: child,
                                ),
                        child: IndexedStack(
                            key: ValueKey<int>(stepIndex), // add this line
                            index: stepIndex,
                            children: [
                              Visibility(
                                  visible: stepIndex == 0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 12, 24, 24),
                                    child: Column(
                                      children: List.generate(
                                          rehabilitationList.length, (index) {
                                        return GestureDetector(
                                          onTap: () =>
                                              handleChooseRehabilitation(
                                                  rehabilitationList[index]),
                                          child: Container(
                                            height: 48,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (rehabilitationGet ==
                                                        rehabilitationList[
                                                                index]
                                                            .id
                                                    ? Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames.duigou,
                                                              size: 18,
                                                              color:
                                                                  'rgb(209,80,54)'),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                                Text(
                                                    rehabilitationList[index]
                                                        .title,
                                                    style: TextStyle(
                                                        color: rehabilitationGet ==
                                                                rehabilitationList[
                                                                        index]
                                                                    .id
                                                            ? const Color
                                                                .fromRGBO(
                                                                211, 66, 67, 1)
                                                            : Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  )),
                              Visibility(
                                  visible: stepIndex == 1,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 12, 24, 24),
                                    child: Column(
                                      children: List.generate(partList.length,
                                          (index) {
                                        return GestureDetector(
                                          onTap: () =>
                                              handleChoosePart(partList[index]),
                                          child: Container(
                                            height: 48,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (partGet == partList[index].id
                                                    ? Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames.duigou,
                                                              size: 18,
                                                              color:
                                                                  'rgb(209,80,54)'),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                                Text(partList[index].title,
                                                    style: TextStyle(
                                                        color: partGet ==
                                                                partList[index]
                                                                    .id
                                                            ? const Color
                                                                .fromRGBO(
                                                                211, 66, 67, 1)
                                                            : Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  )),
                              Visibility(
                                  visible: stepIndex == 2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 12, 24, 24),
                                    child: Column(
                                      children: List.generate(
                                          symptomsList.length, (index) {
                                        return GestureDetector(
                                          onTap: () => handleChooseSymptoms(
                                              symptomsList[index]),
                                          child: Container(
                                            height: 48,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (symptomsGet ==
                                                        symptomsList[index].id
                                                    ? Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames.duigou,
                                                              size: 18,
                                                              color:
                                                                  'rgb(209,80,54)'),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                                Text(symptomsList[index].title,
                                                    style: TextStyle(
                                                        color: symptomsGet ==
                                                                symptomsList[index]
                                                                    .id
                                                            ? const Color
                                                                .fromRGBO(
                                                                211, 66, 67, 1)
                                                            : Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  )),
                              Visibility(
                                  visible: stepIndex == 3,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 12, 24, 24),
                                    child: Column(
                                      children: List.generate(phaseList.length,
                                          (index) {
                                        return GestureDetector(
                                          onTap: () => handleChoosePhase(
                                              phaseList[index]),
                                          child: Container(
                                            height: 48,
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (phaseGet == phaseList[index].id
                                                    ? Container(
                                                        width: 18,
                                                        height: 18,
                                                        margin: const EdgeInsets
                                                            .only(right: 8),
                                                        child: Center(
                                                          child: IconFont(
                                                              IconNames.duigou,
                                                              size: 18,
                                                              color:
                                                                  'rgb(209,80,54)'),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                                Text(phaseList[index].title,
                                                    style: TextStyle(
                                                        color: phaseGet ==
                                                                phaseList[index]
                                                                    .id
                                                            ? const Color
                                                                .fromRGBO(
                                                                211, 66, 67, 1)
                                                            : Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ))
                            ])),
              ),
            ),
          ]),
    );
  }
}
