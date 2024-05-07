import '../models/store_model.dart';

class MajorCourseTypeModel {
  final String id; //主体id
  final String user_id; //用户id
  final String course_id; //课程id
  final String? validity_time; //被预约时间表id
  final String order_id; //订单id
  final int? recent_num; //最近观看节数
  final String? recent_progress; //最近观看进度
  final int status; //课程状态 1 正常 0 冻结
  final String created_at;
  final String updated_at;
  final StoreVideoCourseTypeModel? course_info;
  MajorCourseTypeModel(
      {required this.id,
      required this.user_id,
      required this.course_id,
      this.validity_time,
      required this.order_id,
      this.recent_num,
      this.recent_progress,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.course_info});

  factory MajorCourseTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? MajorCourseTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            course_id: json['course_id'],
            validity_time: json['validity_time'],
            order_id: json['order_id'],
            recent_num: json['recent_num'],
            recent_progress: json['recent_progress'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'],
            course_info: json['course_info'] != null
                ? StoreVideoCourseTypeModel.fromJson(json['course_info'])
                : null,
          )
        : MajorCourseTypeModel(
            id: '',
            user_id: '',
            course_id: '',
            validity_time: null,
            order_id: '',
            recent_num: null,
            recent_progress: null,
            status: 0,
            created_at: '',
            updated_at: '',
            course_info: null);
  }
}
