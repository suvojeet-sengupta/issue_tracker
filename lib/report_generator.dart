import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class ReportGenerator {
  static Future<File> generatePdfReport(List<String> issueHistory) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Daily Issue Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: [
                'CRM ID',
                'TL Name',
                'Advisor Name',
                'Organization',
                'Issue Explanation',
                'Reason',
                'Start Time',
                'End Time',
                'Fill Time',
                'Issue Remarks',
              ],
              data: issueHistory.map((entry) {
                final parts = _parseIssueEntry(entry);
                return [
                  parts['CRM ID'] ?? '',
                  parts['TL Name'] ?? '',
                  parts['Advisor Name'] ?? '',
                  parts['Organization'] ?? '',
                  parts['Issue Explanation'] ?? '',
                  parts['Reason'] ?? '',
                  parts['Start Time'] ?? '',
                  parts['End Time'] ?? '',
                  parts['Fill Time'] ?? '',
                  parts['Issue Remarks'] ?? '',
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(4),
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/issue_report_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateCsvReport(List<String> issueHistory) async {
    List<List<dynamic>> rows = [];
    rows.add([
      'CRM ID',
      'TL Name',
      'Advisor Name',
      'Organization',
      'Issue Explanation',
      'Reason',
      'Start Time',
      'End Time',
      'Fill Time',
      'Issue Remarks',
    ]);

    for (var entry in issueHistory) {
      final parts = _parseIssueEntry(entry);
      rows.add([
        parts['CRM ID'] ?? '',
        parts['TL Name'] ?? '',
        parts['Advisor Name'] ?? '',
        parts['Organization'] ?? '',
        parts['Issue Explanation'] ?? '',
        parts['Reason'] ?? '',
        parts['Start Time'] ?? '',
        parts['End Time'] ?? '',
        parts['Fill Time'] ?? '',
        parts['Issue Remarks'] ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/issue_report_${DateTime.now().millisecondsSinceEpoch}.csv");
    await file.writeAsString(csv);
    return file;
  }

  static Map<String, String> _parseIssueEntry(String entry) {
    final Map<String, String> parsed = {};
    final parts = entry.split(', ');
    for (var part in parts) {
      final keyValue = part.split(': ');
      if (keyValue.length == 2) {
        parsed[keyValue[0]] = keyValue[1];
      }
    }
    return parsed;
  }
}
