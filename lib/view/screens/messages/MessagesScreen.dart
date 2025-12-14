import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../../../core/utils/network_utils.dart';
import '../application/ApplicationDetailScreen.dart';

class MessagesScreen extends GetView<ApplicationController> {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.find<AccountController>();
    
    // Trigger load if empty
    final isEmployer = accountController.currentUser.value?.isEmployer ?? false;
    Future.microtask(() {
       if (isEmployer) {
         if (controller.jobApplications.isEmpty && !controller.isLoading.value) controller.loadJobApplications();
       } else {
         if (controller.myApplications.isEmpty && !controller.isLoading.value) controller.loadMyApplications();
       }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الرسائل', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final hasInternet = await NetworkUtils.checkInternet(context);
              if (!hasInternet) return;
               if (isEmployer) {
                 controller.loadJobApplications();
               } else {
                 controller.loadMyApplications();
               }
            }
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isListLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        final applications = isEmployer ? controller.jobApplications : controller.myApplications;

        if (applications.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد محادثات حالياً',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            if (isEmployer) {
              await controller.loadJobApplications();
            } else {
              await controller.loadMyApplications();
            }
          },
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              return Card(
                color: AppColors.accentColor,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withAlpha(100),
                    child: Icon(isEmployer ? Icons.person : Icons.business, color: AppColors.primaryColor),
                  ),
                  title: Text(
                    isEmployer ? (app.applicantName ?? 'متقدم') : (app.job?.title ?? 'وظيفة'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    isEmployer ? (app.jobTitle ?? '-') : 'اضغط لعرض المحادثة',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  onTap: () {
                    Get.to(() => ApplicationDetailScreen(application: app));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
