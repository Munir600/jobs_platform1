import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/utils/network_utils.dart';
import '../../core/utils/error_handler.dart';
import '../../core/constants.dart';
import '../../data/models/accounts/JobSeekerProfile.dart';
import '../ResumeController.dart';
import 'AccountController.dart';

class JobSeekerProfileController extends GetxController {
  final AccountController _accountController = Get.find<AccountController>();
  final ResumeController _resumeController = Get.put(ResumeController(), permanent: true);

  // Form Controllers
  late TextEditingController skillsCtrl;
  late TextEditingController expectedSalaryMinCtrl;
  late TextEditingController expectedSalaryMaxCtrl;
  late TextEditingController languagesCtrl;

  // Observables for Dropdowns and Switches
  final Rx<String?> selectedExperienceLevel = Rx<String?>(null);
  final Rx<String?> selectedEducationLevel = Rx<String?>(null);
  final Rx<String?> selectedJobType = Rx<String?>(null);
  final RxBool isAvailable = true.obs;

  // Resume Observables
  final Rx<File?> resumeFile = Rx<File?>(null);
  final Rx<String?> resumeName = Rx<String?>(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<JobSeekerProfile?> get jobSeekerProfile => _accountController.jobSeekerProfile;
  RxBool get isLoading => _accountController.isLoading;

  @override
  void onInit() {
    super.onInit();
    _initializeFields();
  }

  void _initializeFields() {
    final profile = jobSeekerProfile.value;
    skillsCtrl = TextEditingController(text: profile?.skills ?? '');
    expectedSalaryMinCtrl = TextEditingController(text: profile?.expectedSalaryMin?.toString() ?? '');
    expectedSalaryMaxCtrl = TextEditingController(text: profile?.expectedSalaryMax?.toString() ?? '');
    languagesCtrl = TextEditingController(text: profile?.languages ?? '');

    isAvailable.value = profile?.availability ?? true;
    _setInitialEnumValues(profile);
  }

  void _setInitialEnumValues(JobSeekerProfile? profile) {
    if (profile == null) return;
    var exp = profile.experienceLevel;
    if (exp != null && !AppEnums.experienceLevels.containsKey(exp)) {
       exp = AppEnums.experienceLevels.entries
          .firstWhere((e) => e.value == exp, orElse: () => const MapEntry('', ''))
          .key;
       if (exp.isEmpty) exp = null;
    }
    selectedExperienceLevel.value = exp;
    var edu = profile.educationLevel;
    if (edu != null && !AppEnums.educationLevels.containsKey(edu)) {
       edu = AppEnums.educationLevels.entries
          .firstWhere((e) => e.value == edu, orElse: () => const MapEntry('', ''))
          .key;
       if (edu.isEmpty) edu = null;
    }
    selectedEducationLevel.value = edu;

    var jobType = profile.preferredJobType;
    if (jobType != null && !AppEnums.jobTypes.containsKey(jobType)) {
       jobType = AppEnums.jobTypes.entries
          .firstWhere((e) => e.value == jobType, orElse: () => const MapEntry('', ''))
          .key;
       if (jobType.isEmpty) jobType = null;
    }
    selectedJobType.value = jobType;
  }

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      resumeFile.value = File(result.files.single.path!);
      resumeName.value = result.files.single.name;
    }
  }

  void viewResume() {
    if (resumeFile.value != null) {
      _resumeController.openResume(resumeFile.value);
    } else if (jobSeekerProfile.value?.resume != null) {
      _resumeController.openResume(jobSeekerProfile.value!.resume);
    }
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final data = {
        'skills': skillsCtrl.text,
        'expected_salary_min': int.tryParse(expectedSalaryMinCtrl.text),
        'expected_salary_max': int.tryParse(expectedSalaryMaxCtrl.text),
        'languages': languagesCtrl.text,
        'experience_level': selectedExperienceLevel.value,
        'education_level': selectedEducationLevel.value,
        'preferred_job_type': selectedJobType.value,
        'availability': isAvailable.value,
      };

      final success = await _accountController.updateJobSeekerProfile(data, resume: resumeFile.value);
      if (success) {
        Get.back();
        AppErrorHandler.showSuccessSnack('تم تحديث الملف الشخصي بنجاح');
      }
    }
  }

  @override
  void onClose() {
    skillsCtrl.dispose();
    expectedSalaryMinCtrl.dispose();
    expectedSalaryMaxCtrl.dispose();
    languagesCtrl.dispose();
    super.onClose();
  }
}

