import 'package:flutter/material.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart';

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
  bool _isSubmitting = false;

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
            setState(() {
              _isSubmitting = false;
            });
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
            // Delay to ensure the form is fully rendered
            await Future.delayed(const Duration(seconds: 2));
            // Auto-fill and submit
            await _autoFillAndSubmit();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.formUrl));
  }

  Future<void> _autoFillAndSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    // Scroll to show the form and then submit
    await _controller.runJavaScript('''
      (function() {
          // Scroll to the top to show the whole form
          window.scrollTo(0, 0);

          setTimeout(function() {
              // Find the submit button
              var buttons = document.querySelectorAll('div[role="button"]');
              var submitButton = null;
              for (var i = 0; i < buttons.length; i++) {
                  if (buttons[i].innerText.includes('Submit') || buttons[i].innerText.includes('Send')) {
                      submitButton = buttons[i];
                      break;
                  }
              }

              if (submitButton) {
                  // Scroll to the submit button
                  submitButton.scrollIntoView({ behavior: 'smooth', block: 'center' });

                  // Wait for a moment before clicking
                  setTimeout(function() {
                      submitButton.click();
                      FlutterChannel.postMessage('formSubmitted');
                  }, 2000); // Wait 2 seconds before clicking
              }
          }, 1500); // Wait 1.5 seconds after scrolling to top
      })();
    ''');
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
                  'assets/animations/success_animation.json',
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
                    color: Color(0xFF1E3A8A),
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
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IssueTrackerScreen()),
      );
    });
  }

  Future<bool> _onWillPop() async {
    if (_isLoading || _isSubmitting) {
      return (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                  'The form is currently being processed. Do you want to cancel?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
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
            if (_isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        'Submitting...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}