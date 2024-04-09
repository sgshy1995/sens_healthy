import './../app/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class GetDeviceInfo {
  final UserController userController = GetInstance().find<UserController>();

  Future<String> getDeviceId() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? deviceIdHistory = prefs.getString('device_uuid');
    final String deviceIdFinal;

    if (deviceIdHistory == null) {
      final String uuidNew = const Uuid().v4();
      final int timeNew = DateTime.now().millisecondsSinceEpoch;
      final String deviceIdNew = '$uuidNew-$timeNew';
      userController.setUUID(deviceIdNew);
      await prefs.setString('device_uuid', deviceIdNew);
      deviceIdFinal = deviceIdNew;
    } else {
      userController.setUUID(deviceIdHistory);
      deviceIdFinal = deviceIdHistory;
    }

    return deviceIdFinal;
  }
}
