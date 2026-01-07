import 'FormDetail.dart';

class PaginatedFormList {
  final int? count;
  final String? next;
  final String? previous;
  final List<FormDetail>? results;

  PaginatedFormList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedFormList.fromJson(Map<String, dynamic> json) {
    return PaginatedFormList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => FormDetail.fromJson(i)).toList()
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
