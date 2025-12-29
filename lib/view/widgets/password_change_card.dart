import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../core/utils/network_utils.dart';
import '../../data/models/user_models.dart';
import 'custom_text_field.dart';

class PasswordChangeCard extends StatefulWidget {
  const PasswordChangeCard({super.key});

  @override
  State<PasswordChangeCard> createState() => _PasswordChangeCardState();
}

class _PasswordChangeCardState extends State<PasswordChangeCard> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final RxBool _obscureOld = true.obs;
  final RxBool _obscureNew = true.obs;
  final RxBool _obscureConfirm = true.obs;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hasInternet = await NetworkUtils.checkInternet(context);
    if (!hasInternet) return;
    if (!_formKey.currentState!.validate()) return;
    final authController = Get.find<AuthController>();
    
    final passwordChange = PasswordChange(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      newPasswordConfirm: _confirmPasswordController.text,
    );

    final success = await authController.changePassword(passwordChange);
    
    if (success) {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Old Password
            Obx(() => CustomTextField(
              controller: _oldPasswordController,
              labelText: 'كلمة المرور القديمة',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOld.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => _obscureOld.toggle(),
              ),
              obscureText: _obscureOld.value,
              validator: (v) => (v == null || v.isEmpty)
                  ? 'الرجاء إدخال كلمة المرور القديمة'
                  : null,
            )),
            const SizedBox(height: 15),

            // New Password
            Obx(() => CustomTextField(
              controller: _newPasswordController,
              labelText: 'كلمة المرور الجديدة',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => _obscureNew.toggle(),
              ),
              obscureText: _obscureNew.value,
              validator: (v) {
                if (v == null || v.isEmpty) return 'الرجاء إدخال كلمة المرور الجديدة';
                 if (v.length < 8) return ' تأكد ان عدد الحروف في هذا الحقل لا يقل عن 8 حروف ';
                return null;
              },
            )),
            const SizedBox(height: 15),

            // Confirm Password
            Obx(() => CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'تأكيد كلمة المرور الجديدة',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => _obscureConfirm.toggle(),
              ),
              obscureText: _obscureConfirm.value,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'الرجاء تأكيد كلمة المرور الجديدة';
                }
                if (v != _newPasswordController.text) {
                  return 'كلمة المرور غير متطابقة';
                }
                return null;
              },
            )),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: authController.isLoading.value ? null : _submit,
                child: authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
