import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      if (route != AppRoutes.login && route != AppRoutes.signup && route != AppRoutes.splash) {
         return const RouteSettings(name: AppRoutes.login);
      }
    }
    return null;
  }
}
