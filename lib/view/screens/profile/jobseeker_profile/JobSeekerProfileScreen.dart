import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/account/JobSeekerProfileController.dart';
import '../../../../core/constants.dart';
import '../../../widgets/custom_text_field.dart';

class JobSeekerProfileScreen extends GetView<JobSeekerProfileController> {
  const JobSeekerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('السيرة الذاتية', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Resume Upload Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.description, size: 40, color: AppColors.primaryColor),
                    const SizedBox(height: 8),
                    Obx(() {
                       final hasRemoteResume = controller.jobSeekerProfile.value?.resume != null;
                       final hasLocalResume = controller.resumeFile.value != null;
                       return Text(
                         controller.resumeName.value ?? (hasRemoteResume ? 'تم رفع السيرة الذاتية' : 'لم يتم رفع السيرة الذاتية'),
                         style: const TextStyle(fontWeight: FontWeight.bold),
                       );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.pickResume,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('رفع ملف'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: AppColors.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() {
                             final hasRemoteResume = controller.jobSeekerProfile.value?.resume != null;
                             final hasLocalResume = controller.resumeFile.value != null;
                             
                             return ElevatedButton.icon(
                              onPressed: (hasRemoteResume || hasLocalResume) 
                                ? controller.viewResume
                                : null,
                              icon: const Icon(Icons.visibility),
                              label: const Text('عرض'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                             );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Obx(() => _buildDropdown('المستوى التعليمي', AppEnums.educationLevels, controller.selectedEducationLevel.value, (v) => controller.selectedEducationLevel.value = v)),
              const SizedBox(height: 16),
              Obx(() => _buildDropdown('مستوى الخبرة', AppEnums.experienceLevels, controller.selectedExperienceLevel.value, (v) => controller.selectedExperienceLevel.value = v)),
              const SizedBox(height: 16),
              Obx(() => _buildDropdown('نوع الوظيفة المفضل', AppEnums.jobTypes, controller.selectedJobType.value, (v) => controller.selectedJobType.value = v)),
              const SizedBox(height: 16),
              
              _buildTextField(controller.skillsCtrl, 'المهارات (افصل بينها بفاصلة)', maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(controller.languagesCtrl, 'اللغات'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildTextField(controller.expectedSalaryMinCtrl, 'أقل راتب متوقع', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(controller.expectedSalaryMaxCtrl, 'أعلى راتب متوقع', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              
              Obx(() => SwitchListTile(
                title: const Text('متاح للعمل فوراً'),
                value: controller.isAvailable.value,
                onChanged: (val) => controller.isAvailable.value = val,
                activeColor: AppColors.primaryColor,
              )),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('حفظ التغييرات', style: TextStyle(color: Colors.white, fontSize: 18)),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown(String label, Map<String, String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
