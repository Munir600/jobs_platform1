// lib/models/interview_models.dart
import 'application_models.dart';

class Interview {
  final int id;
  final JobApplication application;
  final String interviewType;
  final String interviewTypeDisplay;
  final DateTime scheduledDate;
  final int durationMinutes;
  final String? location;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewerEmail;
  final String status;
  final String statusDisplay;
  final String? notes;
  final String? feedback;
  final int? score;
  final DateTime createdAt;
  final DateTime updatedAt;

  Interview({
    required this.id,
    required this.application,
    required this.interviewType,
    required this.interviewTypeDisplay,
    required this.scheduledDate,
    required this.durationMinutes,
    this.location,
    this.meetingLink,
    this.interviewerName,
    this.interviewerEmail,
    required this.status,
    required this.statusDisplay,
    this.notes,
    this.feedback,
    this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      application: JobApplication.fromJson(json['application']),
      interviewType: json['interview_type'],
      interviewTypeDisplay: json['interview_type_display'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      durationMinutes: json['duration_minutes'],
      location: json['location'],
      meetingLink: json['meeting_link'],
      interviewerName: json['interviewer_name'],
      interviewerEmail: json['interviewer_email'],
      status: json['status'],
      statusDisplay: json['status_display'],
      notes: json['notes'],
      feedback: json['feedback'],
      score: json['score'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class InterviewCreate {
  final int application;
  final String interviewType;
  final DateTime scheduledDate;
  final int durationMinutes;
  final String? location;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewerEmail;
  final String? notes;

  InterviewCreate({
    required this.application,
    required this.interviewType,
    required this.scheduledDate,
    required this.durationMinutes,
    this.location,
    this.meetingLink,
    this.interviewerName,
    this.interviewerEmail,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'interview_type': interviewType,
      'scheduled_date': scheduledDate.toIso8601String(),
      'duration_minutes': durationMinutes,
      'location': location,
      'meeting_link': meetingLink,
      'interviewer_name': interviewerName,
      'interviewer_email': interviewerEmail,
      'notes': notes,
    };
  }
}