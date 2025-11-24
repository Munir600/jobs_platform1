import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../config/app_colors.dart';
import '../../../../data/models/user_models.dart';

class EditJobseekerProfile extends StatefulWidget {
  const EditJobseekerProfile({super.key});

  @override
  State<EditJobseekerProfile> createState() => _EditJobseekerProfileState();
}

class _EditJobseekerProfileState extends State<EditJobseekerProfile> {
  final _formKey = GlobalKey<FormState>();
  final GetStorage _storage = GetStorage();
  // Controllers
  final TextEditingController _firstNameCtrl =
  TextEditingController();
  final TextEditingController _lastNameCtrl =
  TextEditingController();
  final TextEditingController _emailCtrl =
  TextEditingController();
  final TextEditingController _phoneCtrl =
  TextEditingController();
  final TextEditingController _dobCtrl =
  TextEditingController();
  final TextEditingController _addressCtrl =
  TextEditingController();

  final TextEditingController _titleCtrl =
  TextEditingController(text: 'مطور برمجيات');
  String _experience = '1-3';
  String _education = 'bachelor';
  final TextEditingController _salaryCtrl =
  TextEditingController(text: '1500');
  String _jobType = 'full-time';
  final TextEditingController _bioCtrl = TextEditingController(
      text:
      'مطور برمجيات متخصص في تطوير تطبيقات الويب باستخدام JavaScript وReact. لدي خبرة 3 سنوات في العمل مع فرق التطوير وإنجاز المشاريع في الوقت المحدد.');

  // Skills
  final TextEditingController _newSkillCtrl = TextEditingController();
  List<String> _skills = ['JavaScript', 'React', 'Node.js', 'Python', 'SQL'];

  // Avatar
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Get.put(AuthController());
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
        _firstNameCtrl.text = userData['first_name'] ?? 'صالح';
        _lastNameCtrl.text = userData['last_name'] ?? '';
        _emailCtrl.text = userData['email'] ?? '';
        _phoneCtrl.text = userData['phone'] ?? '';
        _dobCtrl.text = userData['date_of_birth'] ?? '';
        _addressCtrl.text = userData['location'] ?? '';
        _bioCtrl.text = userData['bio'] ?? '';
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
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _dobCtrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  void _addSkill() {
    final skill = _newSkillCtrl.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _newSkillCtrl.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _submit() async {
    print('Submit pressed'); // للتأكد من الاستدعاء

    try {
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
        bio: _bioCtrl.text.trim(),
        location: _addressCtrl.text.trim(),
      );

     final AuthController authController = Get.put(AuthController());

      print('the data that will updated is : $profile');
      bool success = await authController.updateProfile(profile);
      print('نتيجة تحديث الملف الشخصي: $success');

      if (success) {
        final updatedData = {
          ..._storage.read('user_data') ?? {},
          'first_name': profile.firstName,
          'last_name': profile.lastName,
          'email': profile.email,
          'phone': profile.phone,
          'date_of_birth': profile.dateOfBirth,
          'bio': profile.bio,
          'location': profile.location,
        };
        await _storage.write('user_data', updatedData);
        print('تم تحديث بيانات المستخدم في التخزين المحلي: $updatedData');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
        );

        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.of(context).maybePop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء حفظ البيانات')),
        );
      }
    } catch (e, st) {
      print('Error in _submit: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ غير متوقع: $e')),
      );
    }
  }



  // ---------- الهيدر -----------
  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.backgroundColor,
              backgroundImage: _avatarFile != null
                  ? FileImage(_avatarFile!)
                  : const AssetImage('assets/images/Logo4.png')
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
                      size: 18, color: Colors.white),
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
          'مطور برمجيات',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('12', 'طلبات العمل', icon: Icons.work),
            _buildStat('8', 'وظائف محفوظة', icon: Icons.bookmark),
            _buildStat('%75', 'اكتمال الملف', icon: Icons.check_circle),
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
          title: const Text(' الملف الشخصي'),
          centerTitle: true,
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.textColor,
          leading: Icon(
              Icons.account_circle,
              color: AppColors.primaryColor,
              size: 30
          )
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
                    const SizedBox(height: 24),
                    Form(

                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle(
                              'المعلومات الشخصية', Icons.person_outline),
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
                          _buildTextField(_addressCtrl, 'العنوان'),
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
                          const SizedBox(height: 24),
                          _buildSectionTitle(
                              'المعلومات المهنية', Icons.work_outline),
                          const SizedBox(height: 16),
                          _buildTextField(_titleCtrl, 'المسمى الوظيفي'),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _experience,
                            decoration: const InputDecoration(
                                labelText: 'سنوات الخبرة'),
                            items: const [
                              DropdownMenuItem(
                                  value: '0-1',
                                  child: Text('0-1 سنة')),
                              DropdownMenuItem(
                                  value: '1-3',
                                  child: Text('1-3 سنوات')),
                              DropdownMenuItem(
                                  value: '3-5',
                                  child: Text('3-5 سنوات')),
                              DropdownMenuItem(
                                  value: '5+',
                                  child: Text('أكثر من 5 سنوات')),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _experience = val!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _education,
                            decoration: const InputDecoration(
                                labelText: 'المستوى التعليمي'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'highschool',
                                  child: Text('ثانوي')),
                              DropdownMenuItem(
                                  value: 'diploma',
                                  child: Text('دبلوم')),
                              DropdownMenuItem(
                                  value: 'bachelor',
                                  child: Text('بكالوريوس')),
                              DropdownMenuItem(
                                  value: 'master',
                                  child: Text('ماجستير')),
                              DropdownMenuItem(
                                  value: 'phd', child: Text('دكتوراه')),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _education = val!;
                              });
                            },
                          ),
                          const SizedBox(height: 22),
                          _buildTextField(_salaryCtrl, 'الراتب المتوقع',
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _jobType,
                            decoration: const InputDecoration(
                                labelText: 'نوع العمل'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'full-time',
                                  child: Text('دوام كامل')),
                              DropdownMenuItem(
                                  value: 'part-time',
                                  child: Text('دوام جزئي')),
                              DropdownMenuItem(
                                  value: 'remote', child: Text('عن بعد')),
                              DropdownMenuItem(
                                  value: 'freelance',
                                  child: Text('عمل حر')),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _jobType = val!;
                              });
                            },
                          ),


                          const SizedBox(height: 24),
                          _buildSectionTitle(
                              'المهارات', Icons.build_outlined),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _skills
                                .map((s) => Chip(
                              label: Text(s),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () => _removeSkill(s),
                              backgroundColor:
                              AppColors.accentColor,
                            ))
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _newSkillCtrl,
                                  decoration: InputDecoration(
                                    hintText: 'أضف مهارة جديدة...',
                                    border: OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                  ),
                                  onFieldSubmitted: (_) => _addSkill(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                  side: const BorderSide(color: AppColors.primaryColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _addSkill,
                                child: const Text('إضافة'),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),

                                onPressed: _submit,
                                child: const Text('حفظ التغييرات'),
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
}

