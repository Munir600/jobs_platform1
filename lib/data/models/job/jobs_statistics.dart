// To parse this JSON data, do
//
//     final jobsStatistics = jobsStatisticsFromJson(jsonString);

import 'dart:convert';

JobsStatistics jobsStatisticsFromJson(String str) => JobsStatistics.fromJson(json.decode(str));

String jobsStatisticsToJson(JobsStatistics data) => json.encode(data.toJson());

class JobsStatistics {
  final int? totalJobs;
  final int? featuredJobs;
  final int? urgentJobs;
  final List<JobsByType>? jobsByType;
  final List<JobsByCity>? jobsByCity;
  final List<JobsByCategory>? jobsByCategory;

  JobsStatistics({
    this.totalJobs,
    this.featuredJobs,
    this.urgentJobs,
    this.jobsByType,
    this.jobsByCity,
    this.jobsByCategory,
  });

  factory JobsStatistics.fromJson(Map<String, dynamic> json) => JobsStatistics(
    totalJobs: json["total_jobs"],
    featuredJobs: json["featured_jobs"],
    urgentJobs: json["urgent_jobs"],
    jobsByType: json["jobs_by_type"] == null ? [] : List<JobsByType>.from(json["jobs_by_type"]!.map((x) => JobsByType.fromJson(x))),
    jobsByCity: json["jobs_by_city"] == null ? [] : List<JobsByCity>.from(json["jobs_by_city"]!.map((x) => JobsByCity.fromJson(x))),
    jobsByCategory: json["jobs_by_category"] == null ? [] : List<JobsByCategory>.from(json["jobs_by_category"]!.map((x) => JobsByCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_jobs": totalJobs,
    "featured_jobs": featuredJobs,
    "urgent_jobs": urgentJobs,
    "jobs_by_type": jobsByType == null ? [] : List<dynamic>.from(jobsByType!.map((x) => x.toJson())),
    "jobs_by_city": jobsByCity == null ? [] : List<dynamic>.from(jobsByCity!.map((x) => x.toJson())),
    "jobs_by_category": jobsByCategory == null ? [] : List<dynamic>.from(jobsByCategory!.map((x) => x.toJson())),
  };
}

class JobsByCategory {
  final String? categoryName;
  final int? count;

  JobsByCategory({
    this.categoryName,
    this.count,
  });

  factory JobsByCategory.fromJson(Map<String, dynamic> json) => JobsByCategory(
    categoryName: json["category__name"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "category__name": categoryName,
    "count": count,
  };
}

class JobsByCity {
  final String? city;
  final int? count;

  JobsByCity({
    this.city,
    this.count,
  });

  factory JobsByCity.fromJson(Map<String, dynamic> json) => JobsByCity(
    city: json["city"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "count": count,
  };
}

class JobsByType {
  final String? jobType;
  final int? count;

  JobsByType({
    this.jobType,
    this.count,
  });

  factory JobsByType.fromJson(Map<String, dynamic> json) => JobsByType(
    jobType: json["job_type"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "job_type": jobType,
    "count": count,
  };
}
