class CompanyReview {
  final int? id;
  final int? rating;
  final String? title;
  final String? reviewText;
  final String? pros;
  final String? cons;
  final bool? isCurrentEmployee;
  final String? jobTitle;
  final String? reviewer;
  final String? reviewerName;
  final String? createdAt;

  CompanyReview({
    this.id,
    this.rating,
    this.title,
    this.reviewText,
    this.pros,
    this.cons,
    this.isCurrentEmployee,
    this.jobTitle,
    this.reviewer,
    this.reviewerName,
    this.createdAt,
  });

  factory CompanyReview.fromJson(Map<String, dynamic> json) {
    return CompanyReview(
      id: json['id'],
      rating: json['rating'],
      title: json['title'],
      reviewText: json['review_text'],
      pros: json['pros'],
      cons: json['cons'],
      isCurrentEmployee: json['is_current_employee'],
      jobTitle: json['job_title'],
      reviewer: json['reviewer'],
      reviewerName: json['reviewer_name'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'title': title,
      'review_text': reviewText,
      'pros': pros,
      'cons': cons,
      'is_current_employee': isCurrentEmployee,
      'job_title': jobTitle,
      'reviewer': reviewer,
      'reviewer_name': reviewerName,
      'created_at': createdAt,
    };
  }
}
