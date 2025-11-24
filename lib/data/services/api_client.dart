
import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiClient {
  static const String baseUrl = 'https://job-portal-rcxk.onrender.com';

  Future<http.Response> post(String path, Map<String, dynamic> body, {Map<String,String>? headers}) {
    final url = Uri.parse(baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.post(url, headers: allHeaders, body: jsonEncode(body));
  }

  Future<http.Response> get(String path, {Map<String,String>? headers}) {
    final url = Uri.parse(baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.get(url, headers: allHeaders);
  }
}
