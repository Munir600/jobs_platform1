class ApplicationStatistics {
  final int totalApplications;
  final int pendingApplications;
  final int acceptedApplications;
  final int rejectedApplications;
  final List<StatusCount> applicationsByStatus;

  ApplicationStatistics({
    required this.totalApplications,
    required this.pendingApplications,
    required this.acceptedApplications,
    required this.rejectedApplications,
    required this.applicationsByStatus,
  });

  factory ApplicationStatistics.fromJson(Map<String, dynamic> json) {
    return ApplicationStatistics(
      totalApplications: json['total_applications'] ?? 0,
      pendingApplications: json['pending_applications'] ?? 0,
      acceptedApplications: json['accepted_applications'] ?? 0,
      rejectedApplications: json['rejected_applications'] ?? 0,
      applicationsByStatus: (json['applications_by_status'] as List?)
              ?.map((e) => StatusCount.fromJson(e))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'total_applications': totalApplications,
      'pending_applications': pendingApplications,
      'accepted_applications': acceptedApplications,
      'rejected_applications': rejectedApplications,
      'applications_by_status': applicationsByStatus.map((e) => e.toJson()).toList(),
    };
  }
}

class StatusCount {
  final String status;
  final int count;

  StatusCount({required this.status, required this.count});

  factory StatusCount.fromJson(Map<String, dynamic> json) {
    return StatusCount(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
    };
  }
}
