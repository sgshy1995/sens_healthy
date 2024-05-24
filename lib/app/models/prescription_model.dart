class PrescriptionTypeModel {
  final String id; //处方id
  final String title; //处方标题
  final String cover; //处方封面
  final int prescription_type; //处方类型 0 文章 1 视频
  int watch_num; //观看人数
  final String? prescription_video; //处方视频地址
  final String? prescription_content; //处方内容
  final String description; //处方描述
  final String? gist; //处方要点
  final int difficulty; //难度 难度1~难度5
  final String time_length; //处方时长
  final String rehabilitation; //复健类型 - 标签ID
  final String? part; //部位 - 标签ID
  final String? symptoms; //症状问题 - 标签ID
  final String? phase; //阶段 - 标签ID
  final int priority; //优先级
  final String publish_time; //发布时间
  final int status; //处方状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  PrescriptionTypeModel(
      {required this.id,
      required this.title,
      required this.cover,
      required this.prescription_type,
      required this.watch_num,
      this.prescription_video,
      this.prescription_content,
      required this.description,
      this.gist,
      required this.difficulty,
      required this.time_length,
      required this.rehabilitation,
      this.part,
      this.symptoms,
      this.phase,
      required this.priority,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory PrescriptionTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PrescriptionTypeModel(
            id: json['id'],
            title: json['title'],
            cover: json['cover'],
            prescription_type: json['prescription_type'],
            watch_num: json['watch_num'],
            prescription_video: json['prescription_video'],
            prescription_content: json['prescription_content'],
            description: json['description'],
            gist: json['gist'],
            difficulty: json['difficulty'],
            time_length: json['time_length'],
            rehabilitation: json['rehabilitation'],
            part: json['part'],
            symptoms: json['symptoms'],
            phase: json['phase'],
            priority: json['priority'],
            publish_time: json['publish_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : PrescriptionTypeModel(
            id: '',
            title: '',
            cover: '',
            prescription_type: 1,
            watch_num: 0,
            prescription_video: null,
            prescription_content: null,
            description: '',
            gist: null,
            difficulty: 1,
            time_length: '',
            rehabilitation: '',
            part: null,
            symptoms: null,
            phase: null,
            priority: 0,
            publish_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class PrescriptionTagTypeModel {
  final String id; //标签id
  final String title; //标签名称
  final String parent_id; //父级ID
  final int level; //标签层级
  final int priority; //标签优先级
  final int status; //"标签状态 1 正常 0 禁用
  final String created_at;
  final String updated_at;
  PrescriptionTagTypeModel(
      {required this.id,
      required this.title,
      required this.parent_id,
      required this.level,
      required this.priority,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory PrescriptionTagTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? PrescriptionTagTypeModel(
            id: json['id'],
            title: json['title'],
            parent_id: json['parent_id'],
            level: json['level'],
            priority: json['priority'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : PrescriptionTagTypeModel(
            id: '',
            title: '',
            parent_id: '',
            level: 0,
            priority: 0,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}
