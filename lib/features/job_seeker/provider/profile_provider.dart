import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  static const baseUrl = 'https://job-portal-rcxk.onrender.com';
  static const profileEndpoint = '/api/accounts/profile/';

  bool isLoading = false;
  Map<String, dynamic>? profileData;
  String? errorMessage;

  Future<void> fetchProfile(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl$profileEndpoint');
      final response = await http.get(
        url,
        headers: {
          "Authorization": "token $token", // لاحظ شكل الهيدر
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        profileData = json.decode(response.body);
      } else {
        errorMessage = "خطأ: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "فشل الاتصال: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
