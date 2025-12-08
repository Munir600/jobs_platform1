import 'JobBookmark.dart';

class PaginatedJobBookmarkList {
  final int? count;
  final String? next;
  final String? previous;
  final List<JobBookmark>? results;

  PaginatedJobBookmarkList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedJobBookmarkList.fromJson(Map<String, dynamic> json) {
    return PaginatedJobBookmarkList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => JobBookmark.fromJson(i)).toList()
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
