// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../config/app_colors.dart';
// import '../../../../controllers/account/AccountController.dart';
// import '../../../../core/constants.dart';
// import '../../../widgets/custom_text_field.dart';
//
// class EmployerProfileScreen extends StatefulWidget {
//   const EmployerProfileScreen({super.key});
//
//   @override
//   State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
// }
//
// class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
//   final AccountController controller = Get.find<AccountController>();
//   final _formKey = GlobalKey<FormState>();
//
//   late TextEditingController companyNameCtrl;
//   late TextEditingController companyDescriptionCtrl;
//   late TextEditingController companyWebsiteCtrl;
//   late TextEditingController foundedYearCtrl;
//
//   String? selectedSize;
//   String? selectedIndustry;
//   File? _logoFile;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     final profile = controller.employerProfile.value;
//     companyNameCtrl = TextEditingController(text: profile?.companyName ?? '');
//     companyDescriptionCtrl = TextEditingController(text: profile?.companyDescription ?? '');
//     companyWebsiteCtrl = TextEditingController(text: profile?.companyWebsite ?? '');
//     foundedYearCtrl = TextEditingController(text: profile?.foundedYear?.toString() ?? '');
//
//     selectedSize = profile?.companySize;
//     selectedIndustry = profile?.industry;
//
//     // Map enums if needed (similar to previous fix)
//     if (selectedSize != null && !AppEnums.companySizes.containsKey(selectedSize)) {
//        selectedSize = AppEnums.companySizes.entries
//           .firstWhere((e) => e.value == selectedSize, orElse: () => const MapEntry('', ''))
//           .key;
//        if (selectedSize!.isEmpty) selectedSize = null;
//     }
//
//     if (selectedIndustry != null && !AppEnums.industries.containsKey(selectedIndustry)) {
//        selectedIndustry = AppEnums.industries.entries
//           .firstWhere((e) => e.value == selectedIndustry, orElse: () => const MapEntry('', ''))
//           .key;
//        if (selectedIndustry!.isEmpty) selectedIndustry = null;
//     }
//   }
//
//   Future<void> _pickLogo() async {
//     final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _logoFile = File(picked.path);
//       });
//     }
//   }
//
//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       final data = {
//         'company_name': companyNameCtrl.text,
//         'company_description': companyDescriptionCtrl.text,
//         'company_website': companyWebsiteCtrl.text,
//         'company_size': selectedSize,
//         'industry': selectedIndustry,
//         'founded_year': int.tryParse(foundedYearCtrl.text),
//       };
//
//       controller.updateEmployerProfile(data, companyLogo: _logoFile).then((success) {
//         if (success) Get.back();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text('بيانات الشركة', style: TextStyle(color: AppColors.textColor)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: AppColors.textColor),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickLogo,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: _logoFile != null
//                       ? FileImage(_logoFile!)
//                       : (controller.employerProfile.value?.companyLogo != null
//                           ? NetworkImage(controller.employerProfile.value!.companyLogo!.startsWith('http')
//                               ? controller.employerProfile.value!.companyLogo!
//                               : AppConstants.baseUrl + controller.employerProfile.value!.companyLogo!)
//                           : null) as ImageProvider?,
//                   child: _logoFile == null && controller.employerProfile.value?.companyLogo == null
//                       ? const Icon(Icons.business, size: 40, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text('تغيير الشعار', style: TextStyle(color: AppColors.primaryColor)),
//               const SizedBox(height: 24),
//
//               _buildTextField(companyNameCtrl, 'اسم الشركة', validator: (v) => v!.isEmpty ? 'مطلوب' : null),
//               const SizedBox(height: 16),
//               _buildTextField(companyDescriptionCtrl, 'وصف الشركة', maxLines: 4),
//               const SizedBox(height: 16),
//               _buildDropdown('القطاع', AppEnums.industries, selectedIndustry, (v) => setState(() => selectedIndustry = v)),
//               const SizedBox(height: 16),
//               _buildDropdown('حجم الشركة', AppEnums.companySizes, selectedSize, (v) => setState(() => selectedSize = v)),
//               const SizedBox(height: 16),
//               _buildTextField(companyWebsiteCtrl, 'الموقع الإلكتروني'),
//               const SizedBox(height: 16),
//               _buildTextField(foundedYearCtrl, 'سنة التأسيس', keyboardType: TextInputType.number),
//               const SizedBox(height: 32),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: Obx(() => ElevatedButton(
//                   onPressed: controller.isLoading.value ? null : _submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('حفظ التغييرات', style: TextStyle(color: Colors.white, fontSize: 18)),
//                 )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator}) {
//     return CustomTextField(
//       controller: controller,
//       labelText: label,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       validator: validator,
//     );
//   }
//
//   Widget _buildDropdown(String label, Map<String, String> items, String? value, Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         contentPadding: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }
