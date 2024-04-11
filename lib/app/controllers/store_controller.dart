import 'package:get/get.dart';

// 创建控制器类并扩展GetxController。
class StoreController extends GetxController {
  // 课程购物车
  Rx<int> storeCourseChartNum = Rx(0);
  // 伤痛搜索历史记录，最多存20个
  List<String> storeCourseSearchHistory = [];

  void setStoreCourseChartNum(int storeCourseChartNumNew) {
    storeCourseChartNum.value = storeCourseChartNumNew;
    update();
  }

  void addStoreCourseChartNum() {
    storeCourseChartNum.value += 1;
    update();
  }

  void setStoreCourseSearchHistory(List<String> storeCourseSearchHistoryNew) {
    storeCourseSearchHistory = storeCourseSearchHistoryNew;
    storeCourseSearchHistory = storeCourseSearchHistory.length > 20
        ? storeCourseSearchHistory.sublist(0, 20)
        : storeCourseSearchHistory;
    update();
  }

  void pushStoreCourseSearchHistory(String painSearchHistoryItem) {
    storeCourseSearchHistory.insert(0, painSearchHistoryItem);
    storeCourseSearchHistory = storeCourseSearchHistory.length > 20
        ? storeCourseSearchHistory.sublist(0, 20)
        : storeCourseSearchHistory;
    update();
  }
}
