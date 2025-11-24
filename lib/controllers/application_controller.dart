// lib/controllers/application_controller.dart
import 'package:get/get.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../data/models/application_models.dart';
import '../data/models/interview_models.dart';


class ApplicationController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<JobApplication> myApplications = <JobApplication>[].obs;
  final RxList<JobApplication> employerApplications = <JobApplication>[].obs;
  final RxList<ApplicationMessage> applicationMessages = <ApplicationMessage>[].obs;
  final RxList<Interview> interviews = <Interview>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onReady() {
    loadMyApplications();
    loadEmployerApplications();
    loadInterviews();
    super.onReady();
  }

  Future<void> loadMyApplications() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiEndpoints.myApplications);
      myApplications.assignAll((response['results'] as List)
          .map((app) => JobApplication.fromJson(app))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل طلبات التوظيف');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEmployerApplications() async {
    try {
      final response = await _apiService.get('/api/applications/job-applications/');
      employerApplications.assignAll((response['results'] as List)
          .map((app) => JobApplication.fromJson(app))
          .toList());
    } catch (e) {
      // تجاهل الخطأ إذا لم يكن المستخدم صاحب عمل
    }
  }

  Future<void> loadApplicationMessages(int applicationId) async {
    try {
      final response = await _apiService.get('/api/applications/$applicationId/messages/');
      applicationMessages.assignAll((response['results'] as List)
          .map((msg) => ApplicationMessage.fromJson(msg))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الرسائل');
    }
  }

  Future<void> loadInterviews() async {
    try {
      final response = await _apiService.get('/api/applications/interviews/');
      interviews.assignAll((response['results'] as List)
          .map((interview) => Interview.fromJson(interview))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المقابلات');
    }
  }

  Future<bool> applyForJob(JobApplicationCreate application) async {
    try {
      await _apiService.post(ApiEndpoints.applyJob, application.toJson());
      await loadMyApplications();
      Get.snackbar('نجاح', 'تم التقديم على الوظيفة بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> withdrawApplication(int applicationId) async {
    try {
      await _apiService.post('/api/applications/$applicationId/withdraw/', {});
      await loadMyApplications();
      Get.snackbar('نجاح', 'تم سحب الطلب بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في سحب الطلب');
      return false;
    }
  }

  Future<bool> sendMessage(int applicationId, String message, String? attachment) async {
    try {
      await _apiService.post(
        '/api/applications/$applicationId/messages/create/',
        {'message': message, 'attachment': attachment},
      );
      await loadApplicationMessages(applicationId);
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الرسالة');
      return false;
    }
  }

  Future<bool> updateApplicationStatus(int applicationId, String status, String? notes, int? rating) async {
    try {
      await _apiService.put(
        '/api/applications/$applicationId/update/',
        {'status': status, 'employer_notes': notes, 'rating': rating},
      );
      await loadEmployerApplications();
      Get.snackbar('نجاح', 'تم تحديث حالة الطلب');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> scheduleInterview(InterviewCreate interview) async {
    try {
      await _apiService.post('/api/applications/interviews/create/', interview.toJson());
      await loadInterviews();
      Get.snackbar('نجاح', 'تم جدولة المقابلة بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> updateInterview(int interviewId, Map<String, dynamic> data) async {
    try {
      await _apiService.put('/api/applications/interviews/$interviewId/', data);
      await loadInterviews();
      Get.snackbar('نجاح', 'تم تحديث المقابلة');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }
}