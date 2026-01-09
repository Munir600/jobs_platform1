class ApplicationStatistics {
  final int totalApplications;
  final int pendingApplications;
  final int acceptedApplications;
  final int rejectedApplications;
  final int withdrawnCount;
  final int externalRedirectCount;
  final int interviewScheduledCount;
  final List<StatusCount> applicationsByStatus;

  ApplicationStatistics({
    required this.totalApplications,
    required this.pendingApplications,
    required this.acceptedApplications,
    required this.rejectedApplications,
    this.withdrawnCount = 0,
    this.externalRedirectCount = 0,
    this.interviewScheduledCount = 0,
    required this.applicationsByStatus,
  });

  factory ApplicationStatistics.fromJson(Map<String, dynamic> json) {
    return ApplicationStatistics(
      totalApplications: json['total_applications'] ?? 0,
      pendingApplications: json['pending_applications'] ?? 0,
      acceptedApplications: json['accepted_applications'] ?? 0,
      rejectedApplications: json['rejected_applications'] ?? 0,
      withdrawnCount: json['withdrawn_count'] ?? 0,
      externalRedirectCount: json['external_redirect_count'] ?? 0,
      interviewScheduledCount: json['interview_scheduled_count'] ?? 0,
      applicationsByStatus: (json['applications_by_status'] as List?)
          ?.map((e) => StatusCount.fromJson(e))
          .toList() ??
          [],
    );
  }

  factory ApplicationStatistics.fromModelStatusCounts(dynamic statusCounts, int total) {
    // This factory helps bridge the gap between the new API's status_counts and our UI statistics
    if (statusCounts == null) {
      return ApplicationStatistics(
        totalApplications: total,
        pendingApplications: 0,
        acceptedApplications: 0,
        rejectedApplications: 0,
        applicationsByStatus: [],
      );
    }

    // Convert to the internal list format for DetailedStatisticsSheet
    List<StatusCount> byStatus = [];
    if (statusCounts.pending != null) byStatus.add(StatusCount(status: 'pending', count: statusCounts.pending!));
    if (statusCounts.accepted != null) byStatus.add(StatusCount(status: 'accepted', count: statusCounts.accepted!));
    if (statusCounts.rejected != null) byStatus.add(StatusCount(status: 'rejected', count: statusCounts.rejected!));
    if (statusCounts.interviewScheduled != null) byStatus.add(StatusCount(status: 'interview_scheduled', count: statusCounts.interviewScheduled!));
    if (statusCounts.externalRedirect != null) byStatus.add(StatusCount(status: 'external_redirect', count: statusCounts.externalRedirect!));
    if (statusCounts.withdrawn != null) byStatus.add(StatusCount(status: 'withdrawn', count: statusCounts.withdrawn!));

    return ApplicationStatistics(
      totalApplications: total,
      pendingApplications: statusCounts.pending ?? 0,
      acceptedApplications: statusCounts.accepted ?? 0,
      rejectedApplications: statusCounts.rejected ?? 0,
      withdrawnCount: statusCounts.withdrawn ?? 0,
      externalRedirectCount: statusCounts.externalRedirect ?? 0,
      interviewScheduledCount: statusCounts.interviewScheduled ?? 0,
      applicationsByStatus: byStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_applications': totalApplications,
      'pending_applications': pendingApplications,
      'accepted_applications': acceptedApplications,
      'rejected_applications': rejectedApplications,
      'withdrawn_count': withdrawnCount,
      'external_redirect_count': externalRedirectCount,
      'interview_scheduled_count': interviewScheduledCount,
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
