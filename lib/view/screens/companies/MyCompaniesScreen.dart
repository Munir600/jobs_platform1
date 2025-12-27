import 'package:flutter/material.dart';
import '../../widgets/companies/CompanyCard.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/company/Company.dart';
import 'CreateCompanyScreen.dart';
import 'CompanyDetailScreen.dart';
import '../../widgets/common/PaginationControls.dart';
import '../../widgets/common/StatisticsHeader.dart';

class MyCompaniesScreen extends GetView<CompanyController> {
  const MyCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyCompanies();
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('شركاتي', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const CreateCompanyScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text(
                'إضافة شركة جديدة',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.isListLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final companies = controller.myCompanies;

        if (companies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.business, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'لم تقم بإضافة أي شركات بعد',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Statistics Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StatisticsHeader(
                totalCount: controller.totalMyCompaniesCount.value,
                currentPage: controller.currentMyCompaniesPage.value,
                pageSize: CompanyController.pageSize,
                itemNameSingular: 'شركة',
                itemNamePlural: 'شركات',
              ),
            ),
            
            // Companies List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => await controller.getMyCompanies(),
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return CompanyCard(
                      company: company,
                      showControls: true,
                      onEdit: () => Get.to(() => CreateCompanyScreen(company: company)),
                      onDelete: () => _confirmDelete(company),
                    );
                  },
                ),
              ),
            ),
            
            // Pagination Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: PaginationControls(
                currentPage: controller.currentMyCompaniesPage.value,
                totalPages: controller.totalMyCompaniesPages.value,
                onPageChanged: controller.loadMyCompaniesPage,
                isLoading: controller.isListLoading.value,
              ),
            ),
          ],
        );
      }),
    );
  }

  void _confirmDelete(Company company) {
    Get.defaultDialog(
      title: 'حذف الشركة',
      middleText:
      'هل أنت متأكد من رغبتك في حذف ${company.name}؟ لا يمكن التراجع عن هذا الإجراء.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        if (company.slug != null) {
          await controller.deleteCompany(company.slug!);
        }
      },
    );
  }
}
