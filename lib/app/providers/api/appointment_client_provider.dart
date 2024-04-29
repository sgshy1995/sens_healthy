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

  // 根据JWT获取预约时间列表
  Future<DataFinalModel<List<LecturerTimeTypeModel>>>
      findManyLecturerTimesByJwtAction({int? ifBooked}) async {
    final Map<String, dynamic> query = {};
    if (ifBooked != null) {
      query['if_booked'] = ifBooked.toString();
    }
    final jsonData = await get('/lecturer_time', query: query);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    print(jsonMap);

    late List<LecturerTimeTypeModel> list =
        fromJsonListLecturerTimes(jsonMap['data']);

    final DataFinalModel<List<LecturerTimeTypeModel>> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'], message: jsonMap['message'], data: list);
    return dataFinalModel;
  }

  // 获取可预约的时间列表
  Future<DataFinalModel<List<LecturerTimeTypeModel>>>
      findManyLecturerTimesCanBeBookedAction({int? bookId}) async {
    final Map<String, dynamic> query = {};
    if (bookId != null) {
      query['book_id'] = bookId.toString();
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
}
