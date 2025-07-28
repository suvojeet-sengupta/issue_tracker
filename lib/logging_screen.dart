import 'package:flutter/material.dart';
import 'package:issue_tracker_app/logger_service.dart';
import 'package:share_plus/share_plus.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  _LoggingScreenState createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final LoggerService _loggerService = LoggerService();
  bool _isLogging = false;

  @override
  void initState() {
    super.initState();
    // Check initial logging state if needed, or assume off
  }

  void _toggleLogging() async {
    setState(() {
      _isLogging = !_isLogging;
    });

    if (_isLogging) {
      await _loggerService.startLogging();
    } else {
      _loggerService.stopLogging();
    }
  }

  Future<void> _shareLog() async {
    final path = await _loggerService.getLogFilePath();
    if (path != null) {
      Share.shareXFiles([XFile(path)], text: 'Here is the app log file.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log file not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleLogging,
              child: Text(_isLogging ? 'Stop Logging' : 'Start Logging'),
            ),
            const SizedBox(height: 20), // Added spacing
            ElevatedButton(
              onPressed: _shareLog,
              child: const Text('Share Log with Developer'),
            ),
          ],
        ),
      ),
    );
  }
}
