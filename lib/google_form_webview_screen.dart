import 'package:flutter/material.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleFormWebviewScreen extends StatefulWidget {
  final String formUrl;

  const GoogleFormWebviewScreen({Key? key, required this.formUrl})
      : super(key: key);

  @override
  State<GoogleFormWebviewScreen> createState() =>
      _GoogleFormWebviewScreenState();
}

class _GoogleFormWebviewScreenState extends State<GoogleFormWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
            // Inject JavaScript to scroll to the submit button
            await _controller.runJavaScript('''
              (function() {
                  var buttons = document.querySelectorAll('div[role="button"]');
                  for (var i = 0; i < buttons.length; i++) {
                      if (buttons[i].innerText.includes('Submit') || buttons[i].innerText.includes('Send')) {
                          buttons[i].scrollIntoView({ behavior: 'smooth', block: 'center' });
                          buttons[i].click(); // Add this line to click the button
                          return;
                      }
                  }
              })();
            ''');

            // Show instruction to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.ads_click, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      "Form submitted automatically!", // Changed message
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green, // Changed color
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.formUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Issue'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Loading Form...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      );
  }
}
