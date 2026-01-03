import 'package:get/get.dart';

class ProfileNavigationController extends GetxController {
  // Index for JobseekerProfileScreen
  final RxInt jobseekerIndex = 0.obs;
  
  // Index for CompanyProfile (Employer)
  final RxInt employerIndex = 0.obs;

  void setJobseekerIndex(int index) {
    jobseekerIndex.value = index;
  }

  void setEmployerIndex(int index) {
    employerIndex.value = index;
  }
}
