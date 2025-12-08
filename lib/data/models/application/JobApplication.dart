import '../accounts/profile/jobseeker/job_seeker_profile_model.dart';
import '../job/JobList.dart';

class JobApplication {
  final int? id;
  final JobList? job;
  final User? applicant;
  final String? coverLetter;
  final String? resume;
  final String? portfolioUrl;
  final int? expectedSalary;
  final String? availabilityDate;
  final String? status;
  final String? statusDisplay;
  final String? notes;
  final String? employerNotes;
  final int? rating;
  final bool? isViewed;
  final String? viewedAt;
  final String? appliedAt;
  final String? updatedAt;

  JobApplication({
    this.id,
    this.job,
    this.applicant,
    this.coverLetter,
    this.resume,
    this.portfolioUrl,
    this.expectedSalary,
    this.availabilityDate,
    this.status,
    this.statusDisplay,
    this.notes,
    this.employerNotes,
    this.rating,
    this.isViewed,
    this.viewedAt,
    this.appliedAt,
    this.updatedAt,
  });

  String? get applicantName => applicant?.firstName != null && applicant?.lastName != null
      ? '${applicant!.firstName}' ' ${applicant!.lastName}'
      : null;
  String? get applicantEmail => applicant?.email;
  String? get jobTitle => job?.title;

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      job: json['job'] != null ? JobList.fromJson(json['job']) : null,
      applicant: json['applicant'] != null ? User.fromJson(json['applicant']) : null,
      coverLetter: json['cover_letter'],
      resume: json['resume'],
      portfolioUrl: json['portfolio_url'],
      expectedSalary: json['expected_salary'],
      availabilityDate: json['availability_date'],
      status: json['status'],
      statusDisplay: json['status_display'],
      notes: json['notes'],
      employerNotes: json['employer_notes'],
      rating: json['rating'],
      isViewed: json['is_viewed'],
      viewedAt: json['viewed_at'],
      appliedAt: json['applied_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job': job?.toJson(),
      'applicant': applicant?.toJson(),
      'cover_letter': coverLetter,
      'resume': resume,
      'portfolio_url': portfolioUrl,
      'expected_salary': expectedSalary,
      'availability_date': availabilityDate,
      'status': status,
      'status_display': statusDisplay,
      'notes': notes,
      'employer_notes': employerNotes,
      'rating': rating,
      'is_viewed': isViewed,
      'viewed_at': viewedAt,
      'applied_at': appliedAt,
      'updated_at': updatedAt,
    };
  }
}
