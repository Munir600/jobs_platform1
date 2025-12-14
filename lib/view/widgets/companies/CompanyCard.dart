import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/company/Company.dart';
import '../../screens/companies/CompanyDetailScreen.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  final bool showControls;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CompanyCard({
    super.key,
    required this.company,
    this.showControls = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accentColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Get.to(() => CompanyDetailScreen(company: company)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: company.logo != null
                          ? Image.network(
                              company.logo!.startsWith('http')
                                  ? company.logo!
                                  : AppConstants.baseUrl + company.logo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.business,
                                    color: Colors.grey, size: 30);
                              },
                            )
                          : const Icon(Icons.business,
                              color: Colors.grey, size: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                company.name ?? 'اسم الشركة',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (company.totalJobs ?? 0) > 0
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (company.totalJobs ?? 0) > 0
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.grey[400]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),

                                ],
                              ),
                              child: Text(
                                '${company.activeJobs} وظيفة',
                                style: TextStyle(
                                  color: (company.totalJobs ?? 0) > 0
                                      ? Colors.green
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (company.averageRating ?? 0) > 0
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                  color: (company.averageRating ?? 0) > 0
                                      ? Colors.orange.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),

                                ],

                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    '${company.averageRating != null ? company.averageRating!.toStringAsFixed(1) : '0'} ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(Icons.star,
                                      size: 14, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company.industry != null
                              ? AppEnums.industries[company.industry] ??
                                  company.industry!
                              : 'قطاع غير محدد',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          company.description != null
                              ? company.description!
                              : 'وصف الشركة غير متوفر',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (company.activeJobs ?? 0) > 0
                                ? Colors.green
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (company.totalJobs ?? 0) > 0
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.grey[400]!,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),

                            ],
                          ),
                          child: Text(
                            '${company.activeJobs} وظيفة نشطة',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showControls) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit,
                          size: 18, color: AppColors.primaryColor),
                      label: const Text('تعديل',
                          style: TextStyle(color: AppColors.primaryColor)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete,
                          size: 18, color: Colors.red),
                      label:
                          const Text('حذف', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
