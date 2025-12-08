import 'Company.dart';

class PaginatedCompanyList {
  final int? count;
  final String? next;
  final String? previous;
  final List<Company>? results;

  PaginatedCompanyList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedCompanyList.fromJson(Map<String, dynamic> json) {
    return PaginatedCompanyList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => Company.fromJson(i)).toList()
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
