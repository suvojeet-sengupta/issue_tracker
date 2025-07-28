import 'package:flutter/material.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _submissionStatus = "Initializing...";
  bool _isProcessComplete = false;
  bool _submissionHandled = false;
  int _progress = 0; // New variable for loading progress

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
          } else if (message.message.startsWith('status:')) {
            setState(() {
              _submissionStatus = message.message.substring(7);
            });
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress; // Update progress
            });
          },
          onPageFinished: (String url) async {
            if (url.contains('formResponse')) {
              final String pageBody = await _controller
                  .runJavaScriptReturningResult('document.body.innerText') as String;
              if (pageBody.contains('Your response has been recorded')) {
                _showSuccessDialog();
              } else {
                await _handleSubmissionError();
              }
            } else {
              setState(() {
                _isLoading = false;
              });
              // Delay to ensure the form is fully rendered
              await Future.delayed(const Duration(seconds: 2));
              // Auto-fill and submit
              await _autoFillAndSubmit();
            }
          },
          onWebResourceError: (WebResourceError error) async {
            // Handle web resource loading errors
            await _handleSubmissionError();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.formUrl));
  }

  Future<void> _autoFillAndSubmit() async {
    setState(() {
      _isSubmitting = true;
      _submissionStatus = "Preparing form for submission...";
    });

    try {
      // Scroll to show the form and then submit
      await _controller.runJavaScript('''
        (function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
            setTimeout(() => {
                window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
                setTimeout(() => {
                    var buttons = document.querySelectorAll('div[role="button"]');
                    var submitButton = null;
                    for (var i = 0; i < buttons.length; i++) {
                        if (buttons[i].innerText.includes('Submit') || buttons[i].innerText.includes('Send')) {
                            submitButton = buttons[i];
                            break;
                        }
                    }
                    if (submitButton) {
                        submitButton.click();
                    } else {
                        throw new Error("Submit button not found");
                    }
                }, 3000);
            }, 100);
        })();
      ''');
    } catch (e) {
      await _handleSubmissionError();
    }
  }

  Future<void> _handleSubmissionError() async {
    if (_submissionHandled) return;
    _submissionHandled = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("issueHistory") ?? [];
    if (history.isNotEmpty) {
      String lastEntry = history.last;
      history[history.length - 1] = "$lastEntry<submission_status>failure";
      await prefs.setStringList("issueHistory", history);
    }
    setState(() {
      _isSubmitting = false;
      _isProcessComplete = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to submit the form automatically. Please try again.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    // Optionally, navigate back or show a failure dialog
    Navigator.of(context).pop();
  }

  void _showSuccessDialog() {
    if (_submissionHandled) return;
    _submissionHandled = true;

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

    Future.delayed(const Duration(seconds: 5), () async {
      // Save submission status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList("issueHistory") ?? [];
      if (history.isNotEmpty) {
        String lastEntry = history.last;
        history[history.length - 1] = "$lastEntry<submission_status>success";
        await prefs.setStringList("issueHistory", history);
      }

      setState(() {
        _isProcessComplete = true;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IssueTrackerScreen()),
      );
    });
  }

  Future<bool> _onWillPop() async {
    if (!_isProcessComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for the submission to complete.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
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
            onPressed: _isProcessComplete
                ? () async {
                    if (await _onWillPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0), // Height of the progress bar
            child: LinearProgressIndicator(
              value: _progress / 100, // Convert 0-100 to 0.0-1.0
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ), // New: LinearProgressIndicator
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading && _progress < 100) // Show loading overlay until page is fully loaded
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        'Loading form...',
                        textAlign: TextAlign.center,
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
                        _submissionStatus,
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
