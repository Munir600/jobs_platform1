import '../company/Company.dart';
import 'JobCategory.dart';

class JobDetail {
  final int? id;
  final Company? company;
  final JobCategory? category;
  final bool? isBookmarked;
  final int? applicationsCount;
  final bool? isApplied;
  final String title;
  final String slug;
  final String description;

  final String requirements;
  final String? responsibilities;
  final String? benefits;
  final String? skills;
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
  final bool? isActive;
  final bool? isFeatured;
  final bool? isUrgent;
  final int? viewsCount;
  final String? createdAt;
  final String? updatedAt;
  final int postedBy;

  JobDetail({
    this.id,
    this.company,
    this.category,
    this.isBookmarked,
    this.applicationsCount,
    this.isApplied,
    required this.title,
    required this.slug,
    required this.description,
    required this.requirements,
    this.responsibilities,
    this.benefits,
    this.skills,
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
    this.isActive,
    this.isFeatured,
    this.isUrgent,
    this.viewsCount,
    this.createdAt,
    this.updatedAt,
    required this.postedBy,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    return JobDetail(
      id: json['id'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      category: json['category'] != null ? JobCategory.fromJson(json['category']) : null,
      isBookmarked: json['is_bookmarked'],
      applicationsCount: json['applications_count'],
      isApplied: json['is_applied'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      requirements: json['requirements'],
      responsibilities: json['responsibilities'],
      benefits: json['benefits'],
      skills: json['skills'],
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      postedBy: json['posted_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company?.toJson(),
      'category': category?.toJson(),
      'is_bookmarked': isBookmarked,
      'applications_count': applicationsCount,
      'is_applied': isApplied,
      'title': title,
      'slug': slug,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'benefits': benefits,
      'skills': skills,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'posted_by': postedBy,
    };
  }
}
