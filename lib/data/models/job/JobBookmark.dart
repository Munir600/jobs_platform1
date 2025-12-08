import 'JobList.dart';

class JobBookmark {
  final int? id;
  final JobList? job;
  final String? createdAt;

  JobBookmark({
    this.id,
    this.job,
    this.createdAt,
  });

  factory JobBookmark.fromJson(Map<String, dynamic> json) {
    return JobBookmark(
      id: json['id'],
      job: json['job'] != null ? JobList.fromJson(json['job']) : null,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job': job?.toJson(),
      'created_at': createdAt,
    };
  }
}
