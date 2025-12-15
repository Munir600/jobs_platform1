import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/network_utils.dart';
import '../../widgets/custom_text_field.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  final RxBool _obscurePassword = true.obs;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hasInternet = await NetworkUtils.checkInternet(context);
    if (!hasInternet) return;
    if (!_formKey.currentState!.validate()) return;
    
    final auth = Get.find<AuthController>();
    final ok = await auth.login(_phone.text.trim(), _password.text);
    
    if (ok) {
      Get.offAll(() => MainScreen());
    if (ok) {
      Get.offAll(() => MainScreen());
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          const PatternBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Obx(() => AbsorbPointer(
                    absorbing: auth.isLoading.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/Logo4.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'منصة توظيف ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'قم بتسجيل الدخول',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: _phone,
                          textInputAction: TextInputAction.next,
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
                              if (value.length < 3) return null;
                              return 'رقم الهاتف يجب أن يبدأ بـ 77 أو 78 أو 73 أو 71 أو 70';
                            }
                            final numericRegExp = RegExp(r'^[0-9]+$');
                            if (!numericRegExp.hasMatch(value)) {
                              return 'يسمح فقط بإدخال الأرقام';
                            }
                            if (value.length > 9 || value.length < 9) {
                              return 'رقم الهاتف يجب ان يكون 9 أرقام';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Obx(() => CustomTextField(
                          controller: _password,
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.secondaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textColor.withValues(alpha: 0.5),
                            ),
                            onPressed: () {
                              _obscurePassword.toggle();
                            },
                          ),
                          obscureText: _obscurePassword.value,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'ادخل كلمة المرور '
                              : null,
                        )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'تنبيه',
                                'الرجاء التواصل مع خدمة العملاء',
                                backgroundColor: Colors.white,
                                colorText: AppColors.textColor,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryColor,
                            ),
                            child: const Text('نسيت كلمة المرور'),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.primaryColor.withValues(alpha: 0.5),
                            disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
                          ),
                          onPressed: auth.isLoading.value ? null : _submit,
                          child: auth.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لدي حساب ؟',
                                style: TextStyle(
                                  color: AppColors.textColor.withValues(alpha: 0.7),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.signup);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                ),
                                child: const Text(
                                  'تسجل حساب جديد',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}