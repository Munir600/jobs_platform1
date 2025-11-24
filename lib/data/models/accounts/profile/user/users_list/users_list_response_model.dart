// To parse this JSON data, do
//
//     final usersListResponseModel = usersListResponseModelFromJson(jsonString);

import 'dart:convert';

UsersListResponseModel usersListResponseModelFromJson(String str) => UsersListResponseModel.fromJson(json.decode(str));

String usersListResponseModelToJson(UsersListResponseModel data) => json.encode(data.toJson());

class UsersListResponseModel {
  final int? count;
  final String? next;
  final String? previous;
  final List<Result>? results;

  UsersListResponseModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory UsersListResponseModel.fromJson(Map<String, dynamic> json) => UsersListResponseModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool? isVerified;
  final DateTime? createdAt;

  Result({
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

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userType: json["user_type"],
    phone: json["phone"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
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
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "profile_picture": profilePicture,
    "bio": bio,
    "location": location,
    "is_verified": isVerified,
    "created_at": createdAt?.toIso8601String(),
  };
}
