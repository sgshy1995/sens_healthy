import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../providers/api/pain_client_provider.dart';
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

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class PainQuestionPublishPage extends StatefulWidget {
  const PainQuestionPublishPage({super.key});

  @override
  State<PainQuestionPublishPage> createState() =>
      _PainQuestionPublishPageState();
}

class _PainQuestionPublishPageState extends State<PainQuestionPublishPage> {
  final PainClientProvider painClientProvider = Get.put(PainClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  final TextEditingController _textControllerPainDescription =
      TextEditingController();
  final TextEditingController _textControllerPainInjuryHistory =
      TextEditingController();

  bool publishCheck = false;

  final List<String> painTypeItems = [
    "体型矫正",
    "头痛",
    "关节痛",
    "咽痛",
    "内腑疼痛",
    "失眠",
    "内分泌紊乱",
    "体虚"
  ];
  String? painTypeValue;
  String? painDescriptionValue;
  String? painInjuryHistoryValue;
  bool painAnonymityValue = false;

  List<AssetEntity> imageDataList = [];
  List<GalleryExampleItem> galleryItems = [];
  List<PainFileUploadTypeModel> finalImagesList = [];

  bool _uploading = false;

  bool inputEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    beforeDisposeRemoveUnnecessaryImages(finalImagesList);
    // TODO: implement dispose
    super.dispose();
    _textControllerPainDescription.dispose();
    _textControllerPainInjuryHistory.dispose();
  }

  void changePainType(String? value) {
    setState(() {
      painTypeValue = value;
    });
    checkIfCanPublish();
  }

  void changePainDescription(String? value) {
    setState(() {
      painDescriptionValue = value;
    });
    checkIfCanPublish();
  }

  void changePainInjuryHistory(String? value) {
    setState(() {
      painInjuryHistoryValue = value;
    });
    checkIfCanPublish();
  }

  void handleChooseImages() async {
    setState(() {
      inputEnabled = false;
    });
    Get.back();

    final List<AssetEntity>? resultGet = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          textDelegate: MyAssetPickerTextDelegate(),
          requestType: RequestType.image,
          themeColor: const Color.fromRGBO(211, 66, 67, 1),
          maxAssets: 9 - imageDataList.length),
    );

    setState(() {
      inputEnabled = true;
    });

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
          return painClientProvider.painQuestionImageDataUploadAction(
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

  //销毁前，删除不必要的图片
  void beforeDisposeRemoveUnnecessaryImages(
      List<PainFileUploadTypeModel> finalImagesListGet) {
    final List<PainFileUploadTypeModel> listGet =
        finalImagesListGet.where((item) => item.status == 1).toList();
    final List<String> idsGet = listGet.map((item) => item.realKey!).toList();
    painClientProvider.removeUnnecessaryImagesAction(idsGet);
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
    //伤痛类型是否选择
    if (painTypeValue == null || painTypeValue!.isEmpty) {
      publishCheckGet = false;
    }
    //问题描述是否填写
    if (painDescriptionValue == null || painDescriptionValue!.isEmpty) {
      publishCheckGet = false;
    }
    //诊疗史是否填写
    if (painInjuryHistoryValue == null || painInjuryHistoryValue!.isEmpty) {
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

    final String imageDataString = finalImagesList.isNotEmpty
        ? finalImagesList.map((item) => item.realKey).toList().join(',')
        : '';

    Map<String, dynamic> form = {
      'pain_type': painTypeValue,
      'description': painDescriptionValue,
      'injury_history': painInjuryHistoryValue,
      'anonymity': painAnonymityValue ? 1 : 0,
      'image_data': imageDataString
    };

    if (imageDataString.isEmpty) {
      form.remove('image_data');
    }

    showLoading('发布中...');

    painClientProvider.painQuestionCreateAction(form).then((value) {
      if (value.code == 200) {
        setState(() {
          imageDataList = [];
          galleryItems = [];
          finalImagesList = [];
        });
        hideLoading();
        Get.back<String>(result: 'success');
      } else if (value.code == 403) {
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
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void handleShowPicturesOrCanmera() {
      if (_uploading || imageDataList.length >= 9) {
        return;
      }

      setState(() {
        inputEnabled = false;
      });

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
          }).then((value) {
        setState(() {
          inputEnabled = true;
        });
      });
    }

    final double itemWidthAndHeight = (mediaQuerySizeInfo.width - 24 - 16) / 3;

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

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        // 点击外部区域时取消焦点
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Column(
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
                      child: Center(
                        child: IconFont(
                          IconNames.guanbi,
                          size: 24,
                          color: '#000',
                        ),
                      ),
                    ),
                  ),
                  const Text('发布伤痛问题',
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
                                '发布',
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
                              '发布',
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
                    const Text('伤痛类型',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('伤痛类型，如受伤部位、受伤类型等',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          '请选择',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        items: painTypeItems
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: painTypeValue,
                        onChanged: changePainType,
                        buttonStyleData: ButtonStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: const Color.fromRGBO(250, 250, 250, 1),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('问题描述',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                        '伤病情况介绍，受伤时间、受伤过程、症状描述、受伤部位活动功能是否受影响，日常生活活动是否受影响等',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      enabled: inputEnabled,
                      controller: _textControllerPainDescription,
                      maxLines: 6,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        fontSize: 15, // 设置字体大小为20像素
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                        fillColor: const Color.fromRGBO(250, 250, 250, 1),
                        filled: true, // 使用图标
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10), // 设置圆角大小
                        ),
                        focusedBorder: OutlineInputBorder(
                          // 聚焦状态下边框样式
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        hintText: '请输入您的问题...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(200)],
                      onChanged: changePainDescription,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${painDescriptionValue != null ? painDescriptionValue!.length : 0}/200',
                          style: const TextStyle(
                              color: Color.fromRGBO(150, 150, 150, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('诊疗史',
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
                      enabled: inputEnabled,
                      controller: _textControllerPainInjuryHistory,
                      maxLines: 6,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        fontSize: 15, // 设置字体大小为20像素
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 15),
                        fillColor: const Color.fromRGBO(250, 250, 250, 1),
                        filled: true, // 使用图标
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(10), // 设置圆角大小
                        ),
                        focusedBorder: OutlineInputBorder(
                          // 聚焦状态下边框样式
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4), // 设置圆角大小
                        ),
                        hintText: '请输入您的诊疗史...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(200)],
                      onChanged: changePainInjuryHistory,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${painInjuryHistoryValue != null ? painInjuryHistoryValue!.length : 0}/200',
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
                      child: (finalImagesList.isNotEmpty)
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      // 交叉轴子项数量
                                      mainAxisSpacing: 8, // 主轴间距
                                      crossAxisSpacing: 8, // 交叉轴间距
                                      childAspectRatio: 1,
                                      mainAxisExtent: itemWidthAndHeight,
                                      maxCrossAxisExtent: itemWidthAndHeight),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero, // 设置为零边距
                              shrinkWrap: true,
                              itemCount: finalImagesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => open(context, index),
                                  child: Hero(
                                    tag: finalImagesList[index].id,
                                    child: galleryItems.length <= index
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    229, 229, 229, 1),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    width: 2)),
                                            child: const Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        strokeWidth: 2),
                                              ),
                                            ),
                                          )
                                        : galleryItems[index].imageType ==
                                                'network'
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
                                                          galleryItems[index]
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
                                                                handleDeleteIndexImage(
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
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            208, 64, 55, 1),
                                                        width: 2)),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Image.asset(
                                                      galleryItems[index]
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
                                                                      208,
                                                                      64,
                                                                      55,
                                                                      1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4))),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () =>
                                                                handleDeleteIndexImage(
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
                                              ),
                                  ),
                                );
                              })
                          : const SizedBox.shrink(),
                    ),
                    imageDataList.length < 9
                        ? InkWell(
                            onTap: handleShowPicturesOrCanmera,
                            child: Container(
                              width: (mediaQuerySizeInfo.width - 24 - 16) / 3,
                              height: (mediaQuerySizeInfo.width - 24 - 16) / 3,
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
                                            width: (mediaQuerySizeInfo.width -
                                                    24 -
                                                    16) /
                                                3,
                                            height: (mediaQuerySizeInfo.width -
                                                    24 -
                                                    16) /
                                                3,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.8),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                          ))
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('匿名提问',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('发布者可以选择匿名提问，发布者的个人信息将得到匿名保护，但是可能会对问题的关注度造成影响',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 12,
                    ),
                    Switch(
                      trackOutlineColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color.fromRGBO(0, 0, 0, 1); // 按下状态下的颜色
                        }
                        return const Color.fromRGBO(216, 213, 215, 1); // 默认颜色
                      }),
                      inactiveTrackColor:
                          const Color.fromRGBO(216, 213, 215, 1),
                      inactiveThumbColor:
                          const Color.fromRGBO(157, 157, 157, 1),
                      activeTrackColor: const Color.fromRGBO(0, 0, 0, 1),
                      activeColor: const Color.fromRGBO(255, 255, 255, 1),
                      value: painAnonymityValue,
                      onChanged: (value) {
                        setState(() {
                          painAnonymityValue = value;
                        });
                      },
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
