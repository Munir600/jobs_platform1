import 'JobCategory.dart';

class PaginatedJobCategoryList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobCategory>? results;

  PaginatedJobCategoryList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobCategoryList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobCategoryList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobCategory.fromJson(i)).toList()
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
