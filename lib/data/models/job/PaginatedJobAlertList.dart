import 'JobAlert.dart';

class PaginatedJobAlertList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobAlert>? results;

  PaginatedJobAlertList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobAlertList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobAlertList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobAlert.fromJson(i)).toList()
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
