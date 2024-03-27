import 'package:get/get.dart';
import '../providers/global_client_provider.dart';
import '../providers/api/user_client_provider.dart';
import '../providers/api/pain_client_provider.dart';
import '../controllers/user_controller.dart';
import '../controllers/global_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalClientProvider());
    Get.lazyPut(() => UserClientProvider());
    Get.lazyPut(() => PainClientProvider());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => GlobalController());
  }
}
