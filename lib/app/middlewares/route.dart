import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (false) {
      return RouteSettings(name: '/login');
    }
    return null;
  }
}
