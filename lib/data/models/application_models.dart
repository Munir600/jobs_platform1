// lib/models/application_models.dart
import 'user_models.dart';
import 'job_models.dart';

class JobApplication {
  final int id;
  final JobList job;
  final User applicant;
  final String? coverLetter;
  final String? resume;
  final String? portfolioUrl;
  final int? expectedSalary;
  final String? availabilityDate;
  final String status;
  final String statusDisplay;
  final String? notes;
  final String? employerNotes;
  final int? rating;
  final bool isViewed;
  final DateTime? viewedAt;
  final DateTime appliedAt;
  final DateTime updatedAt;

  JobApplication({
    required this.id,
    required this.job,
    required this.applicant,
    this.coverLetter,
    this.resume,
    this.portfolioUrl,
    this.expectedSalary,
    this.availabilityDate,
    required this.status,
    required this.statusDisplay,
    this.notes,
    this.employerNotes,
    this.rating,
    required this.isViewed,
    this.viewedAt,
    required this.appliedAt,
    required this.updatedAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      job: JobList.fromJson(json['job']),
      applicant: User.fromJson(json['applicant']),
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
      viewedAt: json['viewed_at'] != null
          ? DateTime.parse(json['viewed_at'])
          : null,
      appliedAt: DateTime.parse(json['applied_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

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

class JobApplicationUpdate {
  final String status;
  final String? employerNotes;
  final int? rating;

  JobApplicationUpdate({
    required this.status,
    this.employerNotes,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'employer_notes': employerNotes,
      'rating': rating,
    };
  }
}

class ApplicationMessage {
  final int id;
  final int application;
  final User sender;
  final String senderName;
  final String message;
  final String? attachment;
  final bool isRead;
  final DateTime sentAt;

  ApplicationMessage({
    required this.id,
    required this.application,
    required this.sender,
    required this.senderName,
    required this.message,
    this.attachment,
    required this.isRead,
    required this.sentAt,
  });

  factory ApplicationMessage.fromJson(Map<String, dynamic> json) {
    return ApplicationMessage(
      id: json['id'],
      application: json['application'],
      sender: User.fromJson(json['sender']),
      senderName: json['sender_name'],
      message: json['message'],
      attachment: json['attachment'],
      isRead: json['is_read'],
      sentAt: DateTime.parse(json['sent_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'message': message,
      'attachment': attachment,
    };
  }
}