import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/Interview/InterviewController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/Interview/Interview.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/CompactStatisticsBar.dart';
import '../../widgets/common/DetailedStatisticsSheet.dart';
import 'InterviewDetailScreen.dart';

class InterviewListScreen extends GetView<InterviewController> {
  const InterviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('إدارة المقابلات', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryColor),
            onPressed: () => controller.loadInterviews(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isListLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
            }

            if (controller.interviews.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد مقابلات مجدولة',
                  style: TextStyle(color: AppColors.textColor, fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadInterviews,
              color: AppColors.primaryColor,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.interviews.length + 2, // +2 for header and footer
                itemBuilder: (context, index) {
                  // Statistics header
                  if (index == 0) {
                    return _buildStatisticsHeader(context);
                  }
                  
                  // Loading footer
                  if (index == controller.interviews.length + 1) {
                    return _buildLoadingFooter();
                  }
                  
                  // Interview cards
                  final interview = controller.interviews[index - 1];
                  return _buildInterviewCard(interview);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatisticsHeader(BuildContext context) {
    return Obx(() {
      final stats = controller.statistics;
      
      return CompactStatisticsBar(
        items: [
           StatisticItem(
            icon: Icons.calendar_today,
            value: stats['total'] ?? 0,
            label: 'الإجمالي',
            color: Colors.blue,
          ),
          StatisticItem(
            icon: Icons.schedule,
            value: stats['scheduled'] ?? 0,
            label: 'مجدولة',
            color: Colors.orange,
          ),
          StatisticItem(
            icon: Icons.check_circle,
            value: stats['completed'] ?? 0,
            label: 'مكتملة',
            color: Colors.green,
          ),
          StatisticItem(
            icon: Icons.cancel,
            value: stats['cancelled'] ?? 0,
            label: 'ملغاة',
            color: Colors.red,
          ),
        ],
        onShowDetails: () => _showDetailedStats(context),
      );
    });
  }

  void _showDetailedStats(BuildContext context) {
    if (controller.detailedStatistics.isEmpty) return;

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
    ];

    final category = StatCategory(
      title: 'حالة المقابلات',
      icon: Icons.pie_chart,
      items: controller.detailedStatistics.asMap().entries.map<StatItem>((entry) {
        final item = entry.value;
        return StatItem(
          label: _getStatusText(item['status']),
          value: item['count'],
          color: colors[entry.key % colors.length],
        );
      }).toList(),
    );

    DetailedStatisticsSheet.show(
      context,
      title: 'إحصائيات المقابلات التفصيلية',
      categories: [category],
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingFooter() {
    return Obx(() {
      if (!controller.isLoadingMore.value) {
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

  Widget _buildInterviewCard(Interview interview) {
    final date = DateTime.parse(interview.scheduledDate ?? DateTime.now().toString());
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child:
      InkWell(
        onTap: () {
          Get.to(() => InterviewDetailScreen(interview: interview));
        },
        borderRadius: BorderRadius.circular(12),
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
                      'مقابلة لوظيفة: ${interview.application?.jobTitle ?? "غير معروف"}',
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
                      color: _getStatusColor(interview.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor(interview.status)),
                    ),
                    child: Text(
                      _getStatusText(interview.status),
                      style: TextStyle(color: _getStatusColor(interview.status), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 8),
                  if (interview.interviewType == 'video' || interview.interviewType == 'phone') ...{
                    Icon(
                      interview.interviewType == 'video' ? Icons.videocam : Icons.phone,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      interview.interviewType == 'video' ? 'مقابلة فيديو' : 'مقابلة هاتفية',
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                  } else ...{
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      interview.location ?? 'مقابلة شخصية',
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                  },
                ],
              ) ,

            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'scheduled': return Colors.blue;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'rescheduled': return Colors.orange;
      default: return AppColors.primaryColor;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'scheduled': return 'مجدولة';
      case 'completed': return 'مكتملة';
      case 'cancelled': return 'ملغاة';
      case 'rescheduled': return 'معاد جدولتها';
      default: return status ?? 'غير معروف';
    }
  }
}

