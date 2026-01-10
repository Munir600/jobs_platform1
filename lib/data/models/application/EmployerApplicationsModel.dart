import 'dart:convert';
import 'JobApplication.dart';

class EmployerApplicationsModel {
    final StatusCounts? statusCounts;
    final int? count;
    final String? next;
    final String? previous;
    final List<JobApplication>? results;

    EmployerApplicationsModel({
        this.statusCounts,
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory EmployerApplicationsModel.fromJson(Map<String, dynamic> json) => EmployerApplicationsModel(
        statusCounts: json["status_counts"] == null ? null : StatusCounts.fromJson(json["status_counts"]),
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<JobApplication>.from(json["results"]!.map((x) => JobApplication.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_counts": statusCounts?.toJson(),
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class StatusCounts {
    final int? externalRedirect;
    final int? interviewScheduled;
    final int? pending;
    final int? accepted;
    final int? rejected;
    final int? withdrawn;

    StatusCounts({
        this.externalRedirect,
        this.interviewScheduled,
        this.pending,
        this.accepted,
        this.rejected,
        this.withdrawn,
    });

    factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
        externalRedirect: json["external_redirect"],
        interviewScheduled: json["interview_scheduled"],
        pending: json["pending"],
        accepted: json["accepted"],
        rejected: json["rejected"],
        withdrawn: json["withdrawn"],
    );

    Map<String, dynamic> toJson() => {
        "external_redirect": externalRedirect,
        "interview_scheduled": interviewScheduled,
        "pending": pending,
        "accepted": accepted,
        "rejected": rejected,
        "withdrawn": withdrawn,
    };
}
