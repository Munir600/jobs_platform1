import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../controllers/company/FollowedCompaniesController.dart';
import '../../widgets/companies/CompanyCard.dart';
import '../../widgets/common/PaginationControls.dart';
import '../../widgets/companies/PaginationControlsEmployee.dart';

class FollowedCompaniesScreen extends GetView<FollowedCompaniesController> {
  const FollowedCompaniesScreen({super.key});

  // final FollowedCompaniesController controller = Get.put(
  //     FollowedCompaniesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
            'الشركات المتابعة', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () => _showSearchDialog(context),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   onPressed: () => _showFilterBottomSheet(context),
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.followedCompanies.isEmpty) {
                return const Center(child: CircularProgressIndicator(
                    color: AppColors.primaryColor));
              }

              if (controller.hasError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        controller.hasError.value,
                        style: const TextStyle(color: AppColors.textColor,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshList,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('تحديث'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.followedCompanies.isEmpty) {
                return const Center(
                  child: Text(
                    'لا تتابع أي شركات حالياً',
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshList,
                color: AppColors.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: controller.followedCompanies.length,
                  itemBuilder: (context, index) {
                    final companyFollower = controller.followedCompanies[index];
                    // Ensure we have a company object to display
                    if (companyFollower.company == null)
                      return const SizedBox.shrink();

                    return CompanyCard(
                      company: companyFollower.company!,
                      showControls: false,
                    );
                  },
                ),
              );
            }),
          ),

          // Pagination Controls
          Obx(() =>
          controller.followedCompanies.isNotEmpty
              ? PaginationControlsEmployee(
            currentPage: controller.currentPage.value,
            totalPages: controller.totalPages.value,
            onPageChanged: controller.loadPage,
            isLoading: controller.isLoading.value,
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
  //
  // void _showSearchDialog(BuildContext context) {
  //   final TextEditingController searchController = TextEditingController(
  //     text: controller.searchQuery.value,
  //   );
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) =>
  //         AlertDialog(
  //           backgroundColor: AppColors.accentColor,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20)),
  //           title: const Text(
  //             'البحث عن شركة',
  //             style: TextStyle(
  //                 color: AppColors.textColor, fontWeight: FontWeight.bold),
  //           ),
  //           content: TextField(
  //             controller: searchController,
  //             autofocus: true,
  //             decoration: InputDecoration(
  //               hintText: 'ابحث عن شركة...',
  //               prefixIcon: const Icon(
  //                   Icons.search, color: AppColors.primaryColor),
  //               filled: true,
  //               fillColor: Colors.white,
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(15),
  //                 borderSide: BorderSide.none,
  //               ),
  //               contentPadding: const EdgeInsets.symmetric(
  //                   horizontal: 20, vertical: 15),
  //             ),
  //             onSubmitted: (value) {
  //               controller.setSearchQuery(value);
  //               Get.back();
  //             },
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 searchController.clear();
  //                 controller.setSearchQuery('');
  //                 Get.back();
  //               },
  //               child: const Text('مسح', style: TextStyle(color: Colors.grey)),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 controller.setSearchQuery(searchController.text);
  //                 Get.back();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColors.primaryColor,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10)),
  //               ),
  //               child: const Text('بحث', style: TextStyle(color: Colors.white)),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  // void _showFilterBottomSheet(BuildContext context) {
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: const BoxDecoration(
  //         color: AppColors.accentColor,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'تصفية الشركات',
  //               style: TextStyle(fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.textColor),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildDropdownFilter(
  //               'المدينة',
  //               controller.selectedCity.value,
  //               AppEnums.cities,
  //                   (val) => controller.setFilters(city: val),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildDropdownFilter(
  //               'القطاع',
  //               controller.selectedIndustry.value,
  //               AppEnums.industries,
  //                   (val) => controller.setFilters(industry: val),
  //             ),
  //             const SizedBox(height: 16),
  //             _buildDropdownFilter(
  //               'حجم الشركة',
  //               controller.selectedSize.value,
  //               AppEnums.companySizes,
  //                   (val) => controller.setFilters(size: val),
  //             ),
  //             const SizedBox(height: 24),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   controller.clearFilters();
  //                   Get.back();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.grey[200],
  //                   foregroundColor: AppColors.textColor,
  //                 ),
  //                 child: const Text('مسح التصفيات'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDropdownFilter(String label, String currentValue,
  //     Map<String, String> items, Function(String?) onChanged) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: const TextStyle(
  //           fontWeight: FontWeight.bold, color: AppColors.textColor)),
  //       const SizedBox(height: 8),
  //       DropdownButtonFormField<String>(
  //         value: currentValue.isNotEmpty ? currentValue : null,
  //         items: items.entries.map((e) =>
  //             DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
  //         onChanged: onChanged,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //           contentPadding: const EdgeInsets.symmetric(
  //               horizontal: 12, vertical: 8),
  //         ),
  //         hint: Text('اختر $label'),
  //       ),
  //     ],
  //   );
  // }
}
