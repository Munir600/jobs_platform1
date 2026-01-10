import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/Interview/InterviewController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/Interview/Interview.dart';
import 'package:intl/intl.dart';

class InterviewDetailScreen extends GetView<InterviewController> {
  final Interview interview;

  const InterviewDetailScreen({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(interview.scheduledDate ?? DateTime.now().toString());
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل المقابلة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(formattedDate),
                const SizedBox(height: 16),
                _buildDetailsCard(),
                const SizedBox(height: 16),
                if (interview.meetingLink != null && interview.meetingLink!.isNotEmpty)
                  _buildMeetingLinkCard(),
                const SizedBox(height: 16),
                if (interview.notes != null && interview.notes!.isNotEmpty)
                  _buildNotesCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(String date) {
    return Card(
      color: AppColors.accentColor,

      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مقابلة لوظيفة: ${interview.application?.jobTitle ?? "غير معروف"}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '  المتقدم : ${interview.application?.applicant?.fullName ?? "غير معروف"}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                ),              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('الموعد: $date', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(interview.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getStatusColor(interview.status)),
              ),
              child: Text(
                _getStatusText(interview.status),
                style: TextStyle(color: _getStatusColor(interview.status), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
color: AppColors.accentColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل المقابلة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.person,
              'المقابل',
              interview.interviewerName ?? 'غير معروف',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.videocam,
              'نوع المقابلة',
              interview.interviewType == 'video' ? 'مقابلة فيديو (Online)' : 'حضوري (In-person)',
            ),
            if (interview.location != null && interview.location!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDetailRow(Icons.location_on, 'الموقع', interview.location!),
            ],
            if (interview.durationMinutes != null) ...[
              const SizedBox(height: 16),
              _buildDetailRow(Icons.timer, 'المدة', '${interview.durationMinutes} دقيقة'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, color: AppColors.textColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildMeetingLinkCard() {
    return Card(
      color: AppColors.accentColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'رابط الاجتماع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
            const Divider(),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                 launchUrl(Uri.parse(interview.meetingLink!));
              },
              child: Text(
                interview.meetingLink!,
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                 launchUrl(Uri.parse(interview.meetingLink!));
              },
              icon: const Icon(Icons.video_call, color: Colors.white),
              label: const Text('انضمام للاجتماع', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      color: AppColors.accentColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملاحظات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              interview.notes!,
              style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.5),
            ),
          ],
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
