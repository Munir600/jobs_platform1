import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/company/Company.dart';
import '../../../core/constants.dart';
import '../../../core/utils/contact_utils.dart';


class CompanyDetailScreen extends GetView<CompanyController> {
  final Company company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    // Load related data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(company.id != null) {
        controller.loadCompanyReviews(company.id!);
        //controller.loadCompanyJobs(company.id!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyInfo(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('نبذة عن الشركة'),
                  Text(
                    company.description ?? 'لا يوجد وصف متاح',
                    style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('تفاصيل الشركة'),
                  const SizedBox(height: 12),
                  _buildDetailsGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('معلومات التواصل'),
                  const SizedBox(height: 12),
                  _buildContactInfo(),
                  const SizedBox(height: 20),
                Text('جميع الحقوق محفوظة © ${DateTime.now().year}', style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: company.coverImage != null
            ? Image.network(company.coverImage!, fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.primaryColor,
              alignment: Alignment.center,
              child: const Text(
                'صورة غلاف الشركة غير متوفرة',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        )
            : Container(color: AppColors.primaryColor),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () => controller.followCompany(company.id!),
        ),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: company.logo != null
                ? Image.network(
                    company.logo!.startsWith('http') ? company.logo! : AppConstants.baseUrl + company.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.business, size: 40, color: Colors.grey);
                    },
                  )
                : const Icon(Icons.business, size: 40, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company.name ?? 'اسم الشركة',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
              ),
              const SizedBox(height: 4),
              Text(
                company.industry != null ? AppEnums.industries[company.industry] ?? company.industry! : 'قطاع غير محدد',
                style: TextStyle(fontSize: 16, color: AppColors.textColor.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
    );
  }

  Widget _buildDetailsGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildDetailItem(Icons.calendar_today, 'سنة التأسيس', company.foundedYear?.toString() ?? 'غير معروف'),
          _buildDetailItem(Icons.people, 'عدد الموظفين', company.employeesCount?.toString() ?? 'غير معروف'),
          _buildDetailItem(Icons.business_center, 'حجم الشركة', AppEnums.companySizes[company.size] ?? company.size ?? 'غير محدد'),
          _buildDetailItem(Icons.location_city, 'الدولة', company.country ?? 'غير محدد'),
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
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        if (company.website != null)
          _buildContactItem1(Icons.language, 'الموقع الإلكتروني', company.website!),
        if (company.email != null)
          _buildContactItem1(Icons.email, 'البريد الإلكتروني', company.email!),
        if (company.phone != null)
          _buildContactItem1(Icons.phone, 'رقم الهاتف', company.phone!),
        if (company.city != null || company.address != null)
          _buildContactItem(Icons.location_on, 'العنوان', '${AppEnums.cities[company.city] ?? company.city ?? ''} ${company.address != null ? ' - ${company.address}' : ''}'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // for url
  Widget _buildContactItem1(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => ContactUtils.handleContactAction(value),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Icon(icon, size: 20, color: AppColors.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




}
