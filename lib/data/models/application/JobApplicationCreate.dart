class JobApplicationCreate {
  final int job;
  final String? coverLetter;
  final String? resume;
  final String? portfolioUrl;
  final int? expectedSalary;
  final String? availabilityDate;
  final String? notes;

  JobApplicationCreate({
    required this.job,
    this.coverLetter,
    this.resume,
    this.portfolioUrl,
    this.expectedSalary,
    this.availabilityDate,
    this.notes,
  });

  factory JobApplicationCreate.fromJson(Map<String, dynamic> json) {
    return JobApplicationCreate(
      job: json['job'],
      coverLetter: json['cover_letter'],
      resume: json['resume'],
      portfolioUrl: json['portfolio_url'],
      expectedSalary: json['expected_salary'],
      availabilityDate: json['availability_date'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job,
      'cover_letter': coverLetter,
      'resume': resume,
      'portfolio_url': portfolioUrl,
      'expected_salary': expectedSalary,
      'availability_date': availabilityDate,
      'notes': notes,
    };
  }
}
