class JobAlert {
  final int id;
  final String title;
  final String? keywords;
  final String? city;
  final String? jobType;
  final String? experienceLevel;
  final int? salaryMin;
  final bool? isActive;
  final bool? emailNotifications;
  final String? createdAt;
  final int? user;
  final int? category;

  JobAlert({
    required this.id,
    required this.title,
    this.keywords,
    this.city,
    this.jobType,
    this.experienceLevel,
    this.salaryMin,
    this.isActive,
    this.emailNotifications,
    this.createdAt,
    this.user,
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
      createdAt: json['created_at'],
      user: json['user'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'keywords': keywords,
      'city': city,
      'job_type': jobType,
      'experience_level': experienceLevel,
      'salary_min': salaryMin,
      'is_active': isActive,
      'email_notifications': emailNotifications,
      'created_at': createdAt,
      'user': user,
      'category': category,
    };
  }
}
