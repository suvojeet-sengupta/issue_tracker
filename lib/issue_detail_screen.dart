import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:issue_tracker_app/utils/issue_parser.dart';

class IssueDetailScreen extends StatelessWidget {
  final Map<String, String> issueDetails;
  final List<String> imagePaths;

  const IssueDetailScreen({
    super.key,
    required this.issueDetails,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Issue Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => _shareIssue(issueDetails, imagePaths),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Issue Information', Icons.info_outline),
                    const SizedBox(height: 12),
                    _buildDetailRow('Advisor Name', issueDetails['Advisor Name'] ?? 'N/A'),
                    _buildDetailRow('CRM ID', issueDetails['CRM ID'] ?? 'N/A'),
                    _buildDetailRow('Organization', issueDetails['Organization'] ?? 'N/A'),
                    _buildDetailRow('Issue Type', issueDetails['Issue Explanation'] ?? 'N/A'),
                    _buildDetailRow('Reason', issueDetails['Reason'] ?? 'N/A'),
                    if (issueDetails['Issue Remarks'] != null && issueDetails['Issue Remarks']!.isNotEmpty)
                      _buildDetailRow('Remarks', issueDetails['Issue Remarks']!),
                    _buildDetailRow('Submission Status', issueDetails['submission_status'] ?? 'unknown'),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Time Information', Icons.access_time_rounded),
                    const SizedBox(height: 12),
                    _buildDetailRow('Fill Time', '${_formatOnlyDate(issueDetails['Fill Time']!)} at ${_formatTime(issueDetails['Fill Time']!)}'),
                    _buildDetailRow('Start Time', '${_formatOnlyDate(issueDetails['Start Time']!)} at ${_formatTime(issueDetails['Start Time']!)}'),
                    _buildDetailRow('End Time', '${_formatOnlyDate(issueDetails['End Time']!)} at ${_formatTime(issueDetails['End Time']!)}'),
                    _buildDetailRow('Duration', _formatDuration(issueDetails['Start Time'] ?? '', issueDetails['End Time'] ?? '')),
                  ],
                ),
              ),
            ),
            if (imagePaths.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'Attachments', Icons.attach_file_rounded),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: imagePaths.length,
                        itemBuilder: (context, imgIndex) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Image.file(File(imagePaths[imgIndex])),
                                      IconButton(
                                        icon: const Icon(Icons.download_rounded, color: Colors.white),
                                        onPressed: () async {
                                          await Share.shareXFiles([XFile(imagePaths[imgIndex])]);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(imagePaths[imgIndex]),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
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

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);
      int hour = dateTime.hour;
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) {
        hour = 12;
      }
      return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatOnlyDate(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatDuration(String startTimeIso, String endTimeIso) {
    try {
      DateTime start = DateTime.parse(startTimeIso);
      DateTime end = DateTime.parse(endTimeIso);
      Duration duration = end.difference(start);

      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitHours = twoDigits(duration.inHours);

      if (duration.inHours > 0) {
        return "${twoDigitHours}h ${twoDigitMinutes}m";
      } else if (duration.inMinutes > 0) {
        return "${twoDigitMinutes}m";
      } else {
        return "${duration.inSeconds}s";
      }
    } catch (e) {
      return 'N/A';
    }
  }

  _shareIssue(Map<String, String> parsedEntry, List<String> imagePaths) {
    String message = """*Issue Report*

*Advisor Name:* ${parsedEntry['Advisor Name']}
*CRM ID:* ${parsedEntry['CRM ID']}
*Organization:* ${parsedEntry['Organization']}

*Issue:* ${parsedEntry['Issue Explanation']}
*Reason:* ${parsedEntry['Reason']}

*Start Time:* ${_formatTime(parsedEntry['Start Time']!)} on ${_formatOnlyDate(parsedEntry['Start Time']!)}
*End Time:* ${_formatTime(parsedEntry['End Time']!)} on ${_formatOnlyDate(parsedEntry['End Time']!)}
*Duration:* ${_formatDuration(parsedEntry['Start Time']!, parsedEntry['End Time']!)}
*Fill Time:* ${_formatTime(parsedEntry['Fill Time']!)} on ${_formatOnlyDate(parsedEntry['Fill Time']!)}
${parsedEntry['Issue Remarks'] != null && parsedEntry['Issue Remarks']!.isNotEmpty ? '*Remarks:* ${parsedEntry['Issue Remarks']}' : ''}

"""
        "This report was generated from the Issue Tracker App.";

    Share.shareXFiles(imagePaths.map((path) => XFile(path)).toList(), text: message);
  }
}
