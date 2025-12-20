import 'dart:convert';
import 'package:get_storage/get_storage.dart';

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
    if (page != null) {
      path += '?page=$page';
    }
    try {
      final response = await _apiClient.get(path, headers: headers);
      //print('the response for load interviewsss is: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaginatedInterviewList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error loading interviews: $e');
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
      throw Exception('Error loading interview: $e');
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
         return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error creating interview: $e');
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
      throw Exception('Error updating interview: $e');
    }
  }
}
