// lib/controllers/job_controller.dart
import 'package:get/get.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../data/models/job_models.dart';

class JobController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<JobList> jobs = <JobList>[].obs;
  final RxList<JobList> myJobs = <JobList>[].obs;
  final RxList<JobBookmark> bookmarks = <JobBookmark>[].obs;
  final RxList<JobAlert> alerts = <JobAlert>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedJobType = ''.obs;
  final RxString selectedExperience = ''.obs;

  @override
  void onReady() {
    loadJobs();
    loadMyJobs();
    loadBookmarks();
    loadAlerts();
    super.onReady();
  }

  Future<void> loadJobs() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> params = {};
      if (searchQuery.value.isNotEmpty) params['search'] = searchQuery.value;
      if (selectedCity.value.isNotEmpty) params['city'] = selectedCity.value;
      if (selectedJobType.value.isNotEmpty) params['job_type'] = selectedJobType.value;
      if (selectedExperience.value.isNotEmpty) params['experience_level'] = selectedExperience.value;

      final response = await _apiService.get(ApiEndpoints.jobs, query: params);
      jobs.assignAll((response['results'] as List)
          .map((job) => JobList.fromJson(job))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الوظائف');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyJobs() async {
    try {
      final response = await _apiService.get(ApiEndpoints.myJobs);
      myJobs.assignAll((response['results'] as List)
          .map((job) => JobList.fromJson(job))
          .toList());
    } catch (e) {
      // تجاهل الخطأ إذا لم يكن المستخدم صاحب عمل
    }
  }

  Future<void> loadBookmarks() async {
    try {
      final response = await _apiService.get('/api/jobs/bookmarks/');
      bookmarks.assignAll((response['results'] as List)
          .map((bookmark) => JobBookmark.fromJson(bookmark))
          .toList());
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  Future<void> loadAlerts() async {
    try {
      final response = await _apiService.get(ApiEndpoints.jobAlerts);
      alerts.assignAll((response['results'] as List)
          .map((alert) => JobAlert.fromJson(alert))
          .toList());
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  Future<JobDetail?> getJobDetail(String slug) async {
    try {
      return await _apiService.get('/api/jobs/$slug/');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل تفاصيل الوظيفة');
      return null;
    }
  }

  Future<bool> createJob(JobCreate job) async {
    try {
      await _apiService.post(ApiEndpoints.createJob, job.toJson());
      await loadMyJobs();
      Get.snackbar('نجاح', 'تم إنشاء الوظيفة بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> toggleBookmark(int jobId) async {
    try {
      await _apiService.post('/api/jobs/$jobId/bookmark/', {});
      await loadBookmarks();
      await loadJobs(); // لتحديث حالة isBookmarked
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ الوظيفة');
      return false;
    }
  }

  Future<bool> createAlert(JobAlert alert) async {
    try {
      await _apiService.post(ApiEndpoints.jobAlerts, alert.toJson());
      await loadAlerts();
      Get.snackbar('نجاح', 'تم إنشاء التنبيه بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    loadJobs();
  }

  void setCityFilter(String city) {
    selectedCity.value = city;
    loadJobs();
  }

  void setJobTypeFilter(String jobType) {
    selectedJobType.value = jobType;
    loadJobs();
  }

  void setExperienceFilter(String experience) {
    selectedExperience.value = experience;
    loadJobs();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCity.value = '';
    selectedJobType.value = '';
    selectedExperience.value = '';
    loadJobs();
  }
}