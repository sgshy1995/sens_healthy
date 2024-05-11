import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import 'package:sens_healthy/components/loading.dart';
import 'package:sens_healthy/components/toast.dart';
import '../../../iconfont/icon_font.dart';
import '../../../utils/validate.dart';
import '../../models/user_model.dart';
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

class MyCameraPickerTextDelegate extends CameraPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class MineAuthenticatePublishPage extends StatefulWidget {
  const MineAuthenticatePublishPage({super.key});

  @override
  State<MineAuthenticatePublishPage> createState() =>
      _MineAuthenticatePublishPageState();
}

class _MineAuthenticatePublishPageState
    extends State<MineAuthenticatePublishPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final UserClientProvider userClientProvider = Get.put(UserClientProvider());

  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  final TextEditingController _textControllerGender = TextEditingController();
  final TextEditingController _textControllerAge = TextEditingController();
  final TextEditingController _textControllerName = TextEditingController();
  final TextEditingController _textControllerPhone = TextEditingController();
  final TextEditingController _textControllerOrganization =
      TextEditingController();
  final TextEditingController _textControllerIntroduction =
      TextEditingController();

  bool publishCheck = false;

  String? nameValue;
  String? phoneValue;
  String? organizationValue;
  String? introductionValue;

  List<AssetEntity> imageDataListFront = [];
  List<GalleryExampleItem> galleryItemsFront = [];
  List<PainFileUploadTypeModel> finalImagesListFront = [];
  List<GalleryExampleItem> galleryItemsHistoryFront = [];
  List<String> historyImagesListFront = [];

  List<AssetEntity> imageDataListBack = [];
  List<GalleryExampleItem> galleryItemsBack = [];
  List<PainFileUploadTypeModel> finalImagesListBack = [];
  List<GalleryExampleItem> galleryItemsHistoryBack = [];
  List<String> historyImagesListBack = [];

  List<AssetEntity> imageDataListPracticing = [];
  List<GalleryExampleItem> galleryItemsPracticing = [];
  List<PainFileUploadTypeModel> finalImagesListPracticing = [];
  List<GalleryExampleItem> galleryItemsHistoryPracticing = [];
  List<String> historyImagesListPracticing = [];

  List<AssetEntity> imageDataListEmployee = [];
  List<GalleryExampleItem> galleryItemsEmployee = [];
  List<PainFileUploadTypeModel> finalImagesListEmployee = [];
  List<GalleryExampleItem> galleryItemsHistoryEmployee = [];
  List<String> historyImagesListEmployee = [];

  bool _uploading = false;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  void unfocusAllTextField() {
    _focusNode1.unfocus();
    _focusNode2.unfocus();
    _focusNode3.unfocus();
    _focusNode4.unfocus();
  }

  AuthenticateTypeModel authenticateInfo = AuthenticateTypeModel.fromJson(null);

  Future<String?> loadInfo() async {
    showLoading('请稍后...');
    Completer<String?> completer = Completer();
    userClientProvider.findOneAuthenticateByUserIdAction().then((result) {
      if (result.code == 200) {
        if (result.data != null) {
          setState(() {
            authenticateInfo = result.data!;
            if (authenticateInfo.id.isNotEmpty) {
              genderValue = authenticateInfo.gender;
              _textControllerGender.text = genderList[genderValue!];
              nameValue = authenticateInfo.name;
              _textControllerName.text = authenticateInfo.name;
              phoneValue = authenticateInfo.phone;
              _textControllerPhone.text = authenticateInfo.phone;
              organizationValue = authenticateInfo.organization;
              _textControllerOrganization.text = authenticateInfo.organization;
              introductionValue = authenticateInfo.fcc;
              _textControllerIntroduction.text = authenticateInfo.fcc;

              historyImagesListFront = [authenticateInfo.identity_card_front];
              galleryItemsHistoryFront = historyImagesListFront
                  .map((e) => GalleryExampleItem(
                      id: e,
                      resource: '${globalController.cdnBaseUrl}/$e',
                      isSvg: false,
                      canBeDownloaded: false,
                      imageType: 'network'))
                  .toList();

              historyImagesListBack = [authenticateInfo.identity_card_back];
              galleryItemsHistoryBack = historyImagesListBack
                  .map((e) => GalleryExampleItem(
                      id: e,
                      resource: '${globalController.cdnBaseUrl}/$e',
                      isSvg: false,
                      canBeDownloaded: false,
                      imageType: 'network'))
                  .toList();

              historyImagesListPracticing = [
                authenticateInfo.practicing_certificate
              ];
              galleryItemsHistoryPracticing = historyImagesListPracticing
                  .map((e) => GalleryExampleItem(
                      id: e,
                      resource: '${globalController.cdnBaseUrl}/$e',
                      isSvg: false,
                      canBeDownloaded: false,
                      imageType: 'network'))
                  .toList();

              historyImagesListEmployee = [authenticateInfo.employee_card];
              galleryItemsHistoryEmployee = historyImagesListEmployee
                  .map((e) => GalleryExampleItem(
                      id: e,
                      resource: '${globalController.cdnBaseUrl}/$e',
                      isSvg: false,
                      canBeDownloaded: false,
                      imageType: 'network'))
                  .toList();
            }
          });
        }
        hideLoading();
        checkIfCanPublish();
        completer.complete('success');
      } else {
        completer.completeError('error');
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments['authId'] != null) {
      authenticateInfo.id = Get.arguments['authId'];
    }
    loadInfo();
  }

  @override
  void dispose() {
    beforeDisposeRemoveUnnecessaryImages(finalImagesListFront);
    beforeDisposeRemoveUnnecessaryImages(finalImagesListBack);
    beforeDisposeRemoveUnnecessaryImages(finalImagesListPracticing);
    beforeDisposeRemoveUnnecessaryImages(finalImagesListEmployee);
    _textControllerGender.dispose();
    _textControllerAge.dispose();
    _textControllerName.dispose();
    _textControllerPhone.dispose();
    _textControllerOrganization.dispose();
    _textControllerIntroduction.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  void changeName(String? value) {
    setState(() {
      nameValue = value;
    });
    checkIfCanPublish();
  }

  void changePhone(String? value) {
    setState(() {
      phoneValue = value;
    });
    checkIfCanPublish();
  }

  void changeOrganization(String? value) {
    setState(() {
      organizationValue = value;
    });
    checkIfCanPublish();
  }

  void changeIntroduction(String? value) {
    setState(() {
      introductionValue = value;
    });
    checkIfCanPublish();
  }

  ///身份证正面处理方法
  void handleChooseImagesFront(String type) async {
    Get.back();

    List<AssetEntity>? resultGet;

    if (type == 'assets') {
      resultGet = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
            textDelegate: MyAssetPickerTextDelegate(),
            requestType: RequestType.image,
            themeColor: const Color.fromRGBO(211, 66, 67, 1),
            maxAssets: 1),
      );
    } else {
      final AssetEntity? resultGetCamera = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
            textDelegate: MyCameraPickerTextDelegate(),
            enableRecording: false,
            theme:
                CameraPicker.themeData(const Color.fromRGBO(211, 66, 67, 1))),
      );

      if (resultGetCamera != null) {
        resultGet = [resultGetCamera];
      }
    }

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
        handleDeleteIndexImageFront(0);
        handleDeleteHistoryIndexImageFront(0);
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataListFront.addAll(resultGet!);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet!, (assetEntity) async {
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
          finalImagesListFront.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList =
            finalImagesListFront.where((item) => item.status == 0).toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return userClientProvider.uploadIdentityCardFrontAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesListFront.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesListFront[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesListFront[idIndexGet].status = 1;
              finalImagesListFront[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesListFront[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesListFront.asMap().forEach((index, item) {
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
          galleryItemsFront = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('上传失败，请稍后再试');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImageFront(int index) {
    if (finalImagesListFront.isNotEmpty) {
      beforeDisposeRemoveUnnecessaryImages([...finalImagesListFront]);
      setState(() {
        imageDataListFront.removeAt(index);
        galleryItemsFront.removeAt(index);
        finalImagesListFront.removeAt(index);
      });
    }
  }

  void handleDeleteHistoryIndexImageFront(int index) {
    if (historyImagesListFront.isNotEmpty) {
      setState(() {
        historyImagesListFront.removeAt(index);
        galleryItemsHistoryFront.removeAt(index);
      });
    }
  }

  ///身份证反面处理方法
  void handleChooseImagesBack(String type) async {
    Get.back();

    List<AssetEntity>? resultGet;

    if (type == 'assets') {
      resultGet = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
            textDelegate: MyAssetPickerTextDelegate(),
            requestType: RequestType.image,
            themeColor: const Color.fromRGBO(211, 66, 67, 1),
            maxAssets: 1),
      );
    } else {
      final AssetEntity? resultGetCamera = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
            textDelegate: MyCameraPickerTextDelegate(),
            enableRecording: false,
            theme:
                CameraPicker.themeData(const Color.fromRGBO(211, 66, 67, 1))),
      );

      if (resultGetCamera != null) {
        resultGet = [resultGetCamera];
      }
    }

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
        handleDeleteIndexImageBack(0);
        handleDeleteHistoryIndexImageBack(0);
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataListBack.addAll(resultGet!);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet!, (assetEntity) async {
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
          finalImagesListBack.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList =
            finalImagesListBack.where((item) => item.status == 0).toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return userClientProvider.uploadIdentityCardBackAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesListBack.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesListBack[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesListBack[idIndexGet].status = 1;
              finalImagesListBack[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesListBack[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesListBack.asMap().forEach((index, item) {
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
          galleryItemsBack = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('上传失败，请稍后再试');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImageBack(int index) {
    if (finalImagesListBack.isNotEmpty) {
      beforeDisposeRemoveUnnecessaryImages([...finalImagesListBack]);
      setState(() {
        imageDataListBack.removeAt(index);
        galleryItemsBack.removeAt(index);
        finalImagesListBack.removeAt(index);
      });
    }
  }

  void handleDeleteHistoryIndexImageBack(int index) {
    if (historyImagesListBack.isNotEmpty) {
      setState(() {
        historyImagesListBack.removeAt(index);
        galleryItemsHistoryBack.removeAt(index);
      });
    }
  }

  ///执业证照处理方法
  void handleChooseImagesPracticing(String type) async {
    Get.back();

    List<AssetEntity>? resultGet;

    if (type == 'assets') {
      resultGet = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
            textDelegate: MyAssetPickerTextDelegate(),
            requestType: RequestType.image,
            themeColor: const Color.fromRGBO(211, 66, 67, 1),
            maxAssets: 1),
      );
    } else {
      final AssetEntity? resultGetCamera = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
            textDelegate: MyCameraPickerTextDelegate(),
            enableRecording: false,
            theme:
                CameraPicker.themeData(const Color.fromRGBO(211, 66, 67, 1))),
      );

      if (resultGetCamera != null) {
        resultGet = [resultGetCamera];
      }
    }

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
        handleDeleteIndexImagePracticing(0);
        handleDeleteHistoryIndexImagePracticing(0);
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataListPracticing.addAll(resultGet!);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet!, (assetEntity) async {
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
          finalImagesListPracticing.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList = finalImagesListPracticing
            .where((item) => item.status == 0)
            .toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return userClientProvider.uploadPracticingCertificateAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesListPracticing.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesListPracticing[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesListPracticing[idIndexGet].status = 1;
              finalImagesListPracticing[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesListPracticing[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesListPracticing.asMap().forEach((index, item) {
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
          galleryItemsPracticing = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('上传失败，请稍后再试');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImagePracticing(int index) {
    if (finalImagesListPracticing.isNotEmpty) {
      beforeDisposeRemoveUnnecessaryImages([...finalImagesListPracticing]);
      setState(() {
        imageDataListPracticing.removeAt(index);
        galleryItemsPracticing.removeAt(index);
        finalImagesListPracticing.removeAt(index);
      });
    }
  }

  void handleDeleteHistoryIndexImagePracticing(int index) {
    if (historyImagesListPracticing.isNotEmpty) {
      setState(() {
        historyImagesListPracticing.removeAt(index);
        galleryItemsHistoryPracticing.removeAt(index);
      });
    }
  }

  ///工作证照处理方法
  void handleChooseImagesEmployee(String type) async {
    Get.back();

    List<AssetEntity>? resultGet;

    if (type == 'assets') {
      resultGet = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
            textDelegate: MyAssetPickerTextDelegate(),
            requestType: RequestType.image,
            themeColor: const Color.fromRGBO(211, 66, 67, 1),
            maxAssets: 1),
      );
    } else {
      final AssetEntity? resultGetCamera = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
            textDelegate: MyCameraPickerTextDelegate(),
            enableRecording: false,
            theme:
                CameraPicker.themeData(const Color.fromRGBO(211, 66, 67, 1))),
      );

      if (resultGetCamera != null) {
        resultGet = [resultGetCamera];
      }
    }

    if (resultGet != null) {
      setState(() {
        publishCheck = false;
        handleDeleteIndexImageEmployee(0);
        handleDeleteHistoryIndexImageEmployee(0);
      });

      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          imageDataListEmployee.addAll(resultGet!);
          _uploading = true;
        });

        List<PainFileUploadTypeModel> finalImagesListGet = [];
        await Future.forEach(resultGet!, (assetEntity) async {
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
          finalImagesListEmployee.addAll(finalImagesListGet);
        });

        // 同时执行多个异步任务
        final needUploadImagesList =
            finalImagesListEmployee.where((item) => item.status == 0).toList();
        final List<Future<DataFinalModel<String?>>> futures =
            needUploadImagesList.map((item) {
          return userClientProvider.uploadEmployeeCardAction(
              item.file, item.filename);
        }).toList();

        // 等待所有异步任务完成
        final List<DataFinalModel<String?>?> results =
            await Future.wait(futures);
        bool rejectCheck = false;
        results.asMap().forEach((index, result) {
          final id = needUploadImagesList[index].id;
          final idIndexGet =
              finalImagesListEmployee.indexWhere((item) => item.id == id);
          // 注意：这里将上传失败的图片也作为违规图片处理
          if (result == null) {
            rejectCheck = false;
            setState(() {
              finalImagesListEmployee[idIndexGet].status = 2;
            });
          } else if (result.code == 200) {
            setState(() {
              finalImagesListEmployee[idIndexGet].status = 1;
              finalImagesListEmployee[idIndexGet].realKey = result.data;
            });
          } else {
            rejectCheck = false;
            setState(() {
              finalImagesListEmployee[idIndexGet].status = 2;
            });
          }
        });

        List<GalleryExampleItem> galleryItemsGet = [];

        finalImagesListEmployee.asMap().forEach((index, item) {
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
          galleryItemsEmployee = [...galleryItemsGet];
          _uploading = false;
        });

        if (rejectCheck) {
          showToast('上传失败，请稍后再试');
        }

        checkIfCanPublish();
      });
    }
  }

  void handleDeleteIndexImageEmployee(int index) {
    if (finalImagesListEmployee.isNotEmpty) {
      beforeDisposeRemoveUnnecessaryImages([...finalImagesListEmployee]);
      setState(() {
        imageDataListEmployee.removeAt(index);
        galleryItemsEmployee.removeAt(index);
        finalImagesListEmployee.removeAt(index);
      });
    }
  }

  void handleDeleteHistoryIndexImageEmployee(int index) {
    if (historyImagesListEmployee.isNotEmpty) {
      setState(() {
        historyImagesListEmployee.removeAt(index);
        galleryItemsHistoryEmployee.removeAt(index);
      });
    }
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

  void handleGoBack() {
    Get.back();
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //身份证正面-上传列表有未上传或违规的文件-且历史也为空
    if ((historyImagesListFront.isEmpty && finalImagesListFront.isEmpty) ||
        (finalImagesListFront.isNotEmpty &&
            finalImagesListFront
                .where((item) => item.status != 1)
                .isNotEmpty)) {
      publishCheckGet = false;
    }
    //身份证反面-上传列表有未上传或违规的文件-且历史也为空
    if ((historyImagesListBack.isEmpty && finalImagesListBack.isEmpty) ||
        (finalImagesListBack.isNotEmpty &&
            finalImagesListBack.where((item) => item.status != 1).isNotEmpty)) {
      publishCheckGet = false;
    }
    //执业证照-上传列表有未上传或违规的文件-且历史也为空
    if ((historyImagesListPracticing.isEmpty &&
            finalImagesListPracticing.isEmpty) ||
        (finalImagesListPracticing.isNotEmpty &&
            finalImagesListPracticing
                .where((item) => item.status != 1)
                .isNotEmpty)) {
      publishCheckGet = false;
    }
    //工作证照-上传列表有未上传或违规的文件-且历史也为空
    if ((historyImagesListEmployee.isEmpty &&
            finalImagesListEmployee.isEmpty) ||
        (finalImagesListEmployee.isNotEmpty &&
            finalImagesListEmployee
                .where((item) => item.status != 1)
                .isNotEmpty)) {
      publishCheckGet = false;
    }
    //性别是否选择
    if (genderValue == null) {
      publishCheckGet = false;
    }
    //姓名是否填写
    if (nameValue == null || nameValue!.isEmpty) {
      publishCheckGet = false;
    }
    //手机是否填写
    if (phoneValue == null ||
        phoneValue!.isEmpty ||
        !validatePhoneRegExp(phoneValue!)) {
      publishCheckGet = false;
    }
    //组织机构是否填写
    if (organizationValue == null || organizationValue!.isEmpty) {
      publishCheckGet = false;
    }
    //简介是否填写
    if (introductionValue == null || introductionValue!.isEmpty) {
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

    final String imageDataStringFront = historyImagesListFront.isNotEmpty
        ? historyImagesListFront[0]
        : finalImagesListFront[0].realKey!;

    final String imageDataStringBack = historyImagesListBack.isNotEmpty
        ? historyImagesListBack[0]
        : finalImagesListBack[0].realKey!;

    final String imageDataStringPracticing =
        historyImagesListPracticing.isNotEmpty
            ? historyImagesListPracticing[0]
            : finalImagesListPracticing[0].realKey!;

    final String imageDataStringEmployee = historyImagesListEmployee.isNotEmpty
        ? historyImagesListEmployee[0]
        : finalImagesListEmployee[0].realKey!;

    Map<String, dynamic> form = {
      'name': nameValue,
      'gender': genderValue,
      'phone': phoneValue,
      'organization': organizationValue,
      'fcc': introductionValue,
      'identity_card_front': imageDataStringFront,
      'identity_card_back': imageDataStringBack,
      'practicing_certificate': imageDataStringPracticing,
      'employee_card': imageDataStringEmployee
    };

    if (authenticateInfo.id.isNotEmpty) {
      form['id'] = authenticateInfo.id;
      form['status'] = 2;
    }

    showLoading('请稍后...');

    if (authenticateInfo.id.isEmpty) {
      userClientProvider.createAuthenticateAction(form).then((result) {
        if (result.code == 200) {
          hideLoading();
          showToast('提交成功');
          clearAllImageData();
          Get.back<String>(result: 'success');
        } else {
          hideLoading();
          showToast('请求错误，请稍后再试');
        }
      }).catchError((e) {
        hideLoading();
        showToast('请求错误，请稍后再试');
      });
    } else {
      userClientProvider.updateAuthenticateAction(form).then((result) {
        if (result.code == 200) {
          hideLoading();
          showToast('提交成功');
          clearAllImageData();
          Get.back<String>(result: 'success');
        } else {
          hideLoading();
          showToast('请求错误，请稍后再试');
        }
      }).catchError((e) {
        hideLoading();
        showToast('请求错误，请稍后再试');
      });
    }
  }

  void clearAllImageData() {
    setState(() {
      imageDataListFront = [];
      galleryItemsFront = [];
      finalImagesListFront = [];
      historyImagesListFront = [];
      galleryItemsHistoryFront = [];

      imageDataListBack = [];
      galleryItemsBack = [];
      finalImagesListBack = [];
      historyImagesListBack = [];
      galleryItemsHistoryBack = [];

      imageDataListPracticing = [];
      galleryItemsPracticing = [];
      finalImagesListPracticing = [];
      historyImagesListPracticing = [];
      galleryItemsHistoryPracticing = [];

      imageDataListEmployee = [];
      galleryItemsEmployee = [];
      finalImagesListEmployee = [];
      historyImagesListEmployee = [];
      galleryItemsHistoryEmployee = [];
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

    void handleShowPicturesOrCanmera(String showType) {
      if (_uploading) {
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
                          onTap: showType == 'front'
                              ? () => handleChooseImagesFront('assets')
                              : showType == 'back'
                                  ? () => handleChooseImagesBack('assets')
                                  : showType == 'practicing'
                                      ? () =>
                                          handleChooseImagesPracticing('assets')
                                      : showType == 'employee'
                                          ? () => handleChooseImagesEmployee(
                                              'assets')
                                          : null,
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
                          onTap: showType == 'front'
                              ? () => handleChooseImagesFront('camera')
                              : showType == 'back'
                                  ? () => handleChooseImagesBack('camera')
                                  : showType == 'practicing'
                                      ? () =>
                                          handleChooseImagesPracticing('camera')
                                      : showType == 'employee'
                                          ? () => handleChooseImagesEmployee(
                                              'camera')
                                          : null,
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

    final double itemWidth = mediaQuerySizeInfo.width / 3 * 2;
    final double itemHeight = mediaQuerySizeInfo.width / 3 * 2 / 3 * 2;

    void open(BuildContext context, final int index, String showType) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              GalleryPhotoViewWrapper(
            galleryItems: showType == 'front'
                ? (galleryItemsHistoryFront.isNotEmpty
                    ? galleryItemsHistoryFront
                    : galleryItemsFront)
                : showType == 'back'
                    ? (galleryItemsHistoryBack.isNotEmpty
                        ? galleryItemsHistoryBack
                        : galleryItemsBack)
                    : showType == 'practicing'
                        ? (galleryItemsHistoryPracticing.isNotEmpty
                            ? galleryItemsHistoryPracticing
                            : galleryItemsPracticing)
                        : showType == 'employee'
                            ? (galleryItemsHistoryEmployee.isNotEmpty
                                ? galleryItemsHistoryEmployee
                                : galleryItemsEmployee)
                            : [],
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
                      Text(authenticateInfo.id.isEmpty ? '发起认证' : '重新提交认证',
                          style: const TextStyle(
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
                        ((authenticateInfo.status == 1 &&
                                authenticateInfo.audit_info != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('审核意见',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Text(authenticateInfo.audit_info!,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(234, 71, 56, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink()),
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
                        const Text('姓名',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('您要发起的认证姓名',
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
                          controller: _textControllerName,
                          maxLines: 1,
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
                            LengthLimitingTextInputFormatter(20)
                          ],
                          onChanged: changeName,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${nameValue != null ? nameValue!.length : 0}/20',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('联系电话',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('认证联系电话, 11位大陆手机号',
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
                          controller: _textControllerPhone,
                          maxLines: 1,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11)
                          ],
                          onChanged: changePhone,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${phoneValue != null ? phoneValue!.length : 0}/11',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('机构组织',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('您的认证机构组织名称',
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
                          controller: _textControllerOrganization,
                          maxLines: 2,
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
                            LengthLimitingTextInputFormatter(24)
                          ],
                          onChanged: changeOrganization,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${organizationValue != null ? organizationValue!.length : 0}/24',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('简介',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('认证简介, 该文字将会展示在您的个人主页中',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        TextField(
                          focusNode: _focusNode4,
                          onTapOutside: (PointerDownEvent p) {
                            // 点击外部区域时取消焦点
                            unfocusAllTextField();
                          },
                          controller: _textControllerIntroduction,
                          maxLines: 4,
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
                            LengthLimitingTextInputFormatter(60)
                          ],
                          onChanged: changeIntroduction,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${organizationValue != null ? organizationValue!.length : 0}/60',
                              style: const TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('身份证正面照',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('请保持人像照和个人信息清晰可见',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: galleryItemsHistoryFront.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => open(context, 0, 'front'),
                                  child: Hero(
                                    tag: galleryItemsHistoryFront[0].id,
                                    child: Container(
                                      width: itemWidth,
                                      height: itemHeight,
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
                                                galleryItemsHistoryFront[0]
                                                    .resource,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    handleShowPicturesOrCanmera(
                                                        'front'),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shuaxin,
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
                                )
                              : finalImagesListFront.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => open(context, 0, 'front'),
                                      child: Hero(
                                        tag: finalImagesListFront[0].id,
                                        child: galleryItemsFront.isEmpty
                                            ? Container(
                                                width: itemWidth,
                                                height: itemHeight,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            229, 229, 229, 1),
                                                        width: 2)),
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            strokeWidth: 2),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: itemWidth,
                                                height: itemHeight,
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
                                                          galleryItemsFront[0]
                                                              .resource,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              handleShowPicturesOrCanmera(
                                                                  'front'),
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
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .shuaxin,
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
                                    )
                                  : GestureDetector(
                                      onTap: () =>
                                          handleShowPicturesOrCanmera('front'),
                                      child: Container(
                                        width: itemWidth,
                                        height: itemHeight,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  189, 189, 189, 1),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.tupian,
                                            size: 32,
                                            color: 'rgb(189,189,189)',
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('身份证反面照',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('请保持国徽、有效期和颁发机关清晰可见',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: galleryItemsHistoryBack.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => open(context, 0, 'back'),
                                  child: Hero(
                                    tag: galleryItemsHistoryBack[0].id,
                                    child: Container(
                                      width: itemWidth,
                                      height: itemHeight,
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
                                            imageUrl: galleryItemsHistoryBack[0]
                                                .resource,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    handleShowPicturesOrCanmera(
                                                        'back'),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shuaxin,
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
                                )
                              : finalImagesListBack.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => open(context, 0, 'back'),
                                      child: Hero(
                                        tag: finalImagesListBack[0].id,
                                        child: galleryItemsBack.isEmpty
                                            ? Container(
                                                width: itemWidth,
                                                height: itemHeight,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            229, 229, 229, 1),
                                                        width: 2)),
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            strokeWidth: 2),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: itemWidth,
                                                height: itemHeight,
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
                                                          galleryItemsBack[0]
                                                              .resource,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              handleShowPicturesOrCanmera(
                                                                  'back'),
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
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .shuaxin,
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
                                    )
                                  : GestureDetector(
                                      onTap: () =>
                                          handleShowPicturesOrCanmera('back'),
                                      child: Container(
                                        width: itemWidth,
                                        height: itemHeight,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  189, 189, 189, 1),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.tupian,
                                            size: 32,
                                            color: 'rgb(189,189,189)',
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('执业证照',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('请保持个人信息和人像等清晰可见',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: galleryItemsHistoryPracticing.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => open(context, 0, 'practicing'),
                                  child: Hero(
                                    tag: galleryItemsHistoryPracticing[0].id,
                                    child: Container(
                                      width: itemWidth,
                                      height: itemHeight,
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
                                                galleryItemsHistoryPracticing[0]
                                                    .resource,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    handleShowPicturesOrCanmera(
                                                        'practicing'),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shuaxin,
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
                                )
                              : finalImagesListPracticing.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () =>
                                          open(context, 0, 'practicing'),
                                      child: Hero(
                                        tag: finalImagesListPracticing[0].id,
                                        child: galleryItemsPracticing.isEmpty
                                            ? Container(
                                                width: itemWidth,
                                                height: itemHeight,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            229, 229, 229, 1),
                                                        width: 2)),
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            strokeWidth: 2),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: itemWidth,
                                                height: itemHeight,
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
                                                          galleryItemsPracticing[
                                                                  0]
                                                              .resource,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              handleShowPicturesOrCanmera(
                                                                  'practicing'),
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
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .shuaxin,
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
                                    )
                                  : GestureDetector(
                                      onTap: () => handleShowPicturesOrCanmera(
                                          'practicing'),
                                      child: Container(
                                        width: itemWidth,
                                        height: itemHeight,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  189, 189, 189, 1),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.tupian,
                                            size: 32,
                                            color: 'rgb(189,189,189)',
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text('工作证照',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text('请保持个人信息和人像等清晰可见',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 150, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: galleryItemsHistoryEmployee.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => open(context, 0, 'employee'),
                                  child: Hero(
                                    tag: galleryItemsHistoryEmployee[0].id,
                                    child: Container(
                                      width: itemWidth,
                                      height: itemHeight,
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
                                                galleryItemsHistoryEmployee[0]
                                                    .resource,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    handleShowPicturesOrCanmera(
                                                        'employee'),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0,
                                                              0,
                                                              0,
                                                              0.7),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4))),
                                                  child: Center(
                                                    child: IconFont(
                                                      IconNames.shuaxin,
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
                                )
                              : finalImagesListEmployee.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => open(context, 0, 'employee'),
                                      child: Hero(
                                        tag: finalImagesListEmployee[0].id,
                                        child: galleryItemsEmployee.isEmpty
                                            ? Container(
                                                width: itemWidth,
                                                height: itemHeight,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            229, 229, 229, 1),
                                                        width: 2)),
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            strokeWidth: 2),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: itemWidth,
                                                height: itemHeight,
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
                                                          galleryItemsEmployee[
                                                                  0]
                                                              .resource,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              handleShowPicturesOrCanmera(
                                                                  'employee'),
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
                                                            child: Center(
                                                              child: IconFont(
                                                                IconNames
                                                                    .shuaxin,
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
                                    )
                                  : GestureDetector(
                                      onTap: () => handleShowPicturesOrCanmera(
                                          'employee'),
                                      child: Container(
                                        width: itemWidth,
                                        height: itemHeight,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  189, 189, 189, 1),
                                              width: 1,
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: IconFont(
                                            IconNames.tupian,
                                            size: 32,
                                            color: 'rgb(189,189,189)',
                                          ),
                                        ),
                                      ),
                                    ),
                        )
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
