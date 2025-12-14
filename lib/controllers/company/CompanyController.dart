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

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    loadCompanies();
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
     }
     catch (e)
     {
       AppErrorHandler.showErrorSnack(e);
       // print('Company error from  Response isss: $e');

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
      AppErrorHandler.showErrorSnack(e);
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
      if (showLoading) isLoading.value = true;

      final response = await _companyService.getMyCompanies();
      if (response.results != null) {
        myCompanies.assignAll(response.results!);
        _storage.write('my_companies_list', response.results!.map((e) => e.toJson()).toList());
      }
      print('CompanyController: Fetched ${myCompanies.length} companies');
      for( var company in myCompanies){
        print('CompanyController: Company - ${company.name}, Slug - ${company.slug}');
      }
      return response.results ?? [];

    } catch (e) {
      print('CompanyController: Error fetching companies: $e');
      AppErrorHandler.showErrorSnack(e);
      return [];
    } finally {
      if (showLoading) isLoading.value = false;
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
          // If we just followed, increment
          // But only if we weren't already following to avoid double count if something weird happens 
          // (though checking !currentCompany.isFollowing would be safer)
           newFollowersCount = (currentCompany.followersCount ?? 0) + 1;
        } else {
           // If we just unfollowed, decrement
           newFollowersCount = (currentCompany.followersCount ?? 0) - 1;
           if (newFollowersCount < 0) newFollowersCount = 0;
        }

        // Create new company object with updated fields
        // Since Company fields are final, we have to create a new instance via copyWith-like logic 
        // or just constructing it again. Ideally we should have copyWith.
        // I will re-construct it using existing data + new data.
        
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
        
        // Also update the companies list for Obx in ListScreen
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
      AppErrorHandler.showErrorSnack(e);
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
      AppErrorHandler.showErrorSnack(e);
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
    loadCompanies();
  }

  void setFilters({String? city, String? industry, String? size, bool? featured, bool? verified}) {
    if (city != null) selectedCity.value = city;
    if (industry != null) selectedIndustry.value = industry;
    if (size != null) selectedSize.value = size;
    if (featured != null) isFeatured.value = featured;
    if (verified != null) isVerified.value = verified;
    loadCompanies();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCity.value = '';
    selectedIndustry.value = '';
    selectedSize.value = '';
    isFeatured.value = false;
    isVerified.value = false;
    loadCompanies();
  }
}
