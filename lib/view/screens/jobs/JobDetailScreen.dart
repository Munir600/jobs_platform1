import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobs_platform1/routes/app_routes.dart';
import '../../../controllers/job/JobController.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/job/JobCreate.dart';
import '../../../data/models/job/JobDetail.dart';
import '../../../data/models/job/JobList.dart';
import '../../../core/constants.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobSlug;
  final bool isEmployer;

  const JobDetailScreen({super.key,required this.jobSlug, this.isEmployer = false});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final controller = Get.find<JobController>();
  final accountController = Get.find<AccountController>();
  late String slug;

  @override
  void initState() {
    super.initState();
    slug = widget.jobSlug;
    
    if (slug.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadJobDetail(slug);
      });
    }
  }

  @override
  void dispose() {
    controller.clearCurrentJob();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (slug.isEmpty) return const Scaffold(body: Center(child: Text('Error: No ID provided')));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('تفاصيل الوظيفة', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          if (!widget.isEmployer)
            Obx(() {
              final job = controller.currentJob.value;
              if (job == null) return const SizedBox.shrink();
              
              final isBookmarked = controller.bookmarks.any((b) => b.job?.id == job.id);
              return IconButton(
                icon: Icon(
                  (isBookmarked ) ? Icons.bookmark : Icons.bookmark_border,
                  color: (isBookmarked) ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  if (job.id != null) {
                    controller.bookmarkJob(job.id!);
                  }
                },
              );
            }),
        ],
      ),
      body: Obx(() {
        if (controller.isJobDetailLoading.value && controller.currentJob.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }
        
        final job = controller.currentJob.value;
        if (job == null) {
           return const Center(child: Text('لم يتم العثور على الوظيفة'));
        }

        // Safe parsing of date
        String formattedDate = 'غير محدد';
        if (job.createdAt != null) {
          try {
            final date = DateTime.parse(job.createdAt!);
            formattedDate = DateFormat('yyyy-MM-dd').format(date);
          } catch (e) {
            // Ignore parse error
          }
        }

        return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(job, formattedDate),
                    const SizedBox(height: 24),
                    _buildSectionTitle('تفاصيل الوظيفة'),
                    const SizedBox(height: 12),
                    _buildDetailsGrid(job),
                    const SizedBox(height: 24),

                    if (job.isAiSummaryEnabled == true && job.aiSummary != null && job.aiSummary!.isNotEmpty) ...[
                      _buildAiSummarySection(job.aiSummary!),
                      const SizedBox(height: 24),
                    ],

                    if (job.description != null && job.description.isNotEmpty) ...[
                      _buildSectionTitle('نبذة عن الوظيفة'),
                      Text(job.description!, style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.6)),
                      const SizedBox(height: 24),
                    ],
                    if (job.requirements.isNotEmpty) ...[
                      _buildSectionTitle('المتطلبات'),
                      Text(job.requirements, style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.6)),
                      const SizedBox(height: 24),
                    ],
                    if (job.responsibilities != null && job.responsibilities!.isNotEmpty) ...[
                      _buildSectionTitle('المسؤوليات'),
                      Text(job.responsibilities!, style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.6)),
                      const SizedBox(height: 24),
                    ],
                    if (job.skills != null && job.skills!.isNotEmpty) ...[
                      _buildSectionTitle('المهارات المطلوبة'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: job.skills!.split(RegExp(r'[،,.\n]')).map((s) => _buildSkillChip(s.trim())).where((w) => (w as Chip).label is Text && ((w as Chip).label as Text).data!.isNotEmpty).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (job.benefits != null && job.benefits!.isNotEmpty) ...[
                      _buildSectionTitle('المزايا'),
                      Text(job.benefits!, style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.6)),
                      const SizedBox(height: 24),
                    ],
                    // const SizedBox(height: 16),
                    // if (widget.isEmployer)
                    //    _buildEmployerActions(job),
                    // SizedBox(height: widget.isEmployer ? 16 : 0),
                    Obx(() {
                      final isEmployer = accountController.currentUser.value?.isEmployer ?? false;
                      final isDeadlinePassed = job.applicationDeadline != null && DateTime.tryParse(job.applicationDeadline!)!.isBefore(DateTime.now());

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (isEmployer || isDeadlinePassed) ? null : () {
                             _handleApplication(job);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledBackgroundColor: Colors.grey[350],
                            disabledForegroundColor: Colors.black38,
                          ),
                          child: Text(_getButtonText(job, isDeadlinePassed), style: const TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
        );
      }),
    );
  }



  Widget _buildHeader(JobDetail job, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title ?? 'عنوان الوظيفة',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {

             if (job.company?.slug != null) {
             // Get.to(() => CompanyDetailScreen(company: company));
             }

          },
          child: Text(
            job.company?.name ?? 'اسم الشركة',
            style: const TextStyle(fontSize: 18, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
         const SizedBox(height: 4),
         Text('تاريخ النشر: $date', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }


  Widget _buildDetailsGrid(JobDetail job) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildDetailItem(Icons.location_on, 'الموقع', job.city != null ? AppEnums.cities[job.city] ?? job.city! : 'غير محدد'),
          _buildDetailItem(Icons.work, 'نوع الوظيفة', job.jobType != null ? AppEnums.jobTypes[job.jobType] ?? job.jobType! : 'غير محدد'),
          _buildDetailItem(Icons.school, 'المستوى التعليمي', job.educationLevel != null ? AppEnums.educationLevels[job.educationLevel] ?? job.educationLevel! : 'غير محدد'),
          _buildDetailItem(Icons.star, 'الخبرة', job.experienceLevel != null ? AppEnums.experienceLevels[job.experienceLevel] ?? job.experienceLevel! : 'غير محدد'),
          _buildDetailItem(Icons.monetization_on, 'الراتب', job.isSalaryNegotiable == true ? 'قابل للتفاوض' : '${job.salaryMin ?? 0} - ${job.salaryMax ?? 0}'),
          _buildDetailItem(Icons.timer, 'انتهاء التقديم', job.applicationDeadline?.split('T')[0] ?? 'غير محدد'),
        ],
      );
    });
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      width: (Get.width - 48) / 2, // 2 columns
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
    );
  }

  // Widget _buildEmployerStats(JobDetail job) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.blue[50],
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.blue[100]!),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildStatItem('المشاهدات', '${job.viewsCount ?? 0}', Icons.visibility),
  //         _buildStatItem('المتقدمين', '${job.applicationsCount ?? 0}', Icons.people),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatItem(String label, String value, IconData icon, {bool isLink = false}) {
    return Column(
      children: [
        Icon(icon, color: isLink ? Colors.blue : AppColors.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isLink ? Colors.blue : AppColors.primaryColor,
            decoration: isLink ? TextDecoration.underline : null,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatusBadges(JobDetail job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 8,
          children: [
            _buildBadge(
              job.isActive == true ? 'نشط' : 'غير نشط',
              job.isActive == true ? Colors.green : Colors.red,
            ),
            if (job.isFeatured == true)
              _buildBadge('مميز', Colors.orange),
            if (job.isUrgent == true)
              _buildBadge('عاجل', Colors.redAccent),
          ],
        ),
        // if (widget.isEmployer)
        //   Transform.scale(
        //     scale: 0.8,
        //     child: Switch(
        //       value: job.isActive ?? false,
        //       activeColor: Colors.green,
        //       onChanged: (value) {
        //         _toggleJobStatus(job, value);
        //       },
        //     ),
        //   ),
      ],
    );
  }

  void _toggleJobStatus(JobDetail job, bool isActive) {
     if (job.slug.isEmpty) return;

    final jobCreate = JobCreate(
      title: job.title,
      description: job.description,
      requirements: job.requirements,
      responsibilities: job.responsibilities,
      benefits: job.benefits,
      skills: job.skills,
      company: job.company?.id ?? 0,
      category: job.category?.id,
      jobType: job.jobType,
      experienceLevel: job.experienceLevel,
      educationLevel: job.educationLevel,
      city: job.city,
      salaryMin: job.salaryMin,
      salaryMax: job.salaryMax,
      isSalaryNegotiable: job.isSalaryNegotiable,
      applicationDeadline: job.applicationDeadline,
      contactEmail: job.contactEmail,
      contactPhone: job.contactPhone,
      isFeatured: job.isFeatured,
      isUrgent: job.isUrgent,
    );

    controller.updateJob(job.slug, jobCreate).then((success) {
      if (success) {
        controller.loadJobDetail(slug);
      }
    });
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // Widget _buildEmployerActions(JobDetail job) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: ElevatedButton.icon(
  //           onPressed: () {
  //              final jobList = JobList(
  //               id: job.id,
  //               title: job.title,
  //               slug: job.slug,
  //               jobType: job.jobType,
  //               experienceLevel: job.experienceLevel,
  //               city: job.city,
  //             );
  //             Get.to(() => CreateJobScreen(job: jobList));
  //           },
  //           icon: const Icon(Icons.edit, color: Colors.white),
  //           label: const Text('تعديل', style: TextStyle(color: Colors.white)),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 16),
  //       Expanded(
  //         child: ElevatedButton.icon(
  //           onPressed: () {
  //              Get.defaultDialog(
  //               title: 'حذف الوظيفة',
  //               middleText: 'هل أنت متأكد من رغبتك في حذف هذه الوظيفة؟',
  //               textConfirm: 'حذف',
  //               textCancel: 'إلغاء',
  //               confirmTextColor: Colors.white,
  //               buttonColor: Colors.red,
  //               onConfirm: () {
  //                 if (job.slug.isNotEmpty) {
  //                   controller.deleteJob(job.slug);
  //                   Get.back(); // Close dialog
  //                   Get.back(); // Go back to list
  //                 }
  //               },
  //             );
  //           },
  //           icon: const Icon(Icons.delete, color: Colors.white),
  //           label: const Text('حذف', style: TextStyle(color: Colors.white)),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.red,
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildAiSummarySection(String summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.05),
            Colors.purple.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, size: 20, color: Colors.blue[700]),
              ),
              const SizedBox(width: 12),
              Text(
                'ملخص الوظيفة بالذكاء الاصطناعي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
              height: 1.7,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    if (skill.isEmpty) return const SizedBox.shrink();
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(fontSize: 13, color: AppColors.primaryColor),
      ),
      backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.2)),
      ),
    );
  }

  String _getButtonText(JobDetail job, bool isDeadlinePassed) {
    if (isDeadlinePassed) return 'انتهى التقديم';
    
    switch (job.applicationMethod) {
      case 'external_link':
        return 'التقديم عبر رابط خارجي';
      case 'email':
        return 'التقديم عبر البريد';
      case 'template_file':
        return 'تحميل ملف التقديم';
      case 'custom_form':
        return 'بدء الاستبيان';
      default:
        return 'التقديم الآن';
    }
  }

  void _handleApplication(JobDetail job) async {
    switch (job.applicationMethod) {
      case 'external_link':
        if (job.externalApplicationUrl != null) {
          print('Opening external link: ${job.externalApplicationUrl}');
          Get.snackbar('رابط خارجي', 'سيتم فتح: ${job.externalApplicationUrl}');
        }
        break;
      case 'email':
        if (job.applicationEmail != null) {
          final email = job.applicationEmail!;
          print('Sending email to: $email');
           Get.snackbar('بريد إلكتروني', 'سيتم إرسال بريد إلى: $email');
        }
        break;
      case 'custom_form':
         Get.snackbar('استبيان مخصص', 'سيتم فتح الاستبيان الخاص بالشركة');
        break;
      default:
        if (job.id != null) {
          Get.toNamed(AppRoutes.applyJob, arguments: {
            'jobId': job.id,
            'jobTitle': job.title,
          });
        }
    }
  }
}
