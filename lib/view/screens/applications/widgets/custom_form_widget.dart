import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplyJobController.dart';
import '../../../../data/models/job/JobDetail.dart';

class CustomFormWidget extends StatelessWidget {
  final ApplyJobController controller;
  final JobDetail job;

  const CustomFormWidget({
    super.key,
    required this.controller,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    if (job.customForm == null ||
        job.customForm!.questions == null ||
        job.customForm!.questions!.isEmpty) {
      return const Center(child: Text('لا يوجد استبيان لهذه الوظيفة'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        ...job.customForm!.questions!.map((question) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${question.label}${question.required == true ? ' * ' : ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    if (question.required == true)
                      const Icon(Icons.star, size: 10, color: Colors.red),
                  ],
                ),
                if (question.helpText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      question.helpText!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.surveyControllers[question.id] ??
                      TextEditingController(),
                  maxLines: question.questionType == 'text' ? 1 : 4,
                  decoration: _inputDecoration(
                    question.questionType == 'text'
                        ? 'اكتب إجابتك هنا...'
                        : 'يرجى تقديم إجابة مفصلة...',
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 32),
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
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined,
                  color: Colors.orange, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'استبيان التقديم المخصص',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          job.customForm!.description ??
              'يرجى الإجابة على الأسئلة التالية بعناية لزيادة فرصك في القبول.',
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.accentColor.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
      hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
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
                    'إرسال الاستبيان',
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
