import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for handling contact actions (phone, email, WhatsApp, URLs)
class ContactUtils {
  ContactUtils._(); // Private constructor to prevent instantiation

  /// Handles different types of contact information and launches appropriate apps
  /// 
  /// Supports:
  /// - Phone numbers (tel:)
  /// - Email addresses (mailto:)
  /// - WhatsApp links (wa.me/)
  /// - Website URLs (http/https)
  static Future<void> handleContactAction(String value) async {
    String v = value.trim();

    // رقم هاتف
    if (RegExp(r'^[0-9+\-\s]+$').hasMatch(v)) {
      final cleaned = v.replaceAll(' ', '');
      final uri = Uri(scheme: 'tel', path: cleaned);
      await _launch(uri);
      return;
    }

    // بريد إلكتروني
    if (v.contains('@') && v.contains('.')) {
      final uri = Uri(
        scheme: 'mailto',
        path: v,
      );
      await _launch(uri);
      return;
    }

    // واتساب
    if (v.startsWith('wa.me/') || v.contains('whatsapp')) {
      final number = v.replaceAll(RegExp(r'[^0-9]'), '');
      final uri = Uri.parse("https://wa.me/$number");
      await _launch(uri);
      return;
    }

    // رابط موقع
    if (v.startsWith('http')) {
      final uri = Uri.parse(v);
      await _launch(uri);
      return;
    }

    // رابط بدون https
    final uri = Uri.parse("https://$v");
    await _launch(uri);
  }

  /// Internal method to launch URLs with error handling
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
