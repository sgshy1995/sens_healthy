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
      required this.updated_at});

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
            updated_at: json['updated_at'])
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
            updated_at: '');
  }
}
