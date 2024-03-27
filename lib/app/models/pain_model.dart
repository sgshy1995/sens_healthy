class PainQuestionTypeModel {
  final String id; //问题id
  final String user_id; //用户id
  final String? avatar; //用户头像
  final String? name; //用户名字
  final int has_major; //是否有专业回答 1 是 0 否
  final String pain_type; //伤痛类型
  final String description; //问题描述
  final String injury_history; //诊疗史
  final String question_time; //发布时间
  final int like_num; //点赞数
  final String? like_user_ids; //点赞id集合
  final int reply_num; //答复数量
  final int collect_num; //收藏数量
  final String? collect_user_ids; //收藏id集合
  final int anonymity; //是否匿名 1 是 0 否
  final String? image_data; //影像资料
  final int status; //问题状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  PainQuestionTypeModel(
      {required this.id,
      required this.user_id,
      this.avatar,
      this.name,
      required this.has_major,
      required this.pain_type,
      required this.description,
      required this.injury_history,
      required this.question_time,
      required this.like_num,
      this.like_user_ids,
      required this.reply_num,
      required this.collect_num,
      this.collect_user_ids,
      required this.anonymity,
      this.image_data,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory PainQuestionTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PainQuestionTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            avatar: json['avatar'],
            name: json['name'],
            has_major: json['has_major'],
            pain_type: json['pain_type'],
            description: json['description'],
            injury_history: json['injury_history'],
            question_time: json['question_time'],
            like_num: json['like_num'],
            like_user_ids: json['like_user_ids'],
            reply_num: json['reply_num'],
            collect_num: json['collect_num'],
            collect_user_ids: json['collect_user_ids'],
            anonymity: json['anonymity'],
            image_data: json['image_data'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : PainQuestionTypeModel(
            id: '',
            user_id: '',
            avatar: null,
            name: null,
            has_major: 0,
            pain_type: '',
            description: '',
            injury_history: '',
            question_time: '',
            like_num: 0,
            like_user_ids: null,
            reply_num: 0,
            collect_num: 0,
            collect_user_ids: null,
            anonymity: 0,
            image_data: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}
