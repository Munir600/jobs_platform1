import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_platform1/core/constants.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/utils/network_utils.dart';
import '../companies/MyCompaniesScreen.dart';
import '../jobs/CreateJobScreen.dart';
import 'employer_profile/EmployerProfileScreen.dart';
import 'employer_profile/dashboard.dart';
import 'jobseeker_profile/JobSeekerProfileScreen.dart';
import 'jobseeker_profile/jobseeker_profile_screen.dart';
import '../../widgets/custom_text_field.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AccountController controller = Get.put(AccountController());
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _bioCtrl;

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initControllers();
    // Listen to changes to update text controllers
    ever(controller.currentUser, (_) => _updateControllers());
  }

  void _initControllers() {
    final user = controller.currentUser.value;
    _firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: user?.lastName ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _dobCtrl = TextEditingController(text: user?.dateOfBirth ?? '');
    _locationCtrl = TextEditingController(text: user?.location ?? '');
    _bioCtrl = TextEditingController(text: user?.bio ?? '');
  }

  void _updateControllers() {
    final user = controller.currentUser.value;
    if (user != null) {
      _firstNameCtrl.text = user.firstName;
      _lastNameCtrl.text = user.lastName;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phone;
      _dobCtrl.text = user.dateOfBirth ?? '';
      _locationCtrl.text = user.location ?? '';
      _bioCtrl.text = user.bio ?? '';
    }
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    DateTime initial = DateTime.tryParse(_dobCtrl.text) ?? DateTime(1995, 1, 1);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _dobCtrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _submit() async {
    final hasInternet = await NetworkUtils.checkInternet(context);
    if (!hasInternet) return;
    if (_formKey.currentState!.validate()) {
      final data = {
        'first_name': _firstNameCtrl.text,
        'last_name': _lastNameCtrl.text,
        'email': _emailCtrl.text,
        'phone': _phoneCtrl.text,
        'date_of_birth': _dobCtrl.text,
        'location': _locationCtrl.text,
        'bio': _bioCtrl.text,
      };

      controller.updateGeneralProfile(data, profilePicture: _avatarFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Center(child: const Text('الملف الشخصي', style: TextStyle(color: AppColors.textColor))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout, color: Colors.red),
        //     onPressed: () => authController.logout(),
        //   ),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.currentUser.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        final user = controller.currentUser.value;
        if (user == null) return const Center(child: Text('لا توجد بيانات'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Section
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: ClipOval(
                      child: _avatarFile != null
                          ? Image.file(_avatarFile!, fit: BoxFit.cover)
                          : (user.profilePicture != null
                              ? Image.network(
                                  user.profilePicture!.startsWith('http')
                                      ? user.profilePicture!
                                      : AppConstants.baseUrl + user.profilePicture!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/Logo4.png', fit: BoxFit.cover);
                                  },
                                )
                              : Image.asset('assets/images/Logo4.png', fit: BoxFit.cover)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
              ),

              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المعلومات الشخصية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildTextField(_firstNameCtrl, 'الاسم الأول'),
                    const SizedBox(height: 16),
                    _buildTextField(_lastNameCtrl, 'الاسم الأخير'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailCtrl, 'البريد الإلكتروني'),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneCtrl, 'رقم الهاتف'),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _pickDateOfBirth(context),
                      child: AbsorbPointer(
                        child: _buildTextField(_dobCtrl, 'تاريخ الميلاد'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_locationCtrl, 'الموقع / المدينة'),
                    const SizedBox(height: 16),
                    _buildTextField(_bioCtrl, 'نبذة عني', maxLines: 4),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('حفظ التغييرات', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, {Color color = Colors.white, Color textColor = AppColors.textColor}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor == Colors.white ? Colors.white : AppColors.primaryColor),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: color == Colors.white ? const BorderSide(color: AppColors.primaryColor) : BorderSide.none,
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return CustomTextField(
      controller: controller,
      labelText: label,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
    );
  }
}
