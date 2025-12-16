import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ElfsightChatPage extends StatefulWidget {
  @override
  _ElfsightChatPageState createState() => _ElfsightChatPageState();
}

class _ElfsightChatPageState extends State<ElfsightChatPage> {
  late final WebViewController _controller;
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();

    final params = PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Transparent background for the webview itself
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString("""
      <!DOCTYPE html>
      <html lang="ar">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chat</title>
        <style>
          body, html { margin: 0; padding: 0; height: 100%; width: 100%; background-color: transparent; }
        </style>
      </head>
      <body>
        <div id="loading" style="text-align: center; padding-top: 20px; font-family: sans-serif;">Loading Chat...</div>
        <script src="https://elfsightcdn.com/platform.js" async></script>
        <div class="elfsight-app-7f87f4ec-8f5b-493f-95d4-736548373b3a"></div>
      </body>
      </html>
      """, baseUrl: "https://elfsight.com/");
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Stack(
        children: [
          Positioned.fill(
             child: GestureDetector(
               onTap: () {
                 if (_isChatOpen) _toggleChat();
               },
               child: Container(
                 color: Colors.black.withOpacity(0.1),
               ),
             ),
          ),
          if (_isChatOpen)
            Positioned(
              bottom: 80,
              right: 20,
              left: 20,
              top: 100,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: WebViewWidget(controller: _controller),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                _isChatOpen ? Icons.close : Icons.chat_bubble_outline,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
