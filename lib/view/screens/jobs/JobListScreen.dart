import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/job/JobController.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/job/JobList.dart';
import 'JobDetailScreen.dart';
import '../../widgets/jobs/JobCard.dart';
import '../../widgets/common/PaginationControls.dart';
import '../../widgets/common/StatisticsHeader.dart';
import '../../widgets/common/CompactStatisticsBar.dart';
import '../../widgets/common/DetailedStatisticsSheet.dart';
import '../../../data/models/job/jobs_statistics.dart';

class JobListScreen extends GetView<JobController> {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الوظائف', style: TextStyle(color: AppColors.textColor)),
        backgroundColor:  AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isListLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.jobs.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد وظائف مطابقة للبحث',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }

              return Column(
                children: [
                  // Compact Statistics Bar
                  Obx(() {
                    final stats = controller.jobsStats.value;
                    if (stats == null) return const SizedBox.shrink();
                    
                    return CompactStatisticsBar(
                      items: [
                        StatisticItem(
                          icon: Icons.work,
                          value: stats.totalJobs ?? 0,
                          label: 'إجمالي',
                          color: AppColors.primaryColor,
                        ),
                        StatisticItem(
                          icon: Icons.star,
                          value: stats.featuredJobs ?? 0,
                          label: 'مميزة',
                          color: Colors.amber,
                        ),
                        StatisticItem(
                          icon: Icons.local_fire_department,
                          value: stats.urgentJobs ?? 0,
                          label: 'عاجلة',
                          color: Colors.red,
                        ),
                      ],
                      onShowDetails: () => _showDetailedStats(context, stats),
                    );
                  }),

  
                  // Jobs List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.loadJobs();
                        await controller.loadJobStatistics();
                      },
                      color: AppColors.primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.jobs.length,
                        itemBuilder: (context, index) {
                          final job = controller.jobs[index];
                          return JobCard(
                            job: job,
                            onBookmark: () => controller.bookmarkJob(job.id!),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Pagination Controls
                  if(controller.totalJobsPages.value > 1)
                  PaginationControls(
                    currentPage: controller.currentJobsPage.value,
                    totalPages: controller.totalJobsPages.value,
                    onPageChanged: controller.loadJobsPage,
                    isLoading: controller.isListLoading.value,
                  ),
                ],
              );
            }),
          ),
        ],
      ),

    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController(
      text: controller.searchQuery.value,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'البحث عن وظيفة',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن وظيفة...',
            prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onSubmitted: (value) {
            controller.setSearchQuery(value);
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.setSearchQuery('');
              Get.back();
            },
            child: const Text('مسح', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.setSearchQuery(searchController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('بحث', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تصفية الوظائف',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'المدينة',
                controller.selectedCity.value,
                AppEnums.cities,
                (val) => controller.setFilters(city: val),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'نوع الوظيفة',
                controller.selectedJobType.value,
                AppEnums.jobTypes,
                (val) => controller.setFilters(jobType: val),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'مستوى الخبرة',
                controller.selectedExperienceLevel.value,
                AppEnums.experienceLevels,
                (val) => controller.setFilters(experienceLevel: val),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.clearFilters();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: AppColors.textColor,
                  ),
                  child: const Text('مسح التصفيات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String label, String currentValue, Map<String, String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentValue.isNotEmpty ? currentValue : null,
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: Text('اختر $label'),
        ),
      ],
    );
  }

  void _showDetailedStats(BuildContext context, JobsStatistics stats) {
    final colors = [
      AppColors.primaryColor,
      Colors.teal,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];

    final categories = <StatCategory>[];

    // Jobs by Type
    if (stats.jobsByType != null && stats.jobsByType!.isNotEmpty) {
      categories.add(StatCategory(
        title: 'توزيع الوظائف حسب النوع',
        icon: Icons.category,
        items: stats.jobsByType!.asMap().entries.map<StatItem>((entry) {
          final item = entry.value;
          return StatItem(
            label: AppEnums.jobTypes[item.jobType] ?? item.jobType ?? 'غير محدد',
            value: item.count ?? 0,
            color: colors[entry.key % colors.length],
          );
        }).toList(),
      ));
    }

    // Jobs by City
    if (stats.jobsByCity != null && stats.jobsByCity!.isNotEmpty) {
      categories.add(StatCategory(
        title: 'توزيع الوظائف حسب المدينة',
        icon: Icons.location_city,
        items: stats.jobsByCity!.asMap().entries.map<StatItem>((entry) {
          final item = entry.value;
          return StatItem(
            label: AppEnums.cities[item.city] ?? item.city ?? 'غير محدد',
            value: item.count ?? 0,
            color: colors[entry.key % colors.length],
          );
        }).toList(),
      ));
    }

    // Jobs by Category
    if (stats.jobsByCategory != null && stats.jobsByCategory!.isNotEmpty) {
      categories.add(StatCategory(
        title: 'توزيع الوظائف حسب الفئة',
        icon: Icons.label,
        items: stats.jobsByCategory!.asMap().entries.map<StatItem>((entry) {
          final item = entry.value;
          return StatItem(
            label: item.categoryName ?? 'غير مصنف',
            value: item.count ?? 0,
            color: colors[entry.key % colors.length],
          );
        }).toList(),
      ));
    }

    if (categories.isNotEmpty) {
      DetailedStatisticsSheet.show(
        context,
        title: 'إحصائيات الوظائف التفصيلية',
        categories: categories,
      );
    }
  }
}
