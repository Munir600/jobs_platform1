import 'package:flutter/material.dart';
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
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
