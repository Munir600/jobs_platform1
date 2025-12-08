// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants.dart';
import '../../../models/accounts/profile/employer/employer_profile_model.dart';

class ProfileService {
  static const String baseUrl = 'https://job-portal-rcxk.onrender.com';
  static const String profileEndpoint = '/api/accounts/profile/';

  final GetStorage _storage = GetStorage();

  Future<EmployerProfileModel> getProfile() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from ProfileService  is : $token');

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
