import 'dart:io'; // Added
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // Added
import 'package:get/get.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../core/constants.dart';
import '../../../core/utils/network_utils.dart';
import '../../../data/models/company/Company.dart';
import '../../../data/models/company/CompanyCreate.dart';
import '../../widgets/custom_text_field.dart';

class CreateCompanyScreen extends StatefulWidget {
  final Company? company;

  const CreateCompanyScreen({super.key, this.company});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final CompanyController controller = Get.find<CompanyController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController foundedYearController;
  late TextEditingController employeesCountController;

  String? selectedCity;
  String? selectedIndustry;
  String? selectedSize;

  File? _logoFile;
  File? _coverImageFile;
  String? _logoUrl;
  String? _coverImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    nameController = TextEditingController(text: c?.name ?? '');
    descriptionController = TextEditingController(text: c?.description ?? '');
    emailController = TextEditingController(text: c?.email ?? '');
    websiteController = TextEditingController(text: c?.website ?? '');
    phoneController = TextEditingController(text: c?.phone ?? '');
    addressController = TextEditingController(text: c?.address ?? '');
    _logoUrl = c?.logo;
    _coverImageUrl = c?.coverImage;
    foundedYearController = TextEditingController(text: c?.foundedYear?.toString() ?? '');
    employeesCountController = TextEditingController(text: c?.employeesCount?.toString() ?? '');

    // Map values back to keys
    if (c?.city != null) {
      selectedCity = AppEnums.cities.entries
          .firstWhere((e) => e.value == c!.city || e.key == c.city, orElse: () => const MapEntry('', ''))
          .key;
      if (selectedCity!.isEmpty) selectedCity = null;
    }
    
    if (c?.industry != null) {
      selectedIndustry = AppEnums.industries.entries
          .firstWhere((e) => e.value == c!.industry || e.key == c.industry, orElse: () => const MapEntry('', ''))
          .key;
      if (selectedIndustry!.isEmpty) selectedIndustry = null;
    }

    if (c?.size != null) {
      selectedSize = AppEnums.companySizes.entries
          .firstWhere((e) => e.value == c!.size || e.key == c.size, orElse: () => const MapEntry('', ''))
          .key;
      if (selectedSize!.isEmpty) selectedSize = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.company != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل الشركة' : 'إنشاء شركة جديدة', style: const TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('المعلومات الأساسية'),
              _buildTextField(nameController, 'اسم الشركة', validator: (v) => v!.isEmpty ? 'مطلوب' : null, inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FFa-zA-Z\s]')),
              ]),
              const SizedBox(height: 16),
              _buildTextField(descriptionController, 'وصف الشركة', maxLines: 4, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
              const SizedBox(height: 16),
              _buildDropdown('القطاع', AppEnums.industries, selectedIndustry, (v) => setState(() => selectedIndustry = v)),
              const SizedBox(height: 16),
              _buildDropdown('حجم الشركة', AppEnums.companySizes, selectedSize, (v) => setState(() => selectedSize = v)),
              const SizedBox(height: 16),
              _buildSectionTitle('معلومات الاتصال والموقع'),
              _buildDropdown('المدينة', AppEnums.cities, selectedCity, (v) => setState(() => selectedCity = v)),
              const SizedBox(height: 16),
              _buildTextField(emailController, 'البريد الإلكتروني', validator: (v) => v!.isEmpty ? 'مطلوب' : null),
              const SizedBox(height: 16),
              _buildTextField(phoneController, 'رقم الهاتف'),
              const SizedBox(height: 16),
              _buildTextField(addressController, 'العنوان التفصيلي'),
              const SizedBox(height: 16),
              _buildTextField(websiteController, 'الموقع الإلكتروني'),
              const SizedBox(height: 16),
              _buildSectionTitle('معلومات إضافية'),
              Row(
                children: [
                  Expanded(child: _buildTextField(foundedYearController, 'سنة التأسيس', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(employeesCountController, 'عدد الموظفين', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              _buildImagePicker(
                label: 'شعار الشركة',
                imageFile: _logoFile,
                imageUrl: _logoUrl,
                onTap: () => _pickImage(true),
              ),
              const SizedBox(height: 16),
              _buildImagePicker(
                label: 'صورة الغلاف',
                imageFile: _coverImageFile,
                imageUrl: _coverImageUrl,
                onTap: () => _pickImage(false),
                isCover: true, // Optional styling for cover
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
                      : Text(isEdit ? 'حفظ التعديلات' : 'إنشاء الشركة', style: const TextStyle(color: Colors.white, fontSize: 18)),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(bool isLogo) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (isLogo) {
          _logoFile = File(picked.path);
        } else {
          _coverImageFile = File(picked.path);
        }
      });
    }
  }

  Widget _buildImagePicker({
    required String label,
    File? imageFile,
    String? imageUrl,
    required VoidCallback onTap,
    bool isCover = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: isCover ? 150 : 100,
            width: isCover ? double.infinity : 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
              image: imageFile != null
                  ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
                  : (imageUrl != null && imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl.startsWith('http') ? imageUrl : AppConstants.baseUrl + imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null),
            ),
            child: (imageFile == null && (imageUrl == null || imageUrl.isEmpty))
                ? Icon(Icons.add_a_photo, color: Colors.grey[600], size: 30)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator, List<TextInputFormatter>? inputFormatters}) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdown(String label, Map<String, String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'مطلوب' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _submit() async {
    final hasInternet = await NetworkUtils.checkInternet(context);
    if (!hasInternet) return;
    if (_formKey.currentState!.validate()) {
      // Auto-correct website URL
      String website = websiteController.text.trim();
      if (website.isNotEmpty && !website.startsWith('http://') && !website.startsWith('https://')) {
        website = 'https://$website';
        websiteController.text = website; // Optional: update UI
      }

      final companyCreate = CompanyCreate(
        name: nameController.text,
        description: descriptionController.text,
        email: emailController.text,
        city: selectedCity!,
        industry: selectedIndustry!,
        size: selectedSize!,
        website: website.isNotEmpty ? website : null,
        phone: phoneController.text.isNotEmpty ? phoneController.text : null,
        address: addressController.text.isNotEmpty ? addressController.text : null,
        logo: null, 
        coverImage: null, 
        foundedYear: int.tryParse(foundedYearController.text),
        employeesCount: int.tryParse(employeesCountController.text),
        country: 'Yemen',
      );

      bool success;
      if (widget.company != null) {
        success = await controller.updateCompany(
          widget.company!.slug!, 
          companyCreate, 
          logo: _logoFile, 
          coverImage: _coverImageFile
        );
      } else {
        success = await controller.createCompany(
          companyCreate, 
          logo: _logoFile, 
          coverImage: _coverImageFile
        );
      }

      // if (success) {
      //   Get.back(result: true); // Return success result
      // }
    }
  }
}
