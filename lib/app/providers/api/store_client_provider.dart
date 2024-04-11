import 'dart:io';

import 'package:get/get.dart';
import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/user_model.dart';
import '../../models/pain_model.dart';
import '../../models/store_model.dart';
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

class StoreClientProvider extends GlobalClientProvider {
  StoreClientProvider() : super(); // 调用 GlobalClientProvider 的构造函数

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

  static List<StoreLiveCourseTypeModel> fromJsonListLiveCourse(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => StoreLiveCourseTypeModel.fromJson(json))
        .toList();
  }

  static List<StoreVideoCourseTypeModel> fromJsonListVideoCourse(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => StoreVideoCourseTypeModel.fromJson(json))
        .toList();
  }

  static List<StoreCourseChartTypeModel> fromJsonListCourseChart(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => StoreCourseChartTypeModel.fromJson(json))
        .toList();
  }

  static List<PainReplyTypeModel> fromJsonListReply(List<dynamic> jsonList) {
    return jsonList.map((json) => PainReplyTypeModel.fromJson(json)).toList();
  }

  // 分页请求直播课程列表
  Future<DataPaginationFinalModel<List<StoreLiveCourseTypeModel>>>
      getLiveCoursesByCustomAction(
          {String? keyword,
          int? pageNo = 1,
          int? pageSize = 10,
          int? courseType}) async {
    final Map<String, dynamic> queryMap = {
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };
    if (keyword != null) {
      queryMap['keyword'] = keyword.toString();
    }
    if (courseType != null) {
      queryMap['course_type'] = courseType.toString();
    }

    final jsonData = await get('/live_course/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<StoreLiveCourseTypeModel> list =
        fromJsonListLiveCourse(jsonMap['data']['data']);

    final DataPaginationInModel<List<StoreLiveCourseTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<StoreLiveCourseTypeModel>>
        dataFinalLiveCourseTypeModel =
        DataPaginationFinalModel<List<StoreLiveCourseTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalLiveCourseTypeModel;
  }

  // 根据直播课程轮播
  Future<DataFinalModel<List<StoreLiveCourseTypeModel>>>
      getCarouselLiveCoursesAction() async {
    final jsonData = await get('/live_course/carousel');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<StoreLiveCourseTypeModel> list =
        fromJsonListLiveCourse(jsonMap['data']);

    final DataFinalModel<List<StoreLiveCourseTypeModel>>
        dataFinalCarouselLiveCoursesModel = DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalCarouselLiveCoursesModel;
  }

  // 根据视频课程轮播
  Future<DataFinalModel<List<StoreVideoCourseTypeModel>>>
      getCarouselVideoCoursesAction() async {
    final jsonData = await get('/video_course/carousel');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<StoreVideoCourseTypeModel> list =
        fromJsonListVideoCourse(jsonMap['data']);

    final DataFinalModel<List<StoreVideoCourseTypeModel>>
        dataFinalCarouselVideoCoursesModel = DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalCarouselVideoCoursesModel;
  }

  // 分页请求视频课程列表
  Future<DataPaginationFinalModel<List<StoreVideoCourseTypeModel>>>
      getVideoCoursesByCustomAction(
          {String? keyword,
          int? pageNo = 1,
          int? pageSize = 10,
          int? courseType}) async {
    final Map<String, dynamic> queryMap = {
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };
    if (keyword != null) {
      queryMap['keyword'] = keyword.toString();
    }
    if (courseType != null) {
      queryMap['course_type'] = courseType.toString();
    }

    final jsonData = await get('/video_course/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<StoreVideoCourseTypeModel> list =
        fromJsonListVideoCourse(jsonMap['data']['data']);

    final DataPaginationInModel<List<StoreVideoCourseTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<StoreVideoCourseTypeModel>>
        dataFinalVideoCourseTypeModel =
        DataPaginationFinalModel<List<StoreVideoCourseTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalVideoCourseTypeModel;
  }

  // 根据ID获取直播课程信息
  Future<DataFinalModel<StoreLiveCourseTypeModel>> getCourseLiveByIdAction(
      String id) async {
    final jsonData = await get('/live_course/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<StoreLiveCourseTypeModel>
        dataFinalCourseLiveTypeModel = DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: StoreLiveCourseTypeModel.fromJson(jsonMap['data']));
    return dataFinalCourseLiveTypeModel;
  }

  // 根据课程购物车信息
  Future<DataFinalModel<List<StoreCourseChartTypeModel>>>
      getCourseChartListAction() async {
    final jsonData = await get('/course_chart');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<StoreCourseChartTypeModel> list =
        fromJsonListCourseChart(jsonMap['data']);

    final DataFinalModel<List<StoreCourseChartTypeModel>>
        dataFinalCourseChartsModel = DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalCourseChartsModel;
  }

  // 添加课程至购物车
  Future<DataFinalModel> createCourseChartAction(
      String courseId, int addCourseType) async {
    final jsonData = await post('/course_chart',
        {'course_id': courseId, 'add_course_type': addCourseType});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 根据ID获取视频课程信息
  Future<DataFinalModel<StoreVideoCourseTypeModel>> getCourseVideoByIdAction(
      String id) async {
    final jsonData = await get('/video_course/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<StoreVideoCourseTypeModel>
        dataFinalCourseVideoTypeModel = DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: StoreVideoCourseTypeModel.fromJson(jsonMap['data']));
    return dataFinalCourseVideoTypeModel;
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

  // 文件上传-问题
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

  // 分页请求答复列表
  Future<DataPaginationFinalModel<List<PainReplyTypeModel>>>
      getPainRepliesByCustomAction(
          {required String questionId,
          int? pageNo = 1,
          int? pageSize = 10}) async {
    final jsonData = await get('/pain_reply/custom', query: {
      'question_id': questionId,
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    });
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PainReplyTypeModel> list =
        fromJsonListReply(jsonMap['data']['data']);

    final DataPaginationInModel<List<PainReplyTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<PainReplyTypeModel>>
        dataFinalPainReplyTypeModel =
        DataPaginationFinalModel<List<PainReplyTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalPainReplyTypeModel;
  }

  // 更新答复点赞
  Future<DataFinalModel> updateReplyLikeAction(
      String id, int status, int pageSize) async {
    final jsonData = await put('/pain_reply/like',
        {'id': id, 'status': status, 'page_size': pageSize});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 更新评论点赞
  Future<DataFinalModel> updateCommentLikeAction(
      String id, int status, int pageSize) async {
    final jsonData = await put('/pain_comment/like',
        {'id': id, 'status': status, 'page_size': pageSize});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 根据ID获取答复信息
  Future<DataFinalModel<PainReplyTypeModel>> getReplyByIdAction(
      String id) async {
    final jsonData = await get('/pain_reply/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainReplyTypeModel> dataFinalPainReplyTypeModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PainReplyTypeModel.fromJson(jsonMap['data']));
    return dataFinalPainReplyTypeModel;
  }

  // 根据ID获取评论信息
  Future<DataFinalModel<PainCommentTypeModel>> getCommentByIdAction(
      String id) async {
    final jsonData = await get('/pain_comment/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainCommentTypeModel> dataFinalPainCommentTypeModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PainCommentTypeModel.fromJson(jsonMap['data']));
    return dataFinalPainCommentTypeModel;
  }

  // 文件上传-答复
  Future<DataFinalModel<String?>> painReplyImageDataUploadAction(
      File file, String filename) async {
    final FormData formData =
        FormData({'file': MultipartFile(file, filename: filename)});
    final jsonData = await post('/pain_reply/upload/data', formData);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel<String?> dataFinalUploadModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: jsonMap['data']);
    return dataFinalUploadModel;
  }

  // 发布答复
  Future<DataFinalModel> painReplyCreateAction(
      Map<String, dynamic> json) async {
    final jsonData = await post('/pain_reply', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalPainReplyCreate = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalPainReplyCreate;
  }

  // 文件上传-评论
  Future<DataFinalModel<String?>> painCommentImageDataUploadAction(
      File file, String filename) async {
    final FormData formData =
        FormData({'file': MultipartFile(file, filename: filename)});
    final jsonData = await post('/pain_comment/upload/data', formData);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel<String?> dataFinalUploadModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: jsonMap['data']);
    return dataFinalUploadModel;
  }

  // 发布评论
  Future<DataFinalModel> painCommentCreateAction(
      Map<String, dynamic> json) async {
    final jsonData = await post('/pain_comment', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalPainCommentCreate = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalPainCommentCreate;
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
