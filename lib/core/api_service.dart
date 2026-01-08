// lib/core/api_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class ApiService extends GetxService {
  final GetStorage _storage = GetStorage();
  final String baseUrl = AppConstants.baseUrl;
  bool _isRefreshing = false;

  String? get authToken => _storage.read(AppConstants.authTokenKey);
  String? get refreshToken => _storage.read(AppConstants.RefreshToken);

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  Future<ApiService> init() async {
    await GetStorage.init();
    return this;
  }

  void setAuthToken(String token) {
    _storage.write(AppConstants.authTokenKey, token);
  }

  void removeAuthToken() {
    _storage.remove(AppConstants.authTokenKey);
  }

  void setRefreshToken(String token) {
    _storage.write(AppConstants.RefreshToken, token);
  }

  void removeRefreshToken() {
    _storage.remove(AppConstants.RefreshToken);
  }

  Future<dynamic> post(String endpoint, dynamic data, {bool isRetry = false}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      return _handleResponse(response, () => post(endpoint, data, isRetry: true), isRetry);
    } catch (e) {
      if (e.toString().contains('انتهت الجلسة')) rethrow;
      throw 'فشل في الاتصال: $e';
    }
  }

  Future<dynamic> put(String endpoint, dynamic data, {bool isRetry = false}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      return _handleResponse(response, () => put(endpoint, data, isRetry: true), isRetry);
    } catch (e) {
       if (e.toString().contains('انتهت الجلسة')) rethrow;
      throw 'فشل في الاتصال: $e';
    }
  }

  Future<dynamic> get(String endpoint, {bool isRetry = false}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response, () => get(endpoint, isRetry: true), isRetry);
    } catch (e) {
       if (e.toString().contains('انتهت الجلسة')) rethrow;
      throw 'فشل في الاتصال: $e';
    }
  }

  Future<dynamic> delete(String endpoint, {bool isRetry = false}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response, () => delete(endpoint, isRetry: true), isRetry);
    } catch (e) {
       if (e.toString().contains('انتهت الجلسة')) rethrow;
      throw 'فشل في الاتصال: $e';
    }
  }

  Future<bool> _refreshAccessToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refresh = refreshToken;
      if (refresh == null) {
        return false;
      }

      print("Attempting to refresh token...");
      
      // Call refresh endpoint directly without using post() to avoid recursion loop
      final response = await http.post(
        Uri.parse('$baseUrl/api/token/refresh/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newAccessToken = data['access'];
        final newRefreshToken = data['refresh']; // Some APIs rotate refresh tokens
        
        if (newAccessToken != null) {
          setAuthToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          setRefreshToken(newRefreshToken);
        }
        
        print("Token refreshed successfully");
        return true;
      } else {
        print("Failed to refresh token: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<dynamic> _handleResponse(http.Response response, Future<dynamic> Function() retryMethod, bool isRetry) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      if (!isRetry) {
        final success = await _refreshAccessToken();
        if (success) {
          return retryMethod();
        }
      }
      _performLogout();
      throw 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';
    } else {
      throw 'خطأ ${response.statusCode}: ${response.body}';
    }
  }

  void _performLogout() {
      removeAuthToken();
      removeRefreshToken();
      Get.offAllNamed('/login');
  }
}