import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../models/accounts/profile/document/document_create.dart';
import '../../models/accounts/profile/document/document_detail.dart';
import '../../../core/constants.dart';
import '../../models/accounts/profile/document/documents_list.dart';
import '../api_client.dart';

class JobseekerDocumentService {
  final ApiClient _apiClient = ApiClient();
  final GetStorage _storage = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read(AppConstants.authTokenKey);
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  Future<DocumentsList> listDocuments() async {
    final headers = await _getHeaders();
    String url = ApiEndpoints.documents;

    final response = await _apiClient.get(url, headers: headers);
    print('the response load listDocuments status: ${response.statusCode}');
    print('the response load listDocuments body: ${response.body}');
    if (response.statusCode == 500 && response.body.contains('FileNotFoundError')) {
      print('Handling FileNotFoundError 500 as empty list');
      return DocumentsList(results: []);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final json = jsonDecode(response.body);
        return DocumentsList.fromJson(json);
      } catch (e) {
        throw Exception('عذراً، فشل في تحليل البيانات المستلمة من الخادم.');
      }
    } else {
      print('the error listDocuments body: ${response.body}');
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> createDocument(DocumentCreate request, File file) async {
    final token = _storage.read(AppConstants.authTokenKey);
    final url = Uri.parse(AppConstants.baseUrl + ApiEndpoints.documents);

    var multipartRequest = http.MultipartRequest('POST', url);
    multipartRequest.headers.addAll({
      'Authorization': 'Token $token',
      'Accept': 'application/json',
    });

    // Add fields
    final json = request.toJson();
    json.forEach((key, value) {
      if (key != 'file' && value != null) {
        multipartRequest.fields[key] = value.toString();
      }
    });

    // Add file
    multipartRequest.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    );

    print('Sending Create Document Request to: $url');
    print('Fields: ${multipartRequest.fields}');

    var streamedResponse = await multipartRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response Status in createDocument: ${response.statusCode}');
    print('Response Body in createDocument: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        final data = (decoded is Map && decoded.containsKey('data')) ? decoded['data'] : decoded;
        
        final docData = (data is Map && data.containsKey('document')) ? data['document'] : data;
        final message = (data is Map && data.containsKey('message')) ? data['message'] : 'تم رفع الوثيقة بنجاح';

        return {
          'document': DocumentDetail.fromJson(docData),
          'message': message,
        };
      } catch (e) {
        print('Error parsing createDocument response: $e');
        throw Exception(response.body);
      }
    } else {
      print('the error createDocument bodyaaaaaaaa: ${response.body}');
      throw Exception(response.body);
    }
  }



  Future<Map<String, dynamic>> updateDocument(int id, DocumentCreate request, {File? file}) async {
    return _update(id, request, file: file, method: 'PUT');
  }

  Future<Map<String, dynamic>> partialUpdateDocument(int id, DocumentCreate request, {File? file}) async {
    return _update(id, request, file: file, method: 'PATCH');
  }


  Future<Map<String, dynamic>> _update(int id, DocumentCreate request, {File? file, required String method}) async {
    final token = _storage.read(AppConstants.authTokenKey);
    final url = Uri.parse(AppConstants.baseUrl + ApiEndpoints.documentDetail.replaceAll('{id}', id.toString()));

    var multipartRequest = http.MultipartRequest(method, url);
    multipartRequest.headers.addAll({
      'Authorization': 'Token $token',
      'Accept': 'application/json',
    });

    final json = request.toJson();
    json.forEach((key, value) {
      if (key != 'file' && value != null) {
        multipartRequest.fields[key] = value.toString();
      }
    });

    if (file != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      );
    }

    print('Sending $method Document Request to: $url');

    var streamedResponse = await multipartRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response Status in _update ($method): ${response.statusCode}');
    print('Response body in _update ($method): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final decoded = jsonDecode(response.body);
        final data = (decoded is Map && decoded.containsKey('data')) ? decoded['data'] : decoded;
        
        final docData = (data is Map && data.containsKey('document')) ? data['document'] : data;
        final message = (data is Map && data.containsKey('message')) ? data['message'] : 'تم تحديث الوثيقة بنجاح';

        return {
          'document': DocumentDetail.fromJson(docData),
          'message': message,
        };
      } catch (e) {
        print('Error parsing update response: $e');
        throw Exception(response.body);
      }
    } else {
      print('the error _update body ssss: ${response.body}');
      throw Exception(response.body);
    }
  }


  Future<bool> deleteDocument(int id) async {
    final headers = await _getHeaders();
    final url = ApiEndpoints.documentDetail.replaceAll('{id}', id.toString());

    final response = await _apiClient.delete(url, headers: headers);
    return response.statusCode == 204 || response.statusCode == 200;
  }
}

