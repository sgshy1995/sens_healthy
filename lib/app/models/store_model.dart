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

class StoreEquipmentTypeModel {
  final String id; //器材id
  final String serial_number; //器材编号 唯一编号，数字和大写字母组合
  final String title; //器材标题
  final String cover; //器材封面
  final String description; //器材介绍
  final String long_figure; //器材长图
  final int equipment_type; //器材类型 0 康复训练器材 1 康复理疗设备 2 康复治疗师工具
  final int model_num; //型号数量
  final int frequency_total_num; //购买总次数
  final int has_discount; //是否包含折扣 1 是 0 否
  final int carousel; //是否轮播 1 是 0 否
  final String publish_time; //发布时间
  final int status; //器材状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  late List<StoreEquipmentInModelTypeModel>? models;
  StoreEquipmentTypeModel(
      {required this.id,
      required this.serial_number,
      required this.title,
      required this.cover,
      required this.description,
      required this.long_figure,
      required this.equipment_type,
      required this.model_num,
      required this.frequency_total_num,
      required this.has_discount,
      required this.carousel,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.models});

  factory StoreEquipmentTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<StoreEquipmentInModelTypeModel> fromJsonList(
          List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreEquipmentInModelTypeModel.fromJson(json))
            .toList();
      }

      final List<StoreEquipmentInModelTypeModel> list =
          json['models'] != null ? fromJsonList(json['models']) : [];

      return StoreEquipmentTypeModel(
          id: json['id'],
          serial_number: json['serial_number'],
          title: json['title'],
          cover: json['cover'],
          description: json['description'],
          long_figure: json['long_figure'],
          equipment_type: json['equipment_type'],
          model_num: json['model_num'],
          frequency_total_num: json['frequency_total_num'],
          has_discount: json['has_discount'],
          carousel: json['carousel'],
          publish_time: json['publish_time'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          models: list);
    }
    return StoreEquipmentTypeModel(
        id: '',
        serial_number: '',
        title: '',
        cover: '',
        description: '',
        long_figure: '',
        equipment_type: 0,
        model_num: 0,
        frequency_total_num: 0,
        has_discount: 0,
        carousel: 0,
        publish_time: '',
        status: 0,
        created_at: '',
        updated_at: '',
        models: null);
  }
}

class StoreEquipmentInModelTypeModel {
  final String id; //型号id
  final String equipment_id; //器材id
  final String title; //型号标题
  final String description; //型号介绍
  final String multi_figure; //型号多图
  final String? parameter; //参数信息
  final String brand; //品牌
  final int frequency_num; //购买次数
  final String price; //售价 最多两位小数
  final int is_discount; //是否折扣 1 折扣 0 不折扣
  final String? discount; //折扣价 最多两位小数
  final String? discount_validity; //折扣有效期
  final int inventory; //库存数
  final String dispatch_place; //发货地
  final int sort; //型号排序
  final String publish_time; //发布时间
  final int status; //型号状态 1 正常 0 下架
  final String created_at;
  final String updated_at;
  StoreEquipmentInModelTypeModel(
      {required this.id,
      required this.equipment_id,
      required this.title,
      required this.description,
      required this.multi_figure,
      this.parameter,
      required this.brand,
      required this.frequency_num,
      required this.price,
      required this.is_discount,
      this.discount,
      required this.discount_validity,
      required this.inventory,
      required this.dispatch_place,
      required this.sort,
      required this.publish_time,
      required this.status,
      required this.created_at,
      required this.updated_at});

  factory StoreEquipmentInModelTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? StoreEquipmentInModelTypeModel(
            id: json['id'],
            equipment_id: json['equipment_id'],
            title: json['title'],
            description: json['description'],
            multi_figure: json['multi_figure'],
            parameter: json['parameter'],
            brand: json['brand'],
            frequency_num: json['frequency_num'],
            price: json['price'],
            is_discount: json['is_discount'],
            discount: json['discount'],
            discount_validity: json['discount_validity'],
            inventory: json['inventory'],
            dispatch_place: json['dispatch_place'],
            sort: json['sort'],
            publish_time: json['publish_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : StoreEquipmentInModelTypeModel(
            id: '',
            equipment_id: '',
            title: '',
            description: '',
            multi_figure: '',
            parameter: null,
            brand: '',
            frequency_num: 0,
            price: '',
            is_discount: 0,
            discount: null,
            discount_validity: null,
            inventory: 0,
            dispatch_place: '',
            sort: 0,
            publish_time: '',
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class StoreEquipmentChartTypeModel {
  final String id; //商品id
  final String user_id; //用户id
  final String equipment_id; //器材id
  final String equipment_model_id; //型号id
  final int add_num; //添加数量
  final int status; //课程状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  late StoreEquipmentTypeModel? equipment_info;
  late StoreEquipmentInModelTypeModel? equipment_model_info;
  StoreEquipmentChartTypeModel(
      {required this.id,
      required this.user_id,
      required this.equipment_id,
      required this.equipment_model_id,
      required this.add_num,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.equipment_info,
      this.equipment_model_info});

  factory StoreEquipmentChartTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      final StoreEquipmentTypeModel? modelEquipment =
          json['equipment_info'] != null
              ? StoreEquipmentTypeModel.fromJson(json['equipment_info'])
              : null;
      final StoreEquipmentInModelTypeModel? modelEquipmentInModel =
          json['equipment_model_info'] != null
              ? StoreEquipmentInModelTypeModel.fromJson(
                  json['equipment_model_info'])
              : null;

      return StoreEquipmentChartTypeModel(
          id: json['id'],
          user_id: json['user_id'],
          equipment_id: json['equipment_id'],
          equipment_model_id: json['equipment_model_id'],
          add_num: json['add_num'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          equipment_info: modelEquipment,
          equipment_model_info: modelEquipmentInModel);
    }
    return StoreEquipmentChartTypeModel(
        id: '',
        user_id: '',
        equipment_id: '',
        equipment_model_id: '',
        add_num: 0,
        status: 0,
        created_at: '',
        updated_at: '',
        equipment_info: null,
        equipment_model_info: null);
  }
}

/// 器材购物车 聚合类型
/// 将器材购物车进行型号聚合
class StoreEquipmentChartPolymerizationTypeModel {
  final String equipment_id; //器材id
  late List<String> chart_ids; //商品id 集合
  final String user_id; //用户id
  late List<String> equipment_model_ids; //型号id 集合
  late List<int> add_nums; //添加数量 集合
  late List<int> status_list; //商品状态 集合 1 正常 0 删除
  final StoreEquipmentTypeModel? equipment_info; //器材信息
  late List<StoreEquipmentInModelTypeModel> equipment_model_infos; //型号信息 集合
  StoreEquipmentChartPolymerizationTypeModel(
      {required this.equipment_id,
      required this.chart_ids,
      required this.user_id,
      required this.equipment_model_ids,
      required this.add_nums,
      required this.status_list,
      required this.equipment_info,
      required this.equipment_model_infos});

  factory StoreEquipmentChartPolymerizationTypeModel.fromJson(
      Map<String, dynamic>? json) {
    if (json != null) {
      final StoreEquipmentTypeModel? modelEquipment =
          json['equipment_info'] != null
              ? StoreEquipmentTypeModel.fromJson(json['equipment_info'])
              : null;

      List<StoreEquipmentInModelTypeModel> fromJsonList(
          List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreEquipmentInModelTypeModel.fromJson(json))
            .toList();
      }

      final List<StoreEquipmentInModelTypeModel> list =
          json['equipment_model_infos'] != null
              ? fromJsonList(json['equipment_model_infos'])
              : [];

      return StoreEquipmentChartPolymerizationTypeModel(
          equipment_id: json['equipment_id'],
          chart_ids: json['chart_ids'],
          user_id: json['user_id'],
          equipment_model_ids: json['equipment_model_ids'],
          add_nums: json['add_nums'],
          status_list: json['status_list'],
          equipment_info: modelEquipment,
          equipment_model_infos: list);
    }
    return StoreEquipmentChartPolymerizationTypeModel(
        equipment_id: '',
        chart_ids: [],
        user_id: '',
        equipment_model_ids: [],
        add_nums: [],
        status_list: [],
        equipment_info: null,
        equipment_model_infos: []);
  }
}
