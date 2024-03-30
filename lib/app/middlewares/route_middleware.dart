import 'package:get/get.dart';

void Function(Routing?)? routeMiddleware = (routing) {
  int a = 0;
  if (routing != null) {
    if (a != 1 && routing.current != '/login') {
      //Get.off('/login');
      print('last route called');
      Get.offAllNamed('/login'); // 如果用户未登录，重定向到登录页面
    }
  }
};
