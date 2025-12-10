import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/Interview/InterviewController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/Interview/Interview.dart';
import 'package:intl/intl.dart';

import 'InterviewDetailScreen.dart';

class InterviewListScreen extends GetView<InterviewController> {
  const InterviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
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

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.interviews.length,
              itemBuilder: (context, index) {
                final interview = controller.interviews[index];
                return _buildInterviewCard(interview);
              },
            );
          }),
        ],
      ),
    );
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
                      'مقابلة لوظيفة: ${interview.application?.jobTitle ?? "غير معروف"}', // Ideally fetch job title
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
                  if (interview.interviewType == 'video' || interview.interviewType == 'phone') ...[
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
                  ] else ...[
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      interview.location ?? 'مقابلة شخصية',
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                  ],
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
