import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/app/models/user_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../providers/api/user_client_provider.dart';
import '../../models/pain_model.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../components/gallery_photo_view_wrapper.dart';
import '../../../components/gallery_photo_view_item.dart';
import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:bottom_picker/bottom_picker.dart';

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class MineDoctorPatientRecordPage extends StatefulWidget {
  const MineDoctorPatientRecordPage({super.key});

  @override
  State<MineDoctorPatientRecordPage> createState() =>
      _MineDoctorPatientRecordPageState();
}

class _MineDoctorPatientRecordPageState
    extends State<MineDoctorPatientRecordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  late final String userId;

  UserTypeModel? userInfo;

  UserInfoTypeModel? info;

  static List<String> genderList = ['女', '男'];

  List<AssetEntity> imageDataList = [];
  List<GalleryExampleItem> galleryItems = [];
  List<PainFileUploadTypeModel> finalImagesList = [];

  List<GalleryExampleItem> galleryItemsHistory = [];
  List<String> historyImagesList = [];

  List<Future> getInfosList() {
    return [
      userClientProvider.getUserInfoByUserIdAction(userId),
      userClientProvider.getInfoByUserIdAction(userId)
    ];
  }

  void getInfos() {
    showLoading('请稍后...');

    Future.wait(getInfosList()).then((valuesIn) {
      if (valuesIn[0].code == 200 &&
          valuesIn[0].data != null &&
          valuesIn[1].code == 200 &&
          valuesIn[1].data != null) {
        setState(() {
          userInfo = valuesIn[0].data!;
          info = valuesIn[1].data!;
        });
        if (info!.image_data != null) {
          setState(() {
            historyImagesList = info!.image_data!.split(',');
            galleryItemsHistory = historyImagesList
                .map((e) => GalleryExampleItem(
                    id: e,
                    resource: '${globalController.cdnBaseUrl}/$e',
                    isSvg: false,
                    canBeDownloaded: false,
                    imageType: 'network'))
                .toList();
          });
        }
        hideLoading();
      } else {
        hideLoading();
        showToast('获取用户信息失败');
      }
    }).catchError((e) {
      hideLoading();
      showToast('操作失败, 请稍后再试');
    });
  }

  @override
  void initState() {
    super.initState();
    userId = Get.arguments['userId'];
    getInfos();
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

    final double itemWidthAndHeight = (mediaQuerySizeInfo.width - 24 - 16) / 3;

    void open(BuildContext context, final int index) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GalleryPhotoViewWrapper(
            galleryItems: [...galleryItemsHistory],
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

    return Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          child: Column(
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
                      InkWell(
                        onTap: handleGoBack,
                        child: SizedBox(
                          width: 36,
                          height: 24,
                          child: Center(
                            child: IconFont(
                              IconNames.guanbi,
                              size: 24,
                              color: '#000',
                            ),
                          ),
                        ),
                      ),
                      const Text('伤痛档案',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 36,
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
                  child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.fromLTRB(
                        12, 24, 12, mediaQuerySafeInfo.bottom + 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('性别',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(userInfo == null
                            ? ''
                            : genderList[userInfo!.gender!]),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('年龄',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(info == null ? '' : '${info!.age}'),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('既往伤病史',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('什么时间在哪里做过什么治疗，治疗效果如何，是否有明确诊断为何病',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        RichText(
                            maxLines: 99,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: info == null
                                      ? ''
                                      : '${info!.injury_history}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('近期伤病描述',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                            '近期伤病情况介绍，受伤时间、受伤过程、症状描述；受伤部位活动功能是否受到影响，日常生活活动是否受到影响等',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        RichText(
                            maxLines: 99,
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: info == null
                                      ? ''
                                      : '${info!.injury_recent}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('出院小结',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('何时出院，治疗结果，医生嘱托，后续治疗方案',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        RichText(
                            maxLines: 99,
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: info == null
                                      ? ''
                                      : '${info!.discharge_abstract}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('影像资料',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('影像资料，诊断报告，受伤部位等资料',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: (finalImagesList.isNotEmpty ||
                                  galleryItemsHistory.isNotEmpty)
                              ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          // 交叉轴子项数量
                                          mainAxisSpacing: 8, // 主轴间距
                                          crossAxisSpacing: 8, // 交叉轴间距
                                          childAspectRatio: 1,
                                          mainAxisExtent: itemWidthAndHeight,
                                          maxCrossAxisExtent:
                                              itemWidthAndHeight),
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero, // 设置为零边距
                                  shrinkWrap: true,
                                  itemCount: galleryItemsHistory.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => open(context, index),
                                      child: Hero(
                                        tag: galleryItemsHistory[index].id,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  width: 2)),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    galleryItemsHistory[index]
                                                        .resource,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
