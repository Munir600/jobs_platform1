// To parse this JSON data, do
//
//     final usersRetrieveModel = usersRetrieveModelFromJson(jsonString);

import 'dart:convert';

UsersRetrieveModel usersRetrieveModelFromJson(String str) => UsersRetrieveModel.fromJson(json.decode(str));

String usersRetrieveModelToJson(UsersRetrieveModel data) => json.encode(data.toJson());

class UsersRetrieveModel {
  final Data? data;

  UsersRetrieveModel({
    this.data,
  });

  factory UsersRetrieveModel.fromJson(Map<String, dynamic> json) => UsersRetrieveModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? phone;
  final dynamic dateOfBirth;
  final String? profilePicture;
  final dynamic bio;
  final dynamic location;
  final bool? isVerified;
  final DateTime? createdAt;

  Data({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.userType,
    this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
    this.isVerified,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
