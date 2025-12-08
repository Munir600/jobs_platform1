import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../application/ApplicationDetailScreen.dart';

class JobApplicationsScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;

  const JobApplicationsScreen({super.key, required this.jobId, required this.jobTitle});

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  final ApplicationController controller = Get.find<ApplicationController>();

  @override
  void initState() {
    super.initState();
    controller.loadJobApplications(jobId: widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المتقدمين لـ ${widget.jobTitle}'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.jobApplications.isEmpty) {
          return const Center(child: Text('لا يوجد متقدمين حتى الآن'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jobApplications.length,
          itemBuilder: (context, index) {
            final app = controller.jobApplications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(app.applicantName ?? 'متقدم غير معروف'),
                subtitle: Text('تاريخ التقديم: ${app.appliedAt?.split('T')[0] ?? '-'}'),
                trailing: _buildStatusBadge(app.status ?? 'pending'),
                onTap: () {
                  Get.to(() => ApplicationDetailScreen(application: app));
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'accepted':
        color = Colors.green;
        text = 'مقبول';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'مرفوض';
        break;
      case 'viewed':
        color = Colors.blue;
        text = 'تمت المشاهدة';
        break;
      default:
        color = Colors.orange;
        text = 'قيد الانتظار';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
