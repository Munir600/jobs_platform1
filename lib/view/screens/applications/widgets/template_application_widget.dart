import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplyJobController.dart';
import '../../../../data/models/job/JobDetail.dart';
import '../../../../core/utils/contact_utils.dart';

class TemplateApplicationWidget extends StatelessWidget {
  final ApplyJobController controller;
  final JobDetail job;

  const TemplateApplicationWidget({
    super.key,
    required this.controller,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 32),
        _buildStepItem(
          stepNumber: 1,
          title: 'تحميل ملف القالب',
          description: 'قم بتحميل الملف المرفق وتعبئة البيانات المطلوبة بدقة.',
          child: Obx(() => _buildDownloadAction()),
        ),
        const SizedBox(height: 32),
        _buildStepItem(
          stepNumber: 2,
          title: 'رفع الملف المعبأ',
          description: 'بعد الانتهاء من تعبئة القالب، قم برفع الملف هنا للإرسال.',
          child: Obx(() => _buildUploadAction()),
        ),
        const SizedBox(height: 48),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.file_present_outlined,
                  color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'التقديم باستخدام قالب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'اتبع الخطوات أدناه لإتمام عملية التقديم لهذه الوظيفة.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (stepNumber == 1)
              Container(
                width: 2,
                height: 100,
                color: Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadAction() {
    bool isDone = controller.isTemplateDownloaded.value;
    return InkWell(
      onTap: () {
        if (job.applicationTemplate != null) {
          ContactUtils.handleContactAction(job.applicationTemplate!);
          controller.isTemplateDownloaded.value = true;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? Colors.green.withOpacity(0.2) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.download_for_offline_outlined,
              color: isDone ? Colors.green : AppColors.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              isDone ? 'تم تحميل القالب بنجاح' : 'اضغط للتحميل الآن',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDone ? Colors.green : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadAction() {
    bool enabled = controller.isTemplateDownloaded.value;
    var file = controller.filledTemplateFile.value;

    return InkWell(
      onTap: enabled ? () => controller.pickTemplateFile() : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: file != null ? AppColors.primaryColor.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: file != null ? AppColors.primaryColor.withOpacity(0.2) : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                file != null ? Icons.file_present : Icons.cloud_upload_outlined,
                color: file != null ? AppColors.primaryColor : Colors.grey[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  file != null ? file.path.split('/').last : 'رفع القالب المكتمل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: file != null ? FontWeight.bold : FontWeight.normal,
                    color: file != null ? AppColors.primaryColor : Colors.grey[600],
                  ),
                ),
              ),
              if (file != null)
                const Icon(Icons.edit, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value || !controller.isTemplateDownloaded.value || controller.filledTemplateFile.value == null
                ? null
                : () => controller.submitApplication(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'تقديم الطلب المكتمل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          )),
    );
  }
}
