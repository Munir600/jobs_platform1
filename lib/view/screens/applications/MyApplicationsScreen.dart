import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/application/JobApplication.dart';
import 'package:intl/intl.dart';
import '../application/ApplicationDetailScreen.dart';

class MyApplicationsScreen extends GetView<ApplicationController> {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.myApplications.isEmpty && !controller.isLoading.value) {
       Future.microtask(() => controller.loadMyApplications());
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value && controller.myApplications.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
            }

            if (controller.myApplications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'لم تقم بالتقديم على أي وظيفة بعد',
                      style: TextStyle(color: AppColors.textColor, fontSize: 16),
                    ),
                     const SizedBox(height: 16),
                     ElevatedButton(
                       onPressed:
                       controller.loadMyApplications,
                       child: const Text('تحديث')
                     )
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadMyApplications,
              color: AppColors.primaryColor,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.myApplications.length,
                itemBuilder: (context, index) {
                  final application = controller.myApplications[index];
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
    final date = DateTime.parse(application.appliedAt ?? DateTime.now().toString());
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Card(
      color: AppColors.accentColor,
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
                  child: Text(
                    application.job?.title ?? 'وظيفة غير معروفة',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
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
              style: TextStyle(color: AppColors.textColor.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (application.status == 'pending')
                  TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'سحب الطلب',
                        middleText: 'هل أنت متأكد من رغبتك في سحب طلب التوظيف؟',
                        textConfirm: 'نعم',
                        textCancel: 'إلغاء',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.withdrawApplication(application.id!);
                          Get.back();
                        },
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('سحب الطلب'),
                  ),
                const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => ApplicationDetailScreen(application: application));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('التفاصيل', style: TextStyle(color: Colors.white)),
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
