import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/job/JobController.dart';
import '../../jobs/CreateJobScreen.dart';
import '../../jobs/JobDetailScreen.dart';

class EmployerJobManagementScreen extends GetView<JobController> {
  const EmployerJobManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () => Get.to(() => const CreateJobScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'نشر وظيفة جديدة',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

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
        return RefreshIndicator(
            onRefresh: controller.loadMyJobs,
            color: AppColors.primaryColor,
        child:  ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.myJobs.length,
          itemBuilder: (context, index) {
            final job = controller.myJobs[index];
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
        );
      }),
    );
  }
}
