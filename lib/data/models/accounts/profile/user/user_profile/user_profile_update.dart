// To parse this JSON data, do
//
//     final userProfileUpdate = userProfileUpdateFromJson(jsonString);

import 'dart:convert';

UserProfileUpdate userProfileUpdateFromJson(String str) => UserProfileUpdate.fromJson(json.decode(str));

String userProfileUpdateToJson(UserProfileUpdate data) => json.encode(data.toJson());

class UserProfileUpdate {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;

  UserProfileUpdate({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
  });

  factory UserProfileUpdate.fromJson(Map<String, dynamic> json) => UserProfileUpdate(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    profilePicture: json["profile_picture"],
    bio: json["bio"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "bio": bio,
    "location": location,
  };
}
