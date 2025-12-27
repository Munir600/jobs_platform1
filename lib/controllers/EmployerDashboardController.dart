import 'package:get/get.dart';
import '../data/models/accounts/profile/employer/employer_dashboard.dart';
import '../data/services/company/CompanyService.dart';
import '../core/utils/error_handler.dart';

class EmployerDashboardController extends GetxController {
  final CompanyService _companyService = CompanyService();
  
  // Observables
  var isLoading = false.obs;
  var dashboardStats = Rxn<EmployerDashboard>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final stats = await _companyService.getEmployerDashboardStats();
      dashboardStats.value = stats;
    } catch (e) {
      errorMessage.value = AppErrorHandler.getMessage(e);
      print('Error fetching dashboard stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStats() async {
    await fetchDashboardStats();
  }
}
