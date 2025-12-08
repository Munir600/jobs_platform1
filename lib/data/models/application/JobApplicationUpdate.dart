class JobApplicationUpdate {
  final String? status;
  final String? employerNotes;
  final int? rating;

  JobApplicationUpdate({
    this.status,
    this.employerNotes,
    this.rating,
  });

  factory JobApplicationUpdate.fromJson(Map<String, dynamic> json) {
    return JobApplicationUpdate(
      status: json['status'],
      employerNotes: json['employer_notes'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'employer_notes': employerNotes,
      'rating': rating,
    };
  }
}
