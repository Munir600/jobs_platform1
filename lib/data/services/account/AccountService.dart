import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/error_handler.dart';
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
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  Future<ProfileResponse> getProfile() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get(ApiEndpoints.profile, headers: headers);
    print('Get Profile Response in services: ${response.statusCode} : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ProfileResponse.fromJson(json['data']);
    } else {
      print('Error fetching profile: ${response.statusCode} : ${response.body}');
      throw Exception(response.body);
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return User.fromJson(json['data']['user']);
      } else {
        throw Exception(response.body);
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateProfile, data, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return User.fromJson(json['data']['user']);
      } else {
        throw Exception(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> updateEmployerProfile(Map<String, dynamic> data, {File? companyLogo}) async {
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
      print('Employer Profile Update Response A:${response.statusCode} : ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseEmployerProfileResponse(response.body);
      } else {
        throw Exception(response.body);
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateEmployerProfile, data, headers: headers);
      print('Employer Profile Update Response B:${response.statusCode} : ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseEmployerProfileResponse(response.body);
      } else {
        throw Exception(response.body);
      }
    }
  }

  Future<Map<String, dynamic>> _parseEmployerProfileResponse(String responseBody) async {
    try {
      final json = jsonDecode(responseBody);
      final data = json['data'];
      String message = 'تم تحديث الملف الشخصي بنجاح';
      
      if (data != null && data['message'] != null) {
        message = data['message'];
      }

      EmployerProfile? profile;
      
      if (data != null) {
        if (data['profile'] != null) {
           profile = EmployerProfile.fromJson(data['profile']);
        } else if (data['employer_profile'] != null) {
           profile = EmployerProfile.fromJson(data['employer_profile']);
        } else if (data['id'] != null) {
           // If 'id' is present in data directly
           profile = EmployerProfile.fromJson(data);
        }
      }
      
      profile ??= EmployerProfile.fromJson(data ?? json);
      
      return {'profile': profile, 'message': message};
      
    } catch (e) {
      print('Parsing error in _parseEmployerProfileResponse: $e');
      // Fallback to fetching profile again
      final profileResponse = await getProfile();
      if (profileResponse.profile != null && profileResponse.user.isEmployer) {
         try {
             return {
               'profile': EmployerProfile.fromJson(profileResponse.profile),
               'message': 'تم تحديث الملف الشخصي بنجاح'
             };
         } catch(_) {
             if (profileResponse.profile is Map<String, dynamic>) {
                 return {
                   'profile': EmployerProfile.fromJson(profileResponse.profile),
                   'message': 'تم تحديث الملف الشخصي بنجاح'
                 };
             }
         }
      }
      rethrow; 
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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
          throw Exception(response.body);
        }
      } else {
        throw Exception(response.body);
      }
    } else {
      final response = await _apiClient.put(ApiEndpoints.updateJobSeekerProfile, data, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final responseData = json['data'];
        if (responseData != null && responseData['profile'] != null) {
          return JobSeekerProfile.fromJson(responseData['profile']);
        }
        return JobSeekerProfile.fromJson(responseData ?? json);
      } else {
        throw Exception(response.body);
      }
    }
  }
}
