import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplyJobController.dart';
import '../../../config/app_colors.dart';

class ApplyJobScreen extends StatefulWidget {
  final int jobId;
  final String? jobTitle;

  const ApplyJobScreen({super.key, required this.jobId, this.jobTitle});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  late final ApplyJobController controller;
  
  @override
  void initState() {
    super.initState();
    controller = Get.put(ApplyJobController() ,permanent: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int validJobId = widget.jobId ?? 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('التقديم على: ${widget.jobTitle ?? ""}', style: const TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('خطاب التقديم'),
                TextField(
                  controller: controller.coverLetterController,
                  maxLines: 5,
                  decoration: _inputDecoration('اكتب خطاب التقديم هنا...'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('رابط المعرض / الأعمال (اختياري)'),
                TextField(
                  controller: controller.portfolioController,
                  decoration: _inputDecoration('https://...'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('الراتب المتوقع (اختياري)'),
                TextField(
                  controller: controller.salaryController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('مثال: 1000'),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('تاريخ التوفر (اختياري)'),
                TextField(
                  controller: controller.availabilityController,
                  decoration: _inputDecoration('YYYY-MM-DD'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      controller.availabilityController.text = pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('ملاحظات إضافية (اختياري)'),
                TextField(
                  controller: controller.notesController,
                  maxLines: 3,
                  decoration: _inputDecoration('أي ملاحظات أخرى...'),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value 
                        ? null 
                        : () => controller.submitApplication(validJobId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value 
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
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
