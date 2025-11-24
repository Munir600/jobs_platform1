// lib/models/job_models.dart
import 'company_models.dart';

class JobCategory {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final bool isActive;
  final int jobsCount;

  JobCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    required this.isActive,
    required this.jobsCount,
  });

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['is_active'],
      jobsCount: int.parse(json['jobs_count']),
    );
  }
}

class JobList {
  final int id;
  final String title;
  final String slug;
  final Company company;
  final JobCategory category;
  final String jobType;
  final String experienceLevel;
  final String city;
  final int? salaryMin;
  final int? salaryMax;
  final bool isSalaryNegotiable;
  final DateTime? applicationDeadline;
  final bool isActive;
  final bool isFeatured;
  final bool isUrgent;
  final int viewsCount;
  final int applicationsCount;
  final bool isBookmarked;
  final DateTime createdAt;

  JobList({
    required this.id,
    required this.title,
    required this.slug,
    required this.company,
    required this.category,
    required this.jobType,
    required this.experienceLevel,
    required this.city,
    this.salaryMin,
    this.salaryMax,
    required this.isSalaryNegotiable,
    this.applicationDeadline,
    required this.isActive,
    required this.isFeatured,
    required this.isUrgent,
    required this.viewsCount,
    required this.applicationsCount,
    required this.isBookmarked,
    required this.createdAt,
  });

  factory JobList.fromJson(Map<String, dynamic> json) {
    return JobList(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      company: Company.fromJson(json['company']),
      category: JobCategory.fromJson(json['category']),
      jobType: json['job_type'],
      experienceLevel: json['experience_level'],
      city: json['city'],
      salaryMin: json['salary_min'],
      salaryMax: json['salary_max'],
      isSalaryNegotiable: json['is_salary_negotiable'],
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.parse(json['application_deadline'])
          : null,
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      isUrgent: json['is_urgent'],
      viewsCount: json['views_count'],
      applicationsCount: int.parse(json['applications_count']),
      isBookmarked: json['is_bookmarked'] == 'true',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class JobDetail {
  final int id;
  final Company company;
  final JobCategory category;
  final bool isBookmarked;
  final int applicationsCount;
  final bool isApplied;
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
  final bool isSalaryNegotiable;
  final DateTime? applicationDeadline;
  final String? contactEmail;
  final String? contactPhone;
  final bool isActive;
  final bool isFeatured;
  final bool isUrgent;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int postedBy;

  JobDetail({
    required this.id,
    required this.company,
    required this.category,
    required this.isBookmarked,
    required this.applicationsCount,
    required this.isApplied,
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
    required this.isSalaryNegotiable,
    this.applicationDeadline,
    this.contactEmail,
    this.contactPhone,
    required this.isActive,
    required this.isFeatured,
    required this.isUrgent,
    required this.viewsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.postedBy,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    return JobDetail(
      id: json['id'],
      company: Company.fromJson(json['company']),
      category: JobCategory.fromJson(json['category']),
      isBookmarked: json['is_bookmarked'] == 'true',
      applicationsCount: int.parse(json['applications_count']),
      isApplied: json['is_applied'] == 'true',
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
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.parse(json['application_deadline'])
          : null,
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      isUrgent: json['is_urgent'],
      viewsCount: json['views_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      postedBy: json['posted_by'],
    );
  }
}

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
  final bool isSalaryNegotiable;
  final DateTime? applicationDeadline;
  final String? contactEmail;
  final String? contactPhone;
  final bool isFeatured;
  final bool isUrgent;

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
    required this.isSalaryNegotiable,
    this.applicationDeadline,
    this.contactEmail,
    this.contactPhone,
    required this.isFeatured,
    required this.isUrgent,
  });

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
      'application_deadline': applicationDeadline?.toIso8601String(),
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'is_featured': isFeatured,
      'is_urgent': isUrgent,
    };
  }
}

class JobBookmark {
  final int id;
  final JobList job;
  final DateTime createdAt;

  JobBookmark({
    required this.id,
    required this.job,
    required this.createdAt,
  });

  factory JobBookmark.fromJson(Map<String, dynamic> json) {
    return JobBookmark(
      id: json['id'],
      job: JobList.fromJson(json['job']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class JobAlert {
  final int id;
  final String title;
  final String? keywords;
  final String? city;
  final String? jobType;
  final String? experienceLevel;
  final int? salaryMin;
  final bool isActive;
  final bool emailNotifications;
  final DateTime createdAt;
  final int user;
  final int? category;

  JobAlert({
    required this.id,
    required this.title,
    this.keywords,
    this.city,
    this.jobType,
    this.experienceLevel,
    this.salaryMin,
    required this.isActive,
    required this.emailNotifications,
    required this.createdAt,
    required this.user,
    this.category,
  });

  factory JobAlert.fromJson(Map<String, dynamic> json) {
    return JobAlert(
      id: json['id'],
      title: json['title'],
      keywords: json['keywords'],
      city: json['city'],
      jobType: json['job_type'],
      experienceLevel: json['experience_level'],
      salaryMin: json['salary_min'],
      isActive: json['is_active'],
      emailNotifications: json['email_notifications'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'keywords': keywords,
      'city': city,
      'job_type': jobType,
      'experience_level': experienceLevel,
      'salary_min': salaryMin,
      'is_active': isActive,
      'email_notifications': emailNotifications,
      'category': category,
    };
  }
}