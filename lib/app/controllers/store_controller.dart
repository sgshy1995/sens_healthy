import 'package:get/get.dart';

// 创建控制器类并扩展GetxController。
class StoreController extends GetxController {
  // 课程购物车
  Rx<int> storeCourseChartNum = Rx(0);
  // 器材购物车
  Rx<int> storeEquipmentChartNum = Rx(0);
  // 伤痛搜索历史记录，最多存20个
  List<String> storeCourseSearchHistory = [];
  // 器械搜索历史记录，最多存20个
  List<String> storeEquipmentSearchHistory = [];
  // 器械订单搜索历史记录，最多存20个
  List<String> storeEquipmentOrderSearchHistory = [];
  //器材订单信息
  int equipmentWaitCounts = 0;
  int equipmentShippingCounts = 0;
  int equipmentReceivedCounts = 0;
  int equipmentCanceledCounts = 0;
  //课程订单信息
  int learningCounts = 0;
  int majorCourseCounts = 0;

  void setStoreCourseChartNum(int storeCourseChartNumNew) {
    storeCourseChartNum.value = storeCourseChartNumNew;
    update();
  }

  void addStoreCourseChartNum() {
    storeCourseChartNum.value += 1;
    update();
  }

  void setStoreEquipmentChartNum(int storeEquipmentChartNumNew) {
    storeEquipmentChartNum.value = storeEquipmentChartNumNew;
    update();
  }

  void addStoreEquipmentChartNum() {
    storeEquipmentChartNum.value += 1;
    update();
  }

  void setStoreCourseSearchHistory(List<String> storeCourseSearchHistoryNew) {
    storeCourseSearchHistory = storeCourseSearchHistoryNew;
    storeCourseSearchHistory = storeCourseSearchHistory.length > 20
        ? storeCourseSearchHistory.sublist(0, 20)
        : storeCourseSearchHistory;
    update();
  }

  void pushStoreCourseSearchHistory(String courseSearchHistoryItem) {
    storeCourseSearchHistory.insert(0, courseSearchHistoryItem);
    storeCourseSearchHistory = storeCourseSearchHistory.length > 20
        ? storeCourseSearchHistory.sublist(0, 20)
        : storeCourseSearchHistory;
    update();
  }

  void setStoreEquipmentSearchHistory(
      List<String> storeEquipmentSearchHistoryNew) {
    storeEquipmentSearchHistory = storeEquipmentSearchHistoryNew;
    storeEquipmentSearchHistory = storeEquipmentSearchHistory.length > 20
        ? storeEquipmentSearchHistory.sublist(0, 20)
        : storeEquipmentSearchHistory;
    update();
  }

  void pushStoreEquipmentSearchHistory(String equipmentSearchHistoryItem) {
    storeEquipmentSearchHistory.insert(0, equipmentSearchHistoryItem);
    storeEquipmentSearchHistory = storeEquipmentSearchHistory.length > 20
        ? storeEquipmentSearchHistory.sublist(0, 20)
        : storeEquipmentSearchHistory;
    update();
  }

  void setStoreEquipmentOrderSearchHistory(
      List<String> storeEquipmentOrderSearchHistoryNew) {
    storeEquipmentOrderSearchHistory = storeEquipmentOrderSearchHistoryNew;
    storeEquipmentOrderSearchHistory =
        storeEquipmentOrderSearchHistory.length > 20
            ? storeEquipmentOrderSearchHistory.sublist(0, 20)
            : storeEquipmentOrderSearchHistory;
    update();
  }

  void pushStoreEquipmentOrderSearchHistory(
      String equipmentOrderSearchHistoryItem) {
    storeEquipmentOrderSearchHistory.insert(0, equipmentOrderSearchHistoryItem);
    storeEquipmentOrderSearchHistory =
        storeEquipmentOrderSearchHistory.length > 20
            ? storeEquipmentOrderSearchHistory.sublist(0, 20)
            : storeEquipmentOrderSearchHistory;
    update();
  }

  void setStoreEquipmentWaitCounts(int equipmentWaitCountsNew) {
    equipmentWaitCounts = equipmentWaitCountsNew;
    update();
  }

  void setStoreEquipmentShippingCounts(int equipmentShippingCountsNew) {
    equipmentShippingCounts = equipmentShippingCountsNew;
    update();
  }

  void setStoreEquipmentReceivedCounts(int equipmentReceivedCountsNew) {
    equipmentReceivedCounts = equipmentReceivedCountsNew;
    update();
  }

  void setStoreEquipmentCanceledCounts(int equipmentCanceledCountsNew) {
    equipmentCanceledCounts = equipmentCanceledCountsNew;
    update();
  }

  void setLearningCounts(int learningCountsNew) {
    learningCounts = learningCountsNew;
    update();
  }

  void setMajorCourseCounts(int majorCourseCountsNew) {
    majorCourseCounts = majorCourseCountsNew;
    update();
  }
}
