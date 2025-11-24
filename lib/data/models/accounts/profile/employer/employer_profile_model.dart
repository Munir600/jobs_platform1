// To parse this JSON data, do
//
//     final employerProfileModel = employerProfileModelFromJson(jsonString);

import 'dart:convert';

EmployerProfileModel employerProfileModelFromJson(String str) => EmployerProfileModel.fromJson(json.decode(str));

String employerProfileModelToJson(EmployerProfileModel data) => json.encode(data.toJson());

class EmployerProfileModel {
  Data data;

  EmployerProfileModel({
    required this.data,
  });

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) => EmployerProfileModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  User user;
  Profile profile;

  Data({
    required this.user,
    required this.profile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    profile: Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "profile": profile.toJson(),
  };
}

class Profile {
  int id;
  User user;
  String companyName;
  String? companyDescription;
  String? companyLogo;
  String? companyWebsite;
  String? companySize;
  String? industry;
  int? foundedYear;

  Profile({
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

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    user: User.fromJson(json["user"]),
    companyName: json["company_name"],
    companyDescription: json["company_description"],
    companyLogo: json["company_logo"],
    companyWebsite: json["company_website"],
    companySize: json["company_size"],
    industry: json["industry"],
    foundedYear: json["founded_year"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "company_name": companyName,
    "company_description": companyDescription,
    "company_logo": companyLogo,
    "company_website": companyWebsite,
    "company_size": companySize,
    "industry": industry,
    "founded_year": foundedYear,
  };
}

class User {
  int id;
  String username;
  String? email;
  String? firstName;
  String? lastName;
  String? userType;
  String? phone;
  String? dateOfBirth;
  String? profilePicture;
  String? bio;
  String? location;
  bool isVerified;
  DateTime createdAt;

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
    createdAt: DateTime.parse(json["created_at"]),
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
    "created_at": createdAt.toIso8601String(),
  };
}
