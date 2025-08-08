import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/google_form_webview_screen.dart';
import 'package:issue_tracker_app/developer_info_screen.dart';
import 'package:issue_tracker_app/ntp_time.dart';
import 'package:issue_tracker_app/logger_service.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:issue_tracker_app/success_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';


class IssueTrackerScreen extends StatefulWidget {
  const IssueTrackerScreen({super.key});

  @override
  _IssueTrackerScreenState createState() => _IssueTrackerScreenState();
}

class _IssueTrackerScreenState extends State<IssueTrackerScreen>
    with TickerProviderStateMixin {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";
  String _organization = "";
  String _selectedIssueExplanation = "System Hang / Voice Issue";
  String _selectedReason = "System issue (Network , Asset & Aspect /WDE issue)";
  final TextEditingController _issueRemarksController = TextEditingController();

  int? _issueStartHour;
  int? _issueStartMinute;
  String _issueStartPeriod = "AM";

  int? _issueEndHour;
  int? _issueEndMinute;
  String _issueEndPeriod = "AM";

  List<XFile> _images = [];

  late AnimationController _animationController;
  late AnimationController _buttonController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _buttonScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonController.dispose();
    _issueRemarksController.dispose();
    super.dispose();
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
      _organization = prefs.getString("organization") ?? "DISH";
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (XFile image in images) {
        final editedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProImageEditor.file(
              File(image.path),
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (Uint8List bytes) async {
                  final tempDir = await getTemporaryDirectory();
                  final file = await File('${tempDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.png').writeAsBytes(bytes);
                  Navigator.pop(context, XFile(file.path));
                },
              ),
            ),
          ),
        );
        if (editedImage != null) {
          setState(() {
            _images.add(XFile(editedImage.path));
          });
        }
      }
    }
  }

  TimeOfDay? _getStartTimeOfDay() {
    if (_issueStartHour == null || _issueStartMinute == null) return null;
    int hour24 = _issueStartHour!;
    if (_issueStartPeriod == "PM" && hour24 != 12) {
      hour24 += 12;
    } else if (_issueStartPeriod == "AM" && hour24 == 12) {
      hour24 = 0;
    }
    return TimeOfDay(hour: hour24, minute: _issueStartMinute!);
  }

  TimeOfDay? _getEndTimeOfDay() {
    if (_issueEndHour == null || _issueEndMinute == null) return null;
    int hour24 = _issueEndHour!;
    if (_issueEndPeriod == "PM" && hour24 != 12) {
      hour24 += 12;
    } else if (_issueEndPeriod == "AM" && hour24 == 12) {
      hour24 = 0;
    }
    return TimeOfDay(hour: hour24, minute: _issueEndMinute!);
  }

  String _formatTime(int? hour, int? minute, String period) {
    if (hour == null || minute == null) return "Select Time";
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  bool _isFormValid() {
    return _issueStartHour != null &&
        _issueStartMinute != null &&
        _issueEndHour != null &&
        _issueEndMinute != null;
  }

  _submitIssue() async {
    if (_isFormValid()) {
      TimeOfDay? startTime = _getStartTimeOfDay();
      TimeOfDay? endTime = _getEndTimeOfDay();

      if (startTime != null && endTime != null) {
        final startMinutes = startTime.hour * 60 + startTime.minute;
        final endMinutes = endTime.hour * 60 + endTime.minute;

        if (endMinutes < startMinutes) {
          final durationInMinutes = (24 * 60 - startMinutes) + endMinutes;
          if (durationInMinutes > 18 * 60) { // More than 18 hours is likely an error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "End time cannot be before start time.",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            return; // Stop the submission
          }
        }
      }

      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });
      await _showConfirmationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                "Please select both start and end times.",
                style: TextStyle(fontFamily: 'Poppins'), // Added Poppins font
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFF8FAFC),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF1E3A8A),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Submission',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Please review the details before submitting.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 20),
                _buildConfirmationInfoRow(Icons.badge_outlined, 'CRM ID', _crmId),
                _buildConfirmationInfoRow(
                    Icons.supervisor_account_outlined, 'Team Leader', _tlName),
                _buildConfirmationInfoRow(
                    Icons.person_outline, 'Advisor Name', _advisorName),
                _buildConfirmationInfoRow(
                    Icons.business_center_outlined, 'Organization', _organization),
                const Divider(height: 20, thickness: 1),
                _buildConfirmationInfoRow(
                    Icons.play_circle_outline_rounded,
                    'Start Time',
                    _formatTime(_issueStartHour, _issueStartMinute, _issueStartPeriod)),
                _buildConfirmationInfoRow(
                    Icons.stop_circle_outlined,
                    'End Time',
                    _formatTime(_issueEndHour, _issueEndMinute, _issueEndPeriod)),
                const Divider(height: 20, thickness: 1),
                _buildConfirmationInfoRow(
                    Icons.help_outline_rounded, 'Issue Explanation', _selectedIssueExplanation),
                _buildConfirmationInfoRow(
                    Icons.report_problem_outlined, 'Reason', _selectedReason),
                if (_issueRemarksController.text.isNotEmpty)
                  _buildConfirmationInfoRow(
                      Icons.notes_rounded, 'Remarks', _issueRemarksController.text),
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Attachments:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_images[index].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF475569),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm & Submit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _proceedWithSubmission();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E3A8A),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _proceedWithSubmission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("issueHistory") ?? [];

    TimeOfDay? startTime = _getStartTimeOfDay();
    TimeOfDay? endTime = _getEndTimeOfDay();

    List<String> imagePaths = [];
    if (_images.isNotEmpty) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      for (var image in _images) {
        final String fileName = image.name;
        final File localImage =
            await File(image.path).copy('${appDir.path}/$fileName');
        imagePaths.add(localImage.path);
      }
    }
    final DateTime now = await getNetworkTime();
    String entry =
        "CRM ID: $_crmId, TL Name: $_tlName, Advisor Name: $_advisorName, "
        "Organization: $_organization, Issue Explanation: $_selectedIssueExplanation, "
        "Reason: $_selectedReason, Start Time: ${DateTime(now.year, now.month, now.day, startTime!.hour, startTime.minute).toIso8601String()}, "
        "End Time: ${DateTime(now.year, now.month, now.day + (endTime!.hour < startTime.hour || (endTime.hour == startTime.hour && endTime.minute < startTime.minute) ? 1 : 0), endTime.hour, endTime.minute).toIso8601String()}, Fill Time: ${now.toIso8601String()}, "
        "Issue Remarks: ${_issueRemarksController.text}";
    if (imagePaths.isNotEmpty) {
      entry += ", Images: ${imagePaths.join('|')}";
    }

    history.add(entry);
    await prefs.setStringList("issueHistory", history);

    LoggerService().log('Issue submitted: $entry');

    // Log Firebase Analytics event
    final String advisorName = prefs.getString("advisorName") ?? "Unknown";
    FirebaseAnalytics.instance.logEvent(
      name: 'issue_submitted',
      parameters: {
        'advisor_name': advisorName,
        'issue_explanation': _selectedIssueExplanation,
        'reason': _selectedReason,
        'fill_time': now.toIso8601String(),
        'start_time': DateTime(now.year, now.month, now.day, startTime!.hour, startTime.minute).toIso8601String(),
        'end_time': DateTime(now.year, now.month, now.day + (endTime!.hour < startTime.hour || (endTime.hour == startTime.hour && endTime.minute < startTime.minute) ? 1 : 0), endTime.hour, endTime.minute).toIso8601String(),
      },
    );

    await _openGoogleForm(entry);
  }

  _openGoogleForm(String entry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String crmIdEntryId = prefs.getString('google_form_crmIdEntryId') ?? '1005447471';
    final String advisorNameEntryId = prefs.getString('google_form_advisorNameEntryId') ?? '44222229';
    final String startTimeHourEntryId = prefs.getString('google_form_startTimeHourEntryId') ?? '1521239602_hour';
    final String startTimeMinuteEntryId = prefs.getString('google_form_startTimeMinuteEntryId') ?? '1521239602_minute';
    final String endTimeHourEntryId = prefs.getString('google_form_endTimeHourEntryId') ?? '701130970_hour';
    final String endTimeMinuteEntryId = prefs.getString('google_form_endTimeMinuteEntryId') ?? '701130970_minute';
    final String tlNameEntryId = prefs.getString('google_form_tlNameEntryId') ?? '115861300';
    final String organizationEntryId = prefs.getString('google_form_organizationEntryId') ?? '313975949';
    final String startDateYearEntryId = prefs.getString('google_form_startDateYearEntryId') ?? '702818104_year';
    final String startDateMonthEntryId = prefs.getString('google_form_startDateMonthEntryId') ?? '702818104_month';
    final String startDateDayEntryId = prefs.getString('google_form_startDateDayEntryId') ?? '702818104_day';
    final String endDateYearEntryId = prefs.getString('google_form_endDateYearEntryId') ?? '514450388_year';
    final String endDateMonthEntryId = prefs.getString('google_form_endDateMonthEntryId') ?? '514450388_month';
    final String endDateDayEntryId = prefs.getString('google_form_endDateDayEntryId') ?? '514450388_day';
    final String explainIssueEntryId = prefs.getString('google_form_explainIssueEntryId') ?? '1211413190';
    final String reasonEntryId = prefs.getString('google_form_reasonEntryId') ?? '1231067802';

    final String encodedCrmId = Uri.encodeComponent(_crmId);
    final String encodedAdvisorName = Uri.encodeComponent(_advisorName);
    final String encodedTlName = Uri.encodeComponent(_tlName);
    final String encodedOrganization = Uri.encodeComponent(_organization);
    final String encodedIssueExplanation =
        Uri.encodeComponent(_selectedIssueExplanation);
    final String encodedReason = Uri.encodeComponent(_selectedReason);

    TimeOfDay? startTime = _getStartTimeOfDay();
    TimeOfDay? endTime = _getEndTimeOfDay();

    final String startTimeHour =
        startTime?.hour.toString().padLeft(2, '0') ?? "";
    final String startTimeMinute =
        startTime?.minute.toString().padLeft(2, '0') ?? "";
    final String endTimeHour = endTime?.hour.toString().padLeft(2, '0') ?? "";
    final String endTimeMinute =
        endTime?.minute.toString().padLeft(2, '0') ?? "";

    final DateTime now = await getNetworkTime();
    final String currentYear = now.year.toString();
    final String currentMonth = now.month.toString();
    final String currentDay = now.day.toString();

    final String formUrl = prefs.getString('google_form_url') ?? 'https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=pp_url';
    String url = formUrl;
    url += "&entry." + crmIdEntryId + "=" + encodedCrmId;
    url += "&entry." + advisorNameEntryId + "=" + encodedAdvisorName;
    url += "&entry." + startTimeHourEntryId + "=" + startTimeHour;
    url += "&entry." + startTimeMinuteEntryId + "=" + startTimeMinute;
    url += "&entry." + endTimeHourEntryId + "=" + endTimeHour;
    url += "&entry." + endTimeMinuteEntryId + "=" + endTimeMinute;
    url += "&entry." + tlNameEntryId + "=" + encodedTlName;
    url += "&entry." + organizationEntryId + "=" + encodedOrganization;
    url += "&entry." + startDateYearEntryId + "=" + currentYear;
    url += "&entry." + startDateMonthEntryId + "=" + currentMonth;
    url += "&entry." + startDateDayEntryId + "=" + currentDay;
    url += "&entry." + endDateYearEntryId + "=" + currentYear;
    url += "&entry." + endDateMonthEntryId + "=" + currentMonth;
    url += "&entry." + endDateDayEntryId + "=" + currentDay;
    url += "&entry." + explainIssueEntryId + "=" + encodedIssueExplanation;
    url += "&entry." + reasonEntryId + "=" + encodedReason;

    final Uri googleFormUri = Uri.parse(url);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GoogleFormWebviewScreen(formUrl: googleFormUri.toString()),
      ),
    );

    List<String> history = prefs.getStringList("issueHistory") ?? [];
    String lastEntryStatus = "";
    if (history.isNotEmpty) {
      String lastEntry = history.last;
      if (lastEntry.contains("<submission_status>")) {
        lastEntryStatus = lastEntry.split("<submission_status>").last;
      }
    }

    if (lastEntryStatus == "success") {
      final Map<String, String> issueData = {
        'CRM ID': _crmId,
        'Team Leader': _tlName,
        'Advisor Name': _advisorName,
        'Organization': _organization,
        'Issue Explanation': _selectedIssueExplanation,
        'Reason': _selectedReason,
        'Start Time': _formatTime(_issueStartHour, _issueStartMinute, _issueStartPeriod),
        'End Time': _formatTime(_issueEndHour, _issueEndMinute, _issueEndPeriod),
        'Remarks': _issueRemarksController.text,
      };

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(issueData: issueData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Form submission failed. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                    ),
                    const Text(
                      'Fill Issue Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins', // Added Poppins font
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.info_outline_rounded,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeveloperInfoScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_slideAnimation),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Advisor Information Card
                          _buildEnhancedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1E3A8A),
                                            Color(0xFF3B82F6)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      'Advisor Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                        fontFamily: 'Poppins', // Added Poppins font
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildEnhancedInfoRow(
                                    Icons.badge_outlined, 'CRM ID', _crmId),
                                const SizedBox(height: 12),
                                _buildEnhancedInfoRow(
                                    Icons.supervisor_account_outlined,
                                    'Team Leader',
                                    _tlName),
                                const SizedBox(height: 12),
                                _buildEnhancedInfoRow(Icons.person_outline,
                                    'Advisor Name', _advisorName),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Time Selection Section
                          const Text(
                            'Issue Timing',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildEnhancedTimeSelector(
                            icon: Icons.play_circle_outline_rounded,
                            title: 'Issue Start Time',
                            hour: _issueStartHour,
                            minute: _issueStartMinute,
                            period: _issueStartPeriod,
                            onHourChanged: (value) =>
                                setState(() { _issueStartHour = value; }),
                            onMinuteChanged: (value) =>
                                setState(() { _issueStartMinute = value; }),
                            onPeriodChanged: (value) =>
                                setState(() { _issueStartPeriod = value!; }),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildEnhancedTimeSelector(
                            icon: Icons.stop_circle_outlined,
                            title: 'Issue End Time',
                            hour: _issueEndHour,
                            minute: _issueEndMinute,
                            period: _issueEndPeriod,
                            onHourChanged: (value) =>
                                setState(() { _issueEndHour = value; }),
                            onMinuteChanged: (value) =>
                                setState(() { _issueEndMinute = value; }),
                            onPeriodChanged: (value) =>
                                setState(() { _issueEndPeriod = value!; }),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Issue Explanation
                          _buildIssueExplanationDropdownField(),

                          const SizedBox(height: 24),

                          // Attachment Section
                          _buildAttachmentSection(),

                          const SizedBox(height: 24),

                          // Reason Section
                          _buildReasonSelection(),

                          const SizedBox(height: 24),

                          // Issue Remarks
                          _buildIssueRemarksField(),

                          const SizedBox(height: 32),

                          // Submit Button
                          ScaleTransition(
                            scale: _buttonScale,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: _isFormValid()
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF1E3A8A),
                                          Color(0xFF3B82F6)
                                        ],
                                      )
                                    : null,
                                color: _isFormValid() ? null : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: _isFormValid()
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF1E3A8A)
                                              .withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _isFormValid() ? _submitIssue : null,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding( // Added Padding for vertical spacing
                                    padding: const EdgeInsets.symmetric(vertical: 16.0), // Adjust padding as needed
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.send_rounded,
                                          size: 24,
                                          color: _isFormValid()
                                              ? Colors.white
                                              : Colors.grey[600],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded( // Wrapped Text in Expanded
                                          child: Text(
                                            'Submit Issue and Open Form',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: _isFormValid()
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                              fontFamily: 'Poppins', // Added Poppins font
                                            ),
                                            textAlign: TextAlign.center, // Center text within Expanded
                                            overflow: TextOverflow.ellipsis, // Handle overflow
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Info Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1E3A8A),
                                  Color(0xFF3B82F6),
                                ],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1E3A8A).withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A8A)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFF1E3A8A),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'After submitting, you will be redirected to a Google Form Please Confirm additional details And Submit.',
                                    style: TextStyle(
                                      color: const Color(0xFF1E3A8A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins', // Added Poppins font
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  Widget _buildEnhancedInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed background color
        borderRadius: BorderRadius.circular(12), // Slightly smaller radius
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1, // Slightly thinner border
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3B82F6), // Changed icon color
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimeSelector({
    required IconData icon,
    required String title,
    required int? hour,
    required int? minute,
    required String period,
    required Function(int?) onHourChanged,
    required Function(int?) onMinuteChanged,
    required Function(String?) onPeriodChanged,
    required Gradient gradient,
  }) {
    return _buildEnhancedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () async {
                        DateTime now;
                        try {
                          now = await getNetworkTime();
                        } catch (e) {
                          now = DateTime.now();
                          LoggerService().log('Failed to get network time, using system time: $e');
                        }
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(now),
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat: false,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          onHourChanged(pickedTime.hourOfPeriod);
                          onMinuteChanged(pickedTime.minute);
                          onPeriodChanged(pickedTime.period == DayPeriod.am ? 'AM' : 'PM');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          _formatTime(hour, minute, period),
                          style: TextStyle(
                            fontSize: 16,
                            color: (hour == null || minute == null)
                                ? Colors.grey[500]
                                : gradient.colors.first,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssueExplanationDropdownField() {
    List<String> issueOptions = [
      "Electricity Issue/Power Failure",
      "Head Phone Issue",
      "Wifi Stopped Working",
      "System Hang / Voice Issue",
      "Voice Issue / Cx Voice Not Audible",
      "Mobile Phone Hang",
      "Auto Call Drop",
      "Aspect / WDE issue",
      "Mobile Network Connectivity",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Explain Issue",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        const SizedBox(height: 16),
        _buildEnhancedCard(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding
            decoration: BoxDecoration(
              color: Colors.white, // Changed background color
              borderRadius: BorderRadius.circular(12), // Slightly smaller radius
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedIssueExplanation,
              isExpanded: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
              ),
              selectedItemBuilder: (BuildContext context) {
                return issueOptions.map<Widget>((String item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList();
              },
              items: issueOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIssueExplanation = newValue!;
                 
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Issue Snap",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        _buildEnhancedCard(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _images.length + 1,
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.grey[500],
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Image',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_images[index].path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reason",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        const SizedBox(height: 16),
        _buildEnhancedCard(
          child: Column(
            children: [
              _buildRadioOption(
                title: "Voice Issue",
                value: "Voice Issue",
                groupValue: _selectedReason,
                onChanged: (String? value) {
                  setState(() {
                    _selectedReason = value!;
                   
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                title: "System issue (Network, Asset & Aspect/WDE issue)",
                value: "System issue (Network , Asset & Aspect /WDE issue)",
                groupValue: _selectedReason,
                onChanged: (String? value) {
                  setState(() {
                    _selectedReason = value!;
                   
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value == groupValue
            ? const Color(0xFF1E3A8A).withOpacity(0.1)
            : Colors.white, // Changed background color
        borderRadius: BorderRadius.circular(12), // Slightly smaller radius
        border: Border.all(
          color: value == groupValue
              ? const Color(0xFF1E3A8A)
              : const Color(0xFFE2E8F0),
          width: value == groupValue ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: value == groupValue
                ? const Color(0xFF1E3A8A)
                : Colors.grey[700],
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: const Color(0xFF1E3A8A),
      ),
    );
  }

  Widget _buildIssueRemarksField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Issue Remarks (Optional)",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        _buildEnhancedCard(
          child: TextFormField(
            controller: _issueRemarksController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter any additional remarks about the issue...",
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[500],
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.notes_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  }
