import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/account/AccountController.dart';
import '../../../../core/constants.dart';
import '../../../widgets/custom_text_field.dart';

class EmployerProfileScreen extends GetView<AccountController> {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmployerProfileView();
  }
}

class _EmployerProfileView extends StatefulWidget {
  const _EmployerProfileView();

  @override
  State<_EmployerProfileView> createState() => _EmployerProfileViewState();
}

class _EmployerProfileViewState extends State<_EmployerProfileView> {
  final AccountController controller = Get.find<AccountController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController companyNameCtrl;
  late TextEditingController companyDescriptionCtrl;
  late TextEditingController companyWebsiteCtrl;
  late TextEditingController foundedYearCtrl;

  String? selectedSize;
  String? selectedIndustry;
  
  // Reactive file for logo
  final Rx<File?> _logoFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final profile = controller.employerProfile.value;
    companyNameCtrl = TextEditingController(text: profile?.companyName ?? '');
    companyDescriptionCtrl = TextEditingController(text: profile?.companyDescription ?? '');
    companyWebsiteCtrl = TextEditingController(text: profile?.companyWebsite ?? '');
    foundedYearCtrl = TextEditingController(text: profile?.foundedYear?.toString() ?? '');

    selectedSize = profile?.companySize;
    selectedIndustry = profile?.industry;

    // Validate enum values against current constants
    if (selectedSize != null && !AppEnums.companySizes.containsKey(selectedSize)) {
      if (selectedSize!.isNotEmpty) {
        // Try to find matching value or default to null
        final entry = AppEnums.companySizes.entries.firstWhere(
            (e) => e.value == selectedSize,
            orElse: () => const MapEntry('', ''));
        selectedSize = entry.key.isNotEmpty ? entry.key : null;
      } else {
         selectedSize = null;
      }
    }

    if (selectedIndustry != null && !AppEnums.industries.containsKey(selectedIndustry)) {
      if (selectedIndustry!.isNotEmpty) {
        final entry = AppEnums.industries.entries.firstWhere(
            (e) => e.value == selectedIndustry,
            orElse: () => const MapEntry('', ''));
        selectedIndustry = entry.key.isNotEmpty ? entry.key : null;
      } else {
        selectedIndustry = null;
      }
    }
  }

  Future<void> _pickLogo() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      _logoFile.value = File(picked.path);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      String website = companyWebsiteCtrl.text.trim();
      if (website.isNotEmpty && !website.startsWith('http://') && !website.startsWith('https://')) {
        website = 'https://$website';
        companyWebsiteCtrl.text = website;
      }

      final data = {
        'company_name': companyNameCtrl.text,
        'company_description': companyDescriptionCtrl.text,
        'company_website': website,
        'company_size': selectedSize,
        'industry': selectedIndustry,
        'founded_year': int.tryParse(foundedYearCtrl.text),
      };

      // Clean nullable fields
      data.removeWhere((key, value) => value == null || (value is String && value.isEmpty));

      controller.updateEmployerProfile(data, companyLogo: _logoFile.value).then((success) {
        if (success) {
         // Get.back();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(' بيانات الشركة الاساسية', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Logo Section
              Center(
                child: GestureDetector(
                  onTap: _pickLogo,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
                    ),
                    child: ClipOval(
                      child: Obx(() {
                        if (_logoFile.value != null) {
                          return Image.file(_logoFile.value!, fit: BoxFit.cover);
                        }
                        
                        // Use string interpolation if calling nested properties carefully or use a local final var
                        final profile = controller.employerProfile.value;
                        if (profile?.companyLogo != null && profile!.companyLogo!.isNotEmpty) {
                          return Image.network(
                            profile.companyLogo!.startsWith('http')
                                ? profile.companyLogo!
                                : AppConstants.baseUrl + profile.companyLogo!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.business, size: 40, color: Colors.grey),
                          );
                        }
                        return const Icon(Icons.camera_alt, size: 40, color: Colors.grey);
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('تغيير شعار الشركة', style: TextStyle(color: AppColors.primaryColor)),
              const SizedBox(height: 24),

              _buildTextField(
                companyNameCtrl, 
                'اسم الشركة *', 
                validator: (v) => v!.isEmpty ? 'اسم الشركة مطلوب' : null
              ),
              const SizedBox(height: 16),
              
              _buildTextField(companyDescriptionCtrl, 'وصف الشركة', maxLines: 4),
              const SizedBox(height: 16),
              
              _buildDropdown(
                'القطاع', 
                AppEnums.industries, 
                selectedIndustry, 
                (v) => setState(() => selectedIndustry = v)
              ),
              const SizedBox(height: 16),
              
              _buildDropdown(
                'حجم الشركة', 
                AppEnums.companySizes, 
                selectedSize, 
                (v) => setState(() => selectedSize = v)
              ),
              const SizedBox(height: 16),
              
              _buildTextField(companyWebsiteCtrl, 'الموقع الإلكتروني'),
              const SizedBox(height: 16),
              
              _buildTextField(
                foundedYearCtrl, 
                'سنة التأسيس', 
                keyboardType: TextInputType.number,
                validator: (v) {
                   if (v != null && v.isNotEmpty) {
                     final year = int.tryParse(v);
                     if (year == null || year < 1800 || year > DateTime.now().year) {
                       return 'يرجى إدخال سنة صحيحة';
                     }
                   }
                   return null;
                }
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('حفظ التغييرات', style: TextStyle(color: Colors.white, fontSize: 18)),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    {int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator}
  ) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown(String label, Map<String, String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
