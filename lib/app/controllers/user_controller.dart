import 'package:get/get.dart';

// 创建控制器类并扩展GetxController。
class UserController extends GetxController {
  String uuid = '';
  String token = '';

  void setUUID(String uuidNew) {
    uuid = uuidNew;
    update(); // 当调用增量时，使用update()来更新用户界面上的计数器变量。
  }

  void setToken(String tokenNew) {
    token = tokenNew;
    update(); // 当调用增量时，使用update()来更新用户界面上的计数器变量。
  }
}
