import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/company/job_forms_controller.dart';
import '../../../../data/models/company/job_form.dart';
import '../../../../config/app_colors.dart';
import '../../../widgets/common/PaginationControls.dart';
import 'create_job_form_screen.dart';

class JobFormsScreen extends GetView<JobFormsController> {
  const JobFormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<JobFormsController>()) {
      Get.put(JobFormsController());
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('ادارة نماذج التقديم', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               controller.fetchJobForms(page: 1);
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                controller.initForm();
                Get.to(() => const CreateJobFormScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: const Text(
                'إنشاء نموذج جديد',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.accentColor,
            child: Column(
              children: [
                TextField(
                  onChanged: controller.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'بحث عن نموذج...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('الحالة: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
                      const SizedBox(width: 8),
                      Obx(() => Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('الكل'),
                            selected: controller.isActiveFilter.value == null,
                            onSelected: (selected) {
                               if (selected) controller.setFilterStatus(null);
                            },
                            selectedColor: AppColors.primaryColor.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: controller.isActiveFilter.value == null ? AppColors.primaryColor : Colors.black
                            ),
                          ),
                          ChoiceChip(
                            label: const Text('نشط'),
                            selected: controller.isActiveFilter.value == true,
                            onSelected: (selected) {
                               if (selected) controller.setFilterStatus(true);
                            },
                            selectedColor: Colors.green.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: controller.isActiveFilter.value == true ? Colors.green : Colors.black
                            ),
                          ),
                          ChoiceChip(
                            label: const Text('غير نشط'),
                            selected: controller.isActiveFilter.value == false,
                            onSelected: (selected) {
                               if (selected) controller.setFilterStatus(false);
                            },
                            selectedColor: Colors.red.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: controller.isActiveFilter.value == false ? Colors.red : Colors.black
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.jobForms.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.jobForms.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد نماذج تقديم مطابقة',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchJobForms();
                },
                color: AppColors.primaryColor,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: controller.jobForms.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final form = controller.jobForms[index];
                    return _buildJobFormCard(context, form);
                  },
                ),
              );
            }),
          ),

          Obx(() => PaginationControls(
            currentPage: controller.currentPage.value,
            totalPages: (controller.totalCount.value / 10).ceil(),
            onPageChanged: (page) => controller.fetchJobForms(page: page),
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    );
  }

  Widget _buildJobFormCard(BuildContext context, JobForm form) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      form.name ?? 'بدون عنوان',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (form.isActive == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text('نشط', style: TextStyle(fontSize: 10, color: Colors.green)),
                      )
                    else 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Text('غير نشط', style: TextStyle(fontSize: 10, color: Colors.red)),
                      )
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: () {
                      controller.initForm(form: form);
                      Get.to(() => const CreateJobFormScreen());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, form),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (form.description != null && form.description!.isNotEmpty)
            Text(
              form.description!,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.list_alt, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${form.questionsCount ?? 0} أسئلة',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                form.createdAt?.split('T')[0] ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, JobForm form) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف النموذج'),
        content: const Text('هل أنت متأكد من رغبتك في حذف هذا النموذج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (form.id != null) {
                controller.deleteJobForm(form.id!);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
