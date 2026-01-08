import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../api_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final ApiService apiService = Get.find();
    if (apiService.authToken!.isEmpty) {
      if (route != AppRoutes.login && route != AppRoutes.signup && route != AppRoutes.splash) {
         return const RouteSettings(name: AppRoutes.login);
      }
    }

    return null;
  }
}
