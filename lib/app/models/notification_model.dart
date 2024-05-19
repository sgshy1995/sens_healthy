import './user_model.dart';
import './pain_model.dart';

class PainNotificationTypeModel {
  final String id; //通知id
  final String user_id; //用户id
  final String? from_user_id; //来自用户id
  final String? push_no; //推送编号
  final int
      notification_type; //通知类型 0 答复 1 回复 2 点赞 3 收藏（暂不做提示） 4 设置为专业答复 5 违规 6 其他
  final String question_id; //问题id
  final String? reply_id; //答复id
  final String? comment_id; //回复id
  final String title; //通知标题
  final String content; //通知内容
  final String publish_time; //发布时间
  final int read; //阅读状态 0 未读 1 已读
  final int status; //通知状态
  final String created_at;
  final String updated_at;
  final UserOnlyNeedTypeModel? from_user_info;
  final PainQuestionTypeModel? question_info;
  final PainReplyTypeModel? reply_info;
  final PainCommentTypeModel? comment_info;
  final PainCommentTypeModel? comment_to_info;
  PainNotificationTypeModel(
      {required this.id,
      required this.user_id,
      this.from_user_id,
      this.push_no,
      required this.notification_type,
      required this.question_id,
      this.reply_id,
      this.comment_id,
      required this.title,
      required this.content,
      required this.publish_time,
      required this.read,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.from_user_info,
      this.question_info,
      this.reply_info,
      this.comment_info,
      this.comment_to_info});

  factory PainNotificationTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PainNotificationTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            from_user_id: json['from_user_id'],
            push_no: json['push_no'],
            notification_type: json['notification_type'],
            question_id: json['question_id'],
            reply_id: json['reply_id'],
            comment_id: json['comment_id'],
            title: json['title'],
            content: json['content'],
            publish_time: json['publish_time'],
            read: json['read'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'],
            from_user_info: json['from_user_info'] != null
                ? UserOnlyNeedTypeModel.fromJson(json['from_user_info'])
                : null,
            question_info: json['question_info'] != null
                ? PainQuestionTypeModel.fromJson(json['question_info'])
                : null,
            reply_info: json['reply_info'] != null
                ? PainReplyTypeModel.fromJson(json['reply_info'])
                : null,
            comment_info: json['comment_info'] != null
                ? PainCommentTypeModel.fromJson(json['comment_info'])
                : null,
            comment_to_info: json['comment_to_info'] != null
                ? PainCommentTypeModel.fromJson(json['comment_to_info'])
                : null)
        : PainNotificationTypeModel(
            id: '',
            user_id: '',
            from_user_id: null,
            push_no: null,
            notification_type: 0,
            question_id: '',
            reply_id: null,
            comment_id: null,
            title: '',
            content: '',
            publish_time: '',
            read: 0,
            status: 0,
            created_at: '',
            updated_at: '',
            from_user_info: null,
            question_info: null,
            reply_info: null,
            comment_info: null,
            comment_to_info: null);
  }
}

class PainNotificationStatisticsTypeModel {
  int reply_num;
  int comment_num;
  int like_num;
  int major_num;
  PainNotificationStatisticsTypeModel(
      {required this.reply_num,
      required this.comment_num,
      required this.like_num,
      required this.major_num});

  factory PainNotificationStatisticsTypeModel.fromJson(
      Map<String, dynamic>? json) {
    return json != null
        ? PainNotificationStatisticsTypeModel(
            reply_num: json['reply_num'],
            comment_num: json['comment_num'],
            like_num: json['like_num'],
            major_num: json['major_num'])
        : PainNotificationStatisticsTypeModel(
            reply_num: 0, comment_num: 0, like_num: 0, major_num: 0);
  }
}
