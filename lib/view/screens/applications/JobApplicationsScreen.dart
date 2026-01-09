import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/application/JobApplication.dart';
import '../../screens/application/EmployerApplicationDetailScreen.dart'; 
import 'package:intl/intl.dart';

class JobApplicationsScreen extends StatefulWidget {
  const JobApplicationsScreen({super.key});

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  final ApplicationController controller = Get.find<ApplicationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadJobApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('طلبات التوظيف الواردة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Stack(
        children: [
          const PatternBackground(),
          Obx(() {
            if (controller.isListLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
            }

            if (controller.jobApplications.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد طلبات توظيف واردة حالياً',
                  style: TextStyle(color: AppColors.textColor, fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadJobApplications,
              color: AppColors.primaryColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.jobApplications.length,
                itemBuilder: (context, index) {
                  final application = controller.jobApplications[index];
                  return _buildApplicationCard(application);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication application) {
    final statusColor = _getStatusColor(application.status);
        final String appliedAtStr = application.appliedAt is String
        ? application.appliedAt as String
        : application.appliedAt?.toString() ?? DateTime.now().toIso8601String();
         final DateTime date = DateTime.tryParse(appliedAtStr) ?? DateTime.now();
         final formattedDate = DateFormat('yyyy-MM-dd').format(date);
         return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
             '     ${application.applicant?.firstName ?? ''} ${application.applicant?.lastName ?? ''}   '
                  ,style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        application.job?.title ?? 'وظيفة غير معروفة',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    _getStatusText(application.status),
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'تاريخ التقديم: $formattedDate',
              style: TextStyle(color: AppColors.textColor.withAlpha(30), fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to details
                    Get.to(() => EmployerApplicationDetailScreen(application: application));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('عرض التفاصيل', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'shortlisted':
        return Colors.purple;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'withdrawn':
        return Colors.grey;
      default:
        return AppColors.primaryColor;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'reviewed':
        return 'تمت المراجعة';
      case 'shortlisted':
        return 'قائمة مختصرة';
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'withdrawn':
        return 'منسحب';
      default:
        return status ?? 'غير معروف';
    }
  }
}
