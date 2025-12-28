import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppErrorHandler {
  static String getMessage(dynamic error) {
    if (error is SocketException) {
      return "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.";
    } else if (error is HttpException) {
      return "تعذر الوصول للخادم. حاول لاحقًا.";
      // Try to find JSON array or object
    } else if (error is FormatException) {
      return "بيانات غير صالحة.";
    } else if (error is NetworkImageLoadException) {
      return "فشل تحميل الصورة. الصورة غير موجودة.";
    }
    else if (error.toString().contains('response has a status code of 404')) {
      return "السيرة الذاتية غير موجودة ... يرجى رفعها مرة اخرى.";
    }

    try {
      final String errorStr = error.toString();
      
      // Check for network-related errors in the error string
      if (errorStr.contains('SocketException') || 
          errorStr.contains('Failed host lookup') ||
          errorStr.contains('No address associated with hostname') ||
          errorStr.contains('Network is unreachable')) {
        return "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.";
      }
      
      if (errorStr.contains('ClientException') ||
          errorStr.contains('Connection refused') ||
          errorStr.contains('Connection timed out')) {
        return "تعذر الوصول للخادم. حاول لاحقًا.";
      }

      // Try to find JSON array or object
      int startIndex = errorStr.indexOf('{');
      int endIndex = errorStr.lastIndexOf('}');
      
      // If no object found, try finding array
      if (startIndex == -1) {
        startIndex = errorStr.indexOf('[');
        endIndex = errorStr.lastIndexOf(']');
      } else {
        // If object found, check if array is outer (e.g. wrapped error) but unlikely given the format
        // stick to object preference if found first? 
        // actually let's just find the first valid json start
      }

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final String jsonStr = errorStr.substring(startIndex, endIndex + 1);
        final dynamic decoded = jsonDecode(jsonStr);

        if (decoded is Map<String, dynamic>) {
          final List<String> errorMessages = [];
          decoded.forEach((key, value) {
            if (value is List) {
              for (var v in value) {
                errorMessages.add(v.toString());
              }
            } else {
              errorMessages.add(value.toString());
            }
          });

          if (errorMessages.isNotEmpty) {
            return errorMessages.join('\n');
          }
        } else if (decoded is List) {
           return decoded.join('\n');
        }
      }
    } catch (_) {
      return "حدث خطأ غير متوقع. حاول مرة أخرى.";
    }

    return "حدث خطأ غير متوقع. حاول مرة أخرى.";
  }

  static void showErrorSnack(dynamic error) {
    Get.snackbar(
      'خطأ',
      getMessage(error),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      isDismissible: true,
    );
  }

  static void showSuccessSnack(String message) {
    Get.snackbar(
      'نجاح',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      isDismissible: true,
    );
  }
}
