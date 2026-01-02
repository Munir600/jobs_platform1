import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/auth/forgot_password_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('نسيت كلمة المرور'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.lock_reset_rounded,
                  size: 100,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 30),
                Text(
                  'أدخل رقم هاتفك لاستعادة كلمة المرور',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'سنقوم بإرسال كود التحقق إلى رقم هاتفك',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: controller.phoneController,
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: AppColors.secondaryColor,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'ادخل رقم الهاتف';
                    final prefixRegExp = RegExp(r'^(77|78|73|71|70)');
                    if (!prefixRegExp.hasMatch(value)) {
                      return 'رقم الهاتف يجب أن يبدأ بـ 77 أو 78 أو 73 أو 71 أو 70';
                    }
                    if (value.length != 9) {
                      return 'رقم الهاتف يجب ان يكون 9 أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Obx(() {
                  final isLoading = Get.find<AuthController>().isLoading.value;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : controller.submit,
                    child: isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : const Text(
                            'إرسال كود التحقق',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  );
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
