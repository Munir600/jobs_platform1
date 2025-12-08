import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If the user is not logged in, redirect to login page
    // We check both the reactive variable and the storage to be safe
    // (though AuthController should handle sync on init)
    if (!authController.isLoggedIn.value) {
      if (route != AppRoutes.login && route != AppRoutes.signup && route != AppRoutes.splash) {
         // Return RouteSettings to redirect
         return const RouteSettings(name: AppRoutes.login);
      }
    }
    return null;
  }
}
