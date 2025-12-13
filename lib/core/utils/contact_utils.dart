import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactUtils {
  ContactUtils._();
  static Future<void> handleContactAction(String value) async {
    String v = value.trim();
    if (RegExp(r'^[0-9+\-\s]+$').hasMatch(v)) {
      final cleaned = v.replaceAll(' ', '');
      final uri = Uri(scheme: 'tel', path: cleaned);
      await _launch(uri);
      return;
    }
    if (v.contains('@') && v.contains('.')) {
      final uri = Uri(
        scheme: 'mailto',
        path: v,
      );
      await _launch(uri);
      return;
    }

   if (v.startsWith('wa.me/') || v.contains('whatsapp')) {
      final number = v.replaceAll(RegExp(r'[^0-9]'), '');
      final uri = Uri.parse("https://wa.me/$number");
      await _launch(uri);
      return;
    }

    if (v.startsWith('http')) {
      final uri = Uri.parse(v);
      await _launch(uri);
      return;
    }
    final uri = Uri.parse("https://$v");
    await _launch(uri);
  }
  static Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "خطأ",
        "تعذّر فتح الرابط",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
