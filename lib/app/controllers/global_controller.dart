import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 创建控制器类并扩展GetxController。
class GlobalController extends GetxController {
  String cdnBaseUrl = dotenv.env['CDN_BASE_URL'] ?? '';

  void setCdnBaseUrl(String cdnBaseUrlNew) {
    cdnBaseUrl = cdnBaseUrlNew;
    update();
  }
}
