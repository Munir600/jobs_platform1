import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants.dart';
import 'api_client.dart';
import '../models/company/job_form.dart';
import '../models/company/paginated_job_form_list.dart';

class JobFormsService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<PaginatedJobFormList> getJobForms({int? page, String? search, bool? isActive}) async {
    final headers = await _getHeaders();
    String path = ApiEndpoints.customForm;
    List<String> queryParams = [];
    
    if (page != null) queryParams.add('page=$page');
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (isActive != null) queryParams.add('is_active=$isActive');

    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }

    final response = await _apiClient.get(path, headers: headers);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobFormList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<JobForm> getJobForm(int id) async {
    final headers = await _getHeaders();
    final response = await _apiClient.get('${ApiEndpoints.customForm}$id/', headers: headers);
    print('the response for get forms form is : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return JobForm.fromJson(jsonDecode(response.body));
    } else {
      print('the error for get forms form is : ${response.body}');

      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> createJobForm(JobForm form) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      ApiEndpoints.customForm,
      form.toJson(),
      headers: headers,
    );
    print('the response for create form is : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'data': JobForm.fromJson(data),
        'message': data['message']
      };
    } else {
      print('the error for create form is : ${response.body}');
      throw Exception(jsonDecode(response.body)['detail'] ?? response.body);
    }
  }

  Future<Map<String, dynamic>> updateJobForm(int id, JobForm form) async {
    final headers = await _getHeaders();
    final response = await _apiClient.put(
      '${ApiEndpoints.customForm}$id/',
      form.toJson(),
      headers: headers,
    );
    print('the response for update form is : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'data': JobForm.fromJson(data),
        'message': data['message']
      };
    } else {
      print('the error for update form is : ${response.body}');
      throw Exception(jsonDecode(response.body)['detail'] ?? response.body);
    }
  }

  Future<String?> deleteJobForm(int id) async {
    final headers = await _getHeaders();
    final response = await _apiClient.delete(
      '${ApiEndpoints.customForm}$id/',
      headers: headers,
    );
    print('the response for delete form is : ${response.body}');

    if (response.statusCode == 204 || response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return data['message']?.toString();
      }
      return null;
    } else {
      print('the error for delete form is : ${response.body}');
      throw Exception(jsonDecode(response.body)['detail'] ?? response.body);
    }
  }
}
