import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jobs_platform1/core/constants.dart';
import '../../controllers/account/AccountController.dart';
import '../../controllers/auth_controller.dart';
import '../../core/api_service.dart';
import '../../routes/app_routes.dart';

class ApiClient {
  ApiService get _apiService => Get.find<ApiService>();
  final GetStorage _storage = GetStorage();
  bool _isRefreshing = false;

  Future<http.Response> post(String path, Map<String, dynamic> body, {Map<String, String>? headers, bool isRetry = false}) async {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = _buildHeaders(headers);
    final response = await http.post(url, headers: allHeaders, body: jsonEncode(body));
    return _handleResponse(response, () => post(path, body, headers: headers, isRetry: true), isRetry);
  }

  Future<http.Response> put(String path, Map<String, dynamic> body, {Map<String, String>? headers, bool isRetry = false}) async {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = _buildHeaders(headers);
    final response = await http.put(url, headers: allHeaders, body: jsonEncode(body));
    return _handleResponse(response, () => put(path, body, headers: headers, isRetry: true), isRetry);
  }

  Future<http.Response> patch(String path, Map<String, dynamic> body, {Map<String, String>? headers, bool isRetry = false}) async {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = _buildHeaders(headers);
    final response = await http.patch(url, headers: allHeaders, body: jsonEncode(body));
    return _handleResponse(response, () => patch(path, body, headers: headers, isRetry: true), isRetry);
  }

  Future<http.Response> delete(String path, {Map<String, String>? headers, bool isRetry = false}) async {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = _buildHeaders(headers);
    final response = await http.delete(url, headers: allHeaders);
    return _handleResponse(response, () => delete(path, headers: headers, isRetry: true), isRetry);
  }

  Future<http.Response> get(String path, {Map<String, String>? headers, bool isRetry = false}) async {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = _buildHeaders(headers);
    final response = await http.get(url, headers: allHeaders);
    return _handleResponse(response, () => get(path, headers: headers, isRetry: true), isRetry);
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    
    // Add Authorization header if token exists and not already provided
    final token = _apiService.authToken;
    if (token != null && !allHeaders.containsKey('Authorization')) {
      allHeaders['Authorization'] = 'Bearer $token';
    }
    return allHeaders;
  }

  Future<http.Response> _handleResponse(http.Response response, Future<http.Response> Function() retryMethod, bool isRetry) async {
    if (response.statusCode == 401 && !isRetry) {
      final success = await _refreshAccessToken();
      if (success) {
        return retryMethod();
      }
      _logout();
    }
    return response;
  }

  void _logout() {
    print("ApiClient: Performing logout due to refresh failure");
    _storage.remove('user_data');
    _storage.remove('employer_profile');
    _storage.remove('job_seeker_profile');
    _apiService.removeAuthToken();
    _apiService.removeRefreshToken();
    if (Get.isRegistered<AccountController>()) {
      Get.find<AccountController>().clearUserData();
    }
    Get.offAllNamed(AppRoutes.login);
  }

  Future<bool> _refreshAccessToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refresh = _apiService.refreshToken;
      if (refresh == null) {
        _logout();
        return false;
      }

      print("ApiClient: Attempting to refresh token...");
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/token/refresh/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newAccessToken = data['access'];
        final newRefreshToken = data['refresh'];
        
        if (newAccessToken != null) {
          _apiService.setAuthToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          _apiService.setRefreshToken(newRefreshToken);
        }
        print("ApiClient: Token refreshed successfully");
        return true;
      } else {
        print("ApiClient: Failed to refresh token: ${response.body}");
        _logout();
        return false;
      }
    } catch (e) {
      print("ApiClient: Error refreshing token: $e");
      _logout();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
}
