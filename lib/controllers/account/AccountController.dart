import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/accounts/User.dart';
import '../../data/models/accounts/EmployerProfile.dart';
import '../../data/models/accounts/JobSeekerProfile.dart';
import '../../data/services/account/AccountService.dart';
import '../application/ApplicationController.dart';

class AccountController extends GetxController {
  final AccountService _accountService = AccountService();
  final GetStorage _storage = GetStorage();
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<EmployerProfile?> employerProfile = Rx<EmployerProfile?>(null);
  final Rx<JobSeekerProfile?> jobSeekerProfile = Rx<JobSeekerProfile?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileFromStorage();
  }

  @override
  void onReady() {
    super.onReady();
    fetchProfile();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadProfileFromStorage() {
    final userData = _storage.read('user_data');
    if (userData != null) {
      currentUser.value = User.fromJson(userData);
    }

    final employerData = _storage.read('employer_profile');
    if (employerData != null) {
      employerProfile.value = EmployerProfile.fromJson(employerData);
    }

    final jobSeekerData = _storage.read('job_seeker_profile');
    if (jobSeekerData != null) {
      jobSeekerProfile.value = JobSeekerProfile.fromJson(jobSeekerData);
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _accountService.getProfile();

      currentUser.value = response.user;
      _storage.write('user_data', response.user.toJson());

      if (currentUser.value?.isEmployer == true && response.profile != null) {
        final profile = EmployerProfile.fromJson(response.profile);
        employerProfile.value = profile;
        _storage.write('employer_profile', profile.toJson());
      } else if (currentUser.value?.isJobSeeker == true && response.profile != null) {
        final profile = JobSeekerProfile.fromJson(response.profile);
        jobSeekerProfile.value = profile;
        _storage.write('job_seeker_profile', profile.toJson());
      }

    } catch (e) {
      print('Error fetching profile: $e');
      AppErrorHandler.showErrorSnack(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateGeneralProfile(Map<String, dynamic> data, {File? profilePicture}) async {
    try {
      isLoading.value = true;
      final updatedUser = await _accountService.updateProfile(data, profilePicture: profilePicture);
      currentUser.value = updatedUser;
      _storage.write('user_data', updatedUser.toJson());
      AppErrorHandler.showSuccessSnack('تم تحديث الملف الشخصي بنجاح');
      return true;
    } catch (e) {
      print("Update Profile Error: $e");
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateEmployerProfile(Map<String, dynamic> data, {File? companyLogo}) async {
    try {
      isLoading.value = true;
      final updatedProfile = await _accountService.updateEmployerProfile(data, companyLogo: companyLogo);
      employerProfile.value = updatedProfile;
      _storage.write('employer_profile', updatedProfile.toJson());
      Get.snackbar('نجاح', 'تم تحديث بيانات الشركة بنجاح');
      return true;
    } catch (e) {
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateJobSeekerProfile(Map<String, dynamic> data, {File? resume}) async {
    try {
      isLoading.value = true;
      final updatedProfile = await _accountService.updateJobSeekerProfile(data, resume: resume);
      jobSeekerProfile.value = updatedProfile;
      _storage.write('job_seeker_profile', updatedProfile.toJson());
      if (Get.isRegistered<ApplicationController>()) {
        final appController = Get.find<ApplicationController>();
        appController.loadMyApplications();
      }
      
      AppErrorHandler.showSuccessSnack('تم تحديث الملف الشخصي بنجاح');
      return true;
    } catch (e) {
      print("the profile update data: $e");
      AppErrorHandler.showErrorSnack(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
