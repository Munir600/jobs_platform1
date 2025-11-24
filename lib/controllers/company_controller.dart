// lib/controllers/company_controller.dart
import 'package:get/get.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../data/models/company_models.dart';
import '../data/models/job_models.dart';

class CompanyController extends GetxController {
  final ApiService _apiService = Get.find();

  final RxList<Company> companies = <Company>[].obs;
  final RxList<Company> myCompanies = <Company>[].obs;
  final RxList<CompanyFollower> followedCompanies = <CompanyFollower>[].obs;
  final RxList<CompanyReview> companyReviews = <CompanyReview>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedIndustry = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedSize = ''.obs;

  @override
  void onReady() {
    loadCompanies();
    loadMyCompanies();
    loadFollowedCompanies();
    super.onReady();
  }

  Future<void> loadCompanies() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> params = {};
      if (searchQuery.value.isNotEmpty) params['search'] = searchQuery.value;
      if (selectedIndustry.value.isNotEmpty) params['industry'] = selectedIndustry.value;
      if (selectedCity.value.isNotEmpty) params['city'] = selectedCity.value;
      if (selectedSize.value.isNotEmpty) params['size'] = selectedSize.value;

      final response = await _apiService.get(ApiEndpoints.companies, query: params);
      companies.assignAll((response['results'] as List)
          .map((company) => Company.fromJson(company))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الشركات');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyCompanies() async {
    try {
      final response = await _apiService.get(ApiEndpoints.myCompanies);
      myCompanies.assignAll((response['results'] as List)
          .map((company) => Company.fromJson(company))
          .toList());
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  Future<void> loadFollowedCompanies() async {
    try {
      final response = await _apiService.get('/api/companies/followed/');
      followedCompanies.assignAll((response['results'] as List)
          .map((follower) => CompanyFollower.fromJson(follower))
          .toList());
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  Future<void> loadCompanyReviews(int companyId) async {
    try {
      final response = await _apiService.get('/api/companies/$companyId/reviews/');
      companyReviews.assignAll((response['results'] as List)
          .map((review) => CompanyReview.fromJson(review))
          .toList());
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل التقييمات');
    }
  }

  Future<Company?> getCompanyDetail(String slug) async {
    try {
      final response = await _apiService.get('/api/companies/$slug/');
      return Company.fromJson(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل تفاصيل الشركة');
      return null;
    }
  }

  Future<List<JobList>> getCompanyJobs(int companyId) async {
    try {
      final response = await _apiService.get('/api/companies/$companyId/jobs/');

      if (response == null) return [];

      // تحقق من نوع الاستجابة
      if (response is List) {
        return response.map((job) => JobList.fromJson(job)).toList();
      }

      if (response is Map<String, dynamic>) {
        if (response.containsKey('results')) {
          final results = response['results'];
          if (results is List) {
            return results.map((job) => JobList.fromJson(job)).toList();
          }
        }
        // إذا كان الرد مباشرة يحتوي على بيانات الوظائف
        if (response.containsKey('id')) {
          return [JobList.fromJson(response)];
        }
      }

      return [];
    } catch (e) {
      print('خطأ في تحميل وظائف الشركة: $e');
      Get.snackbar('خطأ', 'فشل في تحميل وظائف الشركة');
      return [];
    }
  }

  Future<bool> createCompany(CompanyCreate company) async {
    try {
      await _apiService.post(ApiEndpoints.createCompany, company.toJson());
      await loadMyCompanies();
      Get.snackbar('نجاح', 'تم إنشاء الشركة بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  Future<bool> toggleFollowCompany(int companyId) async {
    try {
      await _apiService.post('/api/companies/$companyId/follow/', {});
      await loadFollowedCompanies();
      await loadCompanies(); // لتحديث حالة isFollowing
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في متابعة الشركة');
      return false;
    }
  }

  Future<bool> createReview(int companyId, CompanyReview review) async {
    try {
      await _apiService.post(
          '/api/companies/$companyId/reviews/create/',
          review.toJson()
      );
      await loadCompanyReviews(companyId);
      Get.snackbar('نجاح', 'تم إضافة التقييم بنجاح');
      return true;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    loadCompanies();
  }

  void setIndustryFilter(String industry) {
    selectedIndustry.value = industry;
    loadCompanies();
  }

  void setCityFilter(String city) {
    selectedCity.value = city;
    loadCompanies();
  }

  void setSizeFilter(String size) {
    selectedSize.value = size;
    loadCompanies();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedIndustry.value = '';
    selectedCity.value = '';
    selectedSize.value = '';
    loadCompanies();
  }
}