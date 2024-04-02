import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 创建控制器类并扩展GetxController。
class GlobalController extends GetxController {
  // CDN加速路径
  String cdnBaseUrl = dotenv.env['CDN_BASE_URL'] ?? '';
  // 伤痛搜索历史记录，最多存20个
  List<String> painSearchHistory = [];

  void setCdnBaseUrl(String cdnBaseUrlNew) {
    cdnBaseUrl = cdnBaseUrlNew;
    update();
  }

  void setPainSearchHistory(List<String> painSearchHistoryNew) {
    painSearchHistory = painSearchHistoryNew;
    painSearchHistory = painSearchHistory.length > 20
        ? painSearchHistory.sublist(0, 20)
        : painSearchHistory;
    update();
  }

  void pushPainSearchHistory(String painSearchHistoryItem) {
    painSearchHistory.insert(0, painSearchHistoryItem);
    painSearchHistory = painSearchHistory.length > 20
        ? painSearchHistory.sublist(0, 20)
        : painSearchHistory;
    update();
  }
}
