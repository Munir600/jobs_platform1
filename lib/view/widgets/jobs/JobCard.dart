import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/job/JobList.dart';
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

    // Extract salary info
    String salaryText = '';
    if (job.salaryMin != null || job.salaryMax != null) {
      if (job.salaryMin != null && job.salaryMax != null) {
        salaryText = '💰 ${job.salaryMin}-${job.salaryMax} ريال/شهر';
      } else if (job.salaryMin != null) {
        salaryText = '💰 من ${job.salaryMin} ريال/شهر';
      } else {
        salaryText = '💰 حتى ${job.salaryMax} ريال/شهر';
      }
    } else if (job.isSalaryNegotiable == true) {
      salaryText = '💰 قابل للتفاوض';
    }

    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.to(() => JobDetailScreen(jobSlug: job.slug));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with urgent badge
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
                  if (job.isUrgent == true)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text(
                        'عاجل',
                        style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              
              // Company name
              Text(
                job.company?.name ?? 'اسم الشركة',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              
              // Location, Salary, Type, Date in a wrap
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    '📍 ${job.city != null ? AppEnums.cities[job.city] ?? job.city! : 'غير محدد'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (salaryText.isNotEmpty)
                    Text(salaryText, style: const TextStyle(fontSize: 13)),
                  Text(
                    job.jobType != null ? AppEnums.jobTypes[job.jobType] ?? job.jobType! : 'غير محدد',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(timeAgo, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              
              // Description preview
              if (job.description != null && job.description!.isNotEmpty)
                Text(
                  job.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
              const SizedBox(height: 8),
              
              // Skills/Requirements as tags
              if (job.requirements != null && job.requirements!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _buildSkillTags(job.requirements!),
                ),
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onApply ?? () {
                      Get.to(() => JobDetailScreen(jobSlug: job.slug));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تقديم الآن'),
                  ),
                  OutlinedButton(
                    onPressed: onBookmark,
                    child: Text(
                      job.isBookmarked == true ? 'محفوظة' : 'حفظ',
                    ),
                  ),
                  IconButton(
                    onPressed: onShare ?? () {
                      Get.snackbar('مشاركة', 'سيتم إضافة وظيفة المشاركة قريباً');
                    },
                    icon: const Icon(Icons.share_outlined),
                  ),
                ],
              ),
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
}
