import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobs_platform1/core/constants.dart';
class ApiClient {

  Future<http.Response> post(String path, Map<String, dynamic> body, {Map<String,String>? headers}) {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.post(url, headers: allHeaders, body: jsonEncode(body));
  }

  Future<http.Response> put(String path, Map<String, dynamic> body, {Map<String,String>? headers}) {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.put(url, headers: allHeaders, body: jsonEncode(body));
  }

  Future<http.Response> patch(String path, Map<String, dynamic> body, {Map<String,String>? headers}) {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.patch(url, headers: allHeaders, body: jsonEncode(body));
  }

  Future<http.Response> delete(String path, {Map<String,String>? headers}) {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.delete(url, headers: allHeaders);
  }

  Future<http.Response> get(String path, {Map<String,String>? headers}) {
    final url = Uri.parse(AppConstants.baseUrl + path);
    final allHeaders = {'Content-Type': 'application/json'};
    if (headers != null) allHeaders.addAll(headers);
    return http.get(url, headers: allHeaders);
  }
}
