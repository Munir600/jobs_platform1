class ProfileModel {
  final int id;
  final String? resume;
  final String? experienceLevel;
  final String? educationLevel;
  final String? skills;
  final String? expectedSalaryMin;
  final String? expectedSalaryMax;
  final bool availability;
  final String? preferredJobType;
  final String? languages;

  ProfileModel({
    required this.id,
    this.resume,
    this.experienceLevel,
    this.educationLevel,
    this.skills,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
    this.availability = false,
    this.preferredJobType,
    this.languages,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      resume: json['resume'],
      experienceLevel: json['experience_level'],
      educationLevel: json['education_level'],
      skills: json['skills'],
      expectedSalaryMin: json['expected_salary_min']?.toString(),
      expectedSalaryMax: json['expected_salary_max']?.toString(),
      availability: json['availability'] ?? false,
      preferredJobType: json['preferred_job_type'],
      languages: json['languages'],
    );
  }
}
