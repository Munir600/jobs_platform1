import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    
    final phone = phoneController.text.trim();
    final ok = await _authController.resetPasswordRequest(phone);

    if (ok) {
      Get.toNamed(AppRoutes.resetPassword, arguments: phone);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
