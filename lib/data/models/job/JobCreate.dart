class JobCreate {
  final String title;
  final String description;
  final String requirements;
  final String? responsibilities;
  final String? benefits;
  final String? skills;
  final int company;
  final int? category;
  final String jobType;
  final String experienceLevel;
  final String educationLevel;
  final String city;
  final int? salaryMin;
  final int? salaryMax;
  final bool? isSalaryNegotiable;
  final String? applicationDeadline;
  final String? contactEmail;
  final String? contactPhone;
  final bool? isFeatured;
  final bool? isUrgent;
  final bool? isActive;
  final String? applicationMethod;
  final int? customForm;
  final String? applicationTemplate;
  final String? externalApplicationUrl;
  final String? applicationEmail;
  final bool? isAiSummaryEnabled;

  JobCreate({
    required this.title,
    required this.description,
    required this.requirements,
    this.responsibilities,
    this.benefits,
    this.skills,
    required this.company,
    this.category,
    required this.jobType,
    required this.experienceLevel,
    required this.educationLevel,
    required this.city,
    this.salaryMin,
    this.salaryMax,
    this.isSalaryNegotiable,
    this.applicationDeadline,
    this.contactEmail,
    this.contactPhone,
    this.isFeatured,
    this.isUrgent,
    this.isActive,
    this.applicationMethod,
    this.customForm,
    this.applicationTemplate,
    this.externalApplicationUrl,
    this.applicationEmail,
    this.isAiSummaryEnabled,
  });

  factory JobCreate.fromJson(Map<String, dynamic> json) {
    return JobCreate(
      title: json['title'],
      description: json['description'],
      requirements: json['requirements'],
      responsibilities: json['responsibilities'],
      benefits: json['benefits'],
      skills: json['skills'],
      company: json['company'],
      category: json['category'],
      jobType: json['job_type'],
      experienceLevel: json['experience_level'],
      educationLevel: json['education_level'],
      city: json['city'],
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      isSalaryNegotiable: json['is_salary_negotiable'],
      applicationDeadline: json['application_deadline'],
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      isFeatured: json['is_featured'],
      isUrgent: json['is_urgent'],
      isActive: json['is_active'],
      applicationMethod: json['application_method'],
      customForm: json['custom_form'],
      applicationTemplate: json['application_template'],
      externalApplicationUrl: json['external_application_url'],
      applicationEmail: json['application_email'],
      isAiSummaryEnabled: json['is_ai_summary_enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'benefits': benefits,
      'skills': skills,
      'company': company,
      'category': category,
      'job_type': jobType,
      'experience_level': experienceLevel,
      'education_level': educationLevel,
      'city': city,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'is_salary_negotiable': isSalaryNegotiable,
      'application_deadline': applicationDeadline,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'is_featured': isFeatured,
      'is_urgent': isUrgent,
      'is_active': isActive,
      'application_method': applicationMethod,
      'custom_form': customForm,
      'application_template': applicationTemplate,
      'external_application_url': externalApplicationUrl,
      'application_email': applicationEmail,
      'is_ai_summary_enabled': isAiSummaryEnabled,
    };
  }
}
