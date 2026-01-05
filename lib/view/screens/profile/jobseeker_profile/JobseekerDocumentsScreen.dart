import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/profile/DocumentController.dart';
import '../../../../data/models/accounts/profile/document/document_detail.dart';
import '../../../widgets/DocumentCard.dart';
import '../../../widgets/DocumentFormDialog.dart';

class JobseekerDocumentsScreen extends GetView<DocumentController> {
  const JobseekerDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DocumentController>()) {
      Get.put(DocumentController(), permanent: true);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // appBar: AppBar(
      //   title: const Text('إدارة الوثائق',
      //       style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
      //   backgroundColor: AppColors.accentColor,
      //   elevation: 0,
      //   centerTitle: true,
      //   iconTheme: const IconThemeData(color: AppColors.textColor),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh_rounded),
      //       onPressed: () => controller.loadDocuments(refresh: true),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          _buildStatisticsCard(),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.documents.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.documents.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadDocuments(refresh: true),
                color: AppColors.primaryColor,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: controller.documents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final document = controller.documents[index];
                    return DocumentCard(
                      document: document,
                      onEdit: () => Get.dialog(DocumentFormDialog(document: document)),
                      onDelete: () => _confirmDelete(document),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.dialog(const DocumentFormDialog()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text(
                'إضافة وثيقة',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.primaryColor.withAlpha(200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.folder_copy, color: Colors.black54, size: 24),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'إدارة الوثائق',
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'قم بإدارة وثائقك في مكان واحد',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${controller.documents.length}',
                style: const TextStyle(
                    color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_off_rounded, size: 80, color: AppColors.primaryColor.withAlpha(200)),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد وثائق مضافة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'أضف شهاداتك ووثائقك لتعزيز ملفك المهني',
              style: TextStyle(fontSize: 14, color: AppColors.textColor.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }



  void _confirmDelete(DocumentDetail document) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('حذف الوثيقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('هل أنت متأكد من رغبتك في حذف "${document.title}"؟',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('تراجع'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await controller.deleteDocument(document.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('حذف'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
