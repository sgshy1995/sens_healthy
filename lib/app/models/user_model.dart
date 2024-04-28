class UserTypeModel {
  final String id;
  final String username;
  final String? name;
  final String? avatar;
  final String? background;
  final int? gender;
  final String phone;
  final int identity;
  final int authenticate;
  final String? wx_unionid;
  final String? wx_nickname;
  final String? recent_login_time;
  final int status;
  final String created_at;
  final String updated_at;
  UserTypeModel(
      {required this.id,
      required this.username,
      this.name,
      this.avatar,
      this.background,
      this.gender,
      required this.phone,
      required this.identity,
      required this.authenticate,
      this.wx_unionid,
      this.wx_nickname,
      this.recent_login_time,
      required this.status,
      required this.created_at,
      required this.updated_at});
  factory UserTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? UserTypeModel(
            id: json['id'],
            username: json['username'],
            name: json['name'],
            phone: json['phone'],
            avatar: json['avatar'],
            background: json['background'],
            gender: json['gender'],
            identity: json['identity'],
            authenticate: json['authenticate'],
            wx_unionid: json['wx_unionid'],
            wx_nickname: json['wx_nickname'],
            recent_login_time: json['recent_login_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : UserTypeModel(
            id: '',
            username: '',
            name: null,
            phone: '',
            avatar: null,
            background: null,
            gender: null,
            identity: 0,
            authenticate: 0,
            wx_unionid: null,
            wx_nickname: null,
            recent_login_time: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class UserInfoTypeModel {
  final String id; //id
  final String user_id; //用户id
  final int integral; //积分
  late String balance; //余额
  final int? age; //年龄
  final String? injury_history; //既往伤病史
  final String? injury_recent; //近期伤病描述
  final String? discharge_abstract; //出院小结
  final String? image_data; //影像资料
  final String? default_address_id; //默认地址id
  final AddressInfoTypeModel default_address_info; //默认地址信息
  final int status;
  UserInfoTypeModel(
      {required this.id,
      required this.user_id,
      required this.integral,
      required this.balance,
      this.age,
      this.injury_history,
      this.injury_recent,
      this.discharge_abstract,
      this.image_data,
      this.default_address_id,
      required this.default_address_info,
      required this.status});
  factory UserInfoTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? UserInfoTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            integral: json['integral'],
            balance: json['balance'],
            age: json['age'],
            injury_history: json['injury_history'],
            injury_recent: json['injury_recent'],
            discharge_abstract: json['discharge_abstract'],
            image_data: json['image_data'],
            default_address_id: json['default_address_id'],
            default_address_info:
                AddressInfoTypeModel.fromJson(json['default_address_info']),
            status: json['status'])
        : UserInfoTypeModel(
            id: '',
            user_id: '',
            integral: 0,
            balance: '',
            age: null,
            injury_history: null,
            injury_recent: null,
            discharge_abstract: null,
            image_data: null,
            default_address_id: null,
            default_address_info: AddressInfoTypeModel(
                id: '',
                user_id: '',
                province_code: '',
                city_code: '',
                area_code: '',
                detail_text: '',
                all_text: '',
                phone: '',
                name: '',
                tag: null,
                status: 0,
                created_at: '',
                updated_at: ''),
            status: 0);
  }
}

class AddressInfoTypeModel {
  final String id; //收货地址id
  final String user_id; //用户id
  final String province_code; //省编号
  final String city_code; //市编号
  final String area_code; //区县编号
  final String detail_text; //省市区文本
  final String all_text; //全部文本
  final String phone; //联系电话
  final String name; //联系人
  final String? tag; //标签
  final int status; //收货地址状态 1 正常 0 删除
  final String created_at;
  final String updated_at;
  AddressInfoTypeModel(
      {required this.id,
      required this.user_id,
      required this.province_code,
      required this.city_code,
      required this.area_code,
      required this.detail_text,
      required this.all_text,
      required this.phone,
      required this.name,
      this.tag,
      required this.status,
      required this.created_at,
      required this.updated_at});
  factory AddressInfoTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? AddressInfoTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            province_code: json['province_code'],
            city_code: json['city_code'],
            area_code: json['area_code'],
            detail_text: json['detail_text'],
            all_text: json['all_text'],
            phone: json['phone'],
            name: json['name'],
            tag: json['tag'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : AddressInfoTypeModel(
            id: '',
            user_id: '',
            province_code: '',
            city_code: '',
            area_code: '',
            detail_text: '',
            all_text: '',
            phone: '',
            name: '',
            tag: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class TopUpOrderTypeModel {
  final String id; //订单id
  final String user_id; //用户id
  final String
      order_no; //订单号（28位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+订单序号（8位，保证当天唯一）
  final String order_time; //下单时间
  final String
      payment_no; //支付流水号（32位）编号规则：系统ID（6位）+系统交易日期（8位：YYYYMMDD)+系统交易时间戳(6位：HHmmss)+支付流水序号（12位，保证当天唯一）
  final int payment_type; //支付类型 0 余额支付（表示消费余额） 1 微信支付 2 支付宝支付 3 Apple支付
  final String payment_time; //支付时间
  final String payment_num; //支付金额
  final String? created_reason; //生成原因
  final int status; //订单状态 2 已完成 1 待支付 0 取消/关闭
  final String created_at;
  final String updated_at;
  TopUpOrderTypeModel(
      {required this.id,
      required this.user_id,
      required this.order_no,
      required this.order_time,
      required this.payment_no,
      required this.payment_type,
      required this.payment_time,
      required this.payment_num,
      this.created_reason,
      required this.status,
      required this.created_at,
      required this.updated_at});
  factory TopUpOrderTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? TopUpOrderTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            order_no: json['order_no'],
            order_time: json['order_time'],
            payment_no: json['payment_no'],
            payment_type: json['payment_type'],
            payment_time: json['payment_time'],
            payment_num: json['payment_num'],
            created_reason: json['created_reason'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : TopUpOrderTypeModel(
            id: '',
            user_id: '',
            order_no: '',
            order_time: '',
            payment_no: '',
            payment_type: 0,
            payment_time: '',
            payment_num: '',
            created_reason: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}

class AuthenticateTypeModel {
  String id; //认证id
  final String user_id; //用户id
  final String name; //认证名
  final String phone; //认证联系电话
  final int gender; //认证性别 1 男 0 女
  final String organization; //认证机构组织
  final String identity_card_front; //身份证正面照
  final String identity_card_back; //身份证反面照
  final String practicing_certificate; //执业证照
  final String employee_card; //工作证照
  final String fcc; //认证简介
  final String? audit_info; //审核意见
  final String? validity_time; //有效期
  final int status; //认证状态 3 审核通过 2 待审核 1 驳回 0 失效
  final String created_at;
  final String updated_at;
  AuthenticateTypeModel(
      {required this.id,
      required this.user_id,
      required this.name,
      required this.phone,
      required this.gender,
      required this.organization,
      required this.identity_card_front,
      required this.identity_card_back,
      required this.practicing_certificate,
      required this.employee_card,
      required this.fcc,
      this.audit_info,
      this.validity_time,
      required this.status,
      required this.created_at,
      required this.updated_at});
  factory AuthenticateTypeModel.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? AuthenticateTypeModel(
            id: json['id'],
            user_id: json['user_id'],
            name: json['name'],
            phone: json['phone'],
            gender: json['gender'],
            organization: json['organization'],
            identity_card_front: json['identity_card_front'],
            identity_card_back: json['identity_card_back'],
            practicing_certificate: json['practicing_certificate'],
            employee_card: json['employee_card'],
            fcc: json['fcc'],
            audit_info: json['audit_info'],
            validity_time: json['validity_time'],
            status: json['status'],
            created_at: json['created_at'],
            updated_at: json['updated_at'])
        : AuthenticateTypeModel(
            id: '',
            user_id: '',
            name: '',
            phone: '',
            gender: 0,
            organization: '',
            identity_card_front: '',
            identity_card_back: '',
            practicing_certificate: '',
            employee_card: '',
            fcc: '',
            audit_info: null,
            validity_time: null,
            status: 0,
            created_at: '',
            updated_at: '');
  }
}
