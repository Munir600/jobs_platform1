import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../../../data/models/application/JobApplication.dart';
import '../../../controllers/ResumeController.dart';
import 'package:intl/intl.dart';

class JobseekerApplicationDetailScreen extends GetView<ApplicationController> {
  final JobApplication application;

  const JobseekerApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    if (application.id != null) {
      Future.microtask(() => controller.loadMessages(application.id));
    }

    final resumeController = Get.put(ResumeController(), permanent: true);
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل طلبي', style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        JobApplication? foundApp;
        for (var app in controller.myApplications) {
          if (app.id == application.id) {
            foundApp = app;
            break;
          }
        }
        final latestApp = foundApp ?? application;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(latestApp),
              const SizedBox(height: 20),

              _buildJobSummaryCard(latestApp),
              const SizedBox(height: 24),

              _buildSectionHeader('تفاصيل طلبي', Icons.description),
              _buildApplicationCard(latestApp, resumeController),
              const SizedBox(height: 24),

              if (latestApp.employerNotes != null && latestApp.employerNotes!.isNotEmpty) ...[
                _buildSectionHeader('ملاحظات صاحب العمل', Icons.note_alt),
                _buildEmployerNotesCard(latestApp),
                const SizedBox(height: 24),
              ],

              _buildSectionHeader('المحادثة مع صاحب العمل', Icons.message),
              _buildMessagesSection(latestApp, messageController),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(JobApplication app) {
    final statusColor = _getStatusColor(app.status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('حالة طلبك الحالية', style: TextStyle(color: statusColor.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            app.statusDisplay ?? _getStatusText(app.status),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSummaryCard(JobApplication app) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (app.job?.company?.logo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(app.job!.company!.logo!, width: 60, height: 60, fit: BoxFit.cover),
              )
            else
              Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.business, color: Colors.grey)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.jobTitle ?? '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(app.job?.company?.name ?? '-', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication app, ResumeController resumeController) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildDetailItem('تاريخ التقديم', _formatDate(app.appliedAt))),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailItem('الراتب المتوقع', app.expectedSalary != null ? '${app.expectedSalary} ر.ي' : 'غير محدد')),
              ],
            ),
            const Divider(height: 32),
            const Text('خطاب التقديم المرسل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text(app.coverLetter ?? 'لم ترفق خطاب تقديم.', style: const TextStyle(height: 1.5)),
            const Divider(height: 32),
            const Text('الوثائق المرفقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            if (app.resume != null)
              _buildDocTile(Icons.picture_as_pdf, 'سيرتك الذاتية', Colors.red, () => resumeController.openResume(app.resume)),
            if (app.filledTemplate != null)
              _buildDocTile(Icons.assignment_turned_in, 'النموذج المعبأ', Colors.green, () => resumeController.openResume(app.filledTemplate)),
            if (app.portfolioUrl != null)
              _buildDocTile(Icons.link, 'رابط محفظتك', Colors.blue, () {}),
            if (app.resume == null && app.filledTemplate == null && app.portfolioUrl == null)
              const Text('لم يتم إرفاق وثائق إضافية.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            
            if (app.job?.applicationMethod == 'custom_form' && app.job?.customForm != null) ...[
              const Divider(height: 32),
              const Text('إجابات الاستبيان المخصص', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              ...app.job!.customForm!.questions!.map((q) {
                final responseFallback = app.responses?.firstWhereOrNull((r) => r.question == q.id);
                final answerText = q.answerText ?? responseFallback?.answerText;
                final answerFile = q.answerFile ?? responseFallback?.answerFile;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.label ?? "", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        answerText ?? 'لا توجد إجابة',
                        style: TextStyle(color: answerText != null ? Colors.black87 : Colors.grey, fontSize: 13),
                      ),
                      if (answerFile != null) ...[
                        const SizedBox(height: 4),
                        TextButton.icon(
                          onPressed: () => resumeController.openResume(answerFile),
                          icon: const Icon(Icons.attach_file, size: 14),
                          label: const Text('الملف المرفق', style: TextStyle(fontSize: 11)),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmployerNotesCard(JobApplication app) {
    return Card(
      elevation: 0,
      color: Colors.yellow[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.yellow[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ملاحظة من جهة التوظيف:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange)),
            const SizedBox(height: 8),
            Text(app.employerNotes!, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesSection(JobApplication app, TextEditingController messageController) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: controller.isMessageLoading.value
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      // For seeker, "Me" is the applicant
                      final isMe = msg.senderName == app.applicantName;
                      return _buildChatBubble(msg.message ?? '', _formatTime(msg.sentAt), isMe);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'ارسل استفسار لصاحب العمل...',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (app.id != null && messageController.text.isNotEmpty) {
                        controller.sendMessage(app.id, messageController.text);
                        messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDocTile(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.open_in_new, size: 16),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildChatBubble(String text, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          border: isMe ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      case 'interview':
      case 'interview_scheduled': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending': return 'قيد الانتظار';
      case 'accepted': return 'مقبول';
      case 'rejected': return 'مرفوض';
      case 'interview':
      case 'interview_scheduled': return 'مقابلة';
      default: return status ?? 'غير معروف';
    }
  }
}
