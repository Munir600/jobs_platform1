import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/application/JobApplicationCreate.dart';

class ApplyJobScreen extends StatefulWidget {
  final int? jobId;
  final String? jobTitle;

  const ApplyJobScreen({super.key, this.jobId, this.jobTitle});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final ApplicationController controller = Get.find<ApplicationController>();
  
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  late int jobId;
  late String jobTitle;

  @override
  void initState() {
    super.initState();
    jobId = widget.jobId ?? Get.arguments?['jobId'] ?? 0;
    jobTitle = widget.jobTitle ?? Get.arguments?['jobTitle'] ?? '';
  }

  @override
  void dispose() {
    coverLetterController.dispose();
    portfolioController.dispose();
    salaryController.dispose();
    availabilityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('التقديم على: $jobTitle', style: const TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Stack(
        children: [
          const PatternBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('خطاب التغطية'),
                TextField(
                  controller: coverLetterController,
                  maxLines: 5,
                  decoration: _inputDecoration('اكتب خطاب التغطية هنا...'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('رابط المعرض / الأعمال (اختياري)'),
                TextField(
                  controller: portfolioController,
                  decoration: _inputDecoration('https://...'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('الراتب المتوقع (اختياري)'),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('مثال: 1000'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('تاريخ التوفر (اختياري)'),
                TextField(
                  controller: availabilityController,
                  decoration: _inputDecoration('YYYY-MM-DD'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      availabilityController.text = pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('ملاحظات إضافية (اختياري)'),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: _inputDecoration('أي ملاحظات أخرى...'),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () async {
                      final application = JobApplicationCreate(
                        job: jobId,
                        coverLetter: coverLetterController.text,
                        portfolioUrl: portfolioController.text.isNotEmpty ? portfolioController.text : null,
                        expectedSalary: int.tryParse(salaryController.text),
                        availabilityDate: availabilityController.text.isNotEmpty ? availabilityController.text : null,
                        notes: notesController.text.isNotEmpty ? notesController.text : null,
                      );
                      
                      final success = await controller.createApplication(application);
                      if (success) {
                        Get.back(); // Close screen on success
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('إرسال الطلب', style: TextStyle(color: Colors.white, fontSize: 18)),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textColor),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
