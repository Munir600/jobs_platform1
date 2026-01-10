import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/application/ApplicationController.dart';
import '../../../../data/models/application/JobApplication.dart';
import '../../../../data/models/Interview/InterviewCreate.dart';
import '../../../controllers/ResumeController.dart';
import '../../../../controllers/Interview/InterviewController.dart';
import '../../../../core/utils/contact_utils.dart';

class ApplicationDetailScreen extends GetView<ApplicationController> {
  final JobApplication application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    if (application.id != null) {
      Future.microtask(() => controller.loadMessages(application.id));
    }

    final resumeController = Get.put(ResumeController(), permanent: true);
    final InterviewController interviewController = Get.find<InterviewController>();
    final TextEditingController messageController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Center(child: Text('تفاصيل الطلب', style: const TextStyle(color: AppColors.textColor))),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Obx(() {
        JobApplication? foundApp;
        // Search in myApplications first
        for (var app in controller.myApplications) {
          if (app.id == application.id) {
            foundApp = app;
            break;
          }
        }

        if (foundApp == null) {
          for (var app in controller.jobApplications) {
            if (app.id == application.id) {
              foundApp = app;
              break;
            }
          }
        }
        final latestApp = foundApp ?? application;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: _getStatusColor(latestApp.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'الحالة: ${latestApp.statusDisplay ?? latestApp.status ?? '-'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _getStatusColor(latestApp.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.accentColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: Text(
                          latestApp.applicantName?.substring(0, 1).toUpperCase() ?? '?',
                          style: const TextStyle(fontSize: 32, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        latestApp.applicantName ?? 'متقدم غير معروف',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تاريخ التقديم: ${latestApp.appliedAt != null ? latestApp.appliedAt!.toString().split(' ')[0] : '-'}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoChip(Icons.email, 'Email', latestApp.applicantEmail ?? '-'),
                          _buildInfoChip(Icons.phone, 'الهاتف', latestApp.applicant?.phone ?? '-'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.accentColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('خطاب التقديم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(latestApp.coverLetter ?? 'لا يوجد خطاب تقديم'),
                      const Divider(height: 32),
                      const Text('السيرة الذاتية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (latestApp.resume != null)
                        ListTile(
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: const Text('عرض السيرة الذاتية'),
                          onTap: () {
                            // Open PDF
                            resumeController.openResume(latestApp.resume);
                          },
                        )
                      else
                        const Text('لا توجد سيرة ذاتية مرفقة'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Builder(builder: (context) {
              //   final isEmployer = controller.currentUser.value?.isEmployer ?? false;
              //   if (!isEmployer) return const SizedBox.shrink();
              //
              //   return Column(
              //     children: [
              //       if (latestApp.status == 'pending')
              //         Row(
              //           children: [
              //             Expanded(
              //               child: ElevatedButton(
              //                 onPressed: () => _showActionDialog(context, 'accepted', notesController),
              //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              //                 child: const Text('قبول'),
              //               ),
              //             ),
              //             const SizedBox(width: 16),
              //             Expanded(
              //               child: ElevatedButton(
              //                 onPressed: () => _showActionDialog(context, 'rejected', notesController),
              //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              //                 child: const Text('رفض'),
              //               ),
              //             ),
              //           ],
              //         ),
              //       if (latestApp.status == 'accepted')
              //         SizedBox(
              //           width: double.infinity,
              //           child: ElevatedButton.icon(
              //             onPressed: () => _showScheduleInterviewDialog(context, interviewController, latestApp),
              //             icon: const Icon(Icons.calendar_today),
              //             label: const Text('جدولة مقابلة'),
              //             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white),
              //           ),
              //         ),
              //     ],
              //   );
              // }),

              const SizedBox(height: 24),
              const Text('الرسائل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (controller.isMessageLoading.value)
                const Center(child: CircularProgressIndicator())
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: AppColors.accentColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(msg.senderName ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(msg.sentAt?.substring(0, 16).replaceAll('T', ' ') ?? '',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(msg.message ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              //  const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primaryColor),
                    onPressed: () {
                      if (latestApp.id != null && messageController.text.isNotEmpty) {
                        controller.sendMessage(latestApp.id!, messageController.text);
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return InkWell(
      onTap: () => ContactUtils.handleContactAction(value),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }


  void _showActionDialog(BuildContext context, String status, TextEditingController notesController) {
    Get.defaultDialog(
      title: status == 'accepted' ? 'قبول الطلب' : 'رفض الطلب',
      content: Column(
        children: [
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'ملاحظات (اختياري)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      textConfirm: 'تأكيد',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      buttonColor: status == 'accepted' ? Colors.green : Colors.red,
      onConfirm: () {
        if (application.id != null) {
          controller.updateApplicationStatus(
            application.id,
            status,
            notes: notesController.text,
          );
          Get.back();
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
