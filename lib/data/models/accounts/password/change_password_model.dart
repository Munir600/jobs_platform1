// To parse this JSON data, do
//
//     final changePasswordModel = changePasswordModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());

class ChangePasswordModel {
  String oldPassword;
  String newPassword;
  String newPasswordConfirm;

  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
    oldPassword: json["old_password"],
    newPassword: json["new_password"],
    newPasswordConfirm: json["new_password_confirm"],
  );

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword,
    "new_password": newPassword,
    "new_password_confirm": newPasswordConfirm,
  };
}
