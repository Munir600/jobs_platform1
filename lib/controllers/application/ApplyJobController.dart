import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/application/JobApplicationCreate.dart';
import '../../data/services/application/ApplicationService.dart';

class ApplyJobController extends GetxController {
  final ApplicationService _applicationService = ApplicationService();
  
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    coverLetterController.dispose();
    portfolioController.dispose();
    salaryController.dispose();
    availabilityController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> submitApplication(int jobId) async {
    try {
      isLoading.value = true;
      final application = JobApplicationCreate(
        job: jobId,
        coverLetter: coverLetterController.text,
        portfolioUrl: portfolioController.text.isNotEmpty ? portfolioController.text : null,
        expectedSalary: int.tryParse(salaryController.text),
        availabilityDate: availabilityController.text.isNotEmpty ? availabilityController.text : null,
        notes: notesController.text.isNotEmpty ? notesController.text : null,
      );
      await _applicationService.createApplication(application);
      Get.back();
      AppErrorHandler.showSuccessSnack('تم تقديم الطلب بنجاح');
      
    } catch (e) {
     // print("Submit Application Response: $e");
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }
}
