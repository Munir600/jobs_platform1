import '../company/Company.dart';
import '../company/job_form.dart';
import 'JobCategory.dart';

class JobList {
  final int? id;
  final String title;
  final String slug;
  final String? description;
  final String? requirements;
  final String? responsibilities;
  final String? benefits;
  final String? skills;
  final Company? company;
  final JobCategory? category;
  final String jobType;
  final String experienceLevel;
  final String? educationLevel;
  final String city;
  final int? salaryMin;
  final int? salaryMax;
  final bool? isSalaryNegotiable;
  final String? applicationDeadline;
  final String? contactEmail;
  final String? contactPhone;
  final bool? isActive;
  final bool? isFeatured;
  final bool? isUrgent;
  final int? viewsCount;
  final int? applicationsCount;
  final bool? isBookmarked;
  final String? createdAt;
  final String? aiSummary;
  final bool? isAiSummaryEnabled;
  final String? applicationMethod;
  final JobForm? customForm;
  final String? applicationTemplate;
  final String? externalApplicationUrl;
  final String? applicationEmail;

  JobList({
    this.id,
    required this.title,
    required this.slug,
    this.description,
    this.requirements,
    this.responsibilities,
    this.benefits,
    this.skills,
    this.company,
    this.category,
    required this.jobType,
    required this.experienceLevel,
    this.educationLevel,
    required this.city,
    this.salaryMin,
    this.salaryMax,
    this.isSalaryNegotiable,
    this.applicationDeadline,
    this.contactEmail,
    this.contactPhone,
    this.isActive,
    this.isFeatured,
    this.isUrgent,
    this.viewsCount,
    this.applicationsCount,
    this.isBookmarked,
    this.createdAt,
    this.aiSummary,
    this.isAiSummaryEnabled,
    this.applicationMethod,
    this.customForm,
    this.applicationTemplate,
    this.externalApplicationUrl,
    this.applicationEmail,
  });

  factory JobList.fromJson(Map<String, dynamic> json) {
    return JobList(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      requirements: json['requirements'],
      responsibilities: json['responsibilities'],
      benefits: json['benefits'],
      skills: json['skills'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      category: json['category'] != null ? JobCategory.fromJson(json['category']) : null,
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
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      isUrgent: json['is_urgent'],
      viewsCount: json['views_count'],
      applicationsCount: json['applications_count'],
      isBookmarked: json['is_bookmarked'],
      createdAt: json['created_at'],
      aiSummary: json['ai_summary'],
      isAiSummaryEnabled: json['is_ai_summary_enabled'],
      applicationMethod: json['application_method'],
      customForm: json['custom_form'] != null ? JobForm.fromJson(json['custom_form']) : null,
      applicationTemplate: json['application_template'],
      externalApplicationUrl: json['external_application_url'],
      applicationEmail: json['application_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'benefits': benefits,
      'skills': skills,
      'company': company?.toJson(),
      'category': category?.toJson(),
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
      'is_active': isActive,
      'is_featured': isFeatured,
      'is_urgent': isUrgent,
      'views_count': viewsCount,
      'applications_count': applicationsCount,
      'is_bookmarked': isBookmarked,
      'created_at': createdAt,
      'ai_summary': aiSummary,
      'is_ai_summary_enabled': isAiSummaryEnabled,
      'application_method': applicationMethod,
      'custom_form': customForm?.toJson(),
      'application_template': applicationTemplate,
      'external_application_url': externalApplicationUrl,
      'application_email': applicationEmail,
    };
  }
}
