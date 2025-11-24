// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../models/accounts/profile/employer/employer_profile_model.dart';

class ProfileService {
  static const String baseUrl = 'https://job-portal-rcxk.onrender.com';
  static const String profileEndpoint = '/api/accounts/profile/';

  final GetStorage _storage = GetStorage();

  Future<EmployerProfileModel> getProfile() async {
   // var token1 ='7829c1a0d2e63f0bc8e8e40fae26b8b37a252656';
    _storage.write('token', 'ac1bd217934b6350e0d6169df83536b54020334c');
    final token = _storage.read('token') ?? '';
   // final token = '7829c1a0d2e63f0bc8e8e40fae26b8b37a252656';
    print("===== DEBUG PROFILE REQUEST =====");
    print("TOKEN SENT: $token");
    print("URL: $baseUrl$profileEndpoint");

    final url = Uri.parse(baseUrl + profileEndpoint);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'token $token',
        'Accept': 'application/json',
      },
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return employerProfileModelFromJson(response.body);
    } else {
      throw Exception("Failed to load profile (Status: ${response.statusCode}) - Body: ${response.body}");
    }
  }
}
