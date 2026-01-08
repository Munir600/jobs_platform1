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
    else if (error.toString().contains('انتهت الجلسة')) {
      return "انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى";
    }
    else if (error.toString().contains('رمز غير صحيح')) {
      return "قم بتسجيل الدخول مرة اخرى";
    }
    else if (error.toString().contains('الوثيقة المطلوبة غير موجودة')) {
      return "عذراً، الوثيقة المطلوبة غير موجودة.";
    }
    try {
      final String errorStr = error.toString();
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
      }

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final String jsonStr = errorStr.substring(startIndex, endIndex + 1);
        try {
          final dynamic decoded = jsonDecode(jsonStr);
          final List<String> messages = _extractMessages(decoded);
          if (messages.isNotEmpty) {
            return messages.toSet().join('\n');
          }
        } catch (e) {
          // JSON decode failed, ignore
        }
      }
    } catch (_) {
     // return "حدث خطأ غير متوقع. حاول مرة أخرى.";
    }

    if (error.toString().contains('Exception: ')) {
        return error.toString().replaceAll('Exception: ', '').trim();
    }
    
    return "خطأ";
  }

  static List<String> _extractMessages(dynamic data) {
    final List<String> messages = [];
    
    if (data is String) {
      messages.add(data);
    } else if (data is List) {
      for (var item in data) {
        messages.addAll(_extractMessages(item));
      }
    } else if (data is Map) {
      // Prioritize specific error keys if present
      if (data.containsKey('non_field_errors')) {
        messages.addAll(_extractMessages(data['non_field_errors']));
      } else if (data.containsKey('detail')) {
        messages.addAll(_extractMessages(data['detail']));
      } else if (data.containsKey('message')) {
         messages.addAll(_extractMessages(data['message']));
      } else if (data.containsKey('file')) {
         messages.addAll(_extractMessages(data['file']));
      } else if (data.containsKey('data')) {
         // Often APIs wrap errors in a 'data' field
         messages.addAll(_extractMessages(data['data']));
      } else if (data.containsKey('errors')) {
         messages.addAll(_extractMessages(data['errors']));
      } else {
         for (var value in data.values) {
            messages.addAll(_extractMessages(value));
         }
      }
    }
    return messages;
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
