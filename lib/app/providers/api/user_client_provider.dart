import 'dart:io';

import 'package:get/get.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/user_model.dart';

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

class UserClientProvider extends GlobalClientProvider {
  UserClientProvider() : super(); // 调用 GlobalClientProvider 的构造函数

  static List<AddressInfoTypeModel> fromJsonListAddress(
      List<dynamic> jsonList) {
    return jsonList.map((json) => AddressInfoTypeModel.fromJson(json)).toList();
  }

  static List<TopUpOrderTypeModel> fromJsonListTopUpOrder(
      List<dynamic> jsonList) {
    return jsonList.map((json) => TopUpOrderTypeModel.fromJson(json)).toList();
  }

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

  // Get request
  Future<String> captureAction(String deviceId) async {
    final jsonData = await get('/auth/capture', query: {"device_id": deviceId});
    String body = jsonData.body;
    return body;
  }

  // 登录获取验证码
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

  // 手机号登录
  Future<LoginModel> loginAction(
      String deviceId, String phone, String capture) async {
    final jsonData = await post('/user/login',
        {"device_id": deviceId, "phone": phone, "capture_phone": capture});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final LoginModel capturePhoneModel = LoginModel.fromJson(jsonMap);
    return capturePhoneModel;
  }

  // 修改手机号获取取验证码
  Future<CapturePhoneModel> getCapturePhoneChangeAction(
      String deviceId, String phone, String username) async {
    final Map<String, dynamic> query = {
      "device_id": deviceId,
      "phone": phone,
      "username": username
    };
    print(query);
    final jsonData = await get('/auth/new/capture_phone', query: query);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final CapturePhoneModel capturePhoneModel =
        CapturePhoneModel.fromJson(jsonMap);
    return capturePhoneModel;
  }

  // 退出登录
  Future<DataFinalModel> logoutAction() async {
    final jsonData = await post('/user/logout', null);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinal = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinal;
  }

  // 根据 jwt 获取用户信息
  Future<DataFinalModel<UserTypeModel>> getUserInfoByJWTAction() async {
    final jsonData = await get('/user');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<UserTypeModel> dataFinalUserTypeModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: UserTypeModel.fromJson(jsonMap['data']));
    return dataFinalUserTypeModel;
  }

  // 根据 jwt 更新用户信息
  Future<DataFinalModel> updateUserByJwtAction(Map<String, dynamic> user,
      {String? deviceId, String? phoneCapture}) async {
    final Map form = {'user': user};

    if (deviceId != null) {
      form['device_id'] = deviceId;
    }

    if (phoneCapture != null) {
      form['phone_capture'] = phoneCapture;
    }

    final jsonData = await put('/user/jwt', form);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinal = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinal;
  }

  // 根据 jwt 获取个人信息
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

  // 根据 jwt 更新个人信息
  Future<DataFinalModel> updateInfoByJwtAction(
      Map<String, dynamic> json) async {
    final jsonData = await put('/user_info/jwt', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinal = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinal;
  }

  // 文件上传-头像
  Future<DataFinalModel<String?>> avatarUploadAction(
      File file, String filename) async {
    final FormData formData =
        FormData({'file': MultipartFile(file, filename: filename)});
    final jsonData = await post('/user/upload_avatar', formData);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel<String?> dataFinalUploadModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: jsonMap['data']);
    return dataFinalUploadModel;
  }

  // 文件上传-伤痛档案影像资料
  Future<DataFinalModel<String?>> recordImageDataUploadAction(
      File file, String filename) async {
    final FormData formData =
        FormData({'file': MultipartFile(file, filename: filename)});
    final jsonData = await post('/user_info/upload/data', formData);
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

  // 创建地址
  Future<DataFinalModel> createAddressAction(Map<String, dynamic> json) async {
    final jsonData = await post('/address', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinal = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinal;
  }

  // 更新地址
  Future<DataFinalModel> updateAddressAction(Map<String, dynamic> json) async {
    final jsonData = await put('/address', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinal = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinal;
  }

  // 根据id地址删除
  Future<DataFinalModel> deleteAddressByIdAction(String addressId) async {
    final jsonData = await delete('/address/$addressId');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 获取用户的地址列表
  Future<DataFinalModel<List<AddressInfoTypeModel>>>
      getAddressListByJWTAction() async {
    final jsonData = await get('/address');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<AddressInfoTypeModel> list = fromJsonListAddress(jsonMap['data']);

    final DataFinalModel<List<AddressInfoTypeModel>> dataFinalListModel =
        DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalListModel;
  }

  // 根据 jwt 信息充值
  Future<DataFinalModel<TopUpOrderTypeModel>> addBalanceByUserIdAction(
      String balance, int paymentType) async {
    final jsonData = await put('/user_info/balance/add',
        {'balance': balance, 'payment_type': paymentType});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<TopUpOrderTypeModel> dataFinalModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: TopUpOrderTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }

  // 余额明细列表获取, 带分页
  Future<DataPaginationFinalModel<List<TopUpOrderTypeModel>>>
      getTopUpOrdersWithPaginationAction(
          {required String userId,
          int? pageNo = 1,
          int? pageSize = 10,
          int? recent}) async {
    final Map<String, dynamic> queryMap = {
      'user_id': userId.toString(),
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };
    if (recent != null) {
      queryMap['recent'] = recent.toString();
    }

    final jsonData = await get('/top_up_order/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<TopUpOrderTypeModel> list =
        fromJsonListTopUpOrder(jsonMap['data']['data']);

    final DataPaginationInModel<List<TopUpOrderTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<TopUpOrderTypeModel>> dataFinalModel =
        DataPaginationFinalModel<List<TopUpOrderTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalModel;
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
