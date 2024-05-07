import 'package:sens_healthy/app/models/data_model.dart';
import '../global_client_provider.dart';
import '../../models/major_mode.dart';

class MajorClientProvider extends GlobalClientProvider {
  MajorClientProvider() : super();

  static List<MajorCourseTypeModel> fromJsonListMajorCourse(
      List<dynamic> jsonList) {
    return jsonList.map((json) => MajorCourseTypeModel.fromJson(json)).toList();
  }

  // 修改专业能力提升
  Future<DataFinalModel> updatePatientCourseAction(
      Map<String, dynamic> json) async {
    final jsonData = await put('/major_course', json);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map
    final DataFinalModel dataFinalCreateModel = DataFinalModel(
      code: jsonMap['code'],
      message: jsonMap['message'],
    );
    return dataFinalCreateModel;
  }

  // 根据ID获取专业能力提升课程信息
  Future<DataFinalModel<MajorCourseTypeModel>> findOneMajorCourseByIdAction(
      String id) async {
    final jsonData = await get('/major_course/id/$id');
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    final DataFinalModel<MajorCourseTypeModel> dataFinalModel = DataFinalModel(
        code: jsonMap['code'],
        message: jsonMap['message'],
        data: MajorCourseTypeModel.fromJson(jsonMap['data']));
    return dataFinalModel;
  }

  // 分页请求专业能力提升课程列表
  Future<DataPaginationFinalModel<List<MajorCourseTypeModel>>>
      findManyMajorCoursesAction(
          {required String userId, int? pageNo = 1, int? pageSize = 10}) async {
    final Map<String, dynamic> queryMap = {
      'user_id': userId.toString(),
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString()
    };

    final jsonData = await get('/major_course/custom', query: queryMap);
    final Map<String, dynamic> jsonMap = jsonData.body; // 将 JSON 数据解析为 Map

    late List<MajorCourseTypeModel> list =
        fromJsonListMajorCourse(jsonMap['data']['data']);

    final DataPaginationInModel<List<MajorCourseTypeModel>> inModel =
        DataPaginationInModel(
            data: list,
            pageNo: jsonMap['data']['pageNo'],
            pageSize: jsonMap['data']['pageSize'],
            totalCount: jsonMap['data']['totalCount'],
            totalPage: jsonMap['data']['totalPage']);

    final DataPaginationFinalModel<List<MajorCourseTypeModel>>
        dataFinalTypeModel =
        DataPaginationFinalModel<List<MajorCourseTypeModel>>(
            code: jsonMap['code'], message: jsonMap['message'], data: inModel);
    return dataFinalTypeModel;
  }
}
