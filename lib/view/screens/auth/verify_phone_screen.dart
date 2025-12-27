import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _phone;
  bool _canResend = false;
  int _timerSeconds = 600; // 10 minutes

  @override
  void initState() {
    super.initState();
    _phone = Get.arguments as String? ?? '';
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    // print('Error Message from storage erro_verifyPhone: $erro_verifyPhone');
    // if(erro_verifyPhone.isNotEmpty && erro_verifyPhone.contains('انتهت صلاحية كود التحقق. الرجاء طلب كود جديد')) {
    //   setState(() {
    //     _canResend = true;
    //     _timerSeconds=0;
    //   });
    // }
    _timerSeconds = 600; // Reset to 10 minutes
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (!mounted) return;
    if (_timerSeconds > 0) {
      setState(() {
        _timerSeconds--;
      });
      Future.delayed(const Duration(seconds: 1), _tick);
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  String get _timerText {
    final minutes = (_timerSeconds / 60).floor();
    final seconds = _timerSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  void _resendCode([AuthController? auth]) {
    final controller = auth ?? Get.find<AuthController>();
    print('Error Message from storage erro_verifyPhone: ${controller.erro_verifyPhone}');
    if (controller.erro_verifyPhone.isNotEmpty && controller.erro_verifyPhone.contains('انتهت صلاحية كود التحقق')) {
      setState(() {
        _canResend = true;
        _timerSeconds = 0;
      });
    }
  }


  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('التحقق من رقم الهاتف'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Obx(() => AbsorbPointer(
              absorbing: auth.isLoading.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 80,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'تم إرسال رمز التحقق إلى رقم هاتفك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _phone,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _codeController,
                    labelText: 'رمز التحقق',
                    hintText: 'أدخل الرمز المكون من 6 أرقام',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.security, color: AppColors.secondaryColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رمز التحقق';
                      }
                      if (value.length < 6) {
                        return 'رمز التحقق يجب أن يكون 6 أرقام على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
                    ),
                    // onPressed: auth.isLoading.value
                    //     ? null
                    //     : () {
                    //         if (_formKey.currentState!.validate()) {
                    //           auth.verifyPhone(_phone, _codeController.text.trim());
                    //           _resendCode(auth);
                    //         }
                    //       },
                    onPressed: auth.isLoading.value
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        await auth.verifyPhone(_phone, _codeController.text.trim());
                        _resendCode(auth);
                      }
                    },
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
                            'تحقق',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لم يصلك الرمز؟ ',
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      _canResend
                          ? TextButton(
                              onPressed: () {
                                auth.resendVerificationCode(_phone);
                                _startTimer();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                              ),
                              child: const Text('إعادة إرسال'),
                            )
                          : Text(
                              'إعادة إرسال خلال $_timerText',
                              style: TextStyle(
                                color: AppColors.textColor.withValues(alpha: 0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
