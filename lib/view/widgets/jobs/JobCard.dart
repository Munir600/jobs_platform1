import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/job/JobController.dart';
import '../../../core/constants.dart';
import '../../../data/models/job/JobList.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../routes/app_routes.dart';
import '../../screens/applications/ApplyJobScreen.dart';
import '../../screens/jobs/JobDetailScreen.dart';

class JobCard extends StatelessWidget {
  final JobList job;
  final VoidCallback? onBookmark;
  final VoidCallback? onApply;
  final VoidCallback? onShare;

  const JobCard({
    super.key,
    required this.job,
    this.onBookmark,
    this.onApply,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(job.createdAt ?? DateTime.now().toString());
    final now = DateTime.now();
    final difference = now.difference(date);
    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      timeAgo = 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else {
      timeAgo = 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    }

    String salaryText = '';
    if (job.salaryMin != null || job.salaryMax != null) {
      if (job.salaryMin != null && job.salaryMax != null) {
        salaryText = ' ${job.salaryMin}-${job.salaryMax} ريال/شهر';
      } else if (job.salaryMin != null) {
        salaryText = ' من ${job.salaryMin} ريال/شهر';
      } else {
        salaryText = ' حتى ${job.salaryMax} ريال/شهر';
      }
    } else if (job.isSalaryNegotiable == true) {
      salaryText = ' قابل للتفاوض';
    }

    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetails, arguments: job.slug);
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
                      job.title ?? 'عنوان الوظيفة',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBadge(
                        job.isActive == true ? 'نشط' : 'غير نشط',
                        job.isActive == true ? Colors.green : Colors.red,
                      ),
                      if (job.isFeatured == true)
                        _buildBadge('مميز', Colors.orange),
                      if (job.isUrgent == true)
                        _buildBadge('عاجل', Colors.redAccent),
                      if ( job.applicationsCount! > 0)
                        _buildBadge('${job.applicationsCount} متقدم', Colors.green),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.company?.name ?? 'اسم الشركة',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                     // Icon(Icons.visibility_outlined, size: 14, color: Colors.grey[600]),

                      if ( job.viewsCount! > 0)
                        Text('${job.viewsCount} مشاهدة',
                            style: const TextStyle(fontSize: 13,color: Colors.blue),
                        ),

                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 3,
                runSpacing: 8,
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.blue[600]),
                  Text(
                    ' ${job.city != null ? AppEnums.cities[job.city] ?? job.city : 'غير محدد'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Icon(Icons.local_fire_department, size: 18, color: Colors.red[600]),
                  if (salaryText.isNotEmpty)
                    Text(salaryText, style: const TextStyle(fontSize: 13)),

                ],
              ),
              Wrap(
                spacing: 3,
                runSpacing: 4,
                children: [
                  Icon(Icons.alarm, size: 18, color: Colors.green),
                  Text(
                    job.jobType != null ? AppEnums.jobTypes[job.jobType] ?? job.jobType : 'غير محدد',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Icon(Icons.calendar_month_sharp, size: 18, color: Colors.blue[600]),
                  Text(timeAgo, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),

              // Description preview
              if ((job.isAiSummaryEnabled == true && job.aiSummary != null && job.aiSummary!.isNotEmpty) || (job.description != null && job.description!.isNotEmpty))
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (job.isAiSummaryEnabled == true && job.aiSummary != null) 
                        ? Colors.blue.withOpacity(0.05) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: (job.isAiSummaryEnabled == true && job.aiSummary != null)
                        ? Border.all(color: Colors.blue.withOpacity(0.1))
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (job.isAiSummaryEnabled == true && job.aiSummary != null)
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 14, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            Text(
                              'ملخص الذكاء الاصطناعي',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        (job.isAiSummaryEnabled == true && job.aiSummary != null)
                            ? job.aiSummary!
                            : job.description!,
                        style: TextStyle(
                          color: (job.isAiSummaryEnabled == true && job.aiSummary != null) 
                              ? Colors.blue[900] 
                              : Colors.black54,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              if (job.requirements != null && job.requirements!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _buildSkillTags(job.requirements!),
                ),
              const SizedBox(height: 12),

              // Action buttons - disabled for employers
              Obx(() {
                final accountController = Get.find<AccountController>();
                final isEmployer = accountController.currentUser.value?.isEmployer ?? false;
                final isDeadlinePassed = job.applicationDeadline != null && DateTime.tryParse(job.applicationDeadline!)!.isBefore(DateTime.now());

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (isEmployer || isDeadlinePassed)
                          ? null
                          : (onApply ?? () {
                        if (job.id != null) {
                          if (job.applicationMethod != null && job.applicationMethod != 'platform') {
                             Get.toNamed(AppRoutes.jobDetails, arguments: job.slug);
                          } else {
                             Get.to(() => ApplyJobScreen(jobId: job.id!, jobTitle: job.title ?? ''));
                          }
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[350],
                        disabledForegroundColor: Colors.black38,
                      ),
                      child: Text(isDeadlinePassed ? 'انتهى التقديم' : 'تقديم الآن'),
                    ),
                    OutlinedButton(
                      onPressed: (isDeadlinePassed) ? null : onBookmark,
                      style: OutlinedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey[350],
                        disabledForegroundColor: Colors.black38,
                      ),
                      child: Obx(() {
                        final controller = Get.find<JobController>();
                        final isBookmarked = controller.bookmarks.any((b) => b.job?.id == job.id);
                        return Text(isBookmarked ? 'محفوظة' : 'حفظ');
                      }),
                    ),
                    IconButton(
                      onPressed: onShare ?? () {
                        final jobUrl = 'https://alyaarihazem.github.io/Hire-Me/jobs/job-details/${job.slug}';
                        Clipboard.setData(ClipboardData(text: jobUrl));
                        Get.snackbar(
                          'تم النسخ',
                          'تم نسخ رابط الوظيفة إلى الحافظة',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                        );
                      },
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSkillTags(String requirements) {
    final skills = requirements.split(RegExp(r'[،,.\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length < 30)
        .take(5)
        .toList();
    
    return skills.map((skill) => Chip(
      label: Text(
        skill,
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    )).toList();
  }
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 1)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        //
        // ],
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
