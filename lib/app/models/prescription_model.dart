class PrescriptionTypeModel {
  final String id; //处方id
  final String title; //处方标题
  final String cover; //处方封面
  final int prescription_type; //处方类型 0 文章 1 视频
  final int watch_num; //观看人数
  final String? prescription_video; //处方视频地址
  final String? prescription_content; //处方内容
  final String description; //处方描述
  final String? gist; //处方要点
  final int difficulty; //难度 难度1~难度5
  final String time_length; //处方时长
  final int part; //关节部位 0肩关节 1肘关节 2腕关节 3髋关节 4膝关节 5踝关节 6脊柱
  final int symptoms; //症状 0疼痛 1肿胀 2活动受限 3弹响
  final int phase; //阶段 0 0-2周 1 3-6周 2 6-12周 3 12周以后
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
      required this.part,
      required this.symptoms,
      required this.phase,
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
            part: json['part'],
            symptoms: json['symptoms'],
            phase: json['phase'],
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
            part: 0,
            symptoms: 0,
            phase: 0,
            publish_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}
