// To parse this JSON data, do
//
//     final employerDashboard = employerDashboardFromJson(jsonString);

import 'dart:convert';

EmployerDashboard employerDashboardFromJson(String str) => EmployerDashboard.fromJson(json.decode(str));

String employerDashboardToJson(EmployerDashboard data) => json.encode(data.toJson());

class EmployerDashboard {
  final Overview? overview;
  final Charts? charts;

  EmployerDashboard({
    this.overview,
    this.charts,
  });

  factory EmployerDashboard.fromJson(Map<String, dynamic> json) => EmployerDashboard(
    overview: json["overview"] == null ? null : Overview.fromJson(json["overview"]),
    charts: json["charts"] == null ? null : Charts.fromJson(json["charts"]),
  );

  Map<String, dynamic> toJson() => {
    "overview": overview?.toJson(),
    "charts": charts?.toJson(),
  };
}

class Charts {
  final ApplicantsByCategory? appsOverTime;
  final ApplicantsByCategory? jobsByCity;
  final ApplicantsByCategory? jobsByCategory;
  final ApplicantsByCategory? jobsByType;
  final ApplicantsByCategory? applicationsByStatus;
  final ApplicantsByCategory? applicantsByCity;
  final ApplicantsByCategory? applicantsByCategory;
  final ApplicantsByCategory? applicantsByJobTitle;

  Charts({
    this.appsOverTime,
    this.jobsByCity,
    this.jobsByCategory,
    this.jobsByType,
    this.applicationsByStatus,
    this.applicantsByCity,
    this.applicantsByCategory,
    this.applicantsByJobTitle,
  });

  factory Charts.fromJson(Map<String, dynamic> json) => Charts(
    appsOverTime: json["apps_over_time"] == null ? null : ApplicantsByCategory.fromJson(json["apps_over_time"]),
    jobsByCity: json["jobs_by_city"] == null ? null : ApplicantsByCategory.fromJson(json["jobs_by_city"]),
    jobsByCategory: json["jobs_by_category"] == null ? null : ApplicantsByCategory.fromJson(json["jobs_by_category"]),
    jobsByType: json["jobs_by_type"] == null ? null : ApplicantsByCategory.fromJson(json["jobs_by_type"]),
    applicationsByStatus: json["applications_by_status"] == null ? null : ApplicantsByCategory.fromJson(json["applications_by_status"]),
    applicantsByCity: json["applicants_by_city"] == null ? null : ApplicantsByCategory.fromJson(json["applicants_by_city"]),
    applicantsByCategory: json["applicants_by_category"] == null ? null : ApplicantsByCategory.fromJson(json["applicants_by_category"]),
    applicantsByJobTitle: json["applicants_by_job_title"] == null ? null : ApplicantsByCategory.fromJson(json["applicants_by_job_title"]),
  );

  Map<String, dynamic> toJson() => {
    "apps_over_time": appsOverTime?.toJson(),
    "jobs_by_city": jobsByCity?.toJson(),
    "jobs_by_category": jobsByCategory?.toJson(),
    "jobs_by_type": jobsByType?.toJson(),
    "applications_by_status": applicationsByStatus?.toJson(),
    "applicants_by_city": applicantsByCity?.toJson(),
    "applicants_by_category": applicantsByCategory?.toJson(),
    "applicants_by_job_title": applicantsByJobTitle?.toJson(),
  };
}

class ApplicantsByCategory {
  final List<String>? labels;
  final List<int>? series;

  ApplicantsByCategory({
    this.labels,
    this.series,
  });

  factory ApplicantsByCategory.fromJson(Map<String, dynamic> json) => ApplicantsByCategory(
    labels: json["labels"] == null ? [] : List<String>.from(json["labels"]!.map((x) => x)),
    series: json["series"] == null ? [] : List<int>.from(json["series"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
    "series": series == null ? [] : List<dynamic>.from(series!.map((x) => x)),
  };
}

class Overview {
  final int? totalCompanies;
  final int? totalJobs;
  final int? activeJobs;
  final int? totalApplications;
  final int? totalUniqueApplicants;
  final int? totalViews;
  final int? totalMessages;
  final int? unreadMessages;

  Overview({
    this.totalCompanies,
    this.totalJobs,
    this.activeJobs,
    this.totalApplications,
    this.totalUniqueApplicants,
    this.totalViews,
    this.totalMessages,
    this.unreadMessages,
  });

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    totalCompanies: json["total_companies"],
    totalJobs: json["total_jobs"],
    activeJobs: json["active_jobs"],
    totalApplications: json["total_applications"],
    totalUniqueApplicants: json["total_unique_applicants"],
    totalViews: json["total_views"],
    totalMessages: json["total_messages"],
    unreadMessages: json["unread_messages"],
  );

  Map<String, dynamic> toJson() => {
    "total_companies": totalCompanies,
    "total_jobs": totalJobs,
    "active_jobs": activeJobs,
    "total_applications": totalApplications,
    "total_unique_applicants": totalUniqueApplicants,
    "total_views": totalViews,
    "total_messages": totalMessages,
    "unread_messages": unreadMessages,
  };
}
