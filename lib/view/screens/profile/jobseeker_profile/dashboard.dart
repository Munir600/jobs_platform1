import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../applications/MyApplicationsScreen.dart';
import '../../interview/InterviewListScreen.dart';

class JobSeekerDashboard extends StatelessWidget {
  const JobSeekerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ApplicationController controller = Get.put(ApplicationController());
    
    Future.microtask(() {
       controller.loadStatistics();
       controller.loadMyApplications();
       controller.loadInterviews();
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('لوحة التحكم', style: TextStyle(color: AppColors.textColor)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textColor),
          bottom: const TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
            tabs: [
              Tab(text: 'طلباتي'),
              Tab(text: 'المقابلات'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildStatisticsSection(controller),
            const Expanded(
              child: TabBarView(
                children: [
                  MyApplicationsScreen(),
                  InterviewListScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(ApplicationController controller) {
    return Obx(() {
      final stats = controller.statistics.value;
      if (stats == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildStatCard('الكل', stats.totalApplications, Colors.blue),
            const SizedBox(width: 8),
            _buildStatCard('مقبول', stats.acceptedApplications, Colors.green),
            const SizedBox(width: 8),
            _buildStatCard('مرفوض', stats.rejectedApplications, Colors.red),
            const SizedBox(width: 8),
            _buildStatCard('قيد الانتظار', stats.pendingApplications, Colors.orange),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
