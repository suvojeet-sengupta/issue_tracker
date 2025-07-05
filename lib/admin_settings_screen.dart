import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: const Center(
        child: Text('Welcome to Admin Settings!'),
      ),
    );
  }

  // These methods and variables were part of the reverted commit and are no longer needed.
  // void _showClearDataConfirmationDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Confirm Clear Data'),
  //         content: const Text(
  //             'Are you sure you want to clear all saved user data and settings? This action cannot be undone.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Clear'),
  //             onPressed: () async {
  //               Navigator.of(context).pop(); // Close dialog
  //               await _clearAllData();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _clearAllData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   _googleFormUrlController.clear();
  //   _crmIdEntryController.clear();
  //   _advisorNameEntryController.clear();
  //   _issueStartTimeHourEntryController.clear();
  //   _issueStartTimeMinuteEntryController.clear();
  //   _issueEndTimeHourEntryController.clear();
  //   _issueEndTimeMinuteEntryController.clear();
  //   _tlNameEntryController.clear();
  //   _organizationEntryController.clear();
  //   _issueStartDateYearEntryController.clear();
  //   _issueStartDateMonthEntryController.clear();
  //   _issueStartDateDayEntryController.clear();
  //   _issueEndDateYearEntryController.clear();
  //   _issueEndDateMonthEntryController.clear();
  //   _issueEndDateDayEntryController.clear();

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('All data cleared successfully!')),
  //   );

  //   // Reload default values after clearing
  //   _loadSettings();
  // }
}