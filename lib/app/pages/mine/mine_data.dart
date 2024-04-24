import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';

import '../../../iconfont/icon_font.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/user_controller.dart';

import '../../providers/api/user_client_provider.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:image_cropper/image_cropper.dart';

import 'dart:io';
import 'package:mime/mime.dart';

import './mine_name_sheet.dart';

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class MineDataPage extends StatefulWidget {
  const MineDataPage({super.key});

  @override
  State<MineDataPage> createState() => _MineDataPageState();
}

class _MineDataPageState extends State<MineDataPage> {
  final UserClientProvider userClientProvider =
      GetInstance().find<UserClientProvider>();
  final UserController userController = GetInstance().find<UserController>();
  final GlobalController globalController =
      GetInstance().find<GlobalController>();

  void handleGoBack() {
    Get.back();
  }

  void handleChooseImage() async {
    Get.back();

    final List<AssetEntity>? resultGet = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          textDelegate: MyAssetPickerTextDelegate(),
          requestType: RequestType.image,
          themeColor: const Color.fromRGBO(211, 66, 67, 1),
          maxAssets: 1),
    );

    if (resultGet != null) {
      final AssetEntity assetEntity = resultGet[0];
      // 在此处处理异步操作，例如网络请求、文件读写等
      final fileGet = await assetEntity.file;
      final localPath = fileGet!.path;

      ImageCropper().cropImage(
        sourcePath: localPath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: '头像裁剪',
              toolbarColor: const Color.fromRGBO(211, 66, 67, 1),
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
              title: '头像裁剪',
              minimumAspectRatio: 1,
              rotateClockwiseButtonHidden: true,
              rotateButtonsHidden: true,
              aspectRatioPickerButtonHidden: true,
              resetAspectRatioEnabled: false,
              doneButtonTitle: '确定',
              cancelButtonTitle: '取消'),
          WebUiSettings(
            context: Get.context!,
          ),
        ],
      ).then((CroppedFile? value) async {
        if (value != null) {
          showLoading('请稍后...');
          final String path = value.path;
          final File file = File(path);
          final String mimeType = lookupMimeType(path) ?? 'image/jpg';
          final fileType = mimeType.split('/')[1];
          final filename = 'avatar.$fileType';
          userClientProvider.avatarUploadAction(file, filename).then((result) {
            if (result.code == 200) {
              userClientProvider.getUserInfoByJWTAction().then((resultIn) {
                if (resultIn.code == 200 && resultIn.data != null) {
                  userController.setUserInfo(resultIn.data!);
                  hideLoading();
                } else {
                  hideLoading();
                  showToast('获取用户信息失败');
                }
              }).catchError((e1) {
                hideLoading();
                showToast('操作失败, 请稍后再试');
              });
            } else if (result.code == 403) {
              hideLoading();
              showToast('您的图片包含敏感内容或违反相关法律法规，请重新上传');
            } else {
              hideLoading();
              showToast('请求错误，请稍后再试');
            }
          }).catchError((e) {
            hideLoading();
            showToast('请求错误，请稍后再试');
          });
        }
      });
    }
  }

  void handleUseCamera() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

    void showNameBottomSheet() {
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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom != 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : mediaQuerySafeInfo.bottom),
                    child: const MineNameSheetPage() // Your form widget here
                    ));
          });
    }

    void handleShowPicturesOrCanmera() {
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
                          onTap: handleChooseImage,
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

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.fromLTRB(12, mediaQuerySafeInfo.top + 12, 12, 12),
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
                  const Text('个人资料',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24, height: 24)
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
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 72,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '头像',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: handleShowPicturesOrCanmera,
                              child: Row(
                                children: [
                                  GetBuilder<UserController>(
                                    builder: (controller) {
                                      return Container(
                                        width: 48,
                                        height: 48,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child:
                                            (controller.userInfo.avatar == null)
                                                ? const CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/avatar.webp'),
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            254, 251, 254, 1),
                                                    radius: 24,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            '${globalController.cdnBaseUrl}/${controller.userInfo.avatar}'),
                                                  ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                      child: IconFont(
                                        IconNames.qianjin,
                                        size: 16,
                                        color: 'rgb(156, 156, 156)',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Color.fromRGBO(233, 234, 235, 1),
                      ),
                      SizedBox(
                        height: 72,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '用户名',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userController.userInfo.username,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Color.fromRGBO(233, 234, 235, 1),
                      ),
                      SizedBox(
                        height: 72,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '昵称',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: showNameBottomSheet,
                              child: Row(
                                children: [
                                  GetBuilder<UserController>(
                                      builder: (controller) {
                                    return Text(
                                      controller.userInfo.name ?? '未设置',
                                      style: TextStyle(
                                          color:
                                              controller.userInfo.name != null
                                                  ? Colors.black
                                                  : const Color.fromRGBO(
                                                      156, 156, 156, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    );
                                  }),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Center(
                                      child: IconFont(
                                        IconNames.qianjin,
                                        size: 16,
                                        color: 'rgb(156, 156, 156)',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
