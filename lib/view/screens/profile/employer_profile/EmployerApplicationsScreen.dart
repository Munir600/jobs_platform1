import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../../../data/models/application/ApplicationStatistics.dart';
import '../../../widgets/common/CompactStatisticsBar.dart';
import '../../../widgets/common/DetailedStatisticsSheet.dart';
import '../../application/ApplicationDetailScreen.dart';

class EmployerApplicationsScreen extends StatefulWidget {
  const EmployerApplicationsScreen({super.key});

  @override
  State<EmployerApplicationsScreen> createState() => _EmployerApplicationsScreenState();
}

class _EmployerApplicationsScreenState extends State<EmployerApplicationsScreen> {
  final controller = Get.find<ApplicationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Explicitly load statistics when screen initializes if not already loaded or stale
    // Ideally we might want to refresh lists here too, but GetX controller usually manages state.
    // Given the user wants scrolling, we assume data is loaded or will be loaded.
    if (controller.jobApplications.isEmpty && !controller.isListLoading.value) {
        Future.microtask(() => controller.loadJobApplications());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (controller.hasMoreJobApplications.value) {
        controller.loadMoreJobApplications();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.isListLoading.value && controller.jobApplications.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
      }

      if (controller.jobApplications.isEmpty && controller.statistics.value == null) {
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

      return RefreshIndicator(
        onRefresh: controller.loadJobApplications,
        color: AppColors.primaryColor,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.jobApplications.length + 2, // Header + Footer
          itemBuilder: (context, index) {
            // Statistics Header
            if (index == 0) {
              return _buildStatisticsHeader();
            }

            // Loading Footer
            if (index == controller.jobApplications.length + 1) {
              return _buildLoadingFooter();
            }

            final application = controller.jobApplications[index - 1];
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
        ),
      );
    });
  }

  Widget _buildStatisticsHeader() {
    return Obx(() {
      final stats = controller.statistics.value;
      if (stats == null) return const SizedBox.shrink();

      return CompactStatisticsBar(
        items: [
          StatisticItem(
            icon: Icons.people,
            value: stats.totalApplications,
            label: 'الكل',
            color: Colors.blue,
          ),
          StatisticItem(
            icon: Icons.pending_actions,
            value: stats.pendingApplications,
            label: 'انتظار',
            color: Colors.orange,
          ),
          StatisticItem(
            icon: Icons.check_circle,
            value: stats.acceptedApplications,
            label: 'مقبول',
            color: Colors.green,
          ),
          StatisticItem(
            icon: Icons.cancel,
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
      title: 'تفاصيل إحصائيات المتقدمين',
      categories: [category],
    );
  }

  Widget _buildLoadingFooter() {
    return Obx(() {
       if (!controller.isLoadingMoreJobApplications.value) {
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'interview':
      case 'interview_scheduled':
        return Colors.blue;
      default:
        return Colors.grey;
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
