import 'package:get/get.dart';
import '../models/user_model.dart';

// 创建控制器类并扩展GetxController。
class UserController extends GetxController {
  String uuid = '';
  String token = '';
  UserTypeModel userInfo = UserTypeModel.fromJson(null);
  UserInfoTypeModel info = UserInfoTypeModel.fromJson(null);

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
