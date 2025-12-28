import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/application/ApplicationController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/application/JobApplication.dart';
import '../../../data/models/application/ApplicationStatistics.dart';
import 'package:intl/intl.dart';
import '../application/ApplicationDetailScreen.dart';
import '../../widgets/common/CompactStatisticsBar.dart';
import '../../widgets/common/DetailedStatisticsSheet.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final controller = Get.find<ApplicationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (controller.myApplications.isEmpty && !controller.isListLoading.value) {
       Future.microtask(() => controller.loadMyApplications());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (controller.hasMoreMyApplications.value) {
         controller.loadMoreMyApplications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      // appBar: AppBar(
      //   backgroundColor: AppColors.backgroundColor,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: const Text('طلباتي', style: TextStyle(color: AppColors.textColor)),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isListLoading.value && controller.myApplications.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
            }

            if (controller.myApplications.isEmpty && controller.statistics.value == null) {
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
                       onPressed: controller.loadMyApplications,
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
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
                itemCount: controller.myApplications.length + 2, // +2 for header and footer
                itemBuilder: (context, index) {
                   if (index == 0) {
                    return _buildStatisticsHeader();
                   }
                   
                   if (index == controller.myApplications.length + 1) {
                     return _buildLoadingFooter();
                   }
                   
                  final application = controller.myApplications[index - 1]; // -1 for header
                  return _buildApplicationCard(application);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatisticsHeader() {
    return Obx(() {
      final stats = controller.statistics.value;
      if (stats == null) return const SizedBox.shrink();

      return CompactStatisticsBar(
        items: [
          StatisticItem(
            icon: Icons.assignment,
            value: stats.totalApplications,
            label: 'الكل',
            color: Colors.blue,
          ),
          StatisticItem(
            icon: Icons.hourglass_empty,
            value: stats.pendingApplications,
            label: 'قيد الانتظار',
            color: Colors.orange,
          ),
          StatisticItem(
            icon: Icons.check_circle_outline,
            value: stats.acceptedApplications,
            label: 'مقبول',
            color: Colors.green,
          ),
          StatisticItem(
            icon: Icons.cancel_outlined,
            value: stats.rejectedApplications,
            label: 'مرفوض',
            color: Colors.red,
          ),
        ],
        onShowDetails: () => _showDetailedStats(context, stats),
      );
    });
  }

  void _showDetailedStats(BuildContext context, ApplicationStatistics stats) {
    final colors = [
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.grey,
      Colors.teal,
    ];

    if (stats.applicationsByStatus.isEmpty) return;

    final category = StatCategory(
      title: 'حالة الطلبات',
      icon: Icons.assignment_ind,
      items: stats.applicationsByStatus.asMap().entries.map<StatItem>((entry) {
        final item = entry.value;
        return StatItem(
          label: _getStatusText(item.status),
          value: item.count,
          color: colors[entry.key % colors.length],
        );
      }).toList(),
    );

    DetailedStatisticsSheet.show(
      context,
      title: 'تفاصيل إحصائيات الطلبات',
      categories: [category],
    );
  }

  Widget _buildLoadingFooter() {
    return Obx(() {
      if (!controller.isLoadingMoreMyApplications.value) {
        return const SizedBox.shrink();
      }
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    });
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
      case 'interview_scheduled':
      case 'interview':
        return Colors.indigo;
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
      case 'interview':
      case 'interview_scheduled':
        return 'مقابلة';
      default:
        return status ?? 'غير معروف';
    }
  }
}
