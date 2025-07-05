import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/google_form_webview_screen.dart';

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

  int? _issueStartHour;
  int? _issueStartMinute;
  String _issueStartPeriod = "AM";

  int? _issueEndHour;
  int? _issueEndMinute;
  String _issueEndPeriod = "AM";

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
      duration: const Duration(milliseconds: 1000),
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
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList("issueHistory") ?? [];

      TimeOfDay? startTime = _getStartTimeOfDay();
      TimeOfDay? endTime = _getEndTimeOfDay();

      String entry =
          "CRM ID: $_crmId, TL Name: $_tlName, Advisor Name: $_advisorName, "
          "Organization: $_organization, Issue Explanation: $_selectedIssueExplanation, "
          "Reason: $_selectedReason, Start Time: ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime!.hour, startTime.minute).toIso8601String()}, "
          "End Time: ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, endTime!.hour, endTime.minute).toIso8601String()}, Fill Time: ${DateTime.now().toIso8601String()}";

      history.add(entry);
      await prefs.setStringList("issueHistory", history);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
              ],
            ),
            content: const Text(
              "Issue has been recorded successfully. Opening Google Form Please Verify Form And Submit...",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins', // Added Poppins font
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openGoogleForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontFamily: 'Poppins'), // Added Poppins font
                ),
              ),
            ],
          );
        },
      );
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

    final DateTime now = DateTime.now();
    final String currentYear = now.year.toString();
    final String currentMonth = now.month.toString();
    final String currentDay = now.day.toString();

    String url =
        "https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=pp_url";
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

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GoogleFormWebviewScreen(formUrl: googleFormUri.toString())));
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
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Fill Issue Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins', // Added Poppins font
                      ),
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
                          // User Information Card
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
                                      'User Information',
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
                                setState(() => _issueStartHour = value),
                            onMinuteChanged: (value) =>
                                setState(() => _issueStartMinute = value),
                            onPeriodChanged: (value) =>
                                setState(() => _issueStartPeriod = value!),
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
                                setState(() => _issueEndHour = value),
                            onMinuteChanged: (value) =>
                                setState(() => _issueEndMinute = value),
                            onPeriodChanged: (value) =>
                                setState(() => _issueEndPeriod = value!),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Issue Explanation
                          _buildIssueExplanationDropdownField(),

                          const SizedBox(height: 24),

                          // Reason Section
                          _buildReasonSelection(),

                          const SizedBox(height: 32),

                          // Submit Button
                          ScaleTransition(
                            scale: _buttonScale,
                            child: Container(
                              width: double.infinity,
                              height: 64,
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
                                  child: Center(
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
                                        Text(
                                          'Submit Issue and Open Form',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _isFormValid()
                                                ? Colors.white
                                                : Colors.grey[600],
                                            fontFamily: 'Poppins', // Added Poppins font
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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
        boxShadow: [ // Added subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
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
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
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
              boxShadow: [ // Added subtle shadow
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedIssueExplanation,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding( // Changed to Padding for better spacing
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: Color(0xFF3B82F6), // Changed icon color
                    size: 20,
                  ),
                ),
              ),
              items: issueOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins', // Added Poppins font
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
        boxShadow: [ // Added subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
}
