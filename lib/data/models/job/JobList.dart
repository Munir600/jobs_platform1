import '../company/Company.dart';
import 'JobCategory.dart';

class JobList {
  final int? id;
  final String title;
  final String slug;
  final String? description;
  final String? requirements;
  final Company? company;
  final JobCategory? category;
  final String jobType;
  final String experienceLevel;
  final String city;
  final int? salaryMin;
  final int? salaryMax;
  final bool? isSalaryNegotiable;
  final String? applicationDeadline;
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

  JobList({
    this.id,
    required this.title,
    required this.slug,
    this.description,
    this.requirements,
    this.company,
    this.category,
    required this.jobType,
    required this.experienceLevel,
    required this.city,
    this.salaryMin,
    this.salaryMax,
    this.isSalaryNegotiable,
    this.applicationDeadline,
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
  });

  factory JobList.fromJson(Map<String, dynamic> json) {
    return JobList(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      requirements: json['requirements'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      category: json['category'] != null ? JobCategory.fromJson(json['category']) : null,
      jobType: json['job_type'],
      experienceLevel: json['experience_level'],
      city: json['city'],
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      isSalaryNegotiable: json['is_salary_negotiable'],
      applicationDeadline: json['application_deadline'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'requirements': requirements,
      'company': company?.toJson(),
      'category': category?.toJson(),
      'job_type': jobType,
      'experience_level': experienceLevel,
      'city': city,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'is_salary_negotiable': isSalaryNegotiable,
      'application_deadline': applicationDeadline,
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
    };
  }
}
