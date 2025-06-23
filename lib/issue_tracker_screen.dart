import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueTrackerScreen extends StatefulWidget {
  @override
  _IssueTrackerScreenState createState() => _IssueTrackerScreenState();
}

class _IssueTrackerScreenState extends State<IssueTrackerScreen> with TickerProviderStateMixin {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";

  TimeOfDay? _issueStartTime;
  TimeOfDay? _issueEndTime;
  
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
    });
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D8A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
                const Text('Success!'),
              ],
            ),
            content: const Text('Issue has been recorded successfully. Opening Google Form...'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openGoogleForm();
                },
                child: const Text('Continue'),
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

    final String encodedCrmId = Uri.encodeComponent(_crmId);
    final String encodedAdvisorName = Uri.encodeComponent(_advisorName);
    final String encodedTlName = Uri.encodeComponent(_tlName);
    final String encodedOrganization = Uri.encodeComponent("DISH"); // Default to DISH

    final String startTimeHour = _issueStartTime?.hour.toString().padLeft(2, '0') ?? "";
    final String startTimeMinute = _issueStartTime?.minute.toString().padLeft(2, '0') ?? "";
    final String endTimeHour = _issueEndTime?.hour.toString().padLeft(2, '0') ?? "";
    final String endTimeMinute = _issueEndTime?.minute.toString().padLeft(2, '0') ?? "";

    String url = "https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=pp_url";
    url += "&entry." + crmIdEntryId + "=" + encodedCrmId;
    url += "&entry." + advisorNameEntryId + "=" + encodedAdvisorName;
    url += "&entry." + startTimeHourEntryId + "=" + startTimeHour;
    url += "&entry." + startTimeMinuteEntryId + "=" + startTimeMinute;
    url += "&entry." + endTimeHourEntryId + "=" + endTimeHour;
    url += "&entry." + endTimeMinuteEntryId + "=" + endTimeMinute;
    url += "&entry." + tlNameEntryId + "=" + encodedTlName;
    url += "&entry." + organizationEntryId + "=" + encodedOrganization;

    final Uri googleFormUrl = Uri.parse(url);

    if (!await launchUrl(googleFormUrl)) {
      throw Exception("Could not launch $googleFormUrl");
    }
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
                
                _buildTimeSelector(
                  icon: Icons.play_circle_outline,
                  title: 'Issue Start Time',
                  time: _issueStartTime,
                  onTap: () => _selectTime(context, true),
                  color: const Color(0xFF4CAF50),
                ),
                
                const SizedBox(height: 16),
                
                _buildTimeSelector(
                  icon: Icons.stop_circle_outlined,
                  title: 'Issue End Time',
                  time: _issueEndTime,
                  onTap: () => _selectTime(context, false),
                  color: const Color(0xFFF44336),
                ),
                
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

  Widget _buildTimeSelector({
    required IconData icon,
    required String title,
    required TimeOfDay? time,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
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
                      time == null ? 'Select Time' : time.format(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: time == null ? Colors.grey : const Color(0xFF2E7D8A),
                        fontWeight: time == null ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.access_time,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

