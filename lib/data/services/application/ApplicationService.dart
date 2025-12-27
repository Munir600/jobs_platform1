import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/utils/error_handler.dart';
import '../api_client.dart';
import '../storage_service.dart';
import '../../models/application/JobApplication.dart';
import '../../models/application/JobApplicationCreate.dart';
import '../../models/application/JobApplicationUpdate.dart';
import '../../models/application/ApplicationMessage.dart';
import '../../models/application/PaginatedJobApplicationList.dart';
import '../../models/application/PaginatedApplicationMessageList.dart';
import '../../models/application/ApplicationStatistics.dart';
import '../../models/Interview/Interview.dart';
import '../../models/Interview/InterviewCreate.dart';
import '../../models/Interview/PaginatedInterviewList.dart';
import '../../../core/constants.dart';
import 'package:get_storage/get_storage.dart';

class ApplicationService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();
  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from ApplicationService  is : $token');
    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<PaginatedJobApplicationList> getMyApplications({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/applications/my-applications/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobApplicationList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobApplicationList> getJobApplications({int? page, int? jobId}) async {
    final headers = await _getHeaders();
    String path = '/api/applications/job-applications/?';
    if (page != null) {
      path += 'page=$page&';
    }
    if (jobId != null) {
      path += 'job_id=$jobId&';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobApplicationList.fromJson(jsonDecode(response.body));
    } else {
      print('Error fetching job applicationssss: ${response.body}');
      throw Exception(response.body);

    }
  }

  Future<JobApplication> getApplication(int id) async {
    final headers = await _getHeaders();
    final response = await _apiClient.get('/api/applications/$id/', headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return JobApplication.fromJson(jsonDecode(response.body)); 
    } else {
      print('Error fetching application: ${response.body}');
      throw Exception(response.body);
    }
  }
  
  Future<JobApplicationCreate> createApplication(JobApplicationCreate application) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/applications/apply/',
      application.toJson(),
      headers: headers,
    );
    print('Create Application Response: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return JobApplicationCreate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
  
  Future<void> withdrawApplication(int applicationId) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/applications/$applicationId/withdraw/',
      {},
      headers: headers,
    );
    if (response.statusCode != 200 || response.statusCode == 201) {
      throw Exception(response.body);
    }
  }

  Future<PaginatedApplicationMessageList> getApplicationMessages(int applicationId, {int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/applications/$applicationId/messages/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedApplicationMessageList.fromJson(jsonDecode(response.body));
    } else {
      print('Error fetching application messages: ${response.body}');
      throw Exception(response.body);
    }
  }

  Future<ApplicationMessage> createApplicationMessage(int applicationId, String message) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/applications/$applicationId/messages/create/',
      {
        'application': applicationId,
        'message': message,
        'is_read': false // Default
      },
      headers: headers,
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ApplicationMessage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> markApplicationViewed(int applicationId) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/applications/$applicationId/mark-viewed/',
      {},
      headers: headers,
    );
    if (response.statusCode != 200 || response.statusCode == 201) {
      throw Exception(response.body);
    }
  }
  
  Future<void> updateApplication(int? id, JobApplicationUpdate data) async {
    final headers = await _getHeaders();
    final response = await _apiClient.put(
      '/api/applications/$id/update/',
      data.toJson(),
      headers: headers,
    );
    final data1 = jsonDecode(response.body);
    print('Update Application statusCode : ${response.statusCode}');
    print('Update Application Response for status : ${data1['status']}');
    print('Update Application Response: $data1');
    if (response.statusCode == 200 || response.statusCode == 201) {
     // AppErrorHandler.showSuccessSnack(' تم تحديث حالة الطلب بنجاح الى ${data1['status']}');
    //  Get.back();
      // return JobApplication.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  // Interview Methods

  Future<PaginatedInterviewList> getInterviews({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/applications/interviews/';
    if (page != null) {
      path += '?page=$page';
    }
    try {
      final response = await _apiClient.get(path, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaginatedInterviewList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load interviews');
      }
    } catch (e) {
      throw Exception('Error loading interviews: $e');
    }
  }

  Future<Interview> getInterview(int id) async {
    final headers = await _getHeaders();
    try {
      final response = await _apiClient.get('/api/applications/interviews/$id/', headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Interview.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load interview');
      }
    } catch (e) {
      throw Exception('Error loading interview: $e');
    }
  }

  // Future<Interview> createInterview(InterviewCreate interview) async {
  //   final headers = await _getHeaders();
  //   try {
  //     final response = await _apiClient.post(
  //       '/api/applications/interviews/create/',
  //       interview.toJson(),
  //       headers: headers,
  //     );
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       return Interview.fromJson(jsonDecode(response.body));
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     throw Exception('Error creating interview: $e');
  //   }
  // }

  Future<Interview> updateInterview(int id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    try {
      final response = await _apiClient.put(
        '/api/applications/interviews/$id/',
        data,
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Interview.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update interview');
      }
    } catch (e) {
      throw Exception('Error updating interview: $e');
    }
  }

  Future<void> deleteInterview(int id) async {
    final headers = await _getHeaders();
    final response = await _apiClient.delete(
      '/api/applications/interviews/$id/',
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete interview');
    }
  }

  Future<ApplicationStatistics> getApplicationStatistics() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get('/api/applications/statistics/', headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApplicationStatistics.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load application statistics');
    }
  }
}
