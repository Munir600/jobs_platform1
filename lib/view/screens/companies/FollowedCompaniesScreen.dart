import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../controllers/company/FollowedCompaniesController.dart';
import '../../widgets/companies/CompanyCard.dart';
import '../../widgets/common/PaginationControls.dart';
import '../../widgets/companies/PaginationControlsEmployee.dart';

class FollowedCompaniesScreen extends GetView<FollowedCompaniesController> {
  const FollowedCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
            'الشركات المتابعة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                // final hasInternet = await NetworkUtils.checkInternet(context);
                // if (!hasInternet) return;
               await controller.loadFollowedCompanies();
              }
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.followedCompanies.isEmpty) {
                return const Center(child: CircularProgressIndicator(
                    color: AppColors.primaryColor));
              }

              if (controller.hasError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        controller.hasError.value,
                        style: const TextStyle(color: AppColors.textColor,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('تحديث'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.followedCompanies.isEmpty) {
                return const Center(
                  child: Text(
                    'لا تتابع أي شركات حالياً',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshList,
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: controller.followedCompanies.length,
                  itemBuilder: (context, index) {
                    final companyFollower = controller.followedCompanies[index];
                    if (companyFollower.company == null)
                      return const SizedBox.shrink();

                    return CompanyCard(
                      company: companyFollower.company!,
                      showControls: false,
                    );
                  },
                ),
              );
            }),
          ),

          // Pagination Controls
          Obx(() =>
          controller.followedCompanies.isNotEmpty
              ? PaginationControlsEmployee(
            currentPage: controller.currentPage.value,
            totalPages: controller.totalPages.value,
            onPageChanged: controller.loadPage,
            isLoading: controller.isLoading.value,
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
