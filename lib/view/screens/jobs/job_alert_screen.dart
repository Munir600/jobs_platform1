import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/job/JobController.dart';
import '../../../config/app_colors.dart';

class AlertJobsScreen extends GetView<JobController> {
  const AlertJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.alerts.isEmpty && !controller.isLoading.value) {
       Future.microtask(() => controller.loadAlerts());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تنبيهات الوظائف', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.alerts.isEmpty) {
           return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.alerts.isEmpty) {
          return const Center(child: Text('لا توجد تنبيهات'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadAlerts,
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.alerts.length,
            itemBuilder: (context, index) {
              final alert = controller.alerts[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${alert.keywords ?? ''} ${alert.city ?? ''}'),
                  trailing: Icon(
                    alert.isActive == true ? Icons.notifications_active : Icons.notifications_off,
                    color: alert.isActive == true ? Colors.green : Colors.grey,
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar('قريباً', 'سيتم إضافة صفحة إنشاء التنبيهات قريباً');
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
