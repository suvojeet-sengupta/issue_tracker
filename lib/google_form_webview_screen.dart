import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleFormWebviewScreen extends StatefulWidget {
  final String formUrl;

  const GoogleFormWebviewScreen({Key? key, required this.formUrl}) : super(key: key);

  @override
  State<GoogleFormWebviewScreen> createState() => _GoogleFormWebviewScreenState();
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
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.formUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Form'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}


