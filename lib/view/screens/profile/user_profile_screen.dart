import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_platform1/core/constants.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../data/models/user_models.dart';
import '../companies/MyCompaniesScreen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>{
  final _formKey = GlobalKey<FormState>();
  late final AuthController auth;
  final GetStorage _storage = GetStorage();
  // Controllers
  final TextEditingController _firstNameCtrl =
  TextEditingController();
  final TextEditingController _lastNameCtrl =
  TextEditingController();
  final TextEditingController _userType =
  TextEditingController();
  final TextEditingController _emailCtrl =
  TextEditingController();
  final TextEditingController _phoneCtrl =
  TextEditingController();
  final TextEditingController _dobCtrl =
  TextEditingController();
  String? _profile_picture ='';
  final TextEditingController _location =
  TextEditingController(text: 'صنعاء') ;
  final TextEditingController _bioCtrl = TextEditingController(
      text:
      'مطور برمجيات متخصص في تطوير تطبيقات الويب باستخدام JavaScript وReact. لدي خبرة 3 سنوات في العمل مع فرق التطوير وإنجاز المشاريع في الوقت المحدد.'
  );
  bool _is_verified =false;

  var _created_at ='';
  // Avatar
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    auth = Get.find<AuthController>();
    _loadUserData();
  }
  void _loadUserData() {
    final userData = _storage.read('user_data');
    if (userData == null) {
      print('لا توجد بيانات مستخدم محفوظة في GetStorage.');
      return;
    }
    print('بيانات المستخدم المحفوظة: $userData');
    if (userData != null) {
      _firstNameCtrl.text = userData['first_name'] ?? '';
      _lastNameCtrl.text = userData['last_name'] ?? '';
      _userType.text=userData['user_type']??'';
      _emailCtrl.text = userData['email'] ?? '';
      _phoneCtrl.text = userData['phone'] ?? '';
      _dobCtrl.text = userData['date_of_birth'] ?? '';
      _profile_picture =userData['profile_picture']?? '';
      _location.text = userData['location'] ?? '';
      _bioCtrl.text = userData['bio'] ?? '';
      _is_verified = userData['is_verified']?? '' ;
       _created_at = userData['created_at']?? '' ;
      print(' the value for is_verified is : $_is_verified');
      print('the image source is : $_profile_picture');

    }
  }

  Future<void> _pickAvatar() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    DateTime initial =
        DateTime.tryParse(_dobCtrl.text) ?? DateTime(1995, 1, 1);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1955),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _dobCtrl.text = picked
            .toIso8601String()
            .split('T')
            .first;
      });
    }
  }

  Future<void> _submit() async {
    print('Submit pressed');

    if (!(_formKey.currentState?.validate() ?? false)) {
      print('Form not valid');
      return;
    }

    final profile = UserProfileUpdate(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      dateOfBirth: _dobCtrl.text.trim(),
      profilePicture: null, // أضف رابط الصورة إذا لديك API للرفع
      bio: _bioCtrl.text.trim(),
      location: _location.text.trim(),
    );

    print("DATA TO UPDATE (JSON): ${profile.toJson()}");

    final auth = Get.find<AuthController>();
    final success = await auth.updateProfile(profile);

    print("RESULT OF UPDATE: $success");

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        Navigator.of(context).maybePop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء حفظ البيانات')),
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.backgroundColor,
              backgroundImage: _avatarFile != null
                  ? FileImage(_avatarFile!)
                  : (_profile_picture != null && _profile_picture!.isNotEmpty
                  ? NetworkImage(AppConstants.baseUrl+_profile_picture!)
                  : const AssetImage('assets/images/Logo4.png'))
              as ImageProvider,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: InkWell(
                onTap: _pickAvatar,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 18, color: Colors.white ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          ' ${_firstNameCtrl.text +' '+ _lastNameCtrl.text}',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.textColor),
        ),
        const SizedBox(height: 4),
        Text(
          '${_userType.text}',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('0', 'طلبات العمل', icon: Icons.work),
            _buildStat('0', 'وظائف محفوظة', icon: Icons.bookmark),
            _buildStat('$_is_verified', 'اكتمال الملف', icon: Icons.check_circle),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label, {IconData? icon}) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textColor)),
        Text(label,
            style: const TextStyle(color: AppColors.textColor, fontSize: 13)),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
        String? hint,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.secondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(color: Colors.grey, thickness: 0.8),
        const SizedBox(height: 16),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Center(child: Text('انشاء شركة')),
        elevation: 1,
        actions: [
          if (_userType.text == 'employer')
            IconButton(
              icon: const Icon(Icons.business_center),
              tooltip: 'إدارة شركاتي',
              onPressed: () {
                Get.to(() => const MyCompaniesScreen());
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: AppColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildSectionTitle(
                              'المعلومات الشخصية', Icons.person_outline
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_firstNameCtrl, 'الاسم الأول'),
                          const SizedBox(height: 16),
                          _buildTextField(_lastNameCtrl, 'الاسم الأخير'),
                          const SizedBox(height: 16),
                          _buildTextField(_emailCtrl, 'البريد الإلكتروني'),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneCtrl, 'رقم الهاتف'),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => _pickDateOfBirth(context),
                            child: IgnorePointer(
                              child:
                              _buildTextField(_dobCtrl, 'تاريخ الميلاد'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_location, 'المدينة'),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _bioCtrl,
                            maxLines: 4,
                            style: const TextStyle(color: AppColors.textColor),
                            decoration: const InputDecoration(
                              labelText: 'نبذة شخصية',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('تاريخ انشاء الحساب : $_created_at'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: auth.isLoading.value ? null : _submit,
                                child: auth.isLoading.value
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'حفظ التغييرات',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),

                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('تأكيد'),
                                      content: const Text(
                                          'هل أنت متأكد من إلغاء التغييرات؟ ستفقد جميع التعديلات غير المحفوظة.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text('إلغاء')
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(12)),
                                            ),
                                            onPressed: () =>
                                               Navigator.of(context).maybePop(),
                                            child: const Text('نعم')
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('إلغاء'),
                              ),


                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_is_verified', _is_verified));
  }
}

