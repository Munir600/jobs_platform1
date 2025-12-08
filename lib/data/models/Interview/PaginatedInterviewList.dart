import 'Interview.dart';

class PaginatedInterviewList {
  final int? count;
  final String? next;
  final String? previous;
  final List<Interview>? results;

  PaginatedInterviewList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedInterviewList.fromJson(Map<String, dynamic> json) {
    return PaginatedInterviewList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => Interview.fromJson(i)).toList()
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
