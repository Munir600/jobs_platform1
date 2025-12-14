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
    } else if (error is FormatException) {
      return "بيانات غير صالحة.";
    } else if (error is NetworkImageLoadException) {
      return "فشل تحميل الصورة. الصورة غير موجودة.";
    }

    try {
      final String errorStr = error.toString();
      final int startIndex = errorStr.indexOf('{');
      final int endIndex = errorStr.lastIndexOf('}');

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
