import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/services/api_client.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  Future<http.Response> register(Map<String, dynamic> payload) {
    return _client.post('/api/accounts/register/', payload);
  }
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final resp = await _client.post(
      '/api/accounts/login/',
      {'phone': phone, 'password': password},
    );
    final result = {
      'status': resp.statusCode,
      'body': null,
      'ok': false,
      'message': ''
    };
    try {
      if (resp.body.isNotEmpty) {
        final body = jsonDecode(resp.body);
        result['body'] = body;
        if (body is Map && body.containsKey('token')) {
          await StorageService.saveToken(body['token'].toString());
          result['ok'] = true;
          result['message'] = 'token_saved';
          return result;
        }
      }

      //  (احتياطي)
      final setCookie = resp.headers['set-cookie'];
      if (setCookie != null && setCookie.isNotEmpty) {
        final cookie = setCookie.split(';').first;
        await StorageService.saveToken(cookie);
        result['ok'] = true;
        result['message'] = 'cookie_saved';
        return result;
      }

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        result['ok'] = true;
        result['message'] = 'ok_no_token';
      }
    } catch (e) {
      result['message'] = e.toString();
    }

    return result;
  }

  Future<UserModel?> getProfile() async {
    final token = await StorageService.getToken();
    if (token == null) return null;

    final headers = <String, String>{
      'Authorization': 'Token $token',
    };

    final resp = await _client.get('/api/accounts/profile/', headers: headers);

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is Map && body.containsKey('data') && body['data'].containsKey('user')) {
        return UserModel.fromJson(body['data']['user']);
      }
    }
    return null;
  }


  // تسجيل الخروج
  Future<void> logout() async {
    final token = await StorageService.getToken();
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    await _client.post('/api/accounts/logout/', {}, headers: headers);
    await StorageService.clearAll();
  }
}
