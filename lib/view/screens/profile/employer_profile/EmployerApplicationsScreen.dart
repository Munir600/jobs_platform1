import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../application/ApplicationDetailScreen.dart';

class EmployerApplicationsScreen extends GetView<ApplicationController> {
  const EmployerApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
      }

      if (controller.jobApplications.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_ind, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('لا توجد طلبات توظيف حتى الآن', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.jobApplications.length,
        itemBuilder: (context, index) {
          final application = controller.jobApplications[index];
          return Card(
            color: AppColors.accentColor,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Text(
                  application.applicantName?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                application.applicantName ?? 'متقدم غير معروف',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('الوظيفة: ${application.jobTitle ?? '-'}'),
                  const SizedBox(height: 4),
                  Text(
                    'تاريخ التقديم: ${application.appliedAt?.split('T')[0] ?? '-'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  application.statusDisplay ?? application.status ?? '-',
                  style: TextStyle(
                    color: _getStatusColor(application.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Get.to(() => ApplicationDetailScreen(application: application));
              },
            ),
          );
        },
      );
    });
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'interview':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
