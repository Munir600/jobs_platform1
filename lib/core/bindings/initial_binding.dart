import 'package:get/get.dart';
import '../../controllers/account/JobSeekerProfileController.dart';
import '../../core/api_service.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/account/AccountController.dart';
import '../../controllers/application/ApplicationController.dart';
import '../../controllers/company/CompanyController.dart';
import '../../controllers/job/JobController.dart';
import '../../controllers/Interview/InterviewController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<AccountController>(() => AccountController(), fenix: true);
    Get.lazyPut<ApplicationController>(() => ApplicationController(), fenix: true);
    Get.lazyPut<CompanyController>(() => CompanyController(), fenix: true);
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
    Get.lazyPut<InterviewController>(() => InterviewController(), fenix: true);
    Get.lazyPut<JobSeekerProfileController>(() => JobSeekerProfileController());
  }
}
