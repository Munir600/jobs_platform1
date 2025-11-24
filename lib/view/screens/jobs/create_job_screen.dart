import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  // نموذج البيانات
  final _formData = JobFormData();

  // قوائم الاختيارات
  final List<Map<String, String>> _jobCategories = [
    {'value': 'technology', 'label': 'تقنية المعلومات'},
    {'value': 'marketing', 'label': 'التسويق'},
    {'value': 'sales', 'label': 'المبيعات'},
    {'value': 'finance', 'label': 'المالية والمحاسبة'},
    {'value': 'hr', 'label': 'الموارد البشرية'},
    {'value': 'engineering', 'label': 'الهندسة'},
    {'value': 'healthcare', 'label': 'الرعاية الصحية'},
    {'value': 'education', 'label': 'التعليم'},
    {'value': 'design', 'label': 'التصميم'},
    {'value': 'customer-service', 'label': 'خدمة العملاء'},
  ];

  final List<Map<String, String>> _jobTypes = [
    {'value': 'full-time', 'label': 'دوام كامل'},
    {'value': 'part-time', 'label': 'دوام جزئي'},
    {'value': 'contract', 'label': 'عقد مؤقت'},
    {'value': 'freelance', 'label': 'عمل حر'},
    {'value': 'internship', 'label': 'تدريب'},
  ];

  final List<Map<String, String>> _locations = [
    {'value': 'sanaa', 'label': 'صنعاء'},
    {'value': 'aden', 'label': 'عدن'},
    {'value': 'taiz', 'label': 'تعز'},
    {'value': 'hodeidah', 'label': 'الحديدة'},
    {'value': 'ibb', 'label': 'إب'},
    {'value': 'dhamar', 'label': 'ذمار'},
    {'value': 'mukalla', 'label': 'المكلا'},
    {'value': 'remote', 'label': 'عمل عن بُعد'},
  ];

  final List<Map<String, String>> _experienceLevels = [
    {'value': 'entry', 'label': 'مبتدئ (0-2 سنة)'},
    {'value': 'junior', 'label': 'مبتدئ متقدم (2-4 سنوات)'},
    {'value': 'mid', 'label': 'متوسط (4-7 سنوات)'},
    {'value': 'senior', 'label': 'خبير (7-10 سنوات)'},
    {'value': 'expert', 'label': 'خبير متقدم (10+ سنوات)'},
  ];

  final List<Map<String, String>> _educationLevels = [
    {'value': 'high-school', 'label': 'ثانوية عامة'},
    {'value': 'diploma', 'label': 'دبلوم'},
    {'value': 'bachelor', 'label': 'بكالوريوس'},
    {'value': 'master', 'label': 'ماجستير'},
    {'value': 'phd', 'label': 'دكتوراه'},
    {'value': 'any', 'label': 'غير محدد'},
  ];

  final List<Map<String, String>> _companySizes = [
    {'value': 'startup', 'label': 'ناشئة (1-10 موظفين)'},
    {'value': 'small', 'label': 'صغيرة (11-50 موظف)'},
    {'value': 'medium', 'label': 'متوسطة (51-200 موظف)'},
    {'value': 'large', 'label': 'كبيرة (201-1000 موظف)'},
    {'value': 'enterprise', 'label': 'مؤسسة (1000+ موظف)'},
  ];

  final List<Map<String, String>> _industries = [
    {'value': 'technology', 'label': 'تقنية المعلومات'},
    {'value': 'healthcare', 'label': 'الرعاية الصحية'},
    {'value': 'education', 'label': 'التعليم'},
    {'value': 'finance', 'label': 'المالية والمصرفية'},
    {'value': 'construction', 'label': 'البناء والتشييد'},
    {'value': 'retail', 'label': 'التجارة والبيع بالتجزئة'},
    {'value': 'manufacturing', 'label': 'التصنيع'},
    {'value': 'telecommunications', 'label': 'الاتصالات'},
    {'value': 'other', 'label': 'أخرى'},
  ];

  final List<Map<String, dynamic>> _pricingPlans = [
    {
      'value': 'basic',
      'label': 'نشر أساسي',
      'price': '50,000',
      'duration': '30 يوم'
    },
    {
      'value': 'featured',
      'label': 'نشر مميز',
      'price': '100,000',
      'duration': '60 يوم'
    },
    {
      'value': 'premium',
      'label': 'نشر احترافي',
      'price': '150,000',
      'duration': '90 يوم'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF2563EB),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'انشر وظيفة واعثر على أفضل المواهب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  ),
                ),
              ),
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),

          // Form Section
          SliverToBoxAdapter(
            child: _buildFormSection(),
          ),

          // Benefits Section
          SliverToBoxAdapter(
            child: _buildBenefitsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: const Color(0xFF2563EB),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'وصل إلى آلاف المرشحين المؤهلين في اليمن واعثر على الموظف المثالي لشركتك',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _pricingPlans.map((plan) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        plan['label'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${plan['price']} ريال',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'لمدة ${plan['duration']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Form Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'نشر وظيفة جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'املأ النموذج أدناه لنشر وظيفتك والوصول إلى أفضل المرشحين',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Steps Indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildStepsIndicator(),
          ),

          // Form Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCurrentStep(),
          ),

          // Form Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildFormActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsIndicator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        if (isSmallScreen) {
          // تصميم للشاشات الصغيرة - عمودي
          return Column(
            children: List.generate(_totalSteps, (index) {
              return _buildVerticalStepIndicator(index + 1);
            }),
          );
        } else {
          // تصميم للشاشات الكبيرة - أفقي
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_totalSteps, (index) {
              return _buildHorizontalStepIndicator(index + 1);
            }),
          );
        }
      },
    );
  }

  Widget _buildHorizontalStepIndicator(int stepNumber) {
    bool isActive = stepNumber - 1 == _currentStep;
    bool isCompleted = stepNumber - 1 < _currentStep;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFDBEAFE)
              : isCompleted
              ? const Color(0xFFD1FAE5)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF2563EB)
                    : isCompleted
                    ? const Color(0xFF10B981)
                    : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _getStepTitle(stepNumber),
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : isCompleted
                      ? const Color(0xFF10B981)
                      : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalStepIndicator(int stepNumber) {
    bool isActive = stepNumber - 1 == _currentStep;
    bool isCompleted = stepNumber - 1 < _currentStep;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFDBEAFE)
            : isCompleted
            ? const Color(0xFFD1FAE5)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF2563EB)
                  : isCompleted
                  ? const Color(0xFF10B981)
                  : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getStepTitle(stepNumber),
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF2563EB)
                    : isCompleted
                    ? const Color(0xFF10B981)
                    : Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'معلومات الوظيفة';
      case 2:
        return 'المتطلبات والمهارات';
      case 3:
        return 'معلومات الشركة';
      case 4:
        return 'المراجعة والنشر';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          switch (_currentStep) {
            0 => _buildStep1(),
            1 => _buildStep2(),
            2 => _buildStep3(),
            3 => _buildStep4(),
            _ => Container(),
          },
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        _buildFormField(
          label: 'عنوان الوظيفة',
          hintText: 'مثال: مطور ويب متقدم',
          isRequired: true,
          onChanged: (value) => _formData.jobTitle = value,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // تصميم عمودي للشاشات الصغيرة
              return Column(
                children: [
                  _buildDropdown(
                    label: 'فئة الوظيفة',
                    items: _jobCategories,
                    isRequired: true,
                    onChanged: (value) => _formData.jobCategory = value!,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'نوع الوظيفة',
                    items: _jobTypes,
                    isRequired: true,
                    onChanged: (value) => _formData.jobType = value!,
                  ),
                ],
              );
            } else {
              // تصميم أفقي للشاشات الكبيرة
              return Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'فئة الوظيفة',
                      items: _jobCategories,
                      isRequired: true,
                      onChanged: (value) => _formData.jobCategory = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'نوع الوظيفة',
                      items: _jobTypes,
                      isRequired: true,
                      onChanged: (value) => _formData.jobType = value!,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  _buildDropdown(
                    label: 'موقع العمل',
                    items: _locations,
                    isRequired: true,
                    onChanged: (value) => _formData.jobLocation = value!,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'مستوى الخبرة',
                    items: _experienceLevels,
                    isRequired: true,
                    onChanged: (value) => _formData.experienceLevel = value!,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'موقع العمل',
                      items: _locations,
                      isRequired: true,
                      onChanged: (value) => _formData.jobLocation = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'مستوى الخبرة',
                      items: _experienceLevels,
                      isRequired: true,
                      onChanged: (value) => _formData.experienceLevel = value!,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildSalaryField(),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'وصف الوظيفة',
          hintText: 'اكتب وصفاً مفصلاً للوظيفة، المهام المطلوبة، وبيئة العمل...',
          isRequired: true,
          maxLines: 5,
          onChanged: (value) => _formData.jobDescription = value,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildFormField(
          label: 'متطلبات الوظيفة',
          hintText: 'اكتب المتطلبات الأساسية للوظيفة، المؤهلات المطلوبة، والخبرات اللازمة...',
          isRequired: true,
          maxLines: 5,
          onChanged: (value) => _formData.jobRequirements = value,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'المهارات المطلوبة',
          hintText: 'مثال: JavaScript, React, Node.js, MySQL',
          onChanged: (value) => _formData.jobSkills = value,
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'المؤهل العلمي المطلوب',
          items: _educationLevels,
          onChanged: (value) => _formData.education = value!,
        ),
        const SizedBox(height: 16),
        _buildLanguagesSection(),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'المزايا والفوائد',
          hintText: 'اكتب المزايا التي تقدمها الشركة مثل التأمين الصحي، المرونة في العمل، التدريب...',
          maxLines: 4,
          onChanged: (value) => _formData.benefits = value,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildFormField(
          label: 'اسم الشركة',
          hintText: 'اسم شركتك',
          isRequired: true,
          onChanged: (value) => _formData.companyName = value,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'نبذة عن الشركة',
          hintText: 'اكتب نبذة مختصرة عن شركتك، مجال عملها، وثقافتها...',
          maxLines: 4,
          onChanged: (value) => _formData.companyDescription = value,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  _buildDropdown(
                    label: 'حجم الشركة',
                    items: _companySizes,
                    onChanged: (value) => _formData.companySize = value!,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'قطاع الشركة',
                    items: _industries,
                    onChanged: (value) => _formData.companyIndustry = value!,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'حجم الشركة',
                      items: _companySizes,
                      onChanged: (value) => _formData.companySize = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'قطاع الشركة',
                      items: _industries,
                      onChanged: (value) => _formData.companyIndustry = value!,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  _buildFormField(
                    label: 'البريد الإلكتروني للتواصل',
                    hintText: 'hr@company.com',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _formData.contactEmail = value,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'رقم الهاتف',
                    hintText: '+967 1 234567',
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => _formData.contactPhone = value,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: 'البريد الإلكتروني للتواصل',
                      hintText: 'hr@company.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => _formData.contactEmail = value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFormField(
                      label: 'رقم الهاتف',
                      hintText: '+967 1 234567',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => _formData.contactPhone = value,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildDateField(),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      children: [
        _buildJobPreview(),
        const SizedBox(height: 20),
        _buildPricingPlans(),
        const SizedBox(height: 20),
        _buildTermsCheckbox(),
      ],
    );
  }

  Widget _buildFormActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          // تصميم عمودي للشاشات الضيقة
          return Column(
            children: [
              if (_currentStep > 0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('السابق'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentStep == _totalSteps - 1 ? _submitForm : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == _totalSteps - 1
                        ? const Color(0xFF10B981)
                        : const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_currentStep == _totalSteps - 1 ? 'نشر الوظيفة' : 'التالي'),
                ),
              ),
            ],
          );
        } else {
          // تصميم أفقي للشاشات العريضة
          return Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('السابق'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentStep == _totalSteps - 1 ? _submitForm : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == _totalSteps - 1
                        ? const Color(0xFF10B981)
                        : const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_currentStep == _totalSteps - 1 ? 'نشر الوظيفة' : 'التالي'),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, String>> items,
    bool isRequired = false,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          items: [
            DropdownMenuItem(
              value: '',
              child: Text('اختر $label'),
            ),
            ...items.map((item) {
              return DropdownMenuItem(
                value: item['value'],
                child: Text(item['label']!),
              );
            }),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نطاق الراتب (ريال يمني)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => _formData.salaryMin = value,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'الحد الأدنى',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('إلى'),
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => _formData.salaryMax = value,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'الحد الأعلى',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'اتركه فارغاً إذا كنت تفضل عدم الإفصاح عن الراتب',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اللغات المطلوبة',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _buildLanguageCheckbox('العربية', 'arabic', true),
            _buildLanguageCheckbox('الإنجليزية', 'english', false),
            _buildLanguageCheckbox('الفرنسية', 'french', false),
            _buildLanguageCheckbox('الألمانية', 'german', false),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageCheckbox(String label, String value, bool isChecked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? newValue) {
            // Handle language selection
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'آخر موعد للتقديم',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: const InputDecoration(
            hintText: 'اختر التاريخ',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: _formData.applicationDeadline != null
                ? DateFormat('yyyy-MM-dd').format(_formData.applicationDeadline!)
                : '',
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'اتركه فارغاً إذا لم يكن هناك موعد محدد',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildJobPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معاينة الوظيفة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (_formData.jobTitle.isNotEmpty)
            Text(
              _formData.jobTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          if (_formData.companyName.isNotEmpty)
            Text(
              _formData.companyName,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 16),
          // Add more preview details here...
        ],
      ),
    );
  }

  Widget _buildPricingPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع النشر',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ..._pricingPlans.map((plan) {
          return RadioListTile<String>(
            title: Text('${plan['label']} - ${plan['price']} ريال (${plan['duration']})'),
            value: plan['value'],
            groupValue: _formData.publishPlan,
            onChanged: (value) {
              setState(() {
                _formData.publishPlan = value!;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _formData.agreeToTerms,
          onChanged: (bool? value) {
            setState(() {
              _formData.agreeToTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'أوافق على '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to terms
                    },
                    child: const Text(
                      'شروط الخدمة',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: ' و '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to privacy
                    },
                    child: const Text(
                      'سياسة الخصوصية',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {'icon': '🎯', 'title': 'وصول مستهدف', 'description': 'وصل إلى المرشحين المناسبين في التخصص والموقع الذي تحتاجه'},
      {'icon': '⚡', 'title': 'نشر سريع', 'description': 'انشر وظيفتك في دقائق واحصل على طلبات التقديم فوراً'},
      {'icon': '📊', 'title': 'تقارير مفصلة', 'description': 'احصل على إحصائيات مفصلة عن أداء إعلانك وعدد المشاهدات'},
      {'icon': '🤝', 'title': 'دعم متخصص', 'description': 'فريق دعم متخصص لمساعدتك في كل خطوة من عملية التوظيف'},
    ];

    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'لماذا تختار منصتنا؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: benefits.map((benefit) {
              return SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Text(
                      benefit['icon']!,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      benefit['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      benefit['description']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _formData.applicationDeadline = picked;
      });
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  bool _validateCurrentStep() {
    // Add validation logic for each step
    switch (_currentStep) {
      case 0:
        if (_formData.jobTitle.isEmpty) {
          _showError('يرجى إدخال عنوان الوظيفة');
          return false;
        }
        break;
      case 1:
        if (_formData.jobRequirements.isEmpty) {
          _showError('يرجى إدخال متطلبات الوظيفة');
          return false;
        }
        break;
      case 2:
        if (_formData.companyName.isEmpty) {
          _showError('يرجى إدخال اسم الشركة');
          return false;
        }
        break;
    }
    return true;
  }

  void _submitForm() {
    if (!_formData.agreeToTerms) {
      _showError('يرجى الموافقة على شروط الخدمة');
      return;
    }

    // Submit the form
    _showSuccessDialog();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم النشر بنجاح'),
        content: const Text('تم نشر الوظيفة بنجاح! سيتم مراجعتها وتفعيلها خلال 24 ساعة.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to employer dashboard
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}

class JobFormData {
  String jobTitle = '';
  String jobCategory = '';
  String jobType = '';
  String jobLocation = '';
  String experienceLevel = '';
  String salaryMin = '';
  String salaryMax = '';
  String jobDescription = '';
  String jobRequirements = '';
  String jobSkills = '';
  String education = '';
  String benefits = '';
  String companyName = '';
  String companyDescription = '';
  String companySize = '';
  String companyIndustry = '';
  String contactEmail = '';
  String contactPhone = '';
  DateTime? applicationDeadline;
  String publishPlan = 'basic';
  bool agreeToTerms = false;
}