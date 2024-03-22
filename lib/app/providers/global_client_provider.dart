import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/user_controller.dart';

class ApiResponse<T> {
  final int code;
  final String message;
  final T data;

  ApiResponse({required this.code, required this.message, required this.data});

  factory ApiResponse.fromJson(
      ApiResponse json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      code: json.code,
      message: json.message,
      data: fromJsonT(json.data),
    );
  }
}

class GlobalClientProvider extends GetConnect {
  late Function(dynamic jsonData) defaultDecoderFunction;

  final UserController userController = GetInstance().find<UserController>();

  void setDefaultDecoder(dynamic Function(dynamic json) decoder) {
    defaultDecoderFunction = decoder;
    //httpClient.defaultDecoder = defaultDecoderFunction;
  }

  // void setDefaultDecoder<T>(T Function(dynamic) fromJsonT) {
  //   defaultDecoderFunction = (jsonData) {
  //     return ApiResponse.fromJson(jsonData, fromJsonT);
  //   };
  //   //httpClient.defaultDecoder = defaultDecoderFunction;
  // }

  @override
  void onInit() async {
    super.onInit();

    print('dotenv.env -----: ${dotenv.env['API_BASE_URL']}');

    String? baseUrl = dotenv.env['API_BASE_URL'];

    if (baseUrl != null && Uri.parse(baseUrl).isAbsolute) {
      httpClient.baseUrl = baseUrl;
      print('Right API_BASE_URL: $baseUrl');
    } else {
      print('Invalid API_BASE_URL: $baseUrl');
      // 可以在这里设置一个默认的 baseUrl 或者执行其他处理逻辑
    }

    httpClient.timeout = const Duration(seconds: 10);
    // It's will attach 'apikey' property on header from all requests
    httpClient.addRequestModifier<dynamic>((request) {
      if (userController.token.isNotEmpty) {
        final token = userController.token;
        request.headers['Authorization'] = "Bearer $token";
        print("添加了一次头 $userController.token.toString()");
      }

      request.headers['Connection'] = 'close';
      return request;
    });
    httpClient.addAuthenticator<dynamic>((request) async {
      // Try reading data from the 'action' key. If it doesn't exist, returns null.
      if (userController.token.isNotEmpty) {
        request.headers['Authorization'] = "Bearer $userController.token";
      }
      return request;
    });
  }
}
