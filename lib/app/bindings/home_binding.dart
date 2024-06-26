import 'package:get/get.dart';
import '../providers/global_client_provider.dart';
import '../providers/api/user_client_provider.dart';
import '../providers/api/pain_client_provider.dart';
import '../providers/api/prescription_client_provider.dart';
import '../providers/api/store_client_provider.dart';
import '../providers/api/appointment_client_provider.dart';
import '../providers/api/major_client_provider.dart';
import '../providers/api/notification_client_provider.dart';
import '../controllers/user_controller.dart';
import '../controllers/global_controller.dart';
import '../controllers/store_controller.dart';
import '../controllers/notification_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalClientProvider());
    Get.lazyPut(() => UserClientProvider());
    Get.lazyPut(() => PainClientProvider());
    Get.lazyPut(() => PrescriptionClientProvider());
    Get.lazyPut(() => StoreClientProvider());
    Get.lazyPut(() => AppointmentClientProvider());
    Get.lazyPut(() => MajorClientProvider());
    Get.lazyPut(() => NotificationClientProvider());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => GlobalController());
    Get.lazyPut(() => StoreController());
    Get.lazyPut(() => NotificationController());
  }
}
