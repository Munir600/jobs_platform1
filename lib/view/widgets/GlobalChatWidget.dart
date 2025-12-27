// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../controllers/ChatController.dart';
//
// class GlobalChatWidget extends StatefulWidget {
//   const GlobalChatWidget({super.key});
//
//   @override
//   State<GlobalChatWidget> createState() => _GlobalChatWidgetState();
// }
//
// class _GlobalChatWidgetState extends State<GlobalChatWidget> {
//   WebViewController? _controller;
//   final ChatController chatController = Get.find<ChatController>();
//
//   void _initializeWebView() {
//     if (_controller != null) return; // Already initialized
//
//     final params = PlatformWebViewControllerCreationParams();
//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('Web resource error: ${error.description}');
//           },
//         ),
//       )
//       ..loadHtmlString("""
//       <!DOCTYPE html>
//       <html lang="ar">
//       <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, initial-scale=1.0">
//         <title>Chat</title>
//         <style>
//           body, html { margin: 0; padding: 0; height: 100%; width: 100%; background-color: transparent; }
//         </style>
//       </head>
//       <body>
//         <script src="https://elfsightcdn.com/platform.js" async></script>
//         <div class="elfsight-app-7f87f4ec-8f5b-493f-95d4-736548373b3a"></div>
//       </body>
//       </html>
//       """, baseUrl: "https://elfsight.com/");
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isOpen = chatController.isChatOpen.value;
//
//       // Initialize WebView when chat is first opened
//       if (isOpen && _controller == null) {
//         _initializeWebView();
//       }
//
//       return Stack(
//         children: [
//           if (isOpen)
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: chatController.closeChat,
//                 child: Container(
//                   color: Colors.black.withOpacity(0.01),
//                 ),
//               ),
//             ),
//
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             // When open: Fill the screen (with margins)
//             // When closed: Small box in bottom right for the bubble
//             bottom: isOpen ? 80 : 0,
//             right: isOpen ? 20 : 0,
//             // Adjustable sizing
//             width: isOpen ? MediaQuery.of(context).size.width - 40 : 100,
//             height: isOpen ? MediaQuery.of(context).size.height - 200 : 100,
//
//             child: Stack(
//               children: [
//                 // The WebView itself
//                 Material(
//                    color: Colors.transparent,
//                    elevation: isOpen ? 8 : 0,
//                    borderRadius: BorderRadius.circular(isOpen ? 16 : 0),
//                    clipBehavior: Clip.antiAlias,
//                    child: _controller != null
//                        ? WebViewWidget(controller: _controller!)
//                        : const Center(
//                            child: CircularProgressIndicator(),
//                          ),
//                 ),
//
//                 if (!isOpen)
//                   Positioned.fill(
//                     child: GestureDetector(
//                       onTap: chatController.openChat,
//                       child: Container(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
