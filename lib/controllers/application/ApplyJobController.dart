import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/application/JobApplicationCreate.dart';
import '../../data/services/application/ApplicationService.dart';
import '../../data/models/job/JobDetail.dart';
import '../job/JobController.dart';

class ApplyJobController extends GetxController {
  final ApplicationService _applicationService = ApplicationService();

  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxMap<int, TextEditingController> surveyControllers = <int, TextEditingController>{}.obs;

  final RxBool isLoading = false.obs;
  late final int jobId;
  late final String? jobTitle;
  final Rx<JobDetail?> jobDetail = Rx<JobDetail?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      jobId = args['jobId'] ?? 0;
      jobTitle = args['jobTitle'];
      _initJobDetail(args['jobSlug']);
    } else {
      jobId = 0;
      jobTitle = null;
      _initJobDetail(null);
    }
  }

  void _initJobDetail(String? slug) {
    final jobController = Get.find<JobController>();
    if (jobController.currentJob.value?.id == jobId) {
      final job = jobController.currentJob.value;
      _initSurveyControllers(job);
      jobDetail.value = job;
    } else {
      final slugToLoad = slug ?? jobId.toString();
      jobController.loadJobDetail(slugToLoad).then((_) {
        final job = jobController.currentJob.value;
        _initSurveyControllers(job);
        jobDetail.value = job;
      });
    }
  }

  void _initSurveyControllers(JobDetail? job) {
    if (job?.customForm?.questions != null) {
      for (var question in job!.customForm!.questions!) {
        if (question.id != null) {
          surveyControllers[question.id!] = TextEditingController();
        }
      }
    }
  }

  @override
  void onClose() {
    coverLetterController.dispose();
    portfolioController.dispose();
    salaryController.dispose();
    availabilityController.dispose();
    notesController.dispose();
    for (var controller in surveyControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> submitApplication() async {
    try {
      isLoading.value = true;

      final List<JobApplicationResponse> responses = [];
      surveyControllers.forEach((questionId, controller) {
        if (controller.text.isNotEmpty) {
          responses.add(JobApplicationResponse(
            question: questionId,
            answerText: controller.text,
          ));
        }
      });

      final application = JobApplicationCreate(
        job: jobId,
        coverLetter: coverLetterController.text.isNotEmpty ? coverLetterController.text : null,
        portfolioUrl: portfolioController.text.isNotEmpty ? portfolioController.text : null,
        expectedSalary: int.tryParse(salaryController.text),
        availabilityDate: availabilityController.text.isNotEmpty ? availabilityController.text : null,
        notes: notesController.text.isNotEmpty ? notesController.text : null,
         responses: responses.isNotEmpty ? responses : null,
      );

      await _applicationService.createApplication(application);
      Get.back();
      AppErrorHandler.showSuccessSnack('تم تقديم الطلب بنجاح');

    } catch (e) {
      print("Submit Application Response: $e");
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }
}
