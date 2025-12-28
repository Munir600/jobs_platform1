import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import '../../../controllers/job/JobController.dart';
import '../../../controllers/company/CompanyController.dart';
import '../../../config/app_colors.dart';
import '../../../core/utils/network_utils.dart';
import '../../../data/models/job/JobCreate.dart';
import '../../../data/models/company/Company.dart';
import '../../../core/constants.dart';
import '../companies/CompanyDetailScreen.dart';
import '../../../data/models/job/JobList.dart';
import '../../../data/models/job/JobDetail.dart';
import '../profile/employer_profile/EmployerJobManagementScreen.dart';
import '../profile/employer_profile/employer_profile_screen.dart';
import '../../widgets/custom_text_field.dart';

class CreateJobScreen extends StatefulWidget {
  final JobList? job;
  const CreateJobScreen({super.key, this.job});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {

  final JobController jobController = Get.find<JobController>();
  final CompanyController companyController = Get.find<CompanyController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController responsibilitiesController = TextEditingController();
  final TextEditingController salaryMinController = TextEditingController();
  final TextEditingController salaryMaxController = TextEditingController();
  final TextEditingController benefitsController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  String? selectedCity;
  String? selectedJobType;
  String? selectedExperienceLevel;
  String? selectedEducationLevel;
  int? selectedCompanyId;
  bool isUrgent = false;
  bool isFeatured = false;
  bool salaryNegotiable = false;
  bool isActive = true;
  
  bool isLoadingJobDetails = false;

  @override
  void initState() {
    super.initState();
    _loadMyCompanies();
    if (widget.job != null) {
      isLoadingJobDetails = true;
      _loadJobDetails();
    }
  }

  Future<void> _loadMyCompanies() async {
    // Only load if empty to avoid redundant calls, or force refresh if needed
    if (companyController.myCompanies.isEmpty) {
      await companyController.getMyCompanies(showLoading: false);
    }
    
    // Set initial company if creating new job and companies exist
    if (widget.job == null && companyController.myCompanies.isNotEmpty) {
      if (mounted && selectedCompanyId == null) {
        setState(() {
          selectedCompanyId = companyController.myCompanies.first.id;
        });
      }
    }
  }

  Future<void> _loadJobDetails() async {
    try {
      final jobDetail = await jobController.getJob(widget.job!.slug, showLoading: false);
      if (jobDetail != null && mounted) {
        _prefillJobData(jobDetail);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load job details: $e');
    } finally {
      if (mounted) {
        setState(() => isLoadingJobDetails = false);
      }
    }
  }

  void _prefillJobData(JobDetail job) {
    titleController.text = job.title;
    descriptionController.text = job.description;
    requirementsController.text = job.requirements;
    responsibilitiesController.text = job.responsibilities ?? '';
    salaryMinController.text = job.salaryMin?.toString() ?? '';
    salaryMaxController.text = job.salaryMax?.toString() ?? '';
    benefitsController.text = job.benefits ?? '';
    deadlineController.text = job.applicationDeadline?.split('T')[0] ?? '';
    
    setState(() {
      selectedCity = job.city;
      selectedJobType = job.jobType;
      selectedExperienceLevel = job.experienceLevel;
      selectedEducationLevel = job.educationLevel;
      selectedCompanyId = job.company?.id; 
      
      isUrgent = job.isUrgent ?? false;
      isFeatured = job.isFeatured ?? false;
      salaryNegotiable = job.isSalaryNegotiable ?? false;
      isActive = job.isActive ?? true;
    });
  }

  Widget build(BuildContext context) {
    final isEditing = widget.job != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل الوظيفة' : 'نشر وظيفة جديدة', style: const TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: Stack(
        children: [
        //  const PatternBackground(),
          if (isLoadingJobDetails)
             const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          else
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('معلومات الوظيفة'),
                  
                  // Company Selection
                  Obx(() {
                    if (companyController.isLoading.value && companyController.myCompanies.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                    }
                    if (companyController.myCompanies.isEmpty) {
                      return Card(
                        color: Colors.orange[50],
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'يجب أن يكون لديك شركة مسجلة لنشر وظيفة. قم بإنشاء شركة أولاً.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      );
                    }
                    
                    return DropdownButtonFormField<int>(
                      value: selectedCompanyId,
                      items: companyController.myCompanies.map((company) {
                        return DropdownMenuItem(
                          value: company.id,
                          child: Text(company.name ?? 'شركة غير معروفة'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedCompanyId = val),
                      validator: (val) => val == null ? 'يرجى اختيار الشركة' : null,
                      decoration: InputDecoration(
                        labelText: 'اختر الشركة',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  
                  _buildTextField(titleController, 'عنوان الوظيفة', validator: (v) => v!.isEmpty ? 'مطلوب' : null, inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FFa-zA-Z\s]')),
                  ]),
                  const SizedBox(height: 16),
                  _buildDropdown('المدينة', AppEnums.cities, (val) => setState(() => selectedCity = val), value: selectedCity, validator: (v) => v == null ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildDropdown('نوع الوظيفة', AppEnums.jobTypes, (val) => setState(() => selectedJobType = val), value: selectedJobType, validator: (v) => v == null ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildDropdown('مستوى الخبرة', AppEnums.experienceLevels, (val) => setState(() => selectedExperienceLevel = val), value: selectedExperienceLevel, validator: (v) => v == null ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildDropdown('المستوى التعليمي', AppEnums.educationLevels, (val) => setState(() => selectedEducationLevel = val), value: selectedEducationLevel, validator: (v) => v == null ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildSectionTitle('التفاصيل'),
                  _buildTextField(descriptionController, 'الوصف الوظيفي', maxLines: 5, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildTextField(requirementsController, 'المتطلبات', maxLines: 3, validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                  const SizedBox(height: 16),
                  _buildTextField(responsibilitiesController, 'المسؤوليات', maxLines: 3),
                  const SizedBox(height: 16),
                  _buildSectionTitle('الراتب والمزايا'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(salaryMinController, 'الحد الأدنى', keyboardType: TextInputType.number),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(salaryMaxController, 'الحد الأعلى', keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('راتب قابل للتفاوض'),
                    value: salaryNegotiable,
                    onChanged: (val) => setState(() => salaryNegotiable = val!),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(benefitsController, 'المزايا (اختياري)', maxLines: 2),
                  const SizedBox(height: 16),
                  _buildSectionTitle('إعدادات إضافية'),
                  CheckboxListTile(
                    title: const Text('نشط'),
                    subtitle: const Text('إظهار الوظيفة للباحثين عن عمل'),
                    value: isActive,
                    onChanged: (val) =>(),// setState(() => isActive = val!),
                  ),
                  CheckboxListTile(
                    title: const Text('توظيف عاجل'),
                    value: isUrgent,
                    onChanged: (val) => setState(() => isUrgent = val!),
                  ),
                  CheckboxListTile(
                    title: const Text('إعلان مميز'),
                    value: isFeatured,
                    onChanged: (val) => setState(() => isFeatured = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: deadlineController,
                    decoration: InputDecoration(
                      labelText: 'تاريخ انتهاء التقديم (YYYY-MM-DD)', 
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        deadlineController.text = pickedDate.toString().split(' ')[0];
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: (jobController.isLoading.value) ? null : () async {
                        final hasInternet = await NetworkUtils.checkInternet(context);
                        if (!hasInternet) return;
                        if (!_formKey.currentState!.validate()) {
                          AppErrorHandler.showErrorSnack('يرجى تعبئة جميع الحقول المطلوبة');
                          return;
                        }
                        
                       // Check if company is verified
                        final selectedCompany = companyController.myCompanies.firstWhereOrNull((c) => c.id == selectedCompanyId);
                        if (selectedCompany != null && (selectedCompany.isVerified == false || selectedCompany.isVerified == null)) {
                          Get.snackbar('خطاء', 'عذراً، يجب توثيق الشركة أولاً لتتمكن من نشر وظيفة جديدة',
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                            duration: const Duration(seconds: 4),
                            isDismissible: true,
                          );
                          return;
                        }
                        
                        final jobData = JobCreate(
                          title: titleController.text,
                          description: descriptionController.text,
                          requirements: requirementsController.text,
                          responsibilities: responsibilitiesController.text,
                          city: selectedCity ?? '',
                          jobType: selectedJobType ?? '',
                          experienceLevel: selectedExperienceLevel ?? '',
                          educationLevel: selectedEducationLevel ?? '',
                          company: selectedCompanyId!,
                          salaryMin: int.tryParse(salaryMinController.text),
                          salaryMax: int.tryParse(salaryMaxController.text),
                          isSalaryNegotiable: salaryNegotiable,
                          benefits: benefitsController.text,
                          isUrgent: isUrgent,
                          isFeatured: isFeatured,
                          applicationDeadline: deadlineController.text.isNotEmpty ? deadlineController.text : null,
                          isActive: isActive,
                        );
                        
                        bool success;
                        if (isEditing) {
                          success = await jobController.updateJob(widget.job!.slug, jobData);
                        } else {
                          success = await jobController.createJob(jobData);
                        }

                        // if (success) {
                        //    Get.back(result: true); 
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: jobController.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(isEditing ? 'حفظ التعديلات' : 'نشر الوظيفة', style: const TextStyle(color: Colors.white, fontSize: 18)),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildDropdown(String label, Map<String, String> items, Function(String?) onChanged, {String? value, String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
