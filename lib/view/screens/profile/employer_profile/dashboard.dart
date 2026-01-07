import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../../../controllers/job/JobController.dart';
import '../../interview/InterviewListScreen.dart';
import 'EmployerApplicationsScreen.dart';

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ApplicationController appController = Get.put(ApplicationController());
    final JobController jobController = Get.find<JobController>();

    // Initial Data Load
    Future.microtask(() {
       jobController.loadMyJobs();
       appController.loadJobApplications();
       appController.loadInterviews();
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Center(child: Text('ادارة الطلبات والمقابلات', style: TextStyle(color: AppColors.textColor))),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textColor),
          bottom: const TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
            tabs: [
              Tab(text: 'الطلبات'),
              Tab(text: 'المقابلات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EmployerApplicationsScreen(),
            InterviewListScreen(),
          ],
        ),
      ),
    );
  }
}
