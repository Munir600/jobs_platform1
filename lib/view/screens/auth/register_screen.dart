import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/user_models.dart';
import '../../../controllers/auth_controller.dart';
import '../main_screen.dart';
import 'login_screen.dart';
import '../../../core/utils/network_utils.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text_field.dart';
import '../../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  
  // Reactive local state
  final RxString _userType = 'job_seeker'.obs;
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hasInternet = await NetworkUtils.checkInternet(context);
    if (!hasInternet) return;
    if (!_formKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final registration = UserRegistration(
      username: _username.text.trim(),
      email: _email.text.trim(),
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text,
      passwordConfirm: _confirm.text,
      userType: _userType.value,
    );

    final ok = await auth.register(registration);
    if (ok) {
      final logged = await auth.login(_phone.text.trim(), _password.text);
      if (logged) {
        Get.offAll(() => MainScreen());
      } else {
        Get.off(() => const LoginScreen());
      }
    } else {
      Get.defaultDialog(
        title: 'فشل التسجيل',
        middleText: 'تحقق من البيانات',
        textConfirm: 'حسناً',
        onConfirm: () => Get.back(),
      );
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/Logo4.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person_add,
                                  size: 50,
                                  color: AppColors.primaryColor,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'إنشاء حساب ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تسجيل حساب جديد للبدء ',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor.withValues(alpha: 0.3),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonFormField<String>(
                            dropdownColor: AppColors.backgroundColor,
                            value: _userType.value,
                            items: const [
                              DropdownMenuItem(
                                  value: 'job_seeker',
                                  child: Text('باحث عن عمل')),
                              DropdownMenuItem(
                                  value: 'employer',
                                  child: Text('صاحب عمل')),
                            ],
                            onChanged: (v) => _userType.value = v ?? 'job_seeker',
                            padding: const EdgeInsets.all(8),
                            decoration: InputDecoration(
                              labelText: 'نوع المستخدم',
                              labelStyle: TextStyle(
                                color: AppColors.textColor.withValues(alpha: 0.3),
                              ),
                              prefixIcon: Icon(
                                Icons.add_business_outlined,
                                color: AppColors.secondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.secondaryColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _username,
                          labelText: 'اسم المستخدم',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.secondaryColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسم المستخدم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _first,
                                labelText: 'الاسم الأول',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                controller: _last,
                                labelText: 'الاسم الأخير',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _email,
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.secondaryColor,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _phone,
                          labelText: 'رقم الهاتف',
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: AppColors.secondaryColor,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'الرجاء ادخال رقم الهاتف';
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
                        CustomTextField(
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
                              color: AppColors.textColor.withValues(alpha: 0.3),
                            ),
                            onPressed: () {
                              _obscurePassword.toggle();
                            },
                          ),
                          obscureText: _obscurePassword.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 8) {
                              return 'كلمة المرور يجب أن تكون 8 أحرف أو أكثر';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
                            }
                            if (!RegExp(r'[!@#\$&*~%^()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(value)) {
                              return 'كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _confirm,
                          labelText: 'تأكيد كلمة المرور',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.secondaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textColor.withValues(alpha: 0.3),
                            ),
                            onPressed: () {
                              _obscureConfirmPassword.toggle();
                            },
                          ),
                          obscureText: _obscureConfirmPassword.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء تأكيد كلمة المرور';
                            }
                            if (value != _password.text) {
                              return 'كلمة المرور غير مطابقة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
                            disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.3),
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
                                  'إنشاء حساب',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '  لدي حساب بالفعل ؟',
                                style: TextStyle(
                                  color: AppColors.textColor.withValues(alpha: 0.3),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.login);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                ),
                                child: const Text(
                                  'تسجيل',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
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