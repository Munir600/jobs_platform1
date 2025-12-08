import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../models/accounts/User.dart';
import '../../models/accounts/EmployerProfile.dart';
import '../../models/accounts/JobSeekerProfile.dart';
import '../../models/accounts/ProfileResponse.dart';
import '../../../core/constants.dart';
import '../api_client.dart';

class AccountService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from AccountService  is : $token');
    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<ProfileResponse> getProfile() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get(ApiEndpoints.profile, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProfileResponse.fromJson(json['data']);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<User> updateProfile(Map<String, dynamic> data, {File? profilePicture}) async {
    final headers = await _getHeaders();
    
    if (profilePicture != null) {
      var request = http.MultipartRequest('PUT', Uri.parse(AppConstants.baseUrl + ApiEndpoints.updateProfile));
      request.headers.addAll(headers);

      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      var stream = http.ByteStream(profilePicture.openRead());
      var length = await profilePicture.length();
      var multipartFile = http.MultipartFile('profile_picture', stream, length,
          filename: profilePicture.path.split('/').last);
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return User.fromJson(json['data']['user']);
      } else {
        throw Exception('Failed to update profile with image');
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateProfile, data, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return User.fromJson(json['data']['user']);
      } else {
        throw Exception('Failed to update profile');
      }
    }
  }

  Future<EmployerProfile> updateEmployerProfile(Map<String, dynamic> data, {File? companyLogo}) async {
    final headers = await _getHeaders();

    if (companyLogo != null) {
      var request = http.MultipartRequest('PUT', Uri.parse(AppConstants.baseUrl + ApiEndpoints.updateEmployerProfile));
      request.headers.addAll(headers);

      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      var stream = http.ByteStream(companyLogo.openRead());
      var length = await companyLogo.length();
      var multipartFile = http.MultipartFile('company_logo', stream, length,
          filename: companyLogo.path.split('/').last);
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return EmployerProfile.fromJson(json['data'] ?? json); 
      } else {
        throw Exception('Failed to update employer profile with logo');
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateEmployerProfile, data, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return EmployerProfile.fromJson(json['data'] ?? json);
      } else {
        throw Exception('Failed to update employer profile');
      }
    }
  }

  Future<JobSeekerProfile> updateJobSeekerProfile(Map<String, dynamic> data, {File? resume}) async {
    final headers = await _getHeaders();

    if (resume != null) {
      var request = http.MultipartRequest('PUT', Uri.parse(AppConstants.baseUrl + ApiEndpoints.updateJobSeekerProfile));
      request.headers.addAll(headers);

      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      var stream = http.ByteStream(resume.openRead());
      var length = await resume.length();
      var multipartFile = http.MultipartFile('resume', stream, length,
          filename: resume.path.split('/').last);
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        try {
          final json = jsonDecode(response.body);
          final data = json['data'];
          if (data != null && data['profile'] != null) {
            return JobSeekerProfile.fromJson(data['profile']);
          }
          return JobSeekerProfile.fromJson(data ?? json);
        } catch (e) {
          print('Parsing error after upload, fetching fresh profile: $e');
          final profileResponse = await getProfile();
          if (profileResponse.profile != null) {
            // Merge user and profile data because JobSeekerProfile expects user to be inside
            final profileData = Map<String, dynamic>.from(profileResponse.profile);
            profileData['user'] = profileResponse.user.toJson();
            // Ensure id is present or defaults to 0 (already handled in model, but good to be safe)
            return JobSeekerProfile.fromJson(profileData);
          }
          throw Exception('Failed to parse upload response and fetch profile');
        }
      } else {
        throw Exception('Failed to update job seeker profile with resume');
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateJobSeekerProfile, data, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final responseData = json['data'];
        if (responseData != null && responseData['profile'] != null) {
          return JobSeekerProfile.fromJson(responseData['profile']);
        }
        return JobSeekerProfile.fromJson(responseData ?? json);
      } else {
        throw Exception('Failed to update job seeker profile');
      }
    }
  }
}
