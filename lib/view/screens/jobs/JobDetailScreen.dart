import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobs_platform1/routes/app_routes.dart';
import '../../../controllers/job/JobController.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../config/app_colors.dart';
import '../../../core/utils/contact_utils.dart';
import '../../../controllers/application/ApplyJobController.dart';
import '../../../data/models/application/JobApplicationCreate.dart';
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
  final applyController = Get.put(ApplyJobController());
  late String slug;

  @override
  void initState() {
    super.initState();
    slug = widget.jobSlug;

    if (slug.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.loadJobDetail(slug);
        if (controller.currentJob.value != null) {
          applyController.setupJob(controller.currentJob.value!);
        }
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
                    children: job.skills!
                        .split(RegExp(r'[،,.\n]'))
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .map((s) => _buildSkillChip(s))
                        .toList(),
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

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: ( isDeadlinePassed) ? null : () {
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
                      ),
                    ],
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
    return 'التقديم الآن';
  }

  void _handleApplication(JobDetail job) async {
    applyController.setupJob(job);
    Get.toNamed(AppRoutes.applyJob, arguments: job);
  }
}
