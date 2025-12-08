import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/job/JobController.dart';
import '../../config/app_colors.dart';
import 'jobs/JobDetailScreen.dart';

class HomeScreen extends GetView<JobController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الرئيسية'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
           padding: const EdgeInsets.all(16),
           itemCount: controller.jobs.length,
           itemBuilder: (context, index) {
             final job = controller.jobs[index];
             return Card(
               child: ListTile(
                 title: Text(job.title),
                 subtitle: Text(job.company?.name ?? ''),
                 onTap: () => Get.to(() => JobDetailScreen(jobSlug: job.slug)),
               ),
             );
           },
        );
      }),
    );
  }
}
