// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  final Data? data;

  UserProfileModel({
    this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  final String? message;
  final User? user;
  final String? token;

  Data({
    this.message,
    this.user,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  final int id;
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
