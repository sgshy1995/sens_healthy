import 'dart:io';

import 'package:get/get.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/user_model.dart';
import '../../models/pain_model.dart';
import 'package:dio/dio.dart' as dio;

class UserModel {
  final String code;
  final String message;
  final Object? data;
  // 其他属性

  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  UserModel({required this.code, required this.message, this.data});

  factory UserModel.fromJson(UserModel json) {
    return UserModel(code: json.code, message: json.message, data: json.data
        // 初始化其他属性
        );
  }
}

class CapturePhoneModel {
  final int code;
  final String message;
  CapturePhoneModel({required this.code, required this.message});
  factory CapturePhoneModel.fromJson(Map<String, dynamic> json) {
    return CapturePhoneModel(code: json['code'], message: json['message']
        // 初始化其他属性
        );
  }
}

class LoginModel {
  final int code;
  final String message;
  final LoginDataModel? data;

  LoginModel({required this.code, required this.message, required this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        code: json['code'],
        message: json['message'],
        data:
            json['data'] != null ? LoginDataModel.fromJson(json['data']) : null
        // 初始化其他属性
        );
  }
}

class LoginDataModel {
  final String token;
  LoginDataModel({required this.token});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(token: json['token']);
  }
}

class PainClientProvider extends GlobalClientProvider {
  PainClientProvider() : super(); // 调用 GlobalClientProvider 的构造函数

  Future<List<UserModel>> getUsers() async {
    final response = await get('users/path');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return UserModel.fromJsonList(response.body);
    }
  }

  @override
  void onInit() {
    super.onInit(); // 调用 GlobalClientProvider 的 onInit 方法
    // 可以在这里进行其他初始化操作
    setDefaultDecoder((json) {
      return UserModel.fromJson(json);
    });
  }

  static List<PainQuestionTypeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PainQuestionTypeModel.fromJson(json))
        .toList();
  }

  // Get request
  Future<DataPaginationFinalModel<List<PainQuestionTypeModel>>>
      getPainQuestionsByCustomAction(
          {String? keyword, int? pageNo = 1, int? pageSize = 10}) async {
    final jsonData = await get('/pain_question/custom', query: {
      'keyword': keyword ?? '',
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    });
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PainQuestionTypeModel> list =
        fromJsonList(jsonMap['data']['data']);

    final DataPaginationInModel<List<PainQuestionTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<PainQuestionTypeModel>>
        dataFinalUserTypeModel =
        DataPaginationFinalModel<List<PainQuestionTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalUserTypeModel;
  }

  // 根据ID获取问题信息
  Future<DataFinalModel<PainQuestionTypeModel>> getQuestionByIdAction(
      String id) async {
    final jsonData = await get('/pain_question/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainQuestionTypeModel> dataFinalPainQuestionTypeModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PainQuestionTypeModel.fromJson(jsonMap['data']));
    return dataFinalPainQuestionTypeModel;
  }

  // 更新问题点赞
  Future<DataFinalModel> updateQuestionLikeAction(String id, int status) async {
    final jsonData =
        await put('/pain_question/like', {'id': id, 'status': status});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 更新问题收藏
  Future<DataFinalModel> updateQuestionCollectAction(
      String id, int status) async {
    final jsonData =
        await put('/pain_question/collect', {'id': id, 'status': status});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 文件上传
  Future<DataFinalModel<String?>> painQuestionImageDataUploadAction(
      File file, String filename) async {
    final FormData formData =
        FormData({'file': MultipartFile(file, filename: filename)});
    final jsonData = await post('/pain_question/upload/data', formData);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel<String?> dataFinalUploadModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: jsonMap['data']);
    return dataFinalUploadModel;
  }

  // 删除不必要图片
  Future<DataFinalModel> removeUnnecessaryImagesAction(
      List<String> keys) async {
    final jsonData = await post('/pain_question/unnecessary', {'keys': keys});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 发布问题
  Future<DataFinalModel> painQuestionCreateAction(
      Map<String, dynamic> json) async {
    final jsonData = await post('/pain_question', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalPainQuestionCreate = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalPainQuestionCreate;
  }

  // Get request
  Future<String> captureAction(String deviceId) async {
    final jsonData = await get('/auth/capture', query: {"device_id": deviceId});
    String body = jsonData.body;
    return body;
  }

  // Get request
  Future<CapturePhoneModel> capturePhoneAction(
      String deviceId, String phone, String capture,
      {String? ifReSend = '0'}) async {
    final jsonData = await get('/auth/capture_phone', query: {
      "device_id": deviceId,
      "phone": phone,
      "capture": capture,
      "if_re_send": ifReSend == '0' ? 'false' : 'true'
    });
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final CapturePhoneModel capturePhoneModel =
        CapturePhoneModel.fromJson(jsonMap);
    return capturePhoneModel;
  }

  // Get request
  Future<DataFinalModel<UserTypeModel>> getUserInfoByJWTAction() async {
    final jsonData = await get('/user');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<UserTypeModel> dataFinalUserTypeModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: UserTypeModel.fromJson(jsonMap['data']));
    return dataFinalUserTypeModel;
  }

  // Get request
  Future<DataFinalModel<UserInfoTypeModel>> getInfoByJWTAction() async {
    final jsonData = await get('/user_info/user');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel<UserInfoTypeModel> dataFinalUserInfoTypeModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: UserInfoTypeModel.fromJson(jsonMap['data']));
    return dataFinalUserInfoTypeModel;
  }

  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', data);

  // Post request with File
  Future<Response<UserModel>> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }

  // socket
  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
