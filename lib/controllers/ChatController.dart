import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatController extends GetxController {
  WebViewController? _controller;
  final RxBool isLoading = true.obs;

  WebViewController? get controller => _controller;

  @override
  void onInit() {
    super.onInit();
    _initializeWebView();
  }

  void _initializeWebView() {
    final params = PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF5F5F5))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Chat page started loading: $url');
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            debugPrint('Chat page finished loading: $url');
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Chat web resource error: ${error.description}');
             Get.snackbar(
             'خطأ',
              'لا يوجد اتصال بالانترنت حاول مرة اخرى',
             backgroundColor: Colors.black87,
             colorText: Colors.white,
             snackPosition: SnackPosition.TOP,
             margin: const EdgeInsets.all(16),
             borderRadius: 12,
             duration: const Duration(seconds: 4),
             isDismissible: true,
           );

            isLoading.value = false;
          },
        ),
      )
      ..loadHtmlString("""
      <!DOCTYPE html>
      <html lang="ar">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>الدردشة</title>
        <style>
          body, html { 
            margin: 0; 
            padding: 0; 
            height: 100%; 
            width: 100%;
            background-color: #f5f5f5;
            overflow: hidden;
          }
          .elfsight-app-7f87f4ec-8f5b-493f-95d4-736548373b3a {
            height: 100vh !important;
            width: 100vw !important;
          }
        </style>
      </head>
      <body>
        <script src="https://elfsightcdn.com/platform.js" async></script>
        <div class="elfsight-app-7f87f4ec-8f5b-493f-95d4-736548373b3a" data-elfsight-app-lazy></div>
      </body>
      </html>
      """, baseUrl: "https://elfsight.com/");
  }

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
}
