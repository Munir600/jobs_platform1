import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplyJobController.dart';
import '../../../../data/models/job/JobDetail.dart';
import '../../../../core/utils/contact_utils.dart';

class ExternalApplicationWidget extends StatelessWidget {
  final ApplyJobController controller;
  final JobDetail job;

  const ExternalApplicationWidget({
    super.key,
    required this.controller,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmail = job.applicationMethod == 'email';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildIconCircle(isEmail),
          const SizedBox(height: 32),
          _buildTextContent(isEmail),
          const SizedBox(height: 48),
          _buildActionButton(isEmail),
          const SizedBox(height: 24),
          _buildTipCard(isEmail),
        ],
      ),
    );
  }

  Widget _buildIconCircle(bool isEmail) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1), width: 2),
      ),
      child: Icon(
        isEmail ? Icons.alternate_email : Icons.open_in_new_rounded,
        size: 56,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildTextContent(bool isEmail) {
    return Column(
      children: [
        Text(
          isEmail ? 'التقديم عبر البريد المباشر' : 'إكمال التقديم خارج المنصة',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            isEmail
                ? 'فضل صاحب العمل استلام الطلبات عبر البريد الإلكتروني مباشرة. اضغط أدناه وسيتم فتح تطبيق البريد لديك.'
                : 'تتطلب هذه الوظيفة إكمال بيانات التقديم عبر الموقع الرسمي للشركة. سنقوم بتوجيهك إلى هناك الآن.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(bool isEmail) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final target = isEmail ? job.applicationEmail : job.externalApplicationUrl;
          if (target != null) {
            ContactUtils.handleContactAction(target);
            // Submit an empty application for tracking purposes
            controller.submitApplication(shouldPop: false);
            Get.back();
            Get.snackbar(
              'تم التوجيه',
              isEmail ? 'فتح تطبيق البريد...' : 'الانتقال إلى موقع الشركة...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryColor,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColors.primaryColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEmail ? 'مراسلة جهة التوظيف' : 'الذهاب لرابط التقديم',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_back, color: Colors.white, size: 20), // Arabic RTL icon
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(bool isEmail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'سنقوم بحفظ هذه الوظيفة في قائمة "تقديماتي" لتمكينك من متابعتها لاحقاً.',
              style: TextStyle(fontSize: 12, color: Colors.amber[900]),
            ),
          ),
        ],
      ),
    );
  }
}
