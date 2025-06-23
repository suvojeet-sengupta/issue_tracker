
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueTrackerScreen extends StatefulWidget {
  @override
  _IssueTrackerScreenState createState() => _IssueTrackerScreenState();
}

class _IssueTrackerScreenState extends State<IssueTrackerScreen> {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";

  TimeOfDay? _issueStartTime;
  TimeOfDay? _issueEndTime;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _crmId = prefs.getString("crmId") ?? "";
      _tlName = prefs.getString("tlName") ?? "";
      if (_tlName == "Other") {
        _tlName = prefs.getString("otherTlName") ?? "";
      }
      _advisorName = prefs.getString("advisorName") ?? "";
    });
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _issueStartTime = picked;
        } else {
          _issueEndTime = picked;
        }
      });
    }
  }

  bool _isFormValid() {
    return _issueStartTime != null && _issueEndTime != null;
  }

  _submitIssue() async {
    if (_isFormValid()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList("issueHistory") ?? [];

      String entry = 
          "CRM ID: $_crmId, TL Name: $_tlName, Advisor Name: $_advisorName, "
          "Start Time: ${_issueStartTime!.format(context)}, End Time: ${_issueEndTime!.format(context)}, "
          "Fill Time: ${DateTime.now().toIso8601String()}";

      history.add(entry);
      await prefs.setStringList("issueHistory", history);

      // Redirect to Google Form
      final Uri _googleFormUrl = Uri.parse(
          "https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=sharing");
      if (!await launchUrl(_googleFormUrl)) {
        throw Exception("Could not launch $_googleFormUrl");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Issue submitted and form opened!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both start and end times.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill Issue Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CRM ID: $_crmId"),
            Text("Team Leader: $_tlName"),
            Text("Advisor Name: $_advisorName"),
            SizedBox(height: 20),
            ListTile(
              title: Text("Issue Start Time: "),
              trailing: Text(_issueStartTime == null
                  ? "Select Time"
                  : _issueStartTime!.format(context)),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text("Issue End Time: "),
              trailing: Text(_issueEndTime == null
                  ? "Select Time"
                  : _issueEndTime!.format(context)),
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isFormValid() ? _submitIssue : null,
              child: Text("Submit Issue and Open Form"),
            ),
          ],
        ),
      ),
    );
  }
}


