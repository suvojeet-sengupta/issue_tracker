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
    _loggerService.init();
  }

  void _toggleLogging() {
    setState(() {
      _isLogging = !_isLogging;
      if (_isLogging) {
        _loggerService.clearLog();
        _loggerService.log('Logging started...');
      } else {
        _loggerService.log('Logging stopped...');
      }
    });
  }

  Future<void> _shareLog() async {
    final path = await _loggerService.getLogFilePath();
    if (path != null) {
      Share.shareXFiles([XFile(path)], text: 'Here is the app log file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleLogging,
              child: Text(_isLogging ? 'Stop Logging' : 'Start Logging'),
            ),
            ElevatedButton(
              onPressed: _shareLog,
              child: const Text('Share with Developer'),
            ),
          ],
        ),
      ),
    );
  }
}