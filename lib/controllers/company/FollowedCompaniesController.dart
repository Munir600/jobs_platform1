import 'package:get/get.dart';
import '../../data/models/company/companies_statistics.dart';
import '../../data/services/company/CompanyService.dart';
import '../../data/models/company/CompanyFollower.dart';
import '../../core/utils/error_handler.dart';

class FollowedCompaniesController extends GetxController {
  final CompanyService _companyService = CompanyService();

  final RxList<CompanyFollower> followedCompanies = <CompanyFollower>[].obs;
  final RxBool isLoading = false.obs;
  final RxString hasError = ''.obs;

  // Filter Observables
  final RxString searchQuery = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedIndustry = ''.obs;
  final RxString selectedSize = ''.obs;
  
  // Pagination Observables
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalCount = 0.obs;
  static const int pageSize = 5;
  //////////
  final RxBool isListLoading = false.obs;
  final Rx<CompaniesStatistics?> companiesStats = Rx<CompaniesStatistics?>(null);

  @override
  void onInit() {
    super.onInit();
    loadFollowedCompanies();
  }

  Future<void> loadFollowedCompanies() async {
    try {
      isLoading.value = true;
      isListLoading.value = true;
      hasError.value = '';
      
      final response = await _companyService.getFollowedCompanies(
        page: currentPage.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
        industry: selectedIndustry.value.isNotEmpty ? selectedIndustry.value : null,
        size: selectedSize.value.isNotEmpty ? selectedSize.value : null,
      );
      if (response.results != null) {
        followedCompanies.assignAll(response.results!);
      } else {
        followedCompanies.clear();
      }
      // Update pagination metadata
      totalCount.value = response.count ?? 0;
      totalPages.value = (totalCount.value / pageSize).ceil();
      if (totalPages.value == 0) totalPages.value = 1;
    } catch (e) {
      print('Error loading followed companies: $e');
    } finally {
      isLoading.value = false;
      isListLoading.value = true;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadFollowedCompanies();
  }

  void setFilters({String? city, String? industry, String? size}) {
    if (city != null) selectedCity.value = city;
    if (industry != null) selectedIndustry.value = industry;
    if (size != null) selectedSize.value = size;
    currentPage.value = 1; 
    loadFollowedCompanies();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCity.value = '';
    selectedIndustry.value = '';
    selectedSize.value = '';
    currentPage.value = 1;
    loadFollowedCompanies();
  }

  void loadPage(int page) {
    if (page < 1 || page > totalPages.value) return;
    currentPage.value = page;
    loadFollowedCompanies();
  }
  
  void goToNextPage() {
    if (currentPage.value < totalPages.value) {
      loadPage(currentPage.value + 1);
    }
  }
  
  void goToPreviousPage() {
    if (currentPage.value > 1) {
      loadPage(currentPage.value - 1);
    }
  }

  Future<void> refreshList() async {
    // Keep filters when refreshing
    await loadFollowedCompanies();
  }

  ///////////
  Future<void> loadCompanyStatistics() async {
    try {
      final stats = await _companyService.getCompanyStatistics();
      companiesStats.value = stats;
    } catch (e) {
      print('Error loading company statistics: $e');
    }
  }
  void loadCompaniesPage(int page) {
    if (page < 1 || page > totalPages.value) return;
    currentPage.value = page;
    loadFollowedCompanies();
  }
}
