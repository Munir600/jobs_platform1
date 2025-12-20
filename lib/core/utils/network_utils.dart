import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class NetworkUtils {
  static Future<bool> checkInternet(BuildContext context) async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      if (!context.mounted) return false;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('فشل الاتصال'),
          content: const Text('لا يوجد اتصال بالإنترنت'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('حسناً'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('اعادة الاتصال'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
