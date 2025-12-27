import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';

import '../../../core/constants.dart';
import '../api_client.dart';
import '../../models/Interview/Interview.dart';
import '../../models/Interview/InterviewCreate.dart';
import '../../models/Interview/PaginatedInterviewList.dart';

class InterviewService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();
  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from InterviewService  is : $token');

    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<PaginatedInterviewList> getInterviews({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/applications/interviews/';
    
    // Build query parameters
    List<String> queryParams = [];
    if (page != null) {
      queryParams.add('page=$page');
    }
    // Order by newest first
    queryParams.add('ordering=-created_at');
    
    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }
    
    try {
      final response = await _apiClient.get(path, headers: headers);
      print('the response for load interviews is: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaginatedInterviewList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching interviews: $e');
      throw Exception(e);
    }
  }

  Future<Interview> getInterview(int id) async {
    final headers = await _getHeaders();
    try {
      final response = await _apiClient.get('/api/applications/interviews/$id/', headers: headers);
      print('the response for load interview one by id  is: $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Interview.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error fetching interview: $e');
      throw Exception(e);
    }
  }

  Future<bool> createInterview(InterviewCreate interview) async {
    final headers = await _getHeaders();
    try {
      final response = await _apiClient.post(
        '/api/applications/interviews/create/',
        interview.toJson(),
        headers: headers,
      );
      print('the response for create interview is: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
      //   AppErrorHandler.showSuccessSnack(' تم جدولة المقابلة بنجاح');
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error creating interview: $e');
      throw Exception(e);
    }
  }

  Future<Interview> updateInterview(int id, InterviewCreate interview) async {
    final headers = await _getHeaders();
    try {
      final response = await _apiClient.put(
        '/api/applications/interviews/$id/',
        interview.toJson(),
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
         print('the response for update interview is: ${response.body}');
        return Interview.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print('Error updating interview: $e');
      throw Exception(e);
    }
  }
}
