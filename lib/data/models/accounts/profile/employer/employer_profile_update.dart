// To parse this JSON data, do
//
//     final employerProfileUpdate = employerProfileUpdateFromJson(jsonString);

import 'dart:convert';

EmployerProfileUpdate employerProfileUpdateFromJson(String str) => EmployerProfileUpdate.fromJson(json.decode(str));

String employerProfileUpdateToJson(EmployerProfileUpdate data) => json.encode(data.toJson());

class EmployerProfileUpdate {
  final String companyName;
  final String? companyDescription;
  final String? companyLogo;
  final String? companyWebsite;
  final String? companySize;
  final String? industry;
  final int? foundedYear;

  EmployerProfileUpdate({
   required this.companyName,
    this.companyDescription,
    this.companyLogo,
    this.companyWebsite,
    this.companySize,
    this.industry,
    this.foundedYear,
  });

  factory EmployerProfileUpdate.fromJson(Map<String, dynamic> json) => EmployerProfileUpdate(
    companyName: json["company_name"],
    companyDescription: json["company_description"],
    companyLogo: json["company_logo"],
    companyWebsite: json["company_website"],
    companySize: json["company_size"],
    industry: json["industry"],
    foundedYear: json["founded_year"],
  );

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "company_description": companyDescription,
    "company_logo": companyLogo,
    "company_website": companyWebsite,
    "company_size": companySize,
    "industry": industry,
    "founded_year": foundedYear,
  };
}
