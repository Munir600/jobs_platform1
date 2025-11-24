// lib/controllers/profile_controller.dart
import 'package:get/get.dart';
import '../core/api_service.dart';
import '../data/models/user_models.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  final AuthController authController = Get.find();

  final Rx<JobSeekerProfile?> jobSeekerProfile = Rx<JobSeekerProfile?>(null);
  final Rx<EmployerProfile?> employerProfile = Rx<EmployerProfile?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onReady() {
    loadProfile();
    super.onReady();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      if (authController.isJobSeeker) {
        await loadJobSeekerProfile();
      } else if (authController.isEmployer) {
        await loadEmployerProfile();
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الملف الشخصي');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadJobSeekerProfile() async {
    try {
      final response = await _apiService.get('/api/accounts/profile/job-seeker/');
      jobSeekerProfile.value = JobSeekerProfile.fromJson(response);
    } catch (e) {
      // الملف الشخصي غير موجود بعد
    }
  }

  Future<void> loadEmployerProfile() async {
    try {
      final response = await _apiService.get('/api/accounts/profile/employer/');
      employerProfile.value = EmployerProfile.fromJson(response);
    } catch (e) {
      // الملف الشخصي غير موجود بعد
    }
  }

  Future<bool> updateJobSeekerProfile(JobSeekerProfile profile) async {
    try {
      isLoading.value = true;

      await _apiService.put(
        '/api/accounts/profile/job-seeker/',
        profile.toJson(),
      );

      jobSeekerProfile.value = profile;
      isLoading.value = false;
      Get.snackbar('نجاح', 'تم تحديث الملف الشخصي');
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> updateEmployerProfile(EmployerProfile profile) async {
    try {
      isLoading.value = true;

      await _apiService.put(
        '/api/accounts/profile/employer/',
        profile.toJson(),
      );

      employerProfile.value = profile;
      isLoading.value = false;
      Get.snackbar('نجاح', 'تم تحديث الملف الشخصي');
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> uploadResume(String filePath) async {
    try {
      isLoading.value = true;

      final response = await _apiService.uploadFile(
        '/api/accounts/profile/job-seeker/',
        filePath,
        'resume',
      );

      jobSeekerProfile.value = JobSeekerProfile.fromJson(response);
      isLoading.value = false;
      Get.snackbar('نجاح', 'تم رفع السيرة الذاتية بنجاح');
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في رفع السيرة الذاتية');
      return false;
    }
  }

  Future<bool> uploadCompanyLogo(String filePath) async {
    try {
      isLoading.value = true;

      final response = await _apiService.uploadFile(
        '/api/accounts/profile/employer/',
        filePath,
        'company_logo',
      );

      employerProfile.value = EmployerProfile.fromJson(response);
      isLoading.value = false;
      Get.snackbar('نجاح', 'تم رفع الشعار بنجاح');
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'فشل في رفع الشعار');
      return false;
    }
  }
}