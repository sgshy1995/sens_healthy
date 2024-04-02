import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
  int? part;
  int? symptoms;
  int? phase;
  PrescriptionSectionPage({super.key, this.part, this.symptoms, this.phase});

  @override
  State<PrescriptionSectionPage> createState() =>
      _PrescriptionSectionPageState();
}

class _PrescriptionSectionPageState extends State<PrescriptionSectionPage> {
  late int? partGet;
  late int? symptomsGet;
  late int? phaseGet;

  List<String> partList = ['肩关节', '肘关节', '腕关节', '髋关节', '膝关节', '踝关节', '脊柱'];

  List<String> symptomsList = ['疼痛', '肿胀', '活动受限', '弹响'];

  List<String> phaseList = ['0-2周', '3-6周', '6-12周', '12周以后'];

  bool publishCheck = false;

  void handleChoosePart(int partGetNew) {
    if (partGet != partGetNew) {
      setState(() {
        partGet = partGetNew;
      });
      checkIfCanPublish();
    }
  }

  void handleChooseSymptoms(int symptomsGetNew) {
    if (symptomsGet != symptomsGetNew) {
      setState(() {
        symptomsGet = symptomsGetNew;
      });
      checkIfCanPublish();
    }
  }

  void handleChoosePhase(int phaseGetNew) {
    if (phaseGet != phaseGetNew) {
      setState(() {
        phaseGet = phaseGetNew;
      });
      checkIfCanPublish();
    }
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //关节部位是否选择
    if (partGet == null) {
      publishCheckGet = false;
    }
    //症状是否选择
    if (symptomsGet == null) {
      publishCheckGet = false;
    }
    //阶段是否选择
    if (phaseGet == null) {
      publishCheckGet = false;
    }

    if (publishCheck != publishCheckGet) {
      setState(() {
        publishCheck = publishCheckGet;
      });
    }
  }

  void handlePublish() {
    if (!publishCheck) {
      return;
    }
    Get.back<Map<String, dynamic>>(
        result: {'part': partGet, 'symptoms': symptomsGet, 'phase': phaseGet});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    partGet = widget.part;
    symptomsGet = widget.symptoms;
    phaseGet = widget.phase;
    checkIfCanPublish();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                    InkWell(
                      onTap: handleGoBack,
                      child: SizedBox(
                        width: 36,
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
                    ),
                    const Text('精准定位',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    publishCheck
                        ? InkWell(
                            onTap: handlePublish,
                            child: const SizedBox(
                              width: 36,
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
                            width: 36,
                            height: 24,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color: Color.fromRGBO(211, 66, 67, 0.3),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 12, 6, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (mediaQuerySizeInfo.width - 12) / 3,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text('关节部位',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Column(
                            children: List.generate(partList.length, (index) {
                              return SizedBox(
                                height: 48,
                                child: InkWell(
                                  onTap: () => handleChoosePart(index),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (partGet == index
                                            ? Container(
                                                width: 18,
                                                height: 18,
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.duigou,
                                                      size: 18,
                                                      color: 'rgb(209,80,54)'),
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                        Text(partList[index],
                                            style: TextStyle(
                                                color: partGet == index
                                                    ? const Color.fromRGBO(
                                                        211, 66, 67, 1)
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (mediaQuerySizeInfo.width - 12) / 3,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text('症状',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Column(
                            children:
                                List.generate(symptomsList.length, (index) {
                              return SizedBox(
                                height: 48,
                                child: InkWell(
                                  onTap: () => handleChooseSymptoms(index),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (symptomsGet == index
                                            ? Container(
                                                width: 18,
                                                height: 18,
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.duigou,
                                                      size: 18,
                                                      color: 'rgb(209,80,54)'),
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                        Text(symptomsList[index],
                                            style: TextStyle(
                                                color: symptomsGet == index
                                                    ? const Color.fromRGBO(
                                                        211, 66, 67, 1)
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (mediaQuerySizeInfo.width - 12) / 3,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text('阶段',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Column(
                            children: List.generate(phaseList.length, (index) {
                              return SizedBox(
                                height: 48,
                                child: InkWell(
                                  onTap: () => handleChoosePhase(index),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (phaseGet == index
                                            ? Container(
                                                width: 18,
                                                height: 18,
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: Center(
                                                  child: IconFont(
                                                      IconNames.duigou,
                                                      size: 18,
                                                      color: 'rgb(209,80,54)'),
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                        Text(phaseList[index],
                                            style: TextStyle(
                                                color: phaseGet == index
                                                    ? const Color.fromRGBO(
                                                        211, 66, 67, 1)
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal)),
                                      ],
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
              ),
            ))
          ]),
    );
  }
}
