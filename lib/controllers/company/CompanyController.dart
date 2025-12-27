import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/job/JobList.dart';
import '../../data/services/company/CompanyService.dart';
import '../../data/models/company/Company.dart';
import '../../data/models/company/CompanyCreate.dart';
import '../../data/models/company/CompanyReview.dart';
import '../../data/models/company/CompanyFollower.dart';
import '../../data/models/company/companies_statistics.dart';

class CompanyController extends GetxController {
  final CompanyService _companyService = CompanyService();
  final GetStorage _storage = GetStorage();

  final RxList<Company> companies = <Company>[].obs;
  final RxList<Company> myCompanies = <Company>[].obs;

  final RxList<CompanyFollower> followedCompanies = <CompanyFollower>[].obs;
  final RxList<CompanyReview> companyReviews = <CompanyReview>[].obs;
  final RxList<JobList> companyJobs = <JobList>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isListLoading = false.obs;
  
  // Reactive Company Cache for Detail Screens
  final RxMap<int, Company> companyDetailsCache = <int, Company>{}.obs;

  // Filter Observables
  final RxString searchQuery = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedIndustry = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxBool isFeatured = false.obs;
  final RxBool isVerified = false.obs;
  
  // Pagination Observables
  final RxInt currentCompaniesPage = 1.obs;
  final RxInt totalCompaniesPages = 1.obs;
  final RxInt totalCompaniesCount = 0.obs;
  final RxInt currentMyCompaniesPage = 1.obs;
  final RxInt totalMyCompaniesPages = 1.obs;
  final RxInt totalMyCompaniesCount = 0.obs;
  static const int pageSize = 5; // Items per page
  
  // Statistics Observable
  final Rx<CompaniesStatistics?> companiesStats = Rx<CompaniesStatistics?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    loadCompanies();
    loadCompanyStatistics();
  }

  void loadCachedData() {
    try {
      final cachedCompanies = _storage.read('companies_list');
      if (cachedCompanies != null && cachedCompanies is List) {
        companies.assignAll(cachedCompanies.map((e) => Company.fromJson(e)).toList());
      }

      final cachedMyCompanies = _storage.read('my_companies_list');
      if (cachedMyCompanies != null && cachedMyCompanies is List) {
        myCompanies.assignAll(cachedMyCompanies.map((e) => Company.fromJson(e)).toList());
      }
    } catch (e) {
      print('Error loading cached company data: $e');
    }
  }

  Future<void> loadCompanies() async {
    try {
      isListLoading.value = true;
      final response = await _companyService.getCompanies(
        page: currentCompaniesPage.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
        industry: selectedIndustry.value.isNotEmpty ? selectedIndustry.value : null,
        size: selectedSize.value.isNotEmpty ? selectedSize.value : null,
        isFeatured: isFeatured.value ? true : null,
        isVerified: isVerified.value ? true : null,
      );
      if (response.results != null) {
        companies.assignAll(response.results!);
        _storage.write('companies_list', response.results!.map((e) => e.toJson()).toList());
        
        // Update cache with fresh data
        for (var company in response.results!) {
          if (company.id != null) {
            companyDetailsCache[company.id!] = company;
          }
        }
      }
      
      // Update pagination metadata
      totalCompaniesCount.value = response.count ?? 0;
      totalCompaniesPages.value = (totalCompaniesCount.value / pageSize).ceil();
      
     }
     catch (e)
     {
      // AppErrorHandler.showErrorSnack(e);
        print('Company error from  Response isss: $e');

     } finally {
       isListLoading.value = false;
     }
  }

  Future<Company?> getCompany(String slug) async {
    try {
      isLoading.value = true;

      final cachedCompany = _storage.read('company_detail_$slug');
      if (cachedCompany != null) {
      }
      
      final company = await _companyService.getCompany(slug);
      if (company != null) {
        _storage.write('company_detail_$slug', company.toJson());
        
        // Update cache
        if (company.id != null) {
          companyDetailsCache[company.id!] = company;
        }
        
        return company;
      }
      return null;
    } catch (e) {
     // AppErrorHandler.showErrorSnack(e);

      final cachedCompany = _storage.read('company_detail_$slug');
      if (cachedCompany != null) {
        return Company.fromJson(cachedCompany);
      }
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Company>> getMyCompanies({bool showLoading = true}) async {
    try {
      if (showLoading) isListLoading.value = true;

      final response = await _companyService.getMyCompanies(page: currentMyCompaniesPage.value);
      if (response.results != null) {
        myCompanies.assignAll(response.results!);
        _storage.write('my_companies_list', response.results!.map((e) => e.toJson()).toList());
      }
      
      // Update pagination metadata
      totalMyCompaniesCount.value = response.count ?? 0;
      totalMyCompaniesPages.value = (totalMyCompaniesCount.value / pageSize).ceil();
      
      print('CompanyController: Fetched ${myCompanies.length} companies');
      for( var company in myCompanies){
        print('CompanyController: Company - ${company.name}, Slug - ${company.slug}');
      }
      return response.results ?? [];

    } catch (e) {
      print('CompanyController: Error fetching companies: $e');
     // AppErrorHandler.showErrorSnack(e);
      return [];
    } finally {
      if (showLoading) isListLoading.value = false;
    }
  }


  Future<void> followCompany(int companyId) async {
    try {
      final response = await _companyService.followCompany(companyId);
      final message = response['message'];
      final isFollowing = response['isFollowing'];
      
      // Update local reactive cache manually
      if (companyDetailsCache.containsKey(companyId)) {
        final currentCompany = companyDetailsCache[companyId]!;
        
        // Calculate new follower count
        int newFollowersCount = currentCompany.followersCount ?? 0;
        if (isFollowing == true) {
           newFollowersCount = (currentCompany.followersCount ?? 0) + 1;
        } else {
           newFollowersCount = (currentCompany.followersCount ?? 0) - 1;
           if (newFollowersCount < 0) newFollowersCount = 0;
        }
        
        final updatedCompany = Company(
          id: currentCompany.id,
          name: currentCompany.name,
          slug: currentCompany.slug,
          description: currentCompany.description,
          logo: currentCompany.logo,
          coverImage: currentCompany.coverImage,
          website: currentCompany.website,
          email: currentCompany.email,
          phone: currentCompany.phone,
          size: currentCompany.size,
          address: currentCompany.address,
          city: currentCompany.city,
          country: currentCompany.country,
          industry: currentCompany.industry,
          foundedYear: currentCompany.foundedYear,
          employeesCount: currentCompany.employeesCount,
          isVerified: currentCompany.isVerified,
          isFeatured: currentCompany.isFeatured,
          totalJobs: currentCompany.totalJobs,
          activeJobs: currentCompany.activeJobs,
          isFollowing: isFollowing, // New Status
          followersCount: newFollowersCount, // New Count
          averageRating: currentCompany.averageRating,
          createdAt: currentCompany.createdAt,
        );
        
        companyDetailsCache[companyId] = updatedCompany;
        
        // update the companies list for Obx in ListScreen
        final listIndex = companies.indexWhere((c) => c.id == companyId);
        if (listIndex != -1) {
          companies[listIndex] = updatedCompany;
        }
      }
      
      AppErrorHandler.showSuccessSnack(message);
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
    }
  }

  Future<void> loadCompanyReviews(int companyId) async {
    try {
      isLoading.value = true;
      final response = await _companyService.getCompanyReviews(companyId);
      if (response.results != null) {
        companyReviews.assignAll(response.results!);
      }
    } catch (e) {
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCompanyJobs(int companyId) async {
    try {
      isLoading.value = true;
      final response = await _companyService.getCompanyJobs(companyId);
      if (response.results != null) {
        companyJobs.assignAll(response.results!);
      }
    } catch (e) {
     // AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCompanyReview(int companyId, CompanyReview review) async {
    try {
      isLoading.value = true;
      await _companyService.createCompanyReview(companyId, review);
      await loadCompanyReviews(companyId);
      AppErrorHandler.showSuccessSnack('تم تقديم المراجعة بنجاح');

      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCompany(CompanyCreate company, {File? logo, File? coverImage}) async {
    try {
      isLoading.value = true;
      await _companyService.createCompany(company, logo: logo, coverImage: coverImage);
      
      // Refresh list in background
      getMyCompanies(showLoading: false);
      
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم إنشاء الشركة بنجاح');
      
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCompany(String slug, CompanyCreate company, {File? logo, File? coverImage}) async {
    try {
      isLoading.value = true;
      await _companyService.updateCompany(slug, company, logo: logo, coverImage: coverImage);
      
      getMyCompanies(showLoading: false);
      loadCompanies();
      
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم تحديث بيانات الشركة بنجاح');

      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCompany(String slug) async {
    try {
      isLoading.value = true;
      await _companyService.deleteCompany(slug);
      getMyCompanies();
      loadCompanies();
      
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(result: true);
      AppErrorHandler.showSuccessSnack('تم حذف الشركة بنجاح');
      
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    currentCompaniesPage.value = 1; // Reset to first page when searching
    loadCompanies();
  }

  void setFilters({String? city, String? industry, String? size, bool? featured, bool? verified}) {
    if (city != null) selectedCity.value = city;
    if (industry != null) selectedIndustry.value = industry;
    if (size != null) selectedSize.value = size;
    if (featured != null) isFeatured.value = featured;
    if (verified != null) isVerified.value = verified;
    currentCompaniesPage.value = 1; // Reset to first page when filtering
    loadCompanies();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCity.value = '';
    selectedIndustry.value = '';
    selectedSize.value = '';
    isFeatured.value = false;
    isVerified.value = false;
    currentCompaniesPage.value = 1; // Reset to first page when clearing filters
    loadCompanies();
  }
  
  // Pagination Methods for Companies
  void loadCompaniesPage(int page) {
    if (page < 1 || page > totalCompaniesPages.value) return;
    currentCompaniesPage.value = page;
    loadCompanies();
  }
  
  void goToNextCompaniesPage() {
    if (currentCompaniesPage.value < totalCompaniesPages.value) {
      loadCompaniesPage(currentCompaniesPage.value + 1);
    }
  }
  
  void goToPreviousCompaniesPage() {
    if (currentCompaniesPage.value > 1) {
      loadCompaniesPage(currentCompaniesPage.value - 1);
    }
  }
  
  // Pagination Methods for My Companies
  void loadMyCompaniesPage(int page) {
    if (page < 1 || page > totalMyCompaniesPages.value) return;
    currentMyCompaniesPage.value = page;
    getMyCompanies();
  }
  
  void goToNextMyCompaniesPage() {
    if (currentMyCompaniesPage.value < totalMyCompaniesPages.value) {
      loadMyCompaniesPage(currentMyCompaniesPage.value + 1);
    }
  }
  
  void goToPreviousMyCompaniesPage() {
    if (currentMyCompaniesPage.value > 1) {
      loadMyCompaniesPage(currentMyCompaniesPage.value - 1);
    }
  }
  

  Future<void> loadCompanyStatistics() async {
    try {
      final stats = await _companyService.getCompanyStatistics();
      companiesStats.value = stats;
    } catch (e) {
      print('Error loading company statistics: $e');
    }
  }
}
