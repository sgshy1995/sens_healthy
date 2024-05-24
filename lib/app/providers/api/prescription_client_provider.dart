import 'package:get/get.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/user_model.dart';
import '../../models/prescription_model.dart';

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

class PrescriptionClientProvider extends GlobalClientProvider {
  PrescriptionClientProvider() : super(); // 调用 GlobalClientProvider 的构造函数

  static List<PrescriptionTagTypeModel> fromJsonListPrescriptionTag(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => PrescriptionTagTypeModel.fromJson(json))
        .toList();
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

  static List<PrescriptionTypeModel> fromJsonListPrescription(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => PrescriptionTypeModel.fromJson(json))
        .toList();
  }

  // 分页请求康复处方列表
  Future<DataPaginationFinalModel<List<PrescriptionTypeModel>>>
      getPrescriptionsByCustomAction(
          {int? pageNo = 1,
          int? pageSize = 10,
          String? rehabilitation,
          String? part,
          String? symptoms,
          String? phase,
          int? hotOrder}) async {
    final Map<String, dynamic> queryMap = {
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };
    if (rehabilitation != null) {
      queryMap['rehabilitation'] = rehabilitation.toString();
    }
    if (part != null) {
      queryMap['part'] = part.toString();
    }
    if (symptoms != null) {
      queryMap['symptoms'] = symptoms.toString();
    }
    if (phase != null) {
      queryMap['phase'] = phase.toString();
    }
    if (hotOrder != null) {
      queryMap['hot_order'] = hotOrder.toString();
    }

    final jsonData = await get('/prescription/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PrescriptionTypeModel> list =
        fromJsonListPrescription(jsonMap['data']['data']);

    final DataPaginationInModel<List<PrescriptionTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<PrescriptionTypeModel>>
        dataFinalPrescriptionTypeModel =
        DataPaginationFinalModel<List<PrescriptionTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalPrescriptionTypeModel;
  }

  // 根据ID获取处方信息
  Future<DataFinalModel<PrescriptionTypeModel>> getPrescriptionByIdAction(
      String id) async {
    final jsonData = await get('/prescription/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PrescriptionTypeModel>
        dataFinalPainPrescriptionTypeModel = DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PrescriptionTypeModel.fromJson(jsonMap['data']));
    return dataFinalPainPrescriptionTypeModel;
  }

  // 处方根据id增加观看人数
  Future<DataFinalModel> addPrescriptionWatchNumAction(String id) async {
    final jsonData = await post('/prescription/watch/$id', {});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 获取可检索的标签
  Future<DataFinalModel<List<PrescriptionTagTypeModel>>>
      findManyPrescriptionTagsAction() async {
    final Map<String, dynamic> query = {'status': '1'};
    final jsonData = await get('/prescription_tag/custom', query: query);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PrescriptionTagTypeModel> list =
        fromJsonListPrescriptionTag(jsonMap['data']);

    final DataFinalModel<List<PrescriptionTagTypeModel>> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalModel;
  }

  // Get request
  Future<String> captureAction(String deviceId) async {
    final jsonData = await get('/auth/capture', query: {"device_id": deviceId});
    String body = jsonData.body;
    return body;
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
