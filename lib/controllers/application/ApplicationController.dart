import 'package:flutter/material.dart';
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

  // Scroll Controller for Employer Job Applications
  final ScrollController jobApplicationsScrollController = ScrollController();

  Rx<User?> get currentUser => _accountController.currentUser;
  final RxList<JobApplication> myApplications = <JobApplication>[].obs;
  final RxList<JobApplication> jobApplications = <JobApplication>[].obs;
  final RxList<Interview> interviews = <Interview>[].obs;
  final RxList<ApplicationMessage> messages = <ApplicationMessage>[].obs;
  final Rx<ApplicationStatistics?> statistics = Rx<ApplicationStatistics?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isListLoading = false.obs;
  final RxBool isMessageLoading = false.obs;

  // Pagination for My Applications (Job Seeker)
  final RxInt myApplicationsPage = 1.obs;
  final RxBool hasMoreMyApplications = false.obs;
  final RxBool isLoadingMoreMyApplications = false.obs;

  // Pagination for Job Applications (Employer)
  final RxInt jobApplicationsPage = 1.obs;
  final RxBool hasMoreJobApplications = false.obs;
  final RxBool isLoadingMoreJobApplications = false.obs;

  @override
  void onInit() {
    super.onInit();
    //loadCachedData();
    loadMyApplications();

    // Setup scroll listener for employer applications
    jobApplicationsScrollController.addListener(_onJobApplicationsScroll);
  }

  void _onJobApplicationsScroll() {
    if (jobApplicationsScrollController.position.pixels >=
        jobApplicationsScrollController.position.maxScrollExtent - 200) {
      if (hasMoreJobApplications.value && !isLoadingMoreJobApplications.value) {
        loadMoreJobApplications();
      }
    }
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
    jobApplicationsScrollController.dispose();
    super.onClose();
  }

  Future<void> loadMyApplications() async {
    try {
      isListLoading.value = true;
      myApplicationsPage.value = 1;

      final response = await _applicationService.getMyApplications(page: 1);
      if (response.results != null) {
        myApplications.assignAll(response.results!);
        hasMoreMyApplications.value = response.next != null;
        _storage.write('my_applications', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      // AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> loadMoreMyApplications() async {
    if (!hasMoreMyApplications.value || isLoadingMoreMyApplications.value) return;

    try {
      isLoadingMoreMyApplications.value = true;
      final nextPage = myApplicationsPage.value + 1;

      final response = await _applicationService.getMyApplications(page: nextPage);
      if (response.results != null && response.results!.isNotEmpty) {
        myApplications.addAll(response.results!);
        myApplicationsPage.value = nextPage;
        hasMoreMyApplications.value = response.next != null;
      } else {
        hasMoreMyApplications.value = false;
      }
    } catch (e) {
      print('Error loading more my applications: $e');
    } finally {
      isLoadingMoreMyApplications.value = false;
    }
  }

  Future<void> loadJobApplications({int? jobId}) async {
    try {
      isListLoading.value = true;
      jobApplicationsPage.value = 1; // Reset to page 1

      final response = await _applicationService.getJobApplications(page: 1, jobId: jobId);
      if (response.results != null) {
        jobApplications.assignAll(response.results!);
        hasMoreJobApplications.value = response.next != null;

        // Extract and update statistics from response
        if (response.statusCounts != null) {
          statistics.value = ApplicationStatistics.fromModelStatusCounts(
              response.statusCounts,
              response.count ?? response.results!.length
          );
        }

        final cacheKey = jobId != null ? 'job_applications_$jobId' : 'job_applications';
        _storage.write(cacheKey, response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      print('Error loading job applications: $e');
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> loadMoreJobApplications({int? jobId}) async {
    if (!hasMoreJobApplications.value || isLoadingMoreJobApplications.value) return;

    try {
      isLoadingMoreJobApplications.value = true;
      final nextPage = jobApplicationsPage.value + 1;

      final response = await _applicationService.getJobApplications(page: nextPage, jobId: jobId);
      if (response.results != null && response.results!.isNotEmpty) {
        jobApplications.addAll(response.results!);
        jobApplicationsPage.value = nextPage;
        hasMoreJobApplications.value = response.next != null;
      } else {
        hasMoreJobApplications.value = false;
      }
    } catch (e) {
      print('Error loading more job applications: $e');
    } finally {
      isLoadingMoreJobApplications.value = false;
    }
  }

  Future<void> loadInterviews() async {
    try {
      isListLoading.value = true;
      final response = await _applicationService.getInterviews();
      if (response.results != null) {
        interviews.assignAll(response.results!);
        _storage.write('my_interviews', response.results!.map((e) => e.toJson()).toList());
      }
    } catch (e) {
      // AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> updateApplicationStatus(int? id, String status,
      {String? notes, int? rating}) async {
    try {
      isLoading.value = true;
      final updateData = JobApplicationUpdate(
        status: status,
        employerNotes: notes,
        rating: rating,
      );

      await _applicationService.updateApplication(id!, updateData);

      final index = jobApplications.indexWhere((app) => app.id == id);
      if (index != -1) {
        await loadJobApplications();
      }
      Get.back();
      AppErrorHandler.showSuccessSnack('تم تحديث حالة الطلب بنجاح إلى $status');

    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      print('Error updating application status is : $e');
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
      //  AppErrorHandler.showErrorSnack(e);
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
      // AppErrorHandler.showErrorSnack(e);
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
      await loadMyApplications();
      //AppErrorHandler.showSuccessSnack('تم تحديث الطلب بنجاح');
      return true;
    } catch (e) {
      print('Error updating application: $e');
      // AppErrorHandler.showErrorSnack(e);
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
      print('خطاء في سسحب الطلب $e');
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
      // AppErrorHandler.showErrorSnack(e);

    }
  }
}
