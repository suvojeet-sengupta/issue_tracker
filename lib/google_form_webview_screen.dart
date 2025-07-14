import 'package:flutter/material.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

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
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (message) {
          if (message.message == 'formSubmitted') {
            _showSuccessDialog();
          }
        },
      )
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
                          FlutterChannel.postMessage('formSubmitted'); // Notify Flutter
                          return;
                      }
                  }
              })();
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.formUrl));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success_animation.json', // Placeholder: Replace with your Lottie animation path
                  repeat: false,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Issue Submitted Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A), // A professional blue
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Redirecting to home screen...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop(); // Dismiss the dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IssueTrackerScreen()),
      ); // Redirect to home
    });
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
