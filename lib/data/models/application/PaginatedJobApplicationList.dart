import 'JobApplication.dart';

class PaginatedJobApplicationList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobApplication>? results;

  PaginatedJobApplicationList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobApplicationList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobApplicationList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobApplication.fromJson(i)).toList()
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
