// lib/core/api_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class ApiService extends GetxService {
  final GetStorage _storage = GetStorage();
  final String baseUrl = AppConstants.baseUrl;

  String? get authToken => _storage.read(AppConstants.authTokenKey);

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Token $authToken';
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

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'فشل في الاتصال: $e';
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'فشل في الاتصال: $e';
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      removeAuthToken();
      Get.offAllNamed('/login');
      throw 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';
    } else {
      throw 'خطأ ${response.statusCode}: ${response.body}';
    }
  }
}