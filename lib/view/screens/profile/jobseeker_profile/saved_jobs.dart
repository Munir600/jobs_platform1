import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/job/JobController.dart';
import '../../../../core/utils/network_utils.dart';
import '../../../widgets/common/PaginationControls.dart';
import '../../../widgets/jobs/JobCard.dart';

class SavedJobsScreen extends GetView<JobController> {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الوظائف المحفوظة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor:  AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                // final hasInternet = await NetworkUtils.checkInternet(context);
                // if (!hasInternet) return;
                controller.loadBookmarks();
              }
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isListLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.Savedjobs.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد وظائف محفوظة حتى الآن ',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }
              return Column(
                children: [
                  // Jobs List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.loadBookmarks();
                        // await controller.loadJobStatistics();
                      },
                      color: AppColors.primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.Savedjobs.length,
                        itemBuilder: (context, index) {
                          final job = controller.Savedjobs[index];
                          return JobCard(
                            job: job,
                            onBookmark: () => controller.bookmarkJob(job.id!),
                          );
                        },
                      ),
                    ),
                  ),

                  // Pagination Controls
                  if(controller.totalBookmarksPages.value > 1)
                    PaginationControls(
                        currentPage: controller.currentBookmarksPage.value,
                        totalPages: controller.totalBookmarksPages.value,
                        onPageChanged: controller.loadBookmarksPage,
                        isLoading: controller.isListLoading.value,
                        showNavigationButtons:false
                    ),
                ],
              );
            }),
          ),

        ],
      ),

    );
  }
}
