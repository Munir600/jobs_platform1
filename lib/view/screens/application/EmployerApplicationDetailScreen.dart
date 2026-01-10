import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../../../data/models/application/JobApplication.dart';
import '../../../../data/models/Interview/InterviewCreate.dart';
import '../../../controllers/ResumeController.dart';
import '../../../../controllers/Interview/InterviewController.dart';
import '../../../../core/utils/contact_utils.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../../data/models/job/JobDetail.dart';

class EmployerApplicationDetailScreen extends GetView<ApplicationController> {
  final JobApplication application;

  const EmployerApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    if (application.id != null) {
      Future.microtask(() {
        controller.loadMessages(application.id);
        controller.loadApplicationDetails(application.id);
      });
    }

    final resumeController = Get.put(ResumeController(), permanent: true);
    final InterviewController interviewController = Get.find<InterviewController>();
    final TextEditingController messageController = TextEditingController();
    final TextEditingController notesController = TextEditingController(text: application.employerNotes);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل مقدم الطلب', style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        final latestApp = controller.jobApplications.firstWhereOrNull((a) => a.id == application.id) ?? application;
        
        // Show loading if we are fetching full details and don't have responses yet
        final needsResponses = latestApp.job?.applicationMethod == 'custom_form';
        final hasResponses = latestApp.responses != null && latestApp.responses!.isNotEmpty;
        
        if (controller.isLoading.value && needsResponses && !hasResponses) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildStatusBanner(latestApp),
              // const SizedBox(height: 20),
              
              _buildSectionHeader('معلومات المتقدم', Icons.person),
              _buildApplicantCard(latestApp),
              const SizedBox(height: 24),

              _buildSectionHeader('معلومات الوظيفة', Icons.work),
              _buildJobCard(latestApp),
              const SizedBox(height: 24),


              _buildSectionHeader('طريقة التقديم والمتطلبات', Icons.assignment),
              _buildApplicationMethodDetails(latestApp),
              const SizedBox(height: 24),

              _buildSectionHeader('تفاصيل الطلب', Icons.description),
              _buildApplicationCard(latestApp),
              const SizedBox(height: 24),

              if (latestApp.resume != null || latestApp.portfolioUrl != null || latestApp.filledTemplate != null) ...[
                _buildSectionHeader('الوثائق والروابط', Icons.attach_file),
                _buildDocumentsCard(latestApp, resumeController),
                const SizedBox(height: 24),
              ],

              _buildSectionHeader('ملاحظات صاحب العمل', Icons.note_alt),
              _buildNotesCard(latestApp, notesController),
              const SizedBox(height: 24),

              _buildActionsSection(context, latestApp, interviewController, notesController),
              const SizedBox(height: 32),

              _buildSectionHeader('الرسائل', Icons.message),
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  // Widget _buildStatusBanner(JobApplication app) {
  //   final statusColor = _getStatusColor(app.status);
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: statusColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: statusColor.withOpacity(0.3)),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.info_outline, color: statusColor, size: 20),
  //         const SizedBox(width: 8),
  //         Text(
  //           'حالة الطلب الحالية: ${app.statusDisplay ?? _getStatusText(app.status)}',
  //           style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildApplicantCard(JobApplication app) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: app.applicant?.profilePicture != null
                      ? ClipOval(child: Image.network(app.applicant!.profilePicture!, width: 70, height: 70, fit: BoxFit.cover))
                      : Text(app.applicantName?.substring(0, 1).toUpperCase() ?? '?',
                          style: const TextStyle(fontSize: 24, color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.applicantName ?? 'متقدم غير معروف', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            if (app.applicant?.bio != null && app.applicant!.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                app.applicant!.bio!,
                style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.5),
              ),
            ],
            const Divider(height: 32),
            _buildInfoRow(Icons.email, 'البريد الإلكتروني', app.applicantEmail ?? '-', isAction: app.applicantEmail != null),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, 'رقم الهاتف', app.applicant?.phone ?? '-', isAction: app.applicant?.phone != null),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'الموقع', app.applicant?.location ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(JobApplication app) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(app.jobTitle ?? '-', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSimpleBadge(app.job?.category?.name ?? 'عام', Colors.blue),
                const SizedBox(width: 8),
                _buildSimpleBadge(_getJobTypeLabel(app.job?.jobType), Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem('الراتب المتوقع للوظيفة', '${app.job?.salaryMin ?? 0} - ${app.job?.salaryMax ?? 0}'),
                _buildDetailItem('تاريخ انتهاء التقديم', app.job?.applicationDeadline?.toString().split(' ')[0] ?? '-'),
              ],
            ),
            if (app.job?.applicationMethod != null) ...[
              const Divider(height: 24),
              _buildDetailItem('طريقة التقديم للوظيفة', _getApplicationMethodLabel(app.job?.applicationMethod)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationMethodDetails(JobApplication app) {
    final method = app.job?.applicationMethod;
    if (method == null) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (method == 'custom_form' && app.job?.customForm != null) ...[
              Text('النموذج المخصص: ${app.job?.customForm?.name ?? ""}', style: const TextStyle(fontWeight: FontWeight.bold)),
              if (app.job?.customForm?.description != null) ...[
                const SizedBox(height: 4),
                Text(app.job!.customForm!.description!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
              const Divider(height: 24),
              const Text('الأسئلة والإجابات:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              ...app.job!.customForm!.questions!.map((q) {
                // Find response for this question in the top-level list as a fallback
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Text(
                          answerText ?? 'لا توجد إجابة',
                          style: TextStyle(color: answerText != null ? Colors.black : Colors.grey, fontSize: 13),
                        ),
                      ),
                      if (answerFile != null) ...[
                         const SizedBox(height: 4),
                         TextButton.icon(
                           onPressed: () => Get.put(ResumeController()).openResume(answerFile),
                           icon: const Icon(Icons.attach_file, size: 16),
                           label: const Text('عرض الملف المرفق', style: TextStyle(fontSize: 12)),
                         ),
                      ],
                    ],
                  ),
                );
              }),
            ] else if (method == 'template_file') ...[
              const Text('قالب التقديم المطلوب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _buildDocTile(
                Icons.description,
                'قالب الوظيفة',
                'تحميل القالب الأصلي',
                Colors.deepPurple,
                () => Get.put(ResumeController()).openResume(app.job?.applicationTemplate),
              ),
              if (app.filledTemplate != null) ...[
                const Divider(height: 24),
                const Text('الملف المعبأ من قبل المتقدم:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                _buildDocTile(
                  Icons.assignment_turned_in,
                  'النموذج المعبأ',
                  'مشاهدة الإجابات',
                  Colors.green,
                  () => Get.put(ResumeController()).openResume(app.filledTemplate),
                ),
              ],
            ] else if (method == 'external_link') ...[
              const Text('رابط التقديم الخارجي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                app.job?.externalApplicationUrl ?? 'غير متوفر',
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ] else if (method == 'email') ...[
              const Text('بريد التقديم:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Text(app.job?.applicationEmail ?? 'غير متوفر'),
            ] else ...[
              const Text('التقديم عبر المنصة المباشر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('تم التقديم باستخدام الملف الشخصي والسيرة الذاتية المرفقة.'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication app) {
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
                _buildDetailItem('تاريخ التقديم', _formatDate(app.appliedAt)),
                _buildDetailItem('الراتب المتوقع', app.expectedSalary != null ? '${app.expectedSalary} ر.ي' : 'غير محدد'),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailItem('تاريخ التوفر للعمل', _formatDate(app.availabilityDate)),
            const Divider(height: 32),
            const Text('خطاب التقديم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.2))),
              child: Text(app.coverLetter ?? 'لا يوجد خطاب تقديم مرفق.', style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard(JobApplication app, ResumeController resumeController) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Column(
        children: [
          if (app.resume != null)
            _buildDocTile(Icons.picture_as_pdf, 'السيرة الذاتية', 'PDF Document', Colors.red, () => resumeController.openResume(app.resume)),
          if (app.filledTemplate != null)
            _buildDocTile(Icons.assignment_turned_in, 'النموذج المعبأ', 'Submission Template', Colors.green, () => resumeController.openResume(app.filledTemplate)),
          if (app.portfolioUrl != null)
            _buildDocTile(Icons.link, 'رابط الأعمال (Portfolio)', app.portfolioUrl!, Colors.blue, () => ContactUtils.handleContactAction(app.portfolioUrl!)),
        ],
      ),
    );
  }

  Widget _buildNotesCard(JobApplication app, TextEditingController controller) {
    return Card(
      elevation: 0,
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'أضف ملاحظاتك حول هذا المتقدم هنا...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, JobApplication app, InterviewController interviewController, TextEditingController notesController) {
    return Column(
      children: [
        if (app.status == 'pending')
          Row(
            children: [
              Expanded(
                child: _buildActionButton('قبول الطلب', Icons.check_circle, Colors.green, () => _showActionDialog(context, 'accepted', notesController)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton('رفض الطلب', Icons.cancel, Colors.red, () => _showActionDialog(context, 'rejected', notesController)),
              ),
            ],
          ),
        const SizedBox(height: 12),
        if (app.status == 'accepted')
          SizedBox(
            width: double.infinity,
            child: _buildActionButton('جدولة مقابلة', Icons.calendar_today, AppColors.primaryColor, () => _showScheduleInterviewDialog(context, interviewController, app)),
          ),
      ],
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
            constraints: const BoxConstraints(maxHeight: 400),
            child: controller.isMessageLoading.value
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                : controller.messages.isEmpty
                    ? const Padding(padding: EdgeInsets.all(32), child: Text('لا توجد رسائل سابقة. ابدأ المحادثة الآن!'))
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final msg = controller.messages[index];
                          final isMe = msg.senderName != app.applicantName; // Simple check
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
                      hintText: 'اكتب رسالة...',
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

  // --- Helper Widgets ---

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isAction = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryColor.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              InkWell(
                onTap: isAction ? () => ContactUtils.handleContactAction(value) : null,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isAction ? Colors.blue : Colors.black),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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

  Widget _buildSimpleBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDocTile(IconData icon, String title, String subtitle, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18,color: Colors.white),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildChatBubble(String text, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(16),
            bottomRight: isMe ? const Radius.circular(16) : Radius.zero,
          ),
          border: isMe ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black, height: 1.4)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  // --- Logic Helpers ---

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

  String _getJobTypeLabel(String? type) {
    switch (type) {
      case 'full_time': return 'دوام كامل';
      case 'part_time': return 'دوام جزئي';
      case 'contract': return 'عقد';
      case 'freelance': return 'عمل حر';
      default: return 'عام';
    }
  }

  String _getApplicationMethodLabel(String? method) {
    switch (method) {
      case 'platform': return 'عبر المنصة';
      case 'custom_form': return 'نموذج مخصص';
      case 'template_file': return 'ملف قالب';
      case 'external_link': return 'رابط خارجي';
      case 'email': return 'البريد الإلكتروني';
      default: return method ?? 'غير محدد';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      case 'interview':
      case 'interview_scheduled': return Colors.blue;
      case 'withdrawn': return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending': return 'قيد المراجعة';
      case 'accepted': return 'مقبول';
      case 'rejected': return 'مرفوض';
      case 'withdrawn': return 'منسحب';
      case 'interview':
      case 'interview_scheduled': return 'تمت جدولة مقابلة';
      default: return status ?? 'غير معروف';
    }
  }

  void _showActionDialog(BuildContext context, String status, TextEditingController notesController) {
    Get.defaultDialog(
      title: status == 'accepted' ? 'قبول الطلب' : 'رفض الطلب',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text('هل أنت متأكد من تغيير حالة هذا الطلب؟ يمكنك إضافة ملاحظات إضافية ليراها المتقدم.'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات نهائية', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
      ),
      textConfirm: 'تأكيد',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: status == 'accepted' ? Colors.green : Colors.red,
      onConfirm: () {
        if (application.id != null) {
          controller.updateApplicationStatus(application.id, status, notes: notesController.text);
          Get.back();
        }
      },
    );
  }

  void _showScheduleInterviewDialog(BuildContext context, InterviewController interviewController, JobApplication currentApp) {
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();
    final locationController = TextEditingController();
    final linkController = TextEditingController();
    final interviewerNameController = TextEditingController();
    final interviewerEmailController = TextEditingController();
    final notesController = TextEditingController();

    String interviewType = 'video';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'جدولة مقابلة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: interviewType,
                items: const [
                  DropdownMenuItem(value: 'phone', child: Text('هاتف')),
                  DropdownMenuItem(value: 'video', child: Text('فيديو')),
                  DropdownMenuItem(value: 'in_person', child: Text('شخصي')),
                  DropdownMenuItem(value: 'technical', child: Text('تقني')),
                  DropdownMenuItem(value: 'hr', child: Text('موارد بشرية')),
                ],
                onChanged: (v) => interviewType = v!,
                decoration: const InputDecoration(labelText: 'نوع المقابلة', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'التاريخ',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          selectedDate = picked;
                          dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'الوقت',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          selectedTime = picked;
                          timeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'المدة (بالدقائق)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'الموقع', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: 'رابط الاجتماع', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: interviewerNameController,
                decoration: const InputDecoration(labelText: 'اسم المقابل', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: interviewerEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'بريد المقابل', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'ملاحظات', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              Obx(() => interviewController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (currentApp.id != null && selectedDate != null && selectedTime != null) {
                    final link = linkController.text.trim();
                    if (link.isNotEmpty && !link.startsWith('http://') && !link.startsWith('https://')) {
                      Get.snackbar('خطأ', 'الرجاء إدخال رابط صالح (http/https)', backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    final dateTime = '${dateController.text}T${timeController.text}:00Z';
                    final interview = InterviewCreate(
                      application: currentApp.id,
                      interviewType: interviewType,
                      scheduledDate: dateTime,
                      durationMinutes: int.tryParse(durationController.text),
                      location: locationController.text.isNotEmpty ? locationController.text : null,
                      meetingLink: link.isNotEmpty ? link : null,
                      interviewerName: interviewerNameController.text.isNotEmpty ? interviewerNameController.text : null,
                      interviewerEmail: interviewerEmailController.text.isNotEmpty ? interviewerEmailController.text : null,
                      notes: notesController.text.isNotEmpty ? notesController.text : null,
                    );

                    final success = await interviewController.createInterview(interview);
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Get.snackbar('خطأ', 'يرجى اختيار التاريخ والوقت');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('جدولة المقابلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
