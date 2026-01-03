import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/job/jobs_statistics.dart';
import '../../data/services/job/JobService.dart';
import '../../data/models/job/JobDetail.dart';
import '../../data/models/job/JobCreate.dart';
import '../../data/models/job/JobAlert.dart';
import '../../data/models/job/JobList.dart';
import '../../data/models/job/JobCategory.dart';
import '../../data/models/job/JobBookmark.dart';

class JobController extends GetxController {
  final JobService _jobService = JobService();
  final GetStorage _storage = GetStorage();

  final RxList<JobList> jobs = <JobList>[].obs;
  final RxList<JobList> myJobs = <JobList>[].obs;
  final RxList<JobList> Savedjobs = <JobList>[].obs;
  final RxList<JobCategory> categories = <JobCategory>[].obs;
  final RxList<JobAlert> alerts = <JobAlert>[].obs;
  final RxList<JobBookmark> bookmarks = <JobBookmark>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isListLoading = false.obs;
  final Rx<JobDetail?> currentJob = Rx<JobDetail?>(null);
  final RxBool isJobDetailLoading = false.obs;
  
  // Filtered jobs by company
  List<JobList> get filteredMyJobs {
    if (selectedCompanyId.value == null) {
      return myJobs;
    }
    return myJobs.where((job) => job.company?.id == selectedCompanyId.value).toList();
  }
  
  void clearCurrentJob() {
    currentJob.value = null;
  }

  // Filter Observables
  final RxString searchQuery = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedJobType = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;
  final RxString selectedEducationLevel = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isRemote = false.obs;
  final RxBool isUrgent = false.obs;
  final RxnInt selectedCompanyId = RxnInt();
  
  // Pagination Observables
  final RxInt currentJobsPage = 1.obs;
  final RxInt totalJobsPages = 1.obs;
  final RxInt totalJobsCount = 0.obs;
  final RxInt currentMyJobsPage = 1.obs;
  final RxInt totalMyJobsPages = 1.obs;
  final RxInt totalMyJobsCount = 0.obs;
  
  final RxInt currentBookmarksPage = 1.obs;
  final RxInt totalBookmarksPages = 1.obs;
  final RxInt totalBookmarksCount = 0.obs;

  static const int pageSize = 5;
  
  // Statistics Observable
  final Rx<JobsStatistics?> jobsStats = Rx<JobsStatistics?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    // loadJobs();
    loadCategories();
    loadJobStatistics();
  }

  @override
  void onReady() {
    super.onReady();
    loadJobs();
    loadMyJobs();
  }

  @override
  void onClose() {
    searchQuery.close();
    selectedCity.close();
    selectedJobType.close();
    selectedExperienceLevel.close();
    selectedEducationLevel.close();
    selectedCategory.close();
    isRemote.close();
    isUrgent.close();
    selectedCompanyId.close();
    currentJobsPage.close();
    totalJobsPages.close();
    totalJobsCount.close();
    currentMyJobsPage.close();
    totalMyJobsPages.close();
    totalMyJobsCount.close();
    currentBookmarksPage.close();
    totalBookmarksPages.close();
    totalBookmarksCount.close();
    super.onClose();
  }

  void loadCachedData() {
    try {
      // Load Jobs
      final cachedJobs = _storage.read('jobs_list');
      if (cachedJobs != null && cachedJobs is List) {
        jobs.assignAll(cachedJobs.map((e) => JobList.fromJson(e)).toList());
      }

      // Load My Jobs
      final cachedMyJobs = _storage.read('my_jobs_list');
      if (cachedMyJobs != null && cachedMyJobs is List) {
        myJobs.assignAll(cachedMyJobs.map((e) => JobList.fromJson(e)).toList());
      }
      
      // Load Categories
      final cachedCategories = _storage.read('job_categories');
      if (cachedCategories != null && cachedCategories is List) {
        categories.assignAll(cachedCategories.map((e) => JobCategory.fromJson(e)).toList());
      }
    } catch (e) {
      print('Error loading cached job data: $e');
    }
  }

  Future<void> loadJobs() async {
     try {
      isListLoading.value = true;
      final response = await _jobService.getJobs(
        page: currentJobsPage.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
        jobType: selectedJobType.value.isNotEmpty ? selectedJobType.value : null,
        experienceLevel: selectedExperienceLevel.value.isNotEmpty ? selectedExperienceLevel.value : null,
        educationLevel: selectedEducationLevel.value.isNotEmpty ? selectedEducationLevel.value : null,
        category: selectedCategory.value.isNotEmpty ? selectedCategory.value : null,
        isRemote: isRemote.value ? true : null,
        isUrgent: isUrgent.value ? true : null,
      );
      if (response.results != null) {
        jobs.assignAll(response.results!);
        _storage.write('jobs_list', response.results!.map((e) => e.toJson()).toList());
      }
      
      // Update pagination metadata
      totalJobsCount.value = response.count ?? 0;
      totalJobsPages.value = (totalJobsCount.value / pageSize).ceil();

    } catch (e) {
       print('Error loading jobs: $e');
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> loadMyJobs() async {
    try {
      isListLoading.value = true;
      final response = await _jobService.getMyJobs(page: currentMyJobsPage.value);
      if (response.results != null) {
        myJobs.assignAll(response.results!);
        _storage.write('my_jobs_list', response.results!.map((e) => e.toJson()).toList());
      }

      totalMyJobsCount.value = response.count ?? 0;
    //totalMyJobsPages.value = (totalMyJobsCount.value /pageSize).ceil();
      print('the totalMyJobsCount is ${totalMyJobsCount.value}');
      print('the totalMyJobsPages is ${totalMyJobsPages.value}');
    } catch (e) {
      print('error in loadMyJobs is : $e');
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
    }
  }

  Future<JobDetail?> getJob(String slug, {bool showLoading = true}) async {
   try {
      if (showLoading) isLoading.value = true;

      final job = await _jobService.getJob(slug);
      return job;
    } catch (e) {
    // AppErrorHandler.showErrorSnack(e);
      return null;
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadJobDetail(String slug) async {
    try {
      isJobDetailLoading.value = true;
      currentJob.value = null;
      
       final cachedJob = _storage.read('job_detail_$slug');
       if (cachedJob != null) {
         currentJob.value = JobDetail.fromJson(cachedJob);
       }

      final job = await _jobService.getJob(slug);
      if (job != null) {
        currentJob.value = job;
        _storage.write('job_detail_$slug', job.toJson());
      }
    } catch (e) {
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isJobDetailLoading.value = false;
    }
  }

  Future<bool> createJob(JobCreate job) async {
    try {
      isLoading.value = true;
      await _jobService.createJob(job);
      loadMyJobs();
      loadJobs();
      
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم إنشاء الوظيفة بنجاح');

      return true;
    } catch (e) {
      print('Error creating job: $e');
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateJob(String slug, JobCreate job) async {
    try {
      isLoading.value = true;
      await _jobService.updateJob(slug, job);
      loadMyJobs();
      loadJobs();
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم تحديث الوظيفة بنجاح');
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteJob(String slug) async {
    try {
      isLoading.value = true;
      await _jobService.deleteJob(slug);
      loadMyJobs();
      loadJobs();
      
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم حذف الوظيفة بنجاح');
      
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await _jobService.getJobCategories();
      if (response.isNotEmpty) {
        categories.assignAll(response);
        _storage.write('job_categories', response.map((e) => e.toJson()).toList());
      }
      print('the response for load Categories is : ${response.length} categories loaded');
    } catch (e) {
      print('the error for loadCategories is $e');
     // AppErrorHandler.showErrorSnack(e);
    }
  }

  Future<void> loadAlerts() async {
    try {
      isListLoading.value = true;
      final response = await _jobService.getJobAlerts();
      if (response.results != null) {
        alerts.assignAll(response.results!);
      }
    } catch (e) {
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
    }
  }

  Future<bool> createAlert(JobAlert alert) async {
    try {
      await _jobService.createJobAlert(alert);
      await loadAlerts();
      AppErrorHandler.showSuccessSnack('تم إنشاء التنبيه بنجاح');
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }

  Future<void> loadBookmarks({int? page}) async {
    try {
      isListLoading.value = true;
      final response = await _jobService.getJobBookmarks(page: page ?? currentBookmarksPage.value);
      if (response.results != null) {
        bookmarks.assignAll(response.results!);
        Savedjobs.assignAll(
          response.results!
              .map((e) => e.job)
              .whereType<JobList>()
              .toList(),
        );
      }
      print('the jobs bookmarks after assign is ${bookmarks.length}');
      print('the Savedjobs count is : ${Savedjobs.length}');
      // Update pagination metadata
      totalBookmarksCount.value = response.count ?? 0;
      totalBookmarksPages.value = (totalBookmarksCount.value / pageSize).ceil();
      if (page != null) {
        currentBookmarksPage.value = page;
      }
      print('the response.count is : ${response.count}');
      print('the response.results in controller is : ${response.results![0].job}');
    } catch (e) {
      print('the error loadBookMarks is : $e');
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isListLoading.value = false;
    }
  }

  void loadBookmarksPage(int page) {
    if (page < 1 || page > totalBookmarksPages.value) return;
    currentBookmarksPage.value = page;
    loadBookmarks(page: page);
  }

  Future<void> bookmarkJob(int jobId) async {
    try {
      final isCurrentlyBookmarked = bookmarks.any((b) => b.job?.id == jobId);
      await _jobService.bookmarkJob(jobId);
      await loadBookmarks();
      
      // Show appropriate message based on PREVIOUS state
      if (isCurrentlyBookmarked) {
        AppErrorHandler.showSuccessSnack('تم إلغاء حفظ الوظيفة');
      } else {
        AppErrorHandler.showSuccessSnack('تم حفظ الوظيفة بنجاح');
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    currentJobsPage.value = 1; // Reset to first page when searching
    loadJobs();
  }

  void setFilters({
    String? city,
    String? jobType,
    String? experienceLevel,
    String? educationLevel,
    String? category,
    bool? remote,
    bool? urgent,
  }) {
    if (city != null) selectedCity.value = city;
    if (jobType != null) selectedJobType.value = jobType;
    if (experienceLevel != null) selectedExperienceLevel.value = experienceLevel;
    if (educationLevel != null) selectedEducationLevel.value = educationLevel;
    if (category != null) selectedCategory.value = category;
    if (remote != null) isRemote.value = remote;
    if (urgent != null) isUrgent.value = urgent;
    currentJobsPage.value = 1; // Reset to first page when filtering
    loadJobs();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCity.value = '';
    selectedJobType.value = '';
    selectedExperienceLevel.value = '';
    selectedEducationLevel.value = '';
    selectedCategory.value = '';
    isRemote.value = false;
    isUrgent.value = false;
    currentJobsPage.value = 1;
    loadJobs();
  }
  
  void setCompanyFilter(int? companyId) {
    selectedCompanyId.value = companyId;
  }
  
  void clearCompanyFilter() {
    selectedCompanyId.value = null;
  }
  
  // Pagination Methods for Jobs
  void loadJobsPage(int page) {
    if (page < 1 || page > totalJobsPages.value) return;
    currentJobsPage.value = page;
    loadJobs();
  }
  
  void goToNextJobsPage() {
    if (currentJobsPage.value < totalJobsPages.value) {
      loadJobsPage(currentJobsPage.value + 1);
    }
  }
  
  void goToPreviousJobsPage() {
    if (currentJobsPage.value > 1) {
      loadJobsPage(currentJobsPage.value - 1);
    }
  }
  
  // Pagination Methods for My Jobs
  void loadMyJobsPage(int page) {
    if (page < 1 || page > totalMyJobsPages.value) return;
    currentMyJobsPage.value = page;
    loadMyJobs();
  }
  
  void goToNextMyJobsPage() {
    if (currentMyJobsPage.value < totalMyJobsPages.value) {
      loadMyJobsPage(currentMyJobsPage.value + 1);
    }
  }
  
  void goToPreviousMyJobsPage() {
    if (currentMyJobsPage.value > 1) {
      loadMyJobsPage(currentMyJobsPage.value - 1);
    }
  }
  
  // Load Job Statistics
  Future<void> loadJobStatistics() async {
    try {
      final stats = await _jobService.getJobStatistics();
      jobsStats.value = stats;
    } catch (e) {
      print('Error loading job statistics: $e');
      // Don't show error to user, just log it
    }
  }
}
