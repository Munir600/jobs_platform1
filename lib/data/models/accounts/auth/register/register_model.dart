// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String password;
  final String passwordConfirm;
  final String? userType;
  final String phone;

  RegisterModel({
   required this.username,
    this.email,
    this.firstName,
    this.lastName,
    required this.password,
    required this.passwordConfirm,
     this.userType,
    required this.phone,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    username: json["username"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    password: json["password"],
    passwordConfirm: json["password_confirm"],
    userType: json["user_type"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "password": password,
    "password_confirm": passwordConfirm,
    "user_type": userType,
    "phone": phone,
  };
}
