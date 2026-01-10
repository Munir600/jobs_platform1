import '../accounts/User.dart';
import '../job/JobDetail.dart';
import 'JobApplicationCreate.dart';

class JobApplication {
  final int id;
  final JobDetail? job;
  final User? applicant;
  final String? coverLetter;
  final String? resume;
  final String? portfolioUrl;
  final int? expectedSalary;
  final DateTime? availabilityDate;
  final String? status;
  final String? statusDisplay;
  final String? notes;
  final String? employerNotes;
  final dynamic rating;
  final bool? isViewed;
  final DateTime? viewedAt;
  final DateTime? appliedAt;
  final DateTime? updatedAt;
  final int? documentsCount;
  final String? filledTemplate;
  final List<JobApplicationResponse>? responses;

  JobApplication({
    required this.id,
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
    this.documentsCount,
    this.filledTemplate,
    this.responses,
  });

  String? get applicantName => applicant?.firstName != null && applicant?.lastName != null
      ? '${applicant!.firstName}' ' ${applicant!.lastName}'
      : null;
  String? get applicantEmail => applicant?.email;
  String? get jobTitle => job?.title;

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    // Handle job being either an object (Map) or an ID (int)
    dynamic jobData = json['job'];
    JobDetail? jobDetail;
    if (jobData is Map<String, dynamic>) {
      jobDetail = JobDetail.fromJson(jobData);
    } else if (jobData is int) {
      jobDetail = JobDetail(
        id: jobData,
        title: '',
        slug: '',
        description: '',
        requirements: '',
        jobType: 'full_time',
        experienceLevel: 'entry',
        educationLevel: 'none',
        city: '',
      );
    }

    return JobApplication(
      id: json['id'],
      job: jobDetail,
      applicant: json['applicant'] != null ? User.fromJson(json['applicant']) : null,
      coverLetter: json['cover_letter'],
      resume: json['resume'],
      portfolioUrl: json['portfolio_url'],
      expectedSalary: json['expected_salary'],
      availabilityDate: json['availability_date'] == null ? null : DateTime.parse(json['availability_date']),
      status: json['status'],
      statusDisplay: json['status_display'],
      notes: json['notes'],
      employerNotes: json['employer_notes'],
      rating: json['rating'],
      isViewed: json['is_viewed'],
      viewedAt: json['viewed_at'] == null ? null : DateTime.parse(json['viewed_at']),
      appliedAt: json['applied_at'] == null ? null : DateTime.parse(json['applied_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      documentsCount: json['documents_count'],
      filledTemplate: json['filled_template'],
      responses: (json['responses'] ?? json['question_responses'] ?? json['answers']) != null
          ? (json['responses'] ?? json['question_responses'] ?? json['answers'] as List)
          .map((i) => JobApplicationResponse.fromJson(i))
          .toList()
          : null,
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
      'availability_date': availabilityDate?.toIso8601String(),
      'status': status,
      'status_display': statusDisplay,
      'notes': notes,
      'employer_notes': employerNotes,
      'rating': rating,
      'is_viewed': isViewed,
      'viewed_at': viewedAt?.toIso8601String(),
      'applied_at': appliedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'documents_count': documentsCount,
      'filled_template': filledTemplate,
      'responses': responses?.map((e) => e.toJson()).toList(),
    };
  }
}
