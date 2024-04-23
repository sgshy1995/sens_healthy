import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:sens_healthy/app/models/data_model.dart';
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

class MineRecordPublishPage extends StatefulWidget {
  const MineRecordPublishPage({super.key});

  @override
  State<MineRecordPublishPage> createState() => _MineRecordPublishPageState();
}

class _MineRecordPublishPageState extends State<MineRecordPublishPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();

  final GlobalController globalController =
      GetInstance().find<GlobalController>();
  final UserController userController = GetInstance().find<UserController>();

  final TextEditingController _textControllerGender = TextEditingController();
  final TextEditingController _textControllerAge = TextEditingController();
  final TextEditingController _textControllerInjuryHistory =
      TextEditingController();
  final TextEditingController _textControllerInjuryRecent =
      TextEditingController();
  final TextEditingController _textControllerDischargeAbstractValue =
      TextEditingController();

  bool publishCheck = false;

  String? injuryHistoryValue;
  String? injuryRecentValue;
  String? dischargeAbstractValue;

  List<AssetEntity> imageDataList = [];
  List<GalleryExampleItem> galleryItems = [];
  List<PainFileUploadTypeModel> finalImagesList = [];

  List<GalleryExampleItem> galleryItemsHistory = [];
  List<String> historyImagesList = [];

  bool _uploading = false;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  void unfocusAllTextField() {
    _focusNode1.unfocus();
    _focusNode2.unfocus();
    _focusNode3.unfocus();
  }

  @override
  void initState() {
    super.initState();
    print(userController.info.age);
    if (userController.userInfo.gender != null) {
      genderValue = userController.userInfo.gender;
      _textControllerGender.text = genderList[genderValue!];
    }
    if (userController.info.age != null) {
      ageValue = userController.info.age! - 1;
      _textControllerAge.text = '${userController.info.age}';
    }
    if (userController.info.injury_history != null) {
      injuryHistoryValue = userController.info.injury_history;
      _textControllerInjuryHistory.text = userController.info.injury_history!;
    }
    if (userController.info.injury_recent != null) {
      injuryRecentValue = userController.info.injury_recent;
      _textControllerInjuryRecent.text = userController.info.injury_recent!;
    }
    if (userController.info.discharge_abstract != null) {
      dischargeAbstractValue = userController.info.discharge_abstract;
      _textControllerDischargeAbstractValue.text =
          userController.info.discharge_abstract!;
    }
    if (userController.info.image_data != null) {
      historyImagesList = userController.info.image_data!.split(',');
      galleryItemsHistory = historyImagesList
          .map((e) => GalleryExampleItem(
              id: e,
              resource: '${globalController.cdnBaseUrl}/$e',
              isSvg: false,
              canBeDownloaded: false,
              imageType: 'network'))
          .toList();
    }
    checkIfCanPublish();
  }

  @override
  void dispose() {
    beforeDisposeRemoveUnnecessaryImages(finalImagesList);
    _textControllerGender.dispose();
    _textControllerAge.dispose();
    _textControllerInjuryHistory.dispose();
    _textControllerInjuryRecent.dispose();
    _textControllerDischargeAbstractValue.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  void changeInjuryHistory(String? value) {
    setState(() {
      injuryHistoryValue = value;
    });
    checkIfCanPublish();
  }

  void changeInjuryRecent(String? value) {
    setState(() {
      injuryRecentValue = value;
    });
    checkIfCanPublish();
  }

  void changeDischargeAbstractValue(String? value) {
    setState(() {
      dischargeAbstractValue = value;
    });
    checkIfCanPublish();
  }

  void handleChooseImages() async {
    Get.back();

    final List<AssetEntity>? resultGet = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          textDelegate: MyAssetPickerTextDelegate(),
          requestType: RequestType.image,
          themeColor: const Color.fromRGBO(211, 66, 67, 1),
          maxAssets: 9 - imageDataList.length - galleryItemsHistory.length),
    );

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataList.addAll(resultGet);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet, (assetEntity) async {
          // 在此处处理异步操作，例如网络请求、文件读写等
          final String uuidGet = const Uuid().v4();
          final String id = '${assetEntity.id}-$uuidGet';
          final mimeType = await assetEntity.mimeTypeAsync;
          final fileType = mimeType != null ? mimeType.split('/')[1] : 'jpg';
          final filename = 'picture.$fileType';
          final file = await assetEntity.file;
          final localPath = file!.path;
          finalImagesListGet.add(PainFileUploadTypeModel(
              id: id,
              file: file,
              localPath: localPath,
              filename: filename,
              fileType: fileType,
              mimeType: mimeType!,
              status: 0));
          // 在这里执行您的异步任务
        });

        setState(() {
          finalImagesList.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList =
            finalImagesList.where((item) => item.status == 0).toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return userClientProvider.recordImageDataUploadAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesList.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesList[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesList[idIndexGet].status = 1;
              finalImagesList[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesList[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesList.asMap().forEach((index, item) {
          print('实际添加的url');
          print(item.status == 1
              ? '${globalController.cdnBaseUrl}/${item.realKey!}'
              : item.localPath);
          galleryItemsGet.add(GalleryExampleItem(
              id: item.id,
              resource: item.status == 1
                  ? '${globalController.cdnBaseUrl}/${item.realKey!}'
                  : item.localPath,
              isSvg: false,
              canBeDownloaded: false,
              imageType: item.status == 1 ? 'network' : 'local'));
        });

        setState(() {
          galleryItems = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('您的图片包含敏感内容或违反相关法律法规，请重新上传');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImage(int index) {
    setState(() {
      imageDataList.removeAt(index);
      galleryItems.removeAt(index);
      finalImagesList.removeAt(index);
    });
  }

  void handleDeleteHistoryIndexImage(int index) {
    setState(() {
      historyImagesList.removeAt(index);
      galleryItemsHistory.removeAt(index);
    });
  }

  //销毁前，删除不必要的图片
  void beforeDisposeRemoveUnnecessaryImages(
      List<PainFileUploadTypeModel> finalImagesListGet) {
    final List<PainFileUploadTypeModel> listGet =
        finalImagesListGet.where((item) => item.status == 1).toList();
    final List<String> idsGet = listGet.map((item) => item.realKey!).toList();
    if (idsGet.isNotEmpty) {
      userClientProvider.removeUnnecessaryImagesAction(idsGet);
    }
  }

  void handleUseCamera() async {
    Get.back();
  }

  void handleGoBack() {
    Get.back();
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //上传列表有未上传或违规的文件
    if (finalImagesList.isNotEmpty &&
        finalImagesList.where((item) => item.status != 1).isNotEmpty) {
      publishCheckGet = false;
    }
    //年龄是否选择
    if (ageValue == null) {
      publishCheckGet = false;
    }
    //性别是否选择
    if (genderValue == null) {
      publishCheckGet = false;
    }
    //既往伤病史是否填写
    if (injuryHistoryValue == null || injuryHistoryValue!.isEmpty) {
      publishCheckGet = false;
    }
    //近期伤病描述是否填写
    if (injuryRecentValue == null || injuryRecentValue!.isEmpty) {
      publishCheckGet = false;
    }
    //出院小结是否填写
    if (dischargeAbstractValue == null || dischargeAbstractValue!.isEmpty) {
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

    final List<String> imageDataStringList = finalImagesList.isNotEmpty
        ? finalImagesList.map((item) => item.realKey!).toList()
        : [];

    final List<String> finalStringList = [
      ...historyImagesList,
      ...imageDataStringList
    ];

    final String imageDataString =
        finalStringList.isNotEmpty ? finalStringList.join(',') : '';

    Map<String, dynamic> form = {
      'injury_history': injuryHistoryValue,
      'injury_recent': injuryRecentValue,
      'discharge_abstract': dischargeAbstractValue,
      'image_data': imageDataString,
      'age': ageValue! + 1
    };

    if (imageDataString.isEmpty) {
      form.remove('image_data');
    }

    showLoading('发布中...');

    /// 这里一定要用函数返回 futures List
    /// 否则数组中的 Future 会立即执行
    List<Future> futuresList() {
      return [
        userClientProvider.updateUserByJwtAction({'gender': genderValue}),
        userClientProvider.updateInfoByJwtAction(form)
      ];
    }

    List<Future> getInfosList() {
      return [
        userClientProvider.getUserInfoByJWTAction(),
        userClientProvider.getInfoByJWTAction()
      ];
    }

    Future.wait(futuresList()).then((values) {
      if (values[0].code == 200 && values[1].code == 200) {
        Future.wait(getInfosList()).then((valuesIn) {
          if (valuesIn[0].code == 200 &&
              valuesIn[0].data != null &&
              valuesIn[1].code == 200 &&
              valuesIn[1].data != null) {
            userController.setUserInfo(valuesIn[0].data!);
            userController.setInfo(valuesIn[1].data!);
            setState(() {
              imageDataList = [];
              galleryItems = [];
              finalImagesList = [];
            });
            hideLoading();
            Get.back<String>(result: 'success');
          } else {
            hideLoading();
            showToast('获取用户信息失败');
          }
        }).catchError((e) {
          hideLoading();
          showToast('操作失败, 请稍后再试');
        });
      } else if (values[1].code == 403) {
        hideLoading();
        showToast('您的内容可能包含违规或敏感词汇，或不符合社区规定，请修改后重试');
      } else {
        hideLoading();
        showToast('请求错误，请稍后再试');
      }
    }).catchError((e) {
      hideLoading();
      showToast('请求错误，请稍后再试');
    });

    userClientProvider
        .updateInfoByJwtAction(form)
        .then((value) {})
        .catchError((e) {
      hideLoading();
      showToast('请求错误，请稍后再试');
    });
  }

  int? genderValue;

  static List<String> genderList = ['女', '男'];

  void handleChangeGender(int index) {
    _textControllerGender.text = genderList[index];
    setState(() {
      genderValue = index;
    });
  }

  void handleShowGenderPicker() {
    BottomPicker(
        itemExtent: 42,
        titleAlignment: Alignment.centerLeft,
        dismissable: true,
        popOnClose: true,
        closeIconSize: 20,
        buttonContent: const Center(
          child: Text(
            '确定',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        buttonSingleColor: Colors.black,
        items: List.generate(
            genderList.length,
            (index) => Center(
                  child: Text(genderList[index],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                )),
        pickerTitle: const SizedBox(
          height: 32,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '选择性别',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),
        pickerTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        closeIconColor: Colors.red,
        selectedItemIndex: genderValue ?? 0,
        onSubmit: (p0) {
          handleChangeGender(p0 as int);
        }).show(_scaffoldKey.currentState!.context);
  }

  int? ageValue;

  static List<String> ageList = List.generate(100, (index) => '${index + 1}');

  void handleChangeAge(int index) {
    _textControllerAge.text = ageList[index];
    setState(() {
      ageValue = index;
    });
  }

  void handleShowAgePicker() {
    BottomPicker(
      itemExtent: 42,
      titleAlignment: Alignment.centerLeft,
      dismissable: true,
      popOnClose: true,
      closeIconSize: 20,
      buttonContent: const Center(
        child: Text(
          '确定',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      buttonSingleColor: Colors.black,
      items: List.generate(
          ageList.length,
          (index) => Center(
                child: Text(ageList[index],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              )),
      pickerTitle: const SizedBox(
        height: 32,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '选择年龄',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
      pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      closeIconColor: Colors.red,
      selectedItemIndex: ageValue ?? 17,
      onSubmit: (p0) {
        handleChangeAge(p0 as int);
      },
    ).show(_scaffoldKey.currentState!.context);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void handleShowPicturesOrCanmera() {
      if (_uploading || imageDataList.length >= 9) {
        return;
      }

      showModalBottomSheet(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero, // 设置顶部边缘为直角
            ),
          ),
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        24, 0, 24, mediaQuerySafeInfo.bottom),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: handleChooseImages,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.tupian,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('从相册选择照片',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleUseCamera,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.xiangji,
                                    size: 24,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('拍照',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Color.fromRGBO(200, 200, 200, 1),
                        ),
                        InkWell(
                          onTap: handleGoBack,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(right: 12),
                                child: Center(
                                  child: IconFont(
                                    IconNames.guanbi,
                                    size: 20,
                                    color: '#000',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('取消',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ) // Your form widget here
                    ));
          }).then((value) {});
    }

    final double itemWidthAndHeight = (mediaQuerySizeInfo.width - 24 - 16) / 3;

    void open(BuildContext context, final int index) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GalleryPhotoViewWrapper(
            galleryItems: [...galleryItemsHistory, ...galleryItems],
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
                      const Text('伤痛档案维护',
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
                                child: Center(
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
                              child: Center(
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
                        SizedBox(
                          width: (mediaQuerySizeInfo.width - 24) / 2,
                          child: GestureDetector(
                            onTap: handleShowGenderPicker,
                            child: TextField(
                              enabled: false,
                              controller: _textControllerGender,
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 15, // 设置字体大小为20像素
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 15),
                                fillColor:
                                    const Color.fromRGBO(250, 250, 250, 1),
                                filled: true, // 使用图标
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(10), // 设置圆角大小
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // 聚焦状态下边框样式
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText: '请选择性别',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 12.0), // 增加垂直内边距来增加高度
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
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
                        SizedBox(
                          width: (mediaQuerySizeInfo.width - 24) / 2,
                          child: GestureDetector(
                            onTap: handleShowAgePicker,
                            child: TextField(
                              enabled: false,
                              controller: _textControllerAge,
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 15, // 设置字体大小为20像素
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 15),
                                fillColor:
                                    const Color.fromRGBO(250, 250, 250, 1),
                                filled: true, // 使用图标
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(10), // 设置圆角大小
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // 聚焦状态下边框样式
                                  borderSide:
                                      const BorderSide(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.circular(4), // 设置圆角大小
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                hintText: '请选择年龄',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 12.0), // 增加垂直内边距来增加高度
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
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
                        TextField(
                          focusNode: _focusNode1,
                          onTapOutside: (PointerDownEvent p) {
                            // 点击外部区域时取消焦点
                            unfocusAllTextField();
                          },
                          controller: _textControllerInjuryHistory,
                          maxLines: 6,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            fontSize: 15, // 设置字体大小为20像素
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15),
                            fillColor: const Color.fromRGBO(250, 250, 250, 1),
                            filled: true, // 使用图标
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10), // 设置圆角大小
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 聚焦状态下边框样式
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            hintText: '请输入...',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0), // 增加垂直内边距来增加高度
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          onChanged: changeInjuryHistory,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${injuryHistoryValue != null ? injuryHistoryValue!.length : 0}/200',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
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
                        TextField(
                          focusNode: _focusNode2,
                          onTapOutside: (PointerDownEvent p) {
                            // 点击外部区域时取消焦点
                            unfocusAllTextField();
                          },
                          controller: _textControllerInjuryRecent,
                          maxLines: 6,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            fontSize: 15, // 设置字体大小为20像素
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15),
                            fillColor: const Color.fromRGBO(250, 250, 250, 1),
                            filled: true, // 使用图标
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10), // 设置圆角大小
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 聚焦状态下边框样式
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            hintText: '请输入...',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0), // 增加垂直内边距来增加高度
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          onChanged: changeInjuryRecent,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${injuryRecentValue != null ? injuryRecentValue!.length : 0}/200',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
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
                        TextField(
                          focusNode: _focusNode3,
                          onTapOutside: (PointerDownEvent p) {
                            // 点击外部区域时取消焦点
                            unfocusAllTextField();
                          },
                          controller: _textControllerDischargeAbstractValue,
                          maxLines: 6,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            fontSize: 15, // 设置字体大小为20像素
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15),
                            fillColor: const Color.fromRGBO(250, 250, 250, 1),
                            filled: true, // 使用图标
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10), // 设置圆角大小
                            ),
                            focusedBorder: OutlineInputBorder(
                              // 聚焦状态下边框样式
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
                            hintText: '请输入...',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0), // 增加垂直内边距来增加高度
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          onChanged: changeDischargeAbstractValue,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${dischargeAbstractValue != null ? dischargeAbstractValue!.length : 0}/200',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('上传照片或视频',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('影像资料，诊断报告，受伤部位等资料，最多上传9张',
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
                                  itemCount: finalImagesList.length +
                                      galleryItemsHistory.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => open(context, index),
                                      child: Hero(
                                        tag: index < galleryItemsHistory.length
                                            ? galleryItemsHistory[index].id
                                            : finalImagesList[index -
                                                    galleryItemsHistory.length]
                                                .id,
                                        child: index <
                                                galleryItemsHistory.length
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            255, 255, 255, 1),
                                                        width: 2)),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          galleryItemsHistory[
                                                                  index]
                                                              .resource,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          decoration: const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.7),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () =>
                                                                handleDeleteHistoryIndexImage(
                                                                    index),
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .guanbi,
                                                                size: 16,
                                                                color: '#fff',
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            : galleryItems.length <=
                                                    (index -
                                                        galleryItemsHistory
                                                            .length)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            const Color.fromRGBO(
                                                                229,
                                                                229,
                                                                229,
                                                                1),
                                                        border: Border.all(
                                                            color: const Color
                                                                .fromRGBO(229,
                                                                229, 229, 1),
                                                            width: 2)),
                                                    child: const Center(
                                                      child: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                strokeWidth: 2),
                                                      ),
                                                    ),
                                                  )
                                                : galleryItems[index -
                                                                galleryItemsHistory
                                                                    .length]
                                                            .imageType ==
                                                        'network'
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                                width: 2)),
                                                        child: Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: galleryItems[index -
                                                                      galleryItemsHistory
                                                                          .length]
                                                                  .resource,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            Positioned(
                                                                top: 6,
                                                                right: 6,
                                                                child:
                                                                    Container(
                                                                  width: 32,
                                                                  height: 32,
                                                                  decoration: const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.7),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4))),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () =>
                                                                        handleDeleteIndexImage(index -
                                                                            galleryItemsHistory.length),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          IconFont(
                                                                        IconNames
                                                                            .guanbi,
                                                                        size:
                                                                            16,
                                                                        color:
                                                                            '#fff',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    208,
                                                                    64,
                                                                    55,
                                                                    1),
                                                                width: 2)),
                                                        child: Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            Image.asset(
                                                              galleryItems[index -
                                                                      galleryItemsHistory
                                                                          .length]
                                                                  .resource,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            Positioned(
                                                                top: 6,
                                                                right: 6,
                                                                child:
                                                                    Container(
                                                                  width: 32,
                                                                  height: 32,
                                                                  decoration: const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              208,
                                                                              64,
                                                                              55,
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4))),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () =>
                                                                        handleDeleteIndexImage(index -
                                                                            galleryItemsHistory.length),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          IconFont(
                                                                        IconNames
                                                                            .guanbi,
                                                                        size:
                                                                            16,
                                                                        color:
                                                                            '#fff',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                      ),
                                    );
                                  })
                              : const SizedBox.shrink(),
                        ),
                        (imageDataList.length + galleryItemsHistory.length) < 9
                            ? InkWell(
                                onTap: handleShowPicturesOrCanmera,
                                child: Container(
                                  width:
                                      (mediaQuerySizeInfo.width - 24 - 16) / 3,
                                  height:
                                      (mediaQuerySizeInfo.width - 24 - 16) / 3,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(229, 229, 229, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: IconFont(
                                          IconNames.tianjia,
                                          size: 36,
                                          color: '#000',
                                        ),
                                      ),
                                      _uploading
                                          ? Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width:
                                                    (mediaQuerySizeInfo.width -
                                                            24 -
                                                            16) /
                                                        3,
                                                height:
                                                    (mediaQuerySizeInfo.width -
                                                            24 -
                                                            16) /
                                                        3,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.8),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                              ))
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
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
