import 'User.dart';

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
      'id': id,
      'user': user.toJson(),
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
