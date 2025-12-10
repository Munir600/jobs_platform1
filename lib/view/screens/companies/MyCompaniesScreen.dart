import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/company/Company.dart';
import 'CreateCompanyScreen.dart';
import 'CompanyDetailScreen.dart';

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
        if (controller.isLoading.value) {
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

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          itemCount: companies.length,
          itemBuilder: (context, index) {
            final company = companies[index];
            return _buildCompanyCard(company);
          },
        );
      }),
    );
  }

  Widget _buildCompanyCard(Company company) {
    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Get.to(() => CompanyDetailScreen(company: company)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: company.logo != null
                          ? Image.network(
                              company.logo!.startsWith('http') ? company.logo! : AppConstants.baseUrl + company.logo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.business, color: Colors.grey, size: 30);
                              },
                            )
                          : const Icon(Icons.business, color: Colors.grey, size: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name ?? 'اسم الشركة',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company.industry != null
                              ? AppEnums.industries[company.industry] ??
                              company.industry!
                              : 'قطاع غير محدد',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.to(() => CreateCompanyScreen(company: company));
                    },
                    icon: const Icon(Icons.edit,
                        size: 18, color: AppColors.primaryColor),
                    label: const Text('تعديل',
                        style: TextStyle(color: AppColors.primaryColor)),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _confirmDelete(company),
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text('حذف',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
