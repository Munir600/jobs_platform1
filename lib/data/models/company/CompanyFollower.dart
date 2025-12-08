import 'Company.dart';

class CompanyFollower {
  final int? id;
  final Company? company;
  final String? followedAt;

  CompanyFollower({
    this.id,
    this.company,
    this.followedAt,
  });

  factory CompanyFollower.fromJson(Map<String, dynamic> json) {
    return CompanyFollower(
      id: json['id'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      followedAt: json['followed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company?.toJson(),
      'followed_at': followedAt,
    };
  }
}
