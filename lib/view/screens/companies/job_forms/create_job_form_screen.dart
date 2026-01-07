import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/job_forms_controller.dart';
import '../../../../data/models/company/job_form.dart';
import '../../../../core/constants.dart';

class CreateJobFormScreen extends GetView<JobFormsController> {
  const CreateJobFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is initialized by the previous screen (JobFormsScreen)
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        // We can determine title by checking if we are editing (internal controller state check logic omitted or just generic)
        // Or updated controller to expose a property "isEditing"
        // For simplicity: "نموذج التقديم" or check if nameController has text? 
        // Better: allow title determination. But distinct "Create"/"Edit" is nice.
        // Let's rely on if initialForm was passed to initForm inside controller? 
        // We can't access it easily without public property. 
        // I'll stick to generic or check nameController.text.isNotEmpty for now as a heuristic, or assume "إدارة النموذج".
        title: const Text('إدارة النموذج', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.accentColor,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Obx(() => controller.isFormLoading.value 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Icon(Icons.check)),
            onPressed: () => controller.isFormLoading.value ? null : controller.saveForm(),
          )
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Info Card
              _buildSectionCard(
                title: 'معلومات النموذج',
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    decoration: _inputDecoration('اسم النموذج'),
                    validator: (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.descriptionController,
                    decoration: _inputDecoration('وصف النموذج'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SwitchListTile(
                    title: const Text('نشط', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('تفعيل النموذج للتقديم'),
                    value: controller.isFormActive.value,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) => controller.isFormActive.value = val,
                    contentPadding: EdgeInsets.zero,
                  )),
                ],
              ),
              const SizedBox(height: 24),
              
              // Questions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الأسئلة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                  ),
                  ElevatedButton.icon(
                    onPressed: controller.addQuestion,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text('إضافة سؤال', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Questions List
              Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildQuestionCard(context, controller, index, controller.questions[index]);
                },
              )),

              Obx(() => controller.questions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('لم يتم إضافة أسئلة بعد', style: TextStyle(color: Colors.grey))),
                  )
                : const SizedBox.shrink()
              ),
                
              const SizedBox(height: 32),
              
              Obx(() => ElevatedButton(
                onPressed: controller.isFormLoading.value ? null : controller.saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isFormLoading.value 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'حفظ النموذج',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, JobFormsController controller, int index, FormQuestion question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Text('${index + 1}', style: const TextStyle(fontSize: 12, color: AppColors.primaryColor)),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Text('تفاصيل السؤال', style: TextStyle(fontWeight: FontWeight.bold))),
              
              // Up Button
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 20, color: Colors.grey),
                  onPressed: () => controller.moveQuestionUp(index),
                  tooltip: 'نقل للأعلى',
                ),
              // Down Button
              if (index < controller.questions.length - 1)
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 20, color: Colors.grey),
                  onPressed: () => controller.moveQuestionDown(index),
                  tooltip: 'نقل للأسفل',
                ),
                
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => controller.removeQuestion(index),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          TextFormField(
            initialValue: question.label,
            decoration: _inputDecoration('نص السؤال'),
            onChanged: (val) {
              controller.updateQuestion(index, _copyQuestion(question, label: val));
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: question.helpText,
            decoration: _inputDecoration('نص توضيحي/مساعد (اختياري)'),
            onChanged: (val) {
              controller.updateQuestion(index, _copyQuestion(question, helpText: val));
            },
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: question.questionType,
                  decoration: _inputDecoration('نوع السؤال'),
                  items: AppEnums.questionType.entries.map((e) =>
                    DropdownMenuItem(value: e.key, child: Text(e.value))
                  ).toList(),
                  onChanged: (val) {
                    controller.updateQuestion(index, _copyQuestion(question, questionType: val));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey.shade300),
                   borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Text('مطلوب؟'),
                    Checkbox(
                      value: question.required ?? false,
                      activeColor: AppColors.primaryColor,
                      onChanged: (val) {
                        controller.updateQuestion(index, _copyQuestion(question, required: val));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (question.questionType == 'select' || question.questionType == 'checkbox') ...[
             const SizedBox(height: 12),
             TextFormField(
              initialValue: question.options,
              decoration: _inputDecoration('الخيارات (افصل بينها بفاصلة)'),
              onChanged: (val) {
                controller.updateQuestion(index, _copyQuestion(question, options: val));
              },
            ),
          ],
        ],
      ),
    );
  }

  FormQuestion _copyQuestion(FormQuestion q, {
    String? label, 
    String? helpText, 
    String? questionType, 
    bool? required, 
    String? options
  }) {
    return FormQuestion(
      id: q.id,
      label: label ?? q.label,
      helpText: helpText ?? q.helpText,
      questionType: questionType ?? q.questionType,
      required: required ?? q.required,
      options: options ?? q.options,
      order: q.order,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      isDense: true,
    );
  }
}
