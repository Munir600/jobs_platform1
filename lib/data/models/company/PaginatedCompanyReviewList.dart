import 'CompanyReview.dart';

class PaginatedCompanyReviewList {
  final int? count;
  final String? next;
  final String? previous;
  final List<CompanyReview>? results;

  PaginatedCompanyReviewList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory PaginatedCompanyReviewList.fromJson(Map<String, dynamic> json) {
    return PaginatedCompanyReviewList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? (json['results'] as List).map((i) => CompanyReview.fromJson(i)).toList()
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
