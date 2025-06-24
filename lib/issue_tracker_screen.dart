import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:issue_tracker_app/google_form_webview_screen.dart';

class IssueTrackerScreen extends StatefulWidget {
  @override
  _IssueTrackerScreenState createState() => _IssueTrackerScreenState();
}

class _IssueTrackerScreenState extends State<IssueTrackerScreen> with TickerProviderStateMixin {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";
  String _organization = ""; // New: To store selected organization
  String _selectedIssueExplanation = "Mobile Phone Hang"; // Default value
  String _selectedReason = "Voice Issue"; // Default value

  // Changed from TimeOfDay to separate hour and minute variables
  int? _issueStartHour;
  int? _issueStartMinute;
  String _issueStartPeriod = "AM";
  
  int? _issueEndHour;
  int? _issueEndMinute;
  String _issueEndPeriod = "AM";
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      _organization = prefs.getString("organization") ?? "DISH"; // Load saved organization
    });
  }

  // Helper method to convert 12-hour format to TimeOfDay for compatibility
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
    return _issueStartHour != null && _issueStartMinute != null &&
           _issueEndHour != null && _issueEndMinute != null;
  }

  _submitIssue() async {
    if (_isFormValid()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList("issueHistory") ?? [];

      TimeOfDay? startTime = _getStartTimeOfDay();
      TimeOfDay? endTime = _getEndTimeOfDay();

      String entry = 
          "CRM ID: $_crmId, TL Name: $_tlName, Advisor Name: $_advisorName, "
          "Start Time: ${startTime!.format(context)}, End Time: ${endTime!.format(context)}, "
          "Fill Time: ${DateTime.now().toIso8601String()}";

      history.add(entry);
      await prefs.setStringList("issueHistory", history);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text("Success!"),
              ],
            ),
            content: const Text("Issue has been recorded successfully. Opening Google Form..."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openGoogleForm();
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select both start and end times."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  _openGoogleForm() async {
    final String crmIdEntryId = "1005447471";
    final String advisorNameEntryId = "44222229";
    final String startTimeHourEntryId = "1521239602_hour";
    final String startTimeMinuteEntryId = "1521239602_minute";
    final String endTimeHourEntryId = "701130970_hour";
    final String endTimeMinuteEntryId = "701130970_minute";
    final String tlNameEntryId = "115861300";
    final String organizationEntryId = "313975949";
    final String startDateYearEntryId = "702818104_year";
    final String startDateMonthEntryId = "702818104_month";
    final String startDateDayEntryId = "702818104_day";
    final String endDateYearEntryId = "514450388_year";
    final String endDateMonthEntryId = "514450388_month";
    final String endDateDayEntryId = "514450388_day";
    final String explainIssueEntryId = "1211413190";
    final String reasonEntryId = "1231067802";

    final String encodedCrmId = Uri.encodeComponent(_crmId);
    final String encodedAdvisorName = Uri.encodeComponent(_advisorName);
    final String encodedTlName = Uri.encodeComponent(_tlName);
    final String encodedOrganization = Uri.encodeComponent(_organization);
    final String encodedIssueExplanation = Uri.encodeComponent(_selectedIssueExplanation);
    final String encodedReason = Uri.encodeComponent(_selectedReason);

    TimeOfDay? startTime = _getStartTimeOfDay();
    TimeOfDay? endTime = _getEndTimeOfDay();

    final String startTimeHour = startTime?.hour.toString().padLeft(2, '0') ?? "";
    final String startTimeMinute = startTime?.minute.toString().padLeft(2, '0') ?? "";
    final String endTimeHour = endTime?.hour.toString().padLeft(2, '0') ?? "";
    final String endTimeMinute = endTime?.minute.toString().padLeft(2, '0') ?? "";

    final DateTime now = DateTime.now();
    final String currentYear = now.year.toString();
    final String currentMonth = now.month.toString();
    final String currentDay = now.day.toString();

    String url = "https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=pp_url";
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

    Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleFormWebviewScreen(formUrl: googleFormUri.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fill Issue Tracker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_slideAnimation),
        child: FadeTransition(
          opacity: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D8A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.badge, 'CRM ID', _crmId),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.person, 'Team Leader', _tlName),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.supervisor_account, 'Advisor Name', _advisorName),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Time Selection Section
                const Text(
                  'Issue Timing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D8A),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildNormalTimeSelector(
                  icon: Icons.play_circle_outline,
                  title: 'Issue Start Time',
                  hour: _issueStartHour,
                  minute: _issueStartMinute,
                  period: _issueStartPeriod,
                  onHourChanged: (value) => setState(() => _issueStartHour = value),
                  onMinuteChanged: (value) => setState(() => _issueStartMinute = value),
                  onPeriodChanged: (value) => setState(() => _issueStartPeriod = value!),
                  color: const Color(0xFF4CAF50),
                ),
                
                const SizedBox(height: 16),
                
                _buildNormalTimeSelector(
                  icon: Icons.stop_circle_outlined,
                  title: 'Issue End Time',
                  hour: _issueEndHour,
                  minute: _issueEndMinute,
                  period: _issueEndPeriod,
                  onHourChanged: (value) => setState(() => _issueEndHour = value),
                  onMinuteChanged: (value) => setState(() => _issueEndMinute = value),
                  onPeriodChanged: (value) => setState(() => _issueEndPeriod = value!),
                  color: const Color(0xFFF44336),
                ),
                
                const SizedBox(height: 32),

                // Explain Issue Dropdown
                _buildIssueExplanationDropdownField(),

                const SizedBox(height: 24),

                // Reason Section
                _buildReasonSelection(),

                const SizedBox(height: 32),
                
                // Submit Button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _submitIssue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid() 
                          ? const Color(0xFF2E7D8A) 
                          : Colors.grey[300],
                      foregroundColor: _isFormValid() 
                          ? Colors.white 
                          : Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _isFormValid() ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Submit Issue and Open Form',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2E7D8A).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFF2E7D8A),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'After submitting, you will be redirected to a Google Form to provide additional details.',
                          style: TextStyle(
                            color: const Color(0xFF2E7D8A),
                            fontSize: 14,
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2E7D8A),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.isNotEmpty ? value : 'Not set',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // New normal time selector widget with dropdowns
  Widget _buildNormalTimeSelector({
    required IconData icon,
    required String title,
    required int? hour,
    required int? minute,
    required String period,
    required Function(int?) onHourChanged,
    required Function(int?) onMinuteChanged,
    required Function(String?) onPeriodChanged,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(hour, minute, period),
                        style: TextStyle(
                          fontSize: 14,
                          color: (hour == null || minute == null) ? Colors.grey : const Color(0xFF2E7D8A),
                          fontWeight: (hour == null || minute == null) ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Hour Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hour',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: DropdownButtonFormField<int>(
                          value: hour,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          hint: const Text('Hour'),
                          items: List.generate(12, (index) => index + 1).map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                          onChanged: onHourChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Minute Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minute',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: DropdownButtonFormField<int>(
                          value: minute,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          hint: const Text('Min'),
                          items: List.generate(60, (index) => index).map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString().padLeft(2, '0')),
                            );
                          }).toList(),
                          onChanged: onMinuteChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // AM/PM Dropdown
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Period',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: period,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          items: ['AM', 'PM'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: onPeriodChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D8A),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedIssueExplanation,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.help_outline, color: Color(0xFF2E7D8A)),
            ),
            items: issueOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedIssueExplanation = newValue!;
              });
            },
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D8A),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text("Voice Issue"),
                  value: "Voice Issue",
                  groupValue: _selectedReason,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedReason = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text("System issue (Network , Asset & Aspect /WDE issue)"),
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
        ),
      ],
    );
  }
}

