import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../core/constants.dart';
import '../../../core/utils/error_handler.dart';
import '../../models/company/CompanyFollower.dart';
import '../../models/job/PaginatedJobListList.dart';
import '../api_client.dart';
import '../../models/company/Company.dart';
import '../../models/company/CompanyCreate.dart';
import '../../models/company/CompanyReview.dart';
import '../../models/company/PaginatedCompanyList.dart';
import '../../models/company/PaginatedCompanyFollowerList.dart';
import '../../models/company/PaginatedCompanyReviewList.dart';
import '../../models/accounts/profile/employer/employer_dashboard.dart';
import '../../models/company/companies_statistics.dart';

class CompanyService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    print('Token from CompanyService  is : $token');

    return token != null ? {'Authorization': 'Token $token'} : {};
  }

  Future<PaginatedCompanyList> getCompanies({
    int? page,
    String? search,
    String? city,
    String? industry,
    String? size,
    bool? isFeatured,
    bool? isVerified,
  }) async {
    final headers = await _getHeaders();

    String path = '/api/companies/?';
    if (page != null) path += 'page=$page&';
    if (search != null) path += 'search=$search&';
    if (city != null) path += 'city=$city&';
    if (industry != null) path += 'industry=$industry&';
    if (size != null) path += 'size=$size&';
    if (isFeatured != null) path += 'is_featured=$isFeatured&';
    if (isVerified != null) path += 'is_verified=$isVerified&';

    final response = await _apiClient.get(path, headers: headers);
   // print('Get My Companies Response bbbb: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedCompanyList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedCompanyList> getMyCompanies({int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/companies/my-companies/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedCompanyList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<Company> getCompany(String slug) async {
    final headers = await _getHeaders();
    final response = await _apiClient.get('/api/companies/$slug/', headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedJobListList> getCompanyJobs(int companyId, {int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/companies/$companyId/jobs/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaginatedJobListList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> followCompany(int companyId) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/companies/$companyId/follow/',
      {},
      headers: headers,
    );
    print('Follow Company Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'message': data['message'] ?? 'تمت العملية بنجاح',
        'isFollowing': response.statusCode == 201,
      };
    } else {
      throw Exception(response.body);
    }
  }

  Future<PaginatedCompanyReviewList> getCompanyReviews(int companyId, {int? page}) async {
    final headers = await _getHeaders();
    String path = '/api/companies/$companyId/reviews/';
    if (page != null) {
      path += '?page=$page';
    }
    final response = await _apiClient.get(path, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201){
      return PaginatedCompanyReviewList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<CompanyReview> createCompanyReview(int companyId, CompanyReview review) async {
    final headers = await _getHeaders();
    final response = await _apiClient.post(
      '/api/companies/$companyId/reviews/create/',
      review.toJson(),
      headers: headers,
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return CompanyReview.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
  
  Future<bool> createCompany(CompanyCreate company, {File? logo, File? coverImage}) async {
    final headers = await _getHeaders();

    if (logo != null || coverImage != null) {
      var request = http.MultipartRequest('POST', Uri.parse(AppConstants.baseUrl + '/api/companies/create/'));
      request.headers.addAll(headers);

      company.toJson().forEach((key, value) {
        if (value != null) {
           if (key == 'logo' && logo != null) return;
           if (key == 'cover_image' && coverImage != null) return;
           request.fields[key] = value.toString();
        }
      });

      if (logo != null) {
        var stream = http.ByteStream(logo.openRead());
        var length = await logo.length();
        var multipartFile = http.MultipartFile('logo', stream, length,
            filename: logo.path.split('/').last);
        request.files.add(multipartFile);
      }

      if (coverImage != null) {
        var stream = http.ByteStream(coverImage.openRead());
        var length = await coverImage.length();
        var multipartFile = http.MultipartFile('cover_image', stream, length,
            filename: coverImage.path.split('/').last);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      print('Create Company Multipart Response: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } else {
      final response = await _apiClient.post(
        '/api/companies/create/',
        company.toJson(),
        headers: headers,
      );
      print('Create Company Response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.body);
      }
    }
  }

  Future<bool> updateCompany(String slug, CompanyCreate company, {File? logo, File? coverImage}) async {
    final headers = await _getHeaders();
    final urlString = AppConstants.baseUrl + ApiEndpoints.updateCompany.replaceAll('{slug}', slug);
    
    if (logo != null || coverImage != null) {
      var request = http.MultipartRequest('PUT', Uri.parse(urlString));
      request.headers.addAll(headers);

      company.toJson().forEach((key, value) {
        if (value != null) {
           // Skip image URL strings if we are strictly looking for file uploads here
           if (key == 'logo' || key == 'cover_image') return;
           request.fields[key] = value.toString();
        }
      });

      if (logo != null) {
        var stream = http.ByteStream(logo.openRead());
        var length = await logo.length();
        var multipartFile = http.MultipartFile('logo', stream, length,
            filename: logo.path.split('/').last);
        request.files.add(multipartFile);
      }

      if (coverImage != null) {
        var stream = http.ByteStream(coverImage.openRead());
        var length = await coverImage.length();
        var multipartFile = http.MultipartFile('cover_image', stream, length,
            filename: coverImage.path.split('/').last);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
 //     print('Update Company Multipart Response A: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
   //     print('Error updating company with multipart A: ${response.body}');
        throw Exception(response.body);
      }
    } else {
      // Remove null values and image URL strings to avoid validation errors
      final Map<String, dynamic> data = {};
      company.toJson().forEach((key, value) {
        if (value != null) {
          if (key == 'logo' || key == 'cover_image') return;
          data[key] = value;
        }
      });
      final path = ApiEndpoints.updateCompany.replaceAll('{slug}', slug);
      final response = await _apiClient.put(
        path,
        data,
        headers: headers,
      );
     //  print('Update Company Response  B: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
      //  print('Error updating company B: ${response.body}');
        throw Exception(response.body);
      }
    }
  }

  Future<bool> deleteCompany(String slug) async {
    final headers = await _getHeaders();
    final path = ApiEndpoints.deleteCompany.replaceAll('{slug}', slug);
    final response = await _apiClient.delete(
      path,
      headers: headers,
    );
    print('Delete Company Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    } else {
      print('Error deleting company: ${response.body}');
      throw Exception(response.body);

    }
  }

  Future<EmployerDashboard> getEmployerDashboardStats() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get(
      '/api/companies/employer-dashboard-stats/',
      headers: headers,
    );
    
    print('Get Employer Dashboard Stats Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmployerDashboard.fromJson(jsonDecode(response.body));
    } else {
      print('Error fetching employer dashboard stats: ${response.body}');
      throw Exception(response.body);
    }
  }

  Future<CompaniesStatistics> getCompanyStatistics() async {
    final headers = await _getHeaders();
    final response = await _apiClient.get(
      ApiEndpoints.companyStatistics,
      headers: headers,
    );
    print('Get Company Statistics Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CompaniesStatistics.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
