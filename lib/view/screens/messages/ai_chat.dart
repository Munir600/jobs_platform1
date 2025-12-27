import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/ChatController.dart';

class AiChat extends GetView<ChatController> {
  const AiChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('وكيل توظيف الذكي'),
        centerTitle: true,
      ),
      body: Obx(() {
        final webController = controller.controller;
        final isLoading = controller.isLoading.value;

        return Stack(
          children: [

            // WebView
            if (webController != null)
              WebViewWidget(controller: webController)
            else
              const Center(
                child: Text('فشل تحميل الدردشة'),
              ),

            // Loading indicator
            if (isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'جاري تحميل الدردشة...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
