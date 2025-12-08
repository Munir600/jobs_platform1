import 'JobList.dart';

class PaginatedJobListList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobList>? results;

  PaginatedJobListList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobListList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobListList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobList.fromJson(i)).toList()
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
