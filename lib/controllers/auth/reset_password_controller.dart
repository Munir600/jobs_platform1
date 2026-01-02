import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_models.dart';
import '../../routes/app_routes.dart';
import '../auth_controller.dart';

class ResetPasswordController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  late String phone;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments as String;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final data = PasswordResetConfirm(
      phone: phone,
      verificationCode: codeController.text.trim(),
      newPassword: passwordController.text,
      newPasswordConfirm: confirmPasswordController.text,
    );

    final ok = await _authController.resetPasswordConfirm(data);
    if (ok) {
      Get.offAllNamed(AppRoutes.login, arguments: {
        'phone': phone,
        'password': passwordController.text,
      });
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
