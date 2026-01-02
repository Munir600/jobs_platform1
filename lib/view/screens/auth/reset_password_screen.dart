import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/auth/reset_password_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تعيين كلمة المرور الجديدة'),
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
                const SizedBox(height: 10),
                Text(
                  'تم إرسال كود التحقق إلى ${controller.phone}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: controller.codeController,
                  labelText: 'كود التحقق',
                  prefixIcon: Icon(
                    Icons.security,
                    color: AppColors.secondaryColor,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.isEmpty) ? 'ادخل كود التحقق' : null,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomTextField(
                  controller: controller.passwordController,
                  labelText: 'كلمة المرور الجديدة',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.secondaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textColor.withValues(alpha: 0.5),
                    ),
                    onPressed: () => controller.obscurePassword.toggle(),
                  ),
                  obscureText: controller.obscurePassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'ادخل كلمة المرور';
                    if (value.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                    return null;
                  },
                )),
                const SizedBox(height: 20),
                Obx(() => CustomTextField(
                  controller: controller.confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.secondaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureConfirmPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textColor.withValues(alpha: 0.5),
                    ),
                    onPressed: () => controller.obscureConfirmPassword.toggle(),
                  ),
                  obscureText: controller.obscureConfirmPassword.value,
                  validator: (value) {
                    if (value != controller.passwordController.text) return 'كلمة المرور غير مطابقة';
                    return null;
                  },
                )),
                const SizedBox(height: 40),
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
                            'تغيير كلمة المرور',
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

