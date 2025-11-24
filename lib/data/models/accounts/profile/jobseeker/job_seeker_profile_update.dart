// To parse this JSON data, do
//
//     final jobSeekerProfileUpdate = jobSeekerProfileUpdateFromJson(jsonString);

import 'dart:convert';

JobSeekerProfileUpdate jobSeekerProfileUpdateFromJson(String str) => JobSeekerProfileUpdate.fromJson(json.decode(str));

String jobSeekerProfileUpdateToJson(JobSeekerProfileUpdate data) => json.encode(data.toJson());

class JobSeekerProfileUpdate {
  final String? resume;
  final String? experienceLevel;
  final String? educationLevel;
  final String? skills;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final bool? availability;
  final String? preferredJobType;
  final String? languages;

  JobSeekerProfileUpdate({
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

  factory JobSeekerProfileUpdate.fromJson(Map<String, dynamic> json) => JobSeekerProfileUpdate(
    resume: json["resume"],
    experienceLevel: json["experience_level"],
    educationLevel: json["education_level"],
    skills: json["skills"],
    expectedSalaryMin: json["expected_salary_min"],
    expectedSalaryMax: json["expected_salary_max"],
    availability: json["availability"],
    preferredJobType: json["preferred_job_type"],
    languages: json["languages"],
  );

  Map<String, dynamic> toJson() => {
    "resume": resume,
    "experience_level": experienceLevel,
    "education_level": educationLevel,
    "skills": skills,
    "expected_salary_min": expectedSalaryMin,
    "expected_salary_max": expectedSalaryMax,
    "availability": availability,
    "preferred_job_type": preferredJobType,
    "languages": languages,
  };
}
