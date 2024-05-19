import 'package:get/get.dart';

// 创建控制器类并扩展GetxController。
class NotificationController extends GetxController {
  // 推送设备注册id
  String rid = '';
  // 伤痛通知数量
  int painNotiicationNum = 0;

  void setRid(String ridNew) {
    rid = ridNew;
    update();
  }

  void setPainNotiicationNum(int painNotiicationNumNew) {
    painNotiicationNum = painNotiicationNumNew;
    update();
  }
}
