class StoreLiveCourseTypeModel {
  final String id; //课程id
  final String title; //课程标题
  final String cover; //课程封面
  final String description; //课程介绍
  final int course_type; //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final int live_num; //直播次数
  final int frequency_num; //购买次数
  final String price; //售价 最多两位小数
  final int is_discount; //是否折扣 1 折扣 0 不折扣
  final String? discount; //折扣价 最多两位小数
  final String? discount_validity; //折扣有效期
  final int carousel; //是否轮播 1 是 0 否
  final String publish_time; //发布时间
  final int status; //课程状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  StoreLiveCourseTypeModel(
      {required this.id,
      required this.title,
      required this.cover,
      required this.description,
      required this.course_type,
      required this.live_num,
      required this.frequency_num,
      required this.price,
      required this.is_discount,
      this.discount,
      required this.discount_validity,
      required this.carousel,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory StoreLiveCourseTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? StoreLiveCourseTypeModel(
            id: json['id'],
            title: json['title'],
            cover: json['cover'],
            description: json['description'],
            course_type: json['course_type'],
            live_num: json['live_num'],
            frequency_num: json['frequency_num'],
            price: json['price'],
            is_discount: json['is_discount'],
            discount: json['discount'],
            discount_validity: json['discount_validity'],
            carousel: json['carousel'],
            publish_time: json['publish_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : StoreLiveCourseTypeModel(
            id: '',
            title: '',
            cover: '',
            description: '',
            course_type: 0,
            live_num: 0,
            frequency_num: 0,
            price: '',
            is_discount: 0,
            discount: null,
            discount_validity: null,
            carousel: 0,
            publish_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class StoreVideoCourseTypeModel {
  final String id; //课程id
  final String title; //课程标题
  final String cover; //课程封面
  final String description; //课程介绍
  final int course_type; //课程类型 0 运动康复 1 神经康复 2 产后康复 3 术后康复
  final int video_num; //视频数
  final int frequency_num; //购买次数
  final String price; //售价 最多两位小数
  final int is_discount; //是否折扣 1 折扣 0 不折扣
  final String? discount; //折扣价 最多两位小数
  final String? discount_validity; //折扣有效期
  final int carousel; //是否轮播 1 是 0 否
  final String publish_time; //发布时间
  final int status; //课程状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  late List<StoreCourseInVideoTypeModel>? videos;
  StoreVideoCourseTypeModel(
      {required this.id,
      required this.title,
      required this.cover,
      required this.description,
      required this.course_type,
      required this.video_num,
      required this.frequency_num,
      required this.price,
      required this.is_discount,
      this.discount,
      required this.discount_validity,
      required this.carousel,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.videos});

  factory StoreVideoCourseTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<StoreCourseInVideoTypeModel> fromJsonList(List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreCourseInVideoTypeModel.fromJson(json))
            .toList();
      }

      final List<StoreCourseInVideoTypeModel> list =
          json['videos'] != null ? fromJsonList(json['videos']) : [];

      return StoreVideoCourseTypeModel(
          id: json['id'],
          title: json['title'],
          cover: json['cover'],
          description: json['description'],
          course_type: json['course_type'],
          video_num: json['video_num'],
          frequency_num: json['frequency_num'],
          price: json['price'],
          is_discount: json['is_discount'],
          discount: json['discount'],
          discount_validity: json['discount_validity'],
          carousel: json['carousel'],
          publish_time: json['publish_time'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          videos: list);
    }
    return StoreVideoCourseTypeModel(
        id: '',
        title: '',
        cover: '',
        description: '',
        course_type: 0,
        video_num: 0,
        frequency_num: 0,
        price: '',
        is_discount: 0,
        discount: null,
        discount_validity: null,
        carousel: 0,
        publish_time: '',
        status: 0,
        created_at: '',
        updated_at: '',
        videos: []);
  }
}

class StoreCourseInVideoTypeModel {
  final String id; //视频id
  final String course_id; //课程id
  final String title; //视频标题
  final String cover; //视频封面
  final String description; //视频介绍
  final String source; //视频地址
  final String time_length; //视频时长
  final int sort; //视频排序
  final String publish_time; //发布时间
  final int status; //课程状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  StoreCourseInVideoTypeModel(
      {required this.id,
      required this.course_id,
      required this.title,
      required this.cover,
      required this.description,
      required this.source,
      required this.time_length,
      required this.sort,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory StoreCourseInVideoTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? StoreCourseInVideoTypeModel(
            id: json['id'],
            course_id: json['course_id'],
            title: json['title'],
            cover: json['cover'],
            description: json['description'],
            source: json['source'],
            time_length: json['time_length'],
            sort: json['sort'],
            publish_time: json['publish_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : StoreCourseInVideoTypeModel(
            id: '',
            course_id: '',
            title: '',
            cover: '',
            description: '',
            source: '',
            time_length: '',
            sort: 0,
            publish_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class StoreCourseChartTypeModel {
  final String id; //商品id
  final String user_id; //用户id
  final String course_id; //课程id
  final int add_course_type; //课程类型 1 直播课 0 视频课
  final int add_num; //添加数量
  final int status; //课程状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  late StoreLiveCourseTypeModel? course_live_info;
  late StoreVideoCourseTypeModel? course_video_info;
  StoreCourseChartTypeModel(
      {required this.id,
      required this.user_id,
      required this.course_id,
      required this.add_course_type,
      required this.add_num,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.course_live_info,
      this.course_video_info});

  factory StoreCourseChartTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<StoreCourseInVideoTypeModel> fromJsonList(List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreCourseInVideoTypeModel.fromJson(json))
            .toList();
      }

      final StoreLiveCourseTypeModel? modelLive =
          json['course_live_info'] != null
              ? StoreLiveCourseTypeModel.fromJson(json['course_live_info'])
              : null;
      final StoreVideoCourseTypeModel? modelVideo =
          json['course_video_info'] != null
              ? StoreVideoCourseTypeModel.fromJson(json['course_video_info'])
              : null;

      return StoreCourseChartTypeModel(
          id: json['id'],
          user_id: json['user_id'],
          course_id: json['course_id'],
          add_course_type: json['add_course_type'],
          add_num: json['add_num'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          course_live_info: modelLive,
          course_video_info: modelVideo);
    }
    return StoreCourseChartTypeModel(
        id: '',
        user_id: '',
        course_id: '',
        add_course_type: 0,
        add_num: 0,
        status: 0,
        created_at: '',
        updated_at: '',
        course_live_info: null,
        course_video_info: null);
  }
}
