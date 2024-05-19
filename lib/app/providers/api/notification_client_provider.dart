import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/notification_model.dart';

class NotificationClientProvider extends GlobalClientProvider {
  NotificationClientProvider() : super();

  static List<PainNotificationTypeModel> fromJsonListPainNotification(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => PainNotificationTypeModel.fromJson(json))
        .toList();
  }

  // 创建设备推送注册信息
  Future<DataFinalModel> createPushRegistrationAction(
      Map<String, dynamic> json) async {
    final jsonData = await post('/push_registration', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreateModel;
  }

  // 更新设备推送注册信息
  Future<DataFinalModel> addHistoryUserIdInfo(Map<String, dynamic> json) async {
    final jsonData = await post('/push_registration/history_user_id', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalUpdateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalUpdateModel;
  }

  // 分页请求伤痛通知列表
  Future<DataPaginationFinalModel<List<PainNotificationTypeModel>>>
      findManyPainNotifications(
          {required String userId,
          int? pageNo = 1,
          int? pageSize = 10,
          int? read,
          dynamic notificationType}) async {
    final Map<String, dynamic> queryMap = {
      'user_id': userId.toString(),
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };

    if (read != null) {
      queryMap['read'] = read.toString();
    }

    if (notificationType != null) {
      queryMap['notification_type'] = notificationType.toString();
    }

    final jsonData = await get('/pain_notification/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<PainNotificationTypeModel> list =
        fromJsonListPainNotification(jsonMap['data']['data']);

    final DataPaginationInModel<List<PainNotificationTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<PainNotificationTypeModel>>
        dataFinalModel =
        DataPaginationFinalModel<List<PainNotificationTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalModel;
  }

  // 根据ID获取约伤痛通知信息
  Future<DataFinalModel<PainNotificationTypeModel>>
      findOnePainNotificationByIdAction(String id) async {
    final jsonData = await get('/pain_notification/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainNotificationTypeModel> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data: PainNotificationTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }

  // 根据 ID 伤痛通知信息 标记为已读
  Future<DataFinalModel> readOnePainNotificationByIdAction(String id) async {
    final jsonData = await post('/pain_notification/read/$id', {});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainNotificationTypeModel> dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 一键已读
  Future<DataFinalModel<PainNotificationTypeModel>> readAllAction() async {
    final jsonData = await post('/pain_notification/read_all', {});
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainNotificationTypeModel> dataFinalModel =
        DataFinalModel(code: jsonMap['code'], message: jsonMap['message']);
    return dataFinalModel;
  }

  // 获取伤痛通知统计信息
  Future<DataFinalModel<PainNotificationStatisticsTypeModel>>
      findManyPainNotificationStatisticsAction() async {
    final jsonData = await get('/pain_notification/statistics');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<PainNotificationStatisticsTypeModel> dataFinalModel =
        DataFinalModel(
            code: jsonMap['code'],
            message: jsonMap['message'],
            data:
                PainNotificationStatisticsTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }
}
