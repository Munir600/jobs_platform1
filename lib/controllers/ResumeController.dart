import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../core/utils/error_handler.dart';

class ResumeController extends GetxController {
  final Dio _dio = Dio();

  Future<void> openResume(dynamic resumePath) async {
    try {
      if (resumePath == null) {
        AppErrorHandler.showErrorSnack('لا توجد سيرة ذاتية للعرض');
        return;
      }

      if (resumePath is File) {
        final result = await OpenFilex.open(resumePath.path);
        if (result.type != ResultType.done) {
          AppErrorHandler.showErrorSnack('لا يمكن فتح الملف: ${result.message}');
        }
      } else if (resumePath is String) {
        if (resumePath.startsWith('http')) {
          await _downloadAndOpenResume(resumePath);
        } else {
           final result = await OpenFilex.open(resumePath);
           if (result.type != ResultType.done) {
             AppErrorHandler.showErrorSnack('لا يمكن فتح الملف: ${result.message}');
           }
        }
      }
    } catch (e) {
      AppErrorHandler.showErrorSnack('حدث خطأ أثناء فتح الملف');
      print('Error opening resume: $e');
    }
  }

  Future<void> _downloadAndOpenResume(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        final result = await OpenFilex.open(file.path);
        if (result.type != ResultType.done) {
           AppErrorHandler.showErrorSnack('لا يمكن فتح الملف المحفوظ: ${result.message}');
        }
      } else {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        await _dio.download(url, file.path);
        
        Get.back();

        final result = await OpenFilex.open(file.path);
        if (result.type != ResultType.done) {
          AppErrorHandler.showErrorSnack('لا يمكن فتح الملف الذي تم تنزيله: ${result.message}');
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print('Download error: $e');
      AppErrorHandler.showErrorSnack('فشل تنزيل الملف');
    }
  }
}
