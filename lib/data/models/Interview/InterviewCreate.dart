class InterviewCreate {
  final int? application;
  final String interviewType;
  final String scheduledDate;
  final int? durationMinutes;
  final String? location;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewerEmail;
  final String? notes;

  InterviewCreate({
     this.application,
    required this.interviewType,
    required this.scheduledDate,
    this.durationMinutes,
    this.location,
    this.meetingLink,
    this.interviewerName,
    this.interviewerEmail,
    this.notes,
  });

  factory InterviewCreate.fromJson(Map<String, dynamic> json) {
    return InterviewCreate(
      application: json['application'],
      interviewType: json['interview_type'],
      scheduledDate: json['scheduled_date'],
      durationMinutes: json['duration_minutes'],
      location: json['location'],
      meetingLink: json['meeting_link'],
      interviewerName: json['interviewer_name'],
      interviewerEmail: json['interviewer_email'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'interview_type': interviewType,
      'scheduled_date': scheduledDate,
      'duration_minutes': durationMinutes,
      'location': location,
      'meeting_link': meetingLink,
      'interviewer_name': interviewerName,
      'interviewer_email': interviewerEmail,
      'notes': notes,
    };
  }
}
