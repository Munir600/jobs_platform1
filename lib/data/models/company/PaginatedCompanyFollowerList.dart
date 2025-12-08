import 'CompanyFollower.dart';

class PaginatedCompanyFollowerList {
  final int? count;
  final String? next;
  final String? previous;
  final List<CompanyFollower>? results;

  PaginatedCompanyFollowerList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedCompanyFollowerList.fromJson(Map<String, dynamic> json) {
    return PaginatedCompanyFollowerList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => CompanyFollower.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}
