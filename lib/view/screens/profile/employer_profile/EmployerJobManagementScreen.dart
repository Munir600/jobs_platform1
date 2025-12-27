import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/job/JobController.dart';
import '../../../../controllers/company/CompanyController.dart';
import '../../../../core/constants.dart';
import '../../jobs/CreateJobScreen.dart';
import '../../jobs/JobDetailScreen.dart';
import '../../../widgets/common/PaginationControls.dart';
import '../../../widgets/common/StatisticsHeader.dart';

class EmployerJobManagementScreen extends GetView<JobController> {
  const EmployerJobManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('إدارة الوظائف', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const CreateJobScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text(
                'نشر وظيفة جديدة',
                style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )

      ,
        body: Obx(() {
        if (controller.isListLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        final displayJobs = controller.filteredMyJobs;
        
        if (controller.myJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('لم تقم بنشر أي وظائف بعد', style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => controller.loadMyJobs(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث'),
                ),
              ],
            ),
          );
        }
        
        if (displayJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('لا توجد وظائف لهذه الشركة', style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => controller.clearCompanyFilter(),
                  icon: const Icon(Icons.clear),
                  label: const Text('مسح الفلتر'),
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
                totalCount: controller.totalMyJobsCount.value,
                currentPage: controller.currentMyJobsPage.value,
                pageSize: JobController.pageSize,
                itemNameSingular: 'وظيفة',
                itemNamePlural: 'وظائف',
              ),
            ),
            
            // Jobs List
            Expanded(
              child: RefreshIndicator(
                  onRefresh: controller.loadMyJobs,
                  color: AppColors.primaryColor,
              child:  ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: displayJobs.length,
                itemBuilder: (context, index) {
                  final job = displayJobs[index];
                  return Card(
                    color: AppColors.accentColor,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                    child: InkWell(
                      onTap: () {
                        Get.to(() => JobDetailScreen(jobSlug: job.slug!, isEmployer: true));
                      },
                      child:
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    job.title ?? 'بدون عنوان',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: job.isActive == true ? Colors.green[100] : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    job.isActive == true ? 'نشط' : 'غير نشط',
                                    style: TextStyle(
                                      color: job.isActive == true ? Colors.green[800] : Colors.red[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('الشركة : ${job.company?.name ?? 'غير معروفة'}'),
                            Text('تاريخ النشر: ${job.createdAt?.split('T')[0] ?? '-'}'),
                            Text('عدد المتقدمين: ${job.applicationsCount ?? 0}'),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                   // Get.to(() => (job: job));
                                  },
                                  icon: const Icon(Icons.lock_open, color: Colors.green),
                                  label: const Text('الحالة', style: TextStyle(color: Colors.black)),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Get.to(() => CreateJobScreen(job: job));
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  label: const Text('تعديل', style: TextStyle(color: Colors.blue)),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'حذف الوظيفة',
                                      middleText: 'هل أنت متأكد من رغبتك في حذف هذه الوظيفة؟',
                                      textConfirm: 'حذف',
                                      textCancel: 'إلغاء',
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () {
                                        if (job.slug != null) {
                                          controller.deleteJob(job.slug!);
                                          Get.back();
                                        }
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  label: const Text('حذف', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              ),
            ),
            
            // Pagination Controls
            PaginationControls(
              currentPage: controller.currentMyJobsPage.value,
              totalPages: controller.totalMyJobsPages.value,
              onPageChanged: controller.loadMyJobsPage,
              isLoading: controller.isListLoading.value,
            ),
          ],
        );
      }),
    );
  }
  void _showFilterBottomSheet(BuildContext context) {
    final companyController = Get.find<CompanyController>();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Obx(() {
            final companies = companyController.myCompanies;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تصفية الوظائف حسب الشركة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const SizedBox(height: 16),
                if (companies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'لا توجد شركات متاحة',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  DropdownButtonFormField<int>(
                    value: controller.selectedCompanyId.value,
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('جميع الشركات'),
                      ),
                      ...companies.map((company) {
                        return DropdownMenuItem<int>(
                          value: company.id,
                          child: Text(company.name ?? 'شركة غير معروفة'),
                        );
                      }).toList(),
                    ],
                    onChanged: (val) {
                      controller.setCompanyFilter(val);
                    },
                    decoration: InputDecoration(
                      labelText: 'اختر الشركة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.clearCompanyFilter();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: AppColors.textColor,
                    ),
                    child: const Text('مسح التصفيات'),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
