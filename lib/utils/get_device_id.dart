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
      final String deviceIdNew = const Uuid().v4();
      userController.setUUID(deviceIdNew);
      await prefs.setString('device_uuid', deviceIdNew);
      deviceIdFinal = deviceIdNew;
    } else {
      userController.setUUID(deviceIdHistory);
      deviceIdFinal = deviceIdHistory;
    }

    print('设备的UUID是: $deviceIdFinal');

    return deviceIdFinal;
  }
}
