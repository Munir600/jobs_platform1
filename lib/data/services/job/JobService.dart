import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants.dart';
import '../api_client.dart';
import '../../models/job/JobDetail.dart';
import '../../models/job/JobCreate.dart';
import '../../models/job/JobAlert.dart';
import '../../models/job/PaginatedJobListList.dart';
import '../../models/job/PaginatedJobCategoryList.dart';
import '../../models/job/PaginatedJobAlertList.dart';
import '../../models/job/PaginatedJobBookmarkList.dart';

class JobService {
  final ApiClient _apiClient = ApiClient();
 final GetStorage _storage = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from jobs  is : $token');
    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<PaginatedJobListList> getJobs({
    int? page,
    String? search,
    String? city,
    String? jobType,
    String? experienceLevel,
    String? educationLevel,
    String? category,
    bool? isRemote,
    bool? isUrgent,
  }) async {
    final headers = await _getHeaders();
    String path = '/api/jobs/?';
    if (page != null) path += 'page=$page&';
    if (search != null) path += 'search=$search&';
    if (city != null) path += 'city=$city&';
    if (jobType != null) path += 'job_type=$jobType&';
    if (experienceLevel != null) path += 'experience_level=$experienceLevel&';
    if (educationLevel != null) path += 'education_level=$educationLevel&';
    if (category != null) path += 'category=$category&';
    if (isRemote != null) path += 'is_remote=$isRemote&';
    if (isUrgent != null) path += 'is_urgent=$isUrgent&';

    final response = await _apiClient.get(path, headers: headers);
     print('response body jobs in services: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobListList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<JobDetail> getJob(String slug) async {
    final headers = await _getHeaders();
    final response = await _apiClient.get('/api/jobs/$slug/', headers: headers);
    print('response body job detail: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return JobDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> createJob(JobCreate job) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/jobs/create/',
      job.toJson(),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> updateJob(String slug, JobCreate job) async {
    final headers = await _getHeaders();
    final response = await _apiClient.put(
      '/api/jobs/$slug/update/',
      job.toJson(),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> deleteJob(String slug) async {
    final headers = await _getHeaders();
    final response = await _apiClient.delete(
      '/api/jobs/$slug/delete/',
      headers: headers,
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobCategoryList> getJobCategories({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/jobs/categories/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobCategoryList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobAlertList> getJobAlerts({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/jobs/alerts/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobAlertList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<JobAlert> createJobAlert(JobAlert alert) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/jobs/alerts/',
      alert.toJson(),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return JobAlert.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobBookmarkList> getJobBookmarks({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/jobs/bookmarks/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobBookmarkList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> bookmarkJob(int jobId) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/jobs/$jobId/bookmark/',
      {},
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobListList> getMyJobs({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/jobs/my-jobs/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobListList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
