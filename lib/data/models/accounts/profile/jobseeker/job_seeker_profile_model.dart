// To parse this JSON data, do
//
//     final jobSeekerProfileModel = jobSeekerProfileModelFromJson(jsonString);

import 'dart:convert';

JobSeekerProfileModel jobSeekerProfileModelFromJson(String str) => JobSeekerProfileModel.fromJson(json.decode(str));

String jobSeekerProfileModelToJson(JobSeekerProfileModel data) => json.encode(data.toJson());

class JobSeekerProfileModel {
  final Data? data;

  JobSeekerProfileModel({
    this.data,
  });

  factory JobSeekerProfileModel.fromJson(Map<String, dynamic> json) => JobSeekerProfileModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  final User? user;
  final Profile? profile;

  Data({
   required this.user,
    this.profile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "profile": profile?.toJson(),
  };
}

class Profile {
  final int? id;
  final User? user;
  final String? resume;
  final String? experienceLevel;
  final String? educationLevel;
  final String? skills;
  final String? expectedSalaryMin;
  final String? expectedSalaryMax;
  final bool? availability;
  final String? preferredJobType;
  final String? languages;

  Profile({
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

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
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
    "id": id,
    "user": user?.toJson(),
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

class User {
  final int? id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? phone;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final DateTime? createdAt;

  User({
   required this.id,
   required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
   required this.isVerified,
   required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userType: json["user_type"],
    phone: json["phone"],
    dateOfBirth: json["date_of_birth"],
    profilePicture: json["profile_picture"],
    bio: json["bio"],
    location: json["location"],
    isVerified: json["is_verified"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "user_type": userType,
    "phone": phone,
    "date_of_birth": dateOfBirth,
    "profile_picture": profilePicture,
    "bio": bio,
    "location": location,
    "is_verified": isVerified,
    "created_at": createdAt?.toIso8601String(),
  };
}
