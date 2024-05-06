import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/appointment_model.dart';

class AppointmentClientProvider extends GlobalClientProvider {
  AppointmentClientProvider() : super();

  static List<LecturerTimeTypeModel> fromJsonListLecturerTimes(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => LecturerTimeTypeModel.fromJson(json))
        .toList();
  }

  static List<PatientCourseTypeModel> fromJsonListPatientCourse(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => PatientCourseTypeModel.fromJson(json))
        .toList();
  }

  // 根据JWT获取预约时间列表
  Future<DataFinalModel<List<LecturerTimeTypeModel>>>
      findManyLecturerTimesByJwtAction({int? ifBooked}) async {
    final Map<String, dynamic> query = {};
    if (ifBooked != null) {
      query['if_booked'] = ifBooked.toString();
    }
    final jsonData = await get('/lecturer_time', query: query);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<LecturerTimeTypeModel> list =
        fromJsonListLecturerTimes(jsonMap['data']);

    final DataFinalModel<List<LecturerTimeTypeModel>> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalModel;
  }

  // 获取可预约的时间列表
  Future<DataFinalModel<List<LecturerTimeTypeModel>>>
      findManyLecturerTimesCanBeBookedAction(
          {String? bookId, String? bookHistoryUserId}) async {
    final Map<String, dynamic> query = {};
    if (bookId != null) {
      query['book_id'] = bookId.toString();
    }
    if (bookHistoryUserId != null) {
      query['book_history_user_id'] = bookHistoryUserId.toString();
    }
    final jsonData = await get('/lecturer_time/can_be_booked', query: query);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<LecturerTimeTypeModel> list =
        fromJsonListLecturerTimes(jsonMap['data']);

    final DataFinalModel<List<LecturerTimeTypeModel>> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalModel;
  }

  // 创建预约时间
  Future<DataFinalModel> createLecturerTimeAction(
      Map<String, dynamic> json) async {
    final jsonData = await post('/lecturer_time', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreateModel;
  }

  // 修改预约时间
  Future<DataFinalModel> updateLecturerTimeAction(
      Map<String, dynamic> json) async {
    final jsonData = await put('/lecturer_time/normal', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreateModel;
  }

  // 根据ID获取约预约时间信息
  Future<DataFinalModel<LecturerTimeTypeModel>> getLecturerTimeByIdAction(
      String id) async {
    final jsonData = await get('/lecturer_time/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<LecturerTimeTypeModel> dataFinalModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: LecturerTimeTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }

  // 删除预约时间
  Future<DataFinalModel> deleteOneLecturerTimeAction(
      {required String id, String? canceledReason}) async {
    final Map<String, dynamic> form = {'id': id};
    if (canceledReason != null) {
      form['canceled_reason'] = canceledReason.toString();
    }
    final jsonData = await post('/lecturer_time/delete', form);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreateModel;
  }

  // 分页请求患者课程列表
  Future<DataPaginationFinalModel<List<PatientCourseTypeModel>>>
      getPatientCoursesPaginationAction(
          {required String userId,
          int? pageNo = 1,
          int? pageSize = 10,
          dynamic learnNum,
          int? status}) async {
    final Map<String, dynamic> queryMap = {
      'user_id': userId.toString(),
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };
    if (learnNum != null) {
      queryMap['learn_num'] = learnNum.toString();
    }
    if (status != null) {
      queryMap['status'] = status.toString();
    }

    final jsonData = await get('/patient_course/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PatientCourseTypeModel> list =
        fromJsonListPatientCourse(jsonMap['data']['data']);

    final DataPaginationInModel<List<PatientCourseTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<PatientCourseTypeModel>>
        dataFinalEquipmentTypeModel =
        DataPaginationFinalModel<List<PatientCourseTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalEquipmentTypeModel;
  }

  // 根据ID获取患者课程信息
  Future<DataFinalModel<PatientCourseTypeModel>> getPatientCourseByIdAction(
      String id) async {
    final jsonData = await get('/patient_course/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PatientCourseTypeModel> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PatientCourseTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }

  // 创建预约
  Future<DataFinalModel> createBookAction(Map<String, dynamic> json) async {
    final jsonData = await post('/book', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreate = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreate;
  }

  // 修改预约
  Future<DataFinalModel> updateBookAction(Map<String, dynamic> json) async {
    final jsonData = await put('/book/normal', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalUpdate = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalUpdate;
  }

  // 取消预约
  Future<DataFinalModel> deleteOneBookByIdAction(
      {required String id, required String canceledReason}) async {
    final Map<String, dynamic> form = {
      'id': id,
      'canceled_reason': canceledReason
    };
    final jsonData = await post('/book/cancel', form);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalModel;
  }
}
