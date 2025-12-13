import 'package:flutter/material.dart';
import '../../widgets/companies/CompanyCard.dart';
import 'package:get/get.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/company/Company.dart';
import 'CompanyDetailScreen.dart';

class CompanyListScreen extends GetView<CompanyController> {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الشركات', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => controller.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'بحث عن شركة...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
              }

              if (controller.companies.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد شركات مطابقة للبحث',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadCompanies,
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.companies.length,
                  itemBuilder: (context, index) {
                    final company = controller.companies[index];
                    return CompanyCard(
                      company: company,
                      showControls: false,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تصفية الشركات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'المدينة',
                controller.selectedCity.value,
                AppEnums.cities,
                (val) => controller.setFilters(city: val),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'القطاع',
                controller.selectedIndustry.value,
                AppEnums.industries,
                (val) => controller.setFilters(industry: val),
              ),
              const SizedBox(height: 16),
              _buildDropdownFilter(
                'حجم الشركة',
                controller.selectedSize.value,
                AppEnums.companySizes,
                (val) => controller.setFilters(size: val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.clearFilters();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: AppColors.textColor,
                  ),
                  child: const Text('مسح التصفيات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String label, String currentValue, Map<String, String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentValue.isNotEmpty ? currentValue : null,
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: Text('اختر $label'),
        ),
      ],
    );
  }
}
