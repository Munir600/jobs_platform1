import 'User.dart';

class JobSeekerProfile {
  final int id;
  final User user;
  final String? resume;
  final String? experienceLevel;
  final String? educationLevel;
  final String? skills;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final bool? availability;
  final String? preferredJobType;
  final String? languages;

  JobSeekerProfile({
    required this.id,
    required this.user,
    this.resume,
    this.experienceLevel,
    this.educationLevel,
    this.skills,
    this.expectedSalaryMin,
    this.expectedSalaryMax,
     this.availability,
    this.preferredJobType,
    this.languages,
  });

  factory JobSeekerProfile.fromJson(Map<String, dynamic> json) {
    return JobSeekerProfile(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user']),
      resume: json['resume'],
      experienceLevel: json['experience_level'],
      educationLevel: json['education_level'],
      skills: json['skills'],
      expectedSalaryMin: json['expected_salary_min'],
      expectedSalaryMax: json['expected_salary_max'],
      availability: json['availability'] ?? false,
      preferredJobType: json['preferred_job_type'],
      languages: json['languages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'resume': resume,
      'experience_level': experienceLevel,
      'education_level': educationLevel,
      'skills': skills,
      'expected_salary_min': expectedSalaryMin,
      'expected_salary_max': expectedSalaryMax,
      'availability': availability,
      'preferred_job_type': preferredJobType,
      'languages': languages,
    };
  }
}
