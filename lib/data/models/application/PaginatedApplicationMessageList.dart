import 'ApplicationMessage.dart';

class PaginatedApplicationMessageList {
  final int? count;
  final String? next;
  final String? previous;
  final List<ApplicationMessage>? results;

  PaginatedApplicationMessageList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedApplicationMessageList.fromJson(Map<String, dynamic> json) {
    return PaginatedApplicationMessageList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => ApplicationMessage.fromJson(i)).toList()
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
