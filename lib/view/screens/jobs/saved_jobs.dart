import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/job/JobController.dart';
import '../../../config/app_colors.dart';
import 'JobDetailScreen.dart';

class SavedJobsScreen extends GetView<JobController> {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.bookmarks.isEmpty && !controller.isListLoading.value) {
       Future.microtask(() => controller.loadBookmarks());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الوظائف المحفوظة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        if (controller.isListLoading.value && controller.bookmarks.isEmpty) {
           return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.bookmarks.isEmpty) {
          return const Center(child: Text('لا توجد وظائف محفوظة'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadBookmarks,
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = controller.bookmarks[index];
              final job = bookmark.job;
              if (job == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(job.title ?? 'بدون عنوان', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(job.company?.name ?? '-'),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: AppColors.primaryColor),
                    onPressed: () {
                      if (job.id != null) controller.bookmarkJob(job.id!);
                    },
                  ),
                  onTap: () => Get.to(() => JobDetailScreen(jobSlug: job.slug)),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
