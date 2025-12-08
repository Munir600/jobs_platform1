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
      isLoading.value = true;
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
      }
     }
     catch (e)
     {
       AppErrorHandler.showErrorSnack(e);
       // print('Company error from  Response isss: $e');

     } finally {
       isLoading.value = false;
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
      await _companyService.followCompany(companyId);
      Get.snackbar('Success', 'Follow status updated');
      AppErrorHandler.showSuccessSnack('تم متابعة الشركة بنجاح');
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
