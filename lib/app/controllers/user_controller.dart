import 'package:get/get.dart';
import '../models/user_model.dart';

// 创建控制器类并扩展GetxController。
class UserController extends GetxController {
  String uuid = '';
  String token = '';
  UserTypeModel userInfo = UserTypeModel(
      id: '',
      username: '',
      name: '',
      phone: '',
      identity: 0,
      authenticate: 0,
      recent_login_time: '',
      status: 0,
      created_at: '',
      updated_at: '');
  UserInfoTypeModel info = UserInfoTypeModel(
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

  void setUUID(String uuidNew) {
    uuid = uuidNew;
    update();
  }

  void setToken(String tokenNew) {
    token = tokenNew;
    update();
  }

  void setUserInfo(UserTypeModel userInfoNew) {
    userInfo = userInfoNew;
    update();
  }

  void updateInfoBalance(String balanceNew) {
    info.balance = balanceNew;
    update();
  }

  void setInfo(UserInfoTypeModel infoNew) {
    info = infoNew;
    update();
  }
}
