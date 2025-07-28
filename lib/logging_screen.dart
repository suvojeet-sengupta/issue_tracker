import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  _LoggingScreenState createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  bool _isLogging = false;
  String? _logFilePath;

  void _toggleLogging() {
    setState(() {
      _isLogging = !_isLogging;
      if (!_isLogging) {
        _saveLog();
      }
    });
  }

  Future<void> _saveLog() async {
    // In a real app, you would be writing logs to this file.
    // For this example, we'll just create an empty file.
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/app_log.txt');
    await file.writeAsString('This is a sample log file.');
    setState(() {
      _logFilePath = file.path;
    });
  }

  void _shareLog() {
    if (_logFilePath != null) {
      Share.shareXFiles([XFile(_logFilePath!)], text: 'Here is the app log file.');
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
            if (_logFilePath != null)
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
