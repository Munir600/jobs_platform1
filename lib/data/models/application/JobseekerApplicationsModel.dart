import 'JobApplication.dart';

class JobseekerApplicationsModel {
    final int? count;
    final String? next;
    final String? previous;
    final List<JobApplication>? results;

    JobseekerApplicationsModel({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory JobseekerApplicationsModel.fromJson(Map<String, dynamic> json) => JobseekerApplicationsModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<JobApplication>.from(json["results"]!.map((x) => JobApplication.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}
