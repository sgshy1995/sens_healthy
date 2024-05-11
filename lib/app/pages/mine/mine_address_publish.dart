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
import 'package:city_pickers/city_pickers.dart';

Result emptyResult = Result();

class MyAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'zh'; // 强制修改语言代码为汉语
}

class MineAddressPublishPage extends StatefulWidget {
  const MineAddressPublishPage({super.key});

  @override
  State<MineAddressPublishPage> createState() => _MineAddressPublishPageState();
}

class _MineAddressPublishPageState extends State<MineAddressPublishPage> {
  final UserClientProvider userClientProvider = Get.put(UserClientProvider());
  final GlobalController globalController = Get.put(GlobalController());
  final UserController userController = Get.put(UserController());

  final TextEditingController _textControllerDetailText =
      TextEditingController();
  final TextEditingController _textControllerAddressName =
      TextEditingController();
  final TextEditingController _textControllerAddressPhone =
      TextEditingController();
  final TextEditingController _textControllerAddressInputLocation =
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
  String? addressName;
  String? addressPhone;
  String? detailText;
  bool painAnonymityValue = false;
  String? provinceCode;
  String? cityCode;
  String? areaCode;
  String? addressInputLocation;
  String? choosedTag;

  String? addressId;
  String? userId;

  final List<String> tagsList = ['家', '公司', '学校', '商场'];

  void handleChooseTag(int index) {
    setState(() {
      choosedTag = choosedTag == tagsList[index] ? null : tagsList[index];
    });
  }

  List<AssetEntity> imageDataList = [];
  List<GalleryExampleItem> galleryItems = [];
  List<PainFileUploadTypeModel> finalImagesList = [];

  bool _uploading = false;

  bool inputEnabled = true;

  @override
  void initState() {
    super.initState();
    if (Get.arguments['form'] != null) {
      print(Get.arguments['form']);
      final Map form = Get.arguments['form'];
      addressId = form['addressId'];
      userId = form['userId'];
      addressName = form['addressName'];
      addressPhone = form['addressPhone'];
      detailText = form['detailText'];
      addressInputLocation = form['addressInputLocation'];
      provinceCode = form['provinceCode'];
      cityCode = form['cityCode'];
      areaCode = form['areaCode'];
      choosedTag = form['choosedTag'];
      _textControllerDetailText.text = detailText ?? '';
      _textControllerAddressName.text = addressName ?? '';
      _textControllerAddressPhone.text = addressPhone ?? '';
      _textControllerAddressInputLocation.text = addressInputLocation ?? '';
      checkIfCanPublish();
    }
  }

  @override
  void dispose() {
    _textControllerDetailText.dispose();
    _textControllerAddressName.dispose();
    _textControllerAddressPhone.dispose();
    _textControllerAddressInputLocation.dispose();
    super.dispose();
  }

  void changeAddressName(String? value) {
    setState(() {
      addressName = value;
    });
    checkIfCanPublish();
  }

  void changeAddressPhone(String? value) {
    setState(() {
      addressPhone = value;
    });
    checkIfCanPublish();
  }

  void changeDetailText(String value) {
    setState(() {
      detailText = value;
    });
    checkIfCanPublish();
  }

  void changeAddressInputLocation(String? value) {
    setState(() {
      addressInputLocation = value;
    });
    checkIfCanPublish();
  }

  void handleGoBack() {
    Get.back();
  }

  void checkIfCanPublish() {
    bool publishCheckGet = true;
    //联系人是否填写
    if (addressName == null || addressName!.isEmpty) {
      publishCheckGet = false;
    }
    //联系电话是否填写
    if (addressPhone == null || addressPhone!.isEmpty) {
      publishCheckGet = false;
    }
    //省市区县是否选择
    if (detailText == null || detailText!.isEmpty) {
      publishCheckGet = false;
    }
    //详细地址是否填写
    if (addressInputLocation == null || addressInputLocation!.isEmpty) {
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
      'name': addressName,
      'phone': addressPhone,
      'detail_text': detailText,
      'tag': choosedTag,
      'all_text': '$detailText$addressInputLocation',
      'province_code': provinceCode,
      'city_code': cityCode,
      'area_code': areaCode
    };

    if (addressId != null) {
      form['id'] = addressId;
      form['user_id'] = userId;
    }

    showLoading('请稍后...');

    if (addressId == null) {
      userClientProvider.createAddressAction(form).then((value) {
        if (value.code == 200) {
          userClientProvider.getInfoByJWTAction().then((resultIn) {
            if (resultIn.code == 200 && resultIn.data != null) {
              userController.setInfo(resultIn.data!);
              hideLoading();
              Get.back<String>(result: 'success');
            } else {
              hideLoading();
              showToast(resultIn.message);
            }
          }).catchError((e) {
            hideLoading();
            showToast('操作失败, 请稍后再试');
          });
        } else {
          hideLoading();
          showToast(value.message);
        }
      }).catchError((e) {
        hideLoading();
        showToast('操作失败, 请稍后再试');
      });
    } else {
      userClientProvider.updateAddressAction(form).then((value) {
        if (value.code == 200) {
          userClientProvider.getInfoByJWTAction().then((resultIn) {
            if (resultIn.code == 200 && resultIn.data != null) {
              userController.setInfo(resultIn.data!);
              hideLoading();
              Get.back<String>(result: 'success');
            } else {
              hideLoading();
              showToast(resultIn.message);
            }
          }).catchError((e) {
            hideLoading();
            showToast('操作失败, 请稍后再试');
          });
        } else {
          hideLoading();
          showToast(value.message);
        }
      }).catchError((e) {
        hideLoading();
        showToast('操作失败, 请稍后再试');
      });
    }
  }

  Result pickerResult = Result();

  void handleShowPicker() {
    setState(() {
      inputEnabled = false;
    });
    CityPickers.showFullPageCityPicker(
            theme: ThemeData(
                primaryColor: Colors.red,
                listTileTheme: const ListTileThemeData(
                    selectedColor: Color.fromRGBO(211, 66, 67, 1),
                    textColor: Colors.black,
                    leadingAndTrailingTextStyle: TextStyle(
                        color: Color.fromRGBO(211, 66, 67, 1), fontSize: 14),
                    titleTextStyle: TextStyle(
                        color: Color.fromRGBO(211, 66, 67, 1), fontSize: 14)),
                appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                dividerColor: Colors.transparent),
            context: context,
            locationCode: areaCode ?? cityCode ?? provinceCode ?? "110000",
            showType: ShowType.pca)
        .then((tempResult) {
      print(tempResult);
      setState(() {
        inputEnabled = true;
      });
      if (tempResult == null) {
        return;
      }
      _textControllerDetailText.text =
          '${tempResult.provinceName}${tempResult.cityName}${tempResult.areaName}';
      setState(() {
        pickerResult = tempResult;
        provinceCode = pickerResult.provinceId;
        cityCode = pickerResult.cityId;
        areaCode = pickerResult.areaId;
        detailText =
            '${tempResult.provinceName}${tempResult.cityName}${tempResult.areaName}';
      });
      checkIfCanPublish();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets mediaQuerySafeInfo = MediaQuery.of(context).padding;
    final Size mediaQuerySizeInfo = MediaQuery.of(context).size;

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
                  Text(addressId == null ? '创建地址' : '修改地址',
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
                    const Text('联系人',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('配送联系人',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      enabled: inputEnabled,
                      controller: _textControllerAddressName,
                      maxLines: 1,
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
                        hintText: '请输入配送联系人',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(12)],
                      onChanged: changeAddressName,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${addressName != null ? addressName!.length : 0}/12',
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
                    const Text('配送联系电话, 11位大陆手机号',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      enabled: inputEnabled,
                      controller: _textControllerAddressPhone,
                      maxLines: 1,
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
                        hintText: '请输入手机号',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11)
                      ],
                      onChanged: changeAddressPhone,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${addressPhone != null ? addressPhone!.length : 0}/11',
                          style: const TextStyle(
                              color: Color.fromRGBO(150, 150, 150, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('省 / 市 / 区 (县)',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('配送省 / 市 / 区 (县)地址',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: handleShowPicker,
                      child: TextField(
                          enabled: false,
                          controller: _textControllerDetailText,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              fontSize: 15, // 设置字体大小为20像素
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15),
                            fillColor: const Color.fromRGBO(250, 250, 250, 1),
                            filled: true, // 使用图标
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(4), // 设置圆角大小
                            ),
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
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: '请选择地址',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0), // 增加垂直内边距来增加高度
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('详细地址',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('配送详细地址, 精确到街道、小区、门牌号等',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      enabled: inputEnabled,
                      controller: _textControllerAddressInputLocation,
                      maxLines: 4,
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
                        hintText: '请输入详细地址',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0), // 增加垂直内边距来增加高度
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                      onChanged: changeAddressInputLocation,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${addressInputLocation != null ? addressInputLocation!.length : 0}/60',
                          style: const TextStyle(
                              color: Color.fromRGBO(150, 150, 150, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('标签',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text('可以通过为地址添加标签进行标记',
                        style: TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(
                      height: 18,
                    ),
                    Wrap(
                      spacing: 8.0, // 间距
                      runSpacing: 4.0, // 行间距
                      children: List.generate(tagsList.length, (index) {
                        return GestureDetector(
                          onTap: () => handleChooseTag(index),
                          child: Chip(
                            side: BorderSide.none,
                            backgroundColor: choosedTag == tagsList[index]
                                ? const Color.fromRGBO(211, 66, 67, 1)
                                : const Color.fromRGBO(233, 234, 235, 1),
                            labelStyle: TextStyle(
                                color: choosedTag == tagsList[index]
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14),
                            label: Text(tagsList[index]),
                          ),
                        );
                      }),
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
