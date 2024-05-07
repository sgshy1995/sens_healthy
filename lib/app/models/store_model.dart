import 'dart:convert';

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
  final String? gist; //视频要点
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
      this.gist,
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
            gist: json['gist'],
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
            gist: null,
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

class StoreCourseOrderTypeModel {
  final String id; //订单id
  final String user_id; //用户id
  final String course_ids; //课程id集合
  final String course_types; //课程类型集合 1 直播课 0 视频课
  final String order_prices; //购买价格集合
  final int order_total; //购买总数
  final String
      order_no; //订单号（28位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+订单序号（8位，保证当天唯一）
  final String order_time; //下单时间
  final String
      payment_no; //支付流水号（32位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+支付流水序号（12位，保证当天唯一）
  final int payment_type; //支付类型 0 余额支付 1 微信支付 2 支付宝支付 3 Apple支付
  final String payment_time; //支付时间
  final String payment_num; //支付金额
  final int status; //订单状态 2 已完成 1 待支付 0 取消/关闭
  final String created_at;
  final String updated_at;
  final List<Object>? course_infos;
  StoreCourseOrderTypeModel(
      {required this.id,
      required this.user_id,
      required this.course_ids,
      required this.course_types,
      required this.order_prices,
      required this.order_total,
      required this.order_no,
      required this.order_time,
      required this.payment_no,
      required this.payment_type,
      required this.payment_time,
      required this.payment_num,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.course_infos});

  factory StoreCourseOrderTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<Object> fromJsonList(List<dynamic> jsonList) {
        return jsonList
            .map((json) => json['live_num'] != null
                ? StoreLiveCourseTypeModel.fromJson(json)
                : StoreVideoCourseTypeModel.fromJson(json))
            .toList();
      }

      final List<Object> list = json['course_infos'] != null
          ? fromJsonList(json['course_infos'])
          : [];

      return StoreCourseOrderTypeModel(
          id: json['id'],
          user_id: json['user_id'],
          course_ids: json['course_ids'],
          course_types: json['course_types'],
          order_prices: json['order_prices'],
          order_total: json['order_total'],
          order_no: json['order_no'],
          order_time: json['order_time'],
          payment_no: json['payment_no'],
          payment_type: json['payment_type'],
          payment_time: json['payment_time'],
          payment_num: json['payment_num'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          course_infos: list);
    }
    return StoreCourseOrderTypeModel(
        id: '',
        user_id: '',
        course_ids: '',
        course_types: '',
        order_prices: '',
        order_total: 0,
        order_no: '',
        order_time: '',
        payment_no: '',
        payment_type: 0,
        payment_time: '',
        payment_num: '',
        status: 0,
        created_at: '',
        updated_at: '',
        course_infos: null);
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

class StoreEquipmentOrderTypeModel {
  final String id; //订单id
  final String user_id; //用户id
  final String equipment_ids; //器材id集合
  final String model_ids; //型号id集合
  final String order_prices; //购买价格集合
  final String order_nums; //购买数量集合
  final int order_total_num; //购买总数量
  final int order_total; //购买器材种类数
  final String
      order_no; //订单号（28位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+订单序号（8位，保证当天唯一）
  final String order_time; //下单时间
  final String
      payment_no; //支付流水号（32位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+支付流水序号（12位，保证当天唯一）
  final int payment_type; //支付类型 0 余额支付 1 微信支付 2 支付宝支付 3 Apple支付
  final String payment_time; //支付时间
  final String payment_num; //支付金额
  final String? origin_address; //起送地址
  final String? origin_name; //起送人
  final String? origin_phone; //起送联系电话
  final String shipping_address; //配送地址
  final String shipping_name; //配送人
  final String shipping_phone; //配送联系电话
  final String? courier_number; //物流单号
  final String? courier_company; //物流公司
  final String? remark; //备注
  final int status; //订单状态 6 已退货 5 退货中 4 已收货 3 已发货 2 待发货 1 待支付 0 取消/关闭
  final String created_at;
  final String updated_at;
  final StoreCourierTypeModel? courier_info;
  final List<StoreEquipmentTypeModel>? equipment;
  StoreEquipmentOrderTypeModel(
      {required this.id,
      required this.user_id,
      required this.equipment_ids,
      required this.model_ids,
      required this.order_prices,
      required this.order_nums,
      required this.order_total_num,
      required this.order_total,
      required this.order_no,
      required this.order_time,
      required this.payment_no,
      required this.payment_type,
      required this.payment_time,
      required this.payment_num,
      this.origin_address,
      this.origin_name,
      this.origin_phone,
      required this.shipping_address,
      required this.shipping_name,
      required this.shipping_phone,
      this.courier_number,
      this.courier_company,
      this.remark,
      required this.status,
      required this.created_at,
      required this.updated_at,
      this.courier_info,
      this.equipment});

  factory StoreEquipmentOrderTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<StoreEquipmentTypeModel> fromJsonList(List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreEquipmentTypeModel.fromJson(json))
            .toList();
      }

      final List<StoreEquipmentTypeModel> list =
          json['equipment'] != null ? fromJsonList(json['equipment']) : [];

      return StoreEquipmentOrderTypeModel(
          id: json['id'],
          user_id: json['user_id'],
          equipment_ids: json['equipment_ids'],
          model_ids: json['model_ids'],
          order_prices: json['order_prices'],
          order_nums: json['order_nums'],
          order_total_num: json['order_total_num'],
          order_total: json['order_total'],
          order_no: json['order_no'],
          order_time: json['order_time'],
          payment_no: json['payment_no'],
          payment_type: json['payment_type'],
          payment_time: json['payment_time'],
          payment_num: json['payment_num'],
          origin_address: json['origin_address'],
          origin_name: json['origin_name'],
          origin_phone: json['origin_phone'],
          shipping_address: json['shipping_address'],
          shipping_name: json['shipping_name'],
          shipping_phone: json['shipping_phone'],
          courier_number: json['courier_number'],
          courier_company: json['courier_company'],
          remark: json['remark'],
          status: json['status'],
          created_at: json['created_at'],
          updated_at: json['updated_at'],
          courier_info: (json['courier_info'] != null &&
                  json['courier_info']['id'] != null)
              ? StoreCourierTypeModel.fromJson(json['courier_info'])
              : StoreCourierTypeModel.fromJson(null),
          equipment: list);
    }
    return StoreEquipmentOrderTypeModel(
        id: '',
        user_id: '',
        equipment_ids: '',
        model_ids: '',
        order_prices: '',
        order_nums: '',
        order_total_num: 0,
        order_total: 0,
        order_no: '',
        order_time: '',
        payment_no: '',
        payment_type: 0,
        payment_time: '',
        payment_num: '',
        origin_address: null,
        origin_name: null,
        origin_phone: null,
        shipping_address: '',
        shipping_name: '',
        shipping_phone: '',
        courier_number: null,
        courier_company: null,
        remark: null,
        status: 0,
        created_at: '',
        updated_at: '',
        courier_info: null,
        equipment: null);
  }
}

class StoreCourierTypeModel {
  final String id; //物流信息id
  final String courier_number; //物流单号
  final StoreCourierContentTypeModel courier_content; //物流信息
  final int status; //物流状态 6 退件签收 5 疑难件 4 派送失败 3 已签收 2 正在派件 1 在途中 0 揽件
  final String? recent_update_time; //最近记录时间
  final String created_at;
  final String updated_at;
  StoreCourierTypeModel(
      {required this.id,
      required this.courier_number,
      required this.courier_content,
      required this.status,
      this.recent_update_time,
      required this.created_at,
      required this.updated_at});

  factory StoreCourierTypeModel.fromJson(Map<String, dynamic>? jsonIn) {
    return jsonIn != null
        ? StoreCourierTypeModel(
            id: jsonIn['id'],
            courier_number: jsonIn['courier_number'],
            courier_content: StoreCourierContentTypeModel.fromJson(
                json.decode(jsonIn['courier_content'])),
            status: jsonIn['status'],
            recent_update_time: jsonIn['recent_update_time'],
            created_at: jsonIn['created_at'],
            updated_at: jsonIn['updated_at'])
        : StoreCourierTypeModel(
            id: '',
            courier_number: '',
            courier_content: StoreCourierContentTypeModel.fromJson(null),
            status: 0,
            recent_update_time: null,
            created_at: '',
            updated_at: '');
  }
}

class StoreCourierContentTypeModel {
  final List<StoreCourierContentListTypeModel> list; //物流信息条目
  final String type; //物流公司编码 STO
  final String deliverystatus; //物流状态
  final String issign; //是否签收 1 签收 0 未签收
  final String expName; //物流公司名称
  final String logo; //物流公司logo地址
  final String updateTime; //更新时间
  final String takeTime; //总耗时

  StoreCourierContentTypeModel({
    required this.list,
    required this.type,
    required this.deliverystatus,
    required this.issign,
    required this.expName,
    required this.logo,
    required this.updateTime,
    required this.takeTime,
  });

  factory StoreCourierContentTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      List<StoreCourierContentListTypeModel> fromJsonList(
          List<dynamic> jsonList) {
        return jsonList
            .map((json) => StoreCourierContentListTypeModel.fromJson(json))
            .toList();
      }

      final List<StoreCourierContentListTypeModel> list =
          json['list'] != null ? fromJsonList(json['list']) : [];

      return StoreCourierContentTypeModel(
        list: list,
        type: json['type'],
        deliverystatus: json['deliverystatus'],
        issign: json['issign'],
        expName: json['expName'],
        logo: json['logo'],
        updateTime: json['updateTime'],
        takeTime: json['takeTime'],
      );
    }
    return StoreCourierContentTypeModel(
        list: [],
        type: '',
        deliverystatus: '',
        issign: '',
        expName: '',
        logo: '',
        updateTime: '',
        takeTime: '');
  }
}

class StoreCourierContentListTypeModel {
  final String time; //条目时间
  final String status; //条目信息
  StoreCourierContentListTypeModel({required this.time, required this.status});

  factory StoreCourierContentListTypeModel.fromJson(
      Map<String, dynamic>? json) {
    return json != null
        ? StoreCourierContentListTypeModel(
            time: json['time'], status: json['status'])
        : StoreCourierContentListTypeModel(time: '', status: '');
  }
}
