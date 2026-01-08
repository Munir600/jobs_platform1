import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../controllers/account/AccountController.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/api_service.dart';
import '../../../core/constants.dart';
import '../../../routes/app_routes.dart';
import '../../models/job/JobCategory.dart';
import '../api_client.dart';
import '../../models/job/JobDetail.dart';
import '../../models/job/JobCreate.dart';
import '../../models/job/JobAlert.dart';
import '../../models/job/PaginatedJobListList.dart';
import '../../models/job/PaginatedJobAlertList.dart';
import '../../models/job/PaginatedJobBookmarkList.dart';
import '../../models/job/jobs_statistics.dart';

class JobService {
  final ApiClient _apiClient = ApiClient();
  final ApiService _apiService = Get.find();
 final GetStorage _storage = GetStorage();
  final isUserLoggedIn = Get.find<AuthController>();
  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from jobs  is : $token');
    return token != null ? {'Authorization': 'Bearer $token'} : {};
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
    String path = '';
    final token2 = _storage.read(AppConstants.authTokenKey);
    print('the token2 is: $token2');
    if(token2 !=null){
      path = '/api/jobs/recommended/?';
    }else{
      path = '/api/jobs/?';
      print('path in else if  : $path');
    }
     print('is user token2 in from jobs service : $token2');
    print('path after if  : $path');
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
      ApiEndpoints.createJob,
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

  Future<List<JobCategory>> getJobCategories() async {
    final headers = await _getHeaders();
    String path = ApiEndpoints.jobCategories;
    final response = await _apiClient.get(path, headers: headers);
    print('the response for get Categories is : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> categoriesJson = jsonDecode(response.body);
      return categoriesJson.map((json) => JobCategory.fromJson(json)).toList();
    } else {
      print('the error for get Categories is ${response.body}');
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobAlertList> getJobAlerts({int? page}) async {
    final headers = await _getHeaders();
    String path = ApiEndpoints.jobAlerts;
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
      ApiEndpoints.jobAlerts,
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
    String path = ApiEndpoints.bookmarks;
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    print('the response in getjobbookmarks is : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobBookmarkList.fromJson(jsonDecode(response.body));
    } else {
      print('the response error getjobbookmarks is : ${response.body}');
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

  Future<JobsStatistics> getJobStatistics() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.jobStatistics,
      headers: headers,
    );
    if (response.statusCode == 200) {
      return JobsStatistics.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load job statistics');
    }
  }
}
