// lib/models/user_models.dart
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;
  final String phone;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
    required this.isVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: json['user_type'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      location: json['location'],
      isVerified: json['is_verified'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
  bool get isJobSeeker => userType == 'job_seeker';
  bool get isEmployer => userType == 'employer';
  bool get isAdmin => userType == 'admin';
}

class UserRegistration {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String passwordConfirm;
  final String userType;
  final String phone;

  UserRegistration({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.passwordConfirm,
    required this.userType,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'password_confirm': passwordConfirm,
      'user_type': userType,
      'phone': phone,
    };
  }
}

class UserLogin {
  final String phone;
  final String password;

  UserLogin({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }
}

class UserProfileUpdate {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;

  UserProfileUpdate({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
    }..removeWhere((key, value) => value == null);
  }
}


class JobSeekerProfile {
  final int id;
  final User user;
  final String? resume;
  final String? experienceLevel;
  final String? educationLevel;
  final String? skills;
  final int? expectedSalaryMin;
  final int? expectedSalaryMax;
  final bool availability;
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
    required this.availability,
    this.preferredJobType,
    this.languages,
  });

  factory JobSeekerProfile.fromJson(Map<String, dynamic> json) {
    return JobSeekerProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      resume: json['resume'],
      experienceLevel: json['experience_level'],
      educationLevel: json['education_level'],
      skills: json['skills'],
      expectedSalaryMin: json['expected_salary_min'],
      expectedSalaryMax: json['expected_salary_max'],
      availability: json['availability'],
      preferredJobType: json['preferred_job_type'],
      languages: json['languages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

class EmployerProfile {
  final int id;
  final User user;
  final String companyName;
  final String? companyDescription;
  final String? companyLogo;
  final String? companyWebsite;
  final String? companySize;
  final String? industry;
  final int? foundedYear;

  EmployerProfile({
    required this.id,
    required this.user,
    required this.companyName,
    this.companyDescription,
    this.companyLogo,
    this.companyWebsite,
    this.companySize,
    this.industry,
    this.foundedYear,
  });

  factory EmployerProfile.fromJson(Map<String, dynamic> json) {
    return EmployerProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      companyName: json['company_name'],
      companyDescription: json['company_description'],
      companyLogo: json['company_logo'],
      companyWebsite: json['company_website'],
      companySize: json['company_size'],
      industry: json['industry'],
      foundedYear: json['founded_year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'company_description': companyDescription,
      'company_logo': companyLogo,
      'company_website': companyWebsite,
      'company_size': companySize,
      'industry': industry,
      'founded_year': foundedYear,
    };
  }
}

class PasswordChange {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  PasswordChange({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirm': newPasswordConfirm,
    };
  }
}