import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;

  LoggerService._internal();

  late Logger _logger;
  File? _logFile;
  bool _isLoggingActive = false; // New flag to control logging

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/app_log.txt');

    _logger = Logger(
      printer: PrettyPrinter(),
      output: FileOutput(file: _logFile!),
    );
  }

  void log(String message) {
    if (_isLoggingActive) { // Only log if active
      _logger.i(message);
    }
  }

  Future<void> startLogging() async {
    _isLoggingActive = true;
    await clearLog(); // Clear previous logs when starting new session
    log('Logging session started.');
  }

  void stopLogging() {
    log('Logging session stopped.');
    _isLoggingActive = false;
  }

  Future<String?> getLogFilePath() async {
    return _logFile?.path;
  }

  Future<void> clearLog() async {
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString(''); // Clear file content
    }
  }
}

class FileOutput extends LogOutput {
  final File file;

  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      file.writeAsStringSync('$line\n', mode: FileMode.append);
    }
  }
}