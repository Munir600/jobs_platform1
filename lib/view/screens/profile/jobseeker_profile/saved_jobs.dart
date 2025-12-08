import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/job/JobController.dart';
import '../../../widgets/jobs/JobCard.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final JobController controller = Get.find<JobController>();

  @override
  void initState() {
    super.initState();
    controller.loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.bookmarks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد وظائف محفوظة',
                  style: TextStyle(color: AppColors.textColor, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadBookmarks,
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = controller.bookmarks[index];
              if (bookmark.job == null) return const SizedBox.shrink();
              final job = bookmark.job!;
              return JobCard(
                job: job,
                onBookmark: () {
                  if (job.id != null) {
                    controller.bookmarkJob(job.id!);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}
