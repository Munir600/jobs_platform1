import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/error_handler.dart';
import '../../core/utils/network_utils.dart';
import '../../data/models/accounts/User.dart';
import '../../data/services/application/ApplicationService.dart';
import '../../data/models/application/JobApplication.dart';
import '../../data/models/application/JobApplicationUpdate.dart';
import '../../data/models/application/JobApplicationCreate.dart';
import '../../data/models/application/ApplicationMessage.dart';
import '../../data/models/application/ApplicationStatistics.dart';
import '../../data/models/Interview/Interview.dart';
import '../../data/models/Interview/InterviewCreate.dart';
import '../account/AccountController.dart';

class ApplicationController extends GetxController {
  final ApplicationService _applicationService = ApplicationService();
  final _accountController = Get.find<AccountController>();
  final GetStorage _storage = GetStorage();
  
  Rx<User?> get currentUser => _accountController.currentUser;
  final RxList<JobApplication> myApplications = <JobApplication>[].obs;
  final RxList<JobApplication> jobApplications = <JobApplication>[].obs;
  final RxList<Interview> interviews = <Interview>[].obs;
  final RxList<ApplicationMessage> messages = <ApplicationMessage>[].obs;
  final Rx<ApplicationStatistics?> statistics = Rx<ApplicationStatistics?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isMessageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
  }

  void loadCachedData() {
    try {
      final cachedMyApps = _storage.read('my_applications');
      if (cachedMyApps != null && cachedMyApps is List) {
        myApplications.assignAll(cachedMyApps.map((e) => JobApplication.fromJson(e)).toList());
      }
      
      final cachedInterviews = _storage.read('my_interviews');
      if (cachedInterviews != null && cachedInterviews is List) {
        interviews.assignAll(cachedInterviews.map((e) => Interview.fromJson(e)).toList());
      }

      final cachedStats = _storage.read('application_statistics');
      if (cachedStats != null) {
        statistics.value = ApplicationStatistics.fromJson(cachedStats);
      }
    } catch (e) {
      print('Error loading cached application data: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadMyApplications() async {
    try {
      isLoading.value = true;
      final response = await _applicationService.getMyApplications();
      if (response.results != null) {
        myApplications.assignAll(response.results!);
        _storage.write('my_applications', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadJobApplications({int? jobId}) async {
    try {
      isLoading.value = true;
      if (jobId != null) {
         final cachedJobApps = _storage.read('job_applications_$jobId');
         if(cachedJobApps != null && cachedJobApps is List) {
            jobApplications.assignAll(cachedJobApps.map((e) => JobApplication.fromJson(e)).toList());
         }
      }

      final response = await _applicationService.getJobApplications(jobId: jobId);
      if (response.results != null) {
        jobApplications.assignAll(response.results!);
        if (jobId != null) {
           _storage.write('job_applications_$jobId', response.results!.map((e) => e.toJson()).toList());
        }
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadInterviews() async {
    try {
      isLoading.value = true;
      final response = await _applicationService.getInterviews();
      if (response.results != null) {
        interviews.assignAll(response.results!);
        _storage.write('my_interviews', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateApplicationStatus(int id, String status,
      {String? notes, int? rating}) async {
    try {
      isLoading.value = true;
      final updateData = JobApplicationUpdate(
        status: status,
        employerNotes: notes,
        rating: rating,
      );

      await _applicationService.updateApplication(id, updateData);

      final index = jobApplications.indexWhere((app) => app.id == id);
      if (index != -1) {
        await loadJobApplications();
      }
      AppErrorHandler.showSuccessSnack('تم تحديث حالة الطلب بنجاح إلى $status');

    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(int applicationId) async {
    try {
      isMessageLoading.value = true;
      
      // Load cached messages
      final cachedMsgs = _storage.read('application_messages_$applicationId');
      if (cachedMsgs != null && cachedMsgs is List) {
        messages.assignAll(cachedMsgs.map((e) => ApplicationMessage.fromJson(e)).toList());
      }

      final response = await _applicationService.getApplicationMessages(applicationId);
      if (response.results != null) {
        messages.assignAll(response.results!);
        _storage.write('application_messages_$applicationId', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isMessageLoading.value = false;
    }
  }

  Future<void> sendMessage(int applicationId, String message) async {
    try {
      if (message.isEmpty) return;
      await _applicationService.createApplicationMessage(applicationId, message);
      await loadMessages(applicationId); // Refresh messages
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    }
  }

  Future<void> createInterview(InterviewCreate interview) async {
    try {
      isLoading.value = true;
      await _applicationService.createInterview(interview);
      await loadInterviews();
      AppErrorHandler.showSuccessSnack('تم جدولة المقابلة بنجاح');

    } catch (e) {
      AppErrorHandler.showErrorSnack(e);

    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createApplication(JobApplicationCreate application) async {
    try {
      isLoading.value = true;
      await _applicationService.createApplication(application);
      await loadMyApplications();
      AppErrorHandler.showSuccessSnack('تم تقديم الطلب بنجاح');
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateApplication(int id, JobApplicationUpdate update) async {
    try {
      isLoading.value = true;
      await _applicationService.updateApplication(id, update);
      await loadJobApplications();
      AppErrorHandler.showSuccessSnack('تم تحديث الطلب بنجاح');
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> withdrawApplication(int id) async {
    try {
      isLoading.value = true;
      await _applicationService.withdrawApplication(id);
      await loadMyApplications();
      AppErrorHandler.showSuccessSnack('تم سحب الطلب بنجاح');

    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStatistics() async {
    try {
      final stats = await _applicationService.getApplicationStatistics();
      statistics.value = stats;
      _storage.write('application_statistics', stats.toJson());
    } catch (e) {
      print('Failed to load statistics: $e');
      AppErrorHandler.showErrorSnack(e);

    }
  }
}
