import 'package:sens_healthy/app/models/store_model.dart';

class LecturerTimeTypeModel {
  final String id; //时间表id
  final String user_id; //用户id
  final String start_time; //起始时间
  final String end_time; //结束时间
  final int if_booked; //是否被预约 1 已预约 0 未预约
  final String? book_id; //预约id
  final String? canceled_reason; //取消原因
  final int status; //时间状态 1 正常 0 取消
  final String created_at;
  final String updated_at;
  final StoreLiveCourseTypeModel? course_info;
  final PatientCourseTypeModel? patient_course_info;
  final BookTypeModel? book_info;
  final RoomTypeModel? room_info;
  LecturerTimeTypeModel(
      {required this.id,
      required this.user_id,
      required this.start_time,
      required this.end_time,
      required this.if_booked,
      this.book_id,
      this.canceled_reason,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.course_info,
      this.patient_course_info,
      this.book_info,
      this.room_info});

  factory LecturerTimeTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? LecturerTimeTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            start_time: json['start_time'],
            end_time: json['end_time'],
            if_booked: json['if_booked'],
            book_id: json['book_id'],
            canceled_reason: json['canceled_reason'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'],
            course_info: json['course_info'] != null
                ? StoreLiveCourseTypeModel.fromJson(json['course_info'])
                : null,
            patient_course_info: json['patient_course_info'] != null
                ? PatientCourseTypeModel.fromJson(json['patient_course_info'])
                : null,
            book_info: json['book_info'] != null
                ? BookTypeModel.fromJson(json['book_info'])
                : null,
            room_info: json['room_info'] != null
                ? RoomTypeModel.fromJson(json['room_info'])
                : null)
        : LecturerTimeTypeModel(
            id: '',
            user_id: '',
            start_time: '',
            end_time: '',
            if_booked: 0,
            book_id: null,
            canceled_reason: null,
            status: 0,
            created_at: '',
            updated_at: '',
            course_info: null,
            patient_course_info: null,
            book_info: null,
            room_info: null);
  }
}

class PatientCourseTypeModel {
  final String id; //主体id
  final String user_id; //用户id
  final String course_id; //课程id
  final String validity_time; //有效期
  final int course_live_num; //课程直播次数
  final int learn_num; //已学习次数
  final String order_id; //订单id
  final int cancel_num; //已取消次数
  final String? book_history_user_id; //历史预约用户id
  final int outer_cancel_num; //外部取消次数
  final int status; //课程状态 2 已完成 1 学习中 0 冻结/删除
  final String created_at;
  final String updated_at;
  final StoreLiveCourseTypeModel? course_info;
  final BookTypeModel? book_info;
  final RoomTypeModel? room_info;
  PatientCourseTypeModel(
      {required this.id,
      required this.user_id,
      required this.course_id,
      required this.validity_time,
      required this.course_live_num,
      required this.learn_num,
      required this.order_id,
      required this.cancel_num,
      this.book_history_user_id,
      required this.outer_cancel_num,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.course_info,
      this.book_info,
      this.room_info});

  factory PatientCourseTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PatientCourseTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            course_id: json['course_id'],
            validity_time: json['validity_time'],
            course_live_num: json['course_live_num'],
            learn_num: json['learn_num'],
            order_id: json['order_id'],
            cancel_num: json['cancel_num'],
            book_history_user_id: json['book_history_user_id'],
            outer_cancel_num: json['outer_cancel_num'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'],
            course_info: json['course_info'] != null
                ? StoreLiveCourseTypeModel.fromJson(json['course_info'])
                : null,
            book_info: json['book_info'] != null
                ? BookTypeModel.fromJson(json['book_info'])
                : null,
            room_info: json['room_info'] != null
                ? RoomTypeModel.fromJson(json['room_info'])
                : null)
        : PatientCourseTypeModel(
            id: '',
            user_id: '',
            course_id: '',
            validity_time: '',
            course_live_num: 0,
            learn_num: 0,
            order_id: '',
            cancel_num: 0,
            book_history_user_id: null,
            outer_cancel_num: 0,
            status: 0,
            created_at: '',
            updated_at: '',
            course_info: null,
            book_info: null,
            room_info: null);
  }
}

class BookTypeModel {
  final String id; //预约表id
  final String user_id; //预约用户id
  final String booked_user_id; //被预约用户id
  final String lecturer_time_id; //被预约时间表id
  final String patient_course_id; //预约患者课程id
  final String book_start_time; //预约开始时间
  final String book_end_time; //预约结束时间
  final int change_num; //修改次数
  final String? canceled_reason; //取消原因
  final String? outer_canceled_reason; //外部取消原因
  final int status; //预约状态 2 已完成 1 已预约 0 取消
  final String created_at;
  final String updated_at;
  BookTypeModel(
      {required this.id,
      required this.user_id,
      required this.booked_user_id,
      required this.lecturer_time_id,
      required this.patient_course_id,
      required this.book_start_time,
      required this.book_end_time,
      required this.change_num,
      this.canceled_reason,
      this.outer_canceled_reason,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory BookTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? BookTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            booked_user_id: json['booked_user_id'],
            lecturer_time_id: json['lecturer_time_id'],
            patient_course_id: json['patient_course_id'],
            book_start_time: json['book_start_time'],
            book_end_time: json['book_end_time'],
            change_num: json['change_num'],
            canceled_reason: json['canceled_reason'],
            outer_canceled_reason: json['outer_canceled_reason'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : BookTypeModel(
            id: '',
            user_id: '',
            booked_user_id: '',
            lecturer_time_id: '',
            patient_course_id: '',
            book_start_time: '',
            book_end_time: '',
            change_num: 0,
            canceled_reason: null,
            outer_canceled_reason: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class RoomTypeModel {
  final String id; //房间id
  final String room_no; //房间号
  final String lecturer_user_id; //讲师用户id
  final String patient_user_id; //患者用户id
  final String book_id; //预约id
  final String lecturer_time_id; //预约时间表id
  final String patient_course_id; //预约患者课程id
  final String book_start_time; //预约开始时间
  final String book_end_time; //预约结束时间
  final int status; //房间状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  RoomTypeModel(
      {required this.id,
      required this.room_no,
      required this.lecturer_user_id,
      required this.patient_user_id,
      required this.book_id,
      required this.lecturer_time_id,
      required this.patient_course_id,
      required this.book_start_time,
      required this.book_end_time,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory RoomTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? RoomTypeModel(
            id: json['id'],
            room_no: json['room_no'],
            lecturer_user_id: json['lecturer_user_id'],
            patient_user_id: json['patient_user_id'],
            book_id: json['book_id'],
            lecturer_time_id: json['lecturer_time_id'],
            patient_course_id: json['patient_course_id'],
            book_start_time: json['book_start_time'],
            book_end_time: json['book_end_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : RoomTypeModel(
            id: '',
            room_no: '',
            lecturer_user_id: '',
            patient_user_id: '',
            book_id: '',
            lecturer_time_id: '',
            patient_course_id: '',
            book_start_time: '',
            book_end_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}
