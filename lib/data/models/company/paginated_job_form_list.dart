import 'job_form.dart';

class PaginatedJobFormList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobForm>? results;

  PaginatedJobFormList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobFormList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobFormList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobForm.fromJson(i)).toList()
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
