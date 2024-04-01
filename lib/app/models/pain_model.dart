import 'dart:io';

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
  final String? location; //IP归属地
  final int status; //问题状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  late List<PainReplyTypeModel>? replies; //答复列表
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
      this.location,
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
            location: json['location'],
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
            location: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class PainReplyTypeModel {
  final String id; //答复id
  final String user_id; //用户id
  final String? avatar; //用户头像
  final String? name; //用户名字
  final int authenticate; //用户认证
  final int identity; // 用户身份 0 患者 1 医师
  final int is_major; //是否专业回答 1 是 0 否
  final String question_id; //问题id
  final String reply_time; //答复时间
  final int like_num; //点赞数
  final String? like_user_ids; //点赞id集合
  final int comment_num; //评论数
  final String reply_content; //答复内容
  late int expand_num; // 展开数量
  final String? image_data; //影像资料
  final String? location; //IP归属地
  final int status; //问题状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  late List<PainCommentTypeModel>? comments;
  PainReplyTypeModel(
      {required this.id,
      required this.user_id,
      this.avatar,
      this.name,
      required this.authenticate,
      required this.identity,
      required this.is_major,
      required this.question_id,
      required this.reply_time,
      required this.like_num,
      this.like_user_ids,
      required this.comment_num,
      required this.reply_content,
      this.expand_num = 3,
      this.image_data,
      this.location,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.comments});

  factory PainReplyTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<PainCommentTypeModel> fromJsonList(List<dynamic> jsonList) {
        return jsonList
            .map((json) => PainCommentTypeModel.fromJson(json))
            .toList();
      }

      final List<PainCommentTypeModel> list = fromJsonList(json['comments']);
      return PainReplyTypeModel(
          id: json['id'],
          user_id: json['user_id'],
          avatar: json['avatar'],
          name: json['name'],
          authenticate: json['authenticate'],
          identity: json['identity'],
          is_major: json['is_major'],
          question_id: json['question_id'],
          reply_time: json['reply_time'],
          like_num: json['like_num'],
          like_user_ids: json['like_user_ids'],
          comment_num: json['comment_num'],
          reply_content: json['reply_content'],
          image_data: json['image_data'],
          location: json['location'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          comments: list);
    }
    return PainReplyTypeModel(
        id: '',
        user_id: '',
        avatar: null,
        name: null,
        authenticate: 0,
        identity: 0,
        is_major: 0,
        question_id: '',
        reply_time: '',
        like_num: 0,
        like_user_ids: null,
        comment_num: 0,
        reply_content: '',
        image_data: null,
        location: null,
        status: 0,
        created_at: '',
        updated_at: '',
        comments: []);
  }
}

class PainCommentTypeModel {
  final String id; //评论id
  final String user_id; //用户id
  final String? avatar; //用户头像
  final String? name; //用户名字
  final int authenticate; //用户认证
  final int identity; // 用户身份 0 患者 1 医师
  final String reply_id; //答复id
  final String question_id; //问题id
  final String? comment_id; //评论id 如果存在，表示的是回复的是评论
  final String? to_name; //评论用户名
  final String comment_to_user_id; //评论目标用户id
  final String comment_time; //评论时间
  final int like_num; //点赞数
  final String? like_user_ids; //点赞id集合
  final String comment_content; //评论内容
  final String? image_data; //影像资料
  final String? location; //IP归属地
  final int status; //问题状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  PainCommentTypeModel(
      {required this.id,
      required this.user_id,
      this.avatar,
      this.name,
      required this.authenticate,
      required this.identity,
      required this.reply_id,
      required this.question_id,
      this.comment_id,
      this.to_name,
      required this.comment_to_user_id,
      required this.comment_time,
      required this.like_num,
      this.like_user_ids,
      required this.comment_content,
      this.image_data,
      this.location,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory PainCommentTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PainCommentTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            avatar: json['avatar'],
            name: json['name'],
            authenticate: json['authenticate'],
            identity: json['identity'],
            reply_id: json['reply_id'],
            question_id: json['question_id'],
            comment_id: json['comment_id'],
            to_name: json['to_name'],
            comment_to_user_id: json['comment_to_user_id'],
            comment_time: json['comment_time'],
            like_num: json['like_num'],
            like_user_ids: json['like_user_ids'],
            comment_content: json['comment_content'],
            image_data: json['image_data'],
            location: json['location'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : PainCommentTypeModel(
            id: '',
            user_id: '',
            avatar: null,
            name: null,
            authenticate: 0,
            identity: 0,
            reply_id: '',
            question_id: '',
            comment_id: null,
            to_name: null,
            comment_to_user_id: '',
            comment_time: '',
            like_num: 0,
            like_user_ids: null,
            comment_content: '',
            image_data: null,
            location: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class PainFileUploadTypeModel {
  final String id; //Id
  final File file; //文件
  final String localPath; //本地路劲
  final String filename; //文件名
  final String fileType; //文件类型（后缀）
  final String mimeType; //mimeType
  late int status; //上传状态 0 未上传 1 已上传成功 2 上传未审核通过
  late String? realKey; //bucket桶key

  PainFileUploadTypeModel(
      {required this.id,
      required this.file,
      required this.localPath,
      required this.filename,
      required this.fileType,
      required this.mimeType,
      required this.status,
      this.realKey});
}
