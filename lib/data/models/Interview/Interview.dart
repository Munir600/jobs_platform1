import '../application/JobApplication.dart';

class Interview {
  final int? id;
  final JobApplication? application;
  final String? interviewType;
  final String? interviewTypeDisplay;
  final String? scheduledDate;
  final int? durationMinutes;
  final String? location;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewerEmail;
  final String? status;
  final String? statusDisplay;
  final String? notes;
  final String? feedback;
  final int? score;
  final String? createdAt;
  final String? updatedAt;

  Interview({
    this.id,
    this.application,
    this.interviewType,
    this.interviewTypeDisplay,
    this.scheduledDate,
    this.durationMinutes,
    this.location,
    this.meetingLink,
    this.interviewerName,
    this.interviewerEmail,
    this.status,
    this.statusDisplay,
    this.notes,
    this.feedback,
    this.score,
    this.createdAt,
    this.updatedAt,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      application: json['application'] is Map<String, dynamic> 
          ? JobApplication.fromJson(json['application']) 
          : null, // Handle case where it might be just an ID or null, though API says object
      interviewType: json['interview_type'],
      interviewTypeDisplay: json['interview_type_display'],
      scheduledDate: json['scheduled_date'],
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application': application?.toJson(),
      'interview_type': interviewType,
      'interview_type_display': interviewTypeDisplay,
      'scheduled_date': scheduledDate,
      'duration_minutes': durationMinutes,
      'location': location,
      'meeting_link': meetingLink,
      'interviewer_name': interviewerName,
      'interviewer_email': interviewerEmail,
      'status': status,
      'status_display': statusDisplay,
      'notes': notes,
      'feedback': feedback,
      'score': score,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
