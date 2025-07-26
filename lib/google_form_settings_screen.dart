
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleFormSettingsScreen extends StatefulWidget {
  const GoogleFormSettingsScreen({super.key});

  @override
  _GoogleFormSettingsScreenState createState() => _GoogleFormSettingsScreenState();
}

class _GoogleFormSettingsScreenState extends State<GoogleFormSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _crmIdController = TextEditingController();
  final _advisorNameController = TextEditingController();
  final _startTimeHourController = TextEditingController();
  final _startTimeMinuteController = TextEditingController();
  final _endTimeHourController = TextEditingController();
  final _endTimeMinuteController = TextEditingController();
  final _tlNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _startDateYearController = TextEditingController();
  final _startDateMonthController = TextEditingController();
  final _startDateDayController = TextEditingController();
  final _endDateYearController = TextEditingController();
  final _endDateMonthController = TextEditingController();
  final _endDateDayController = TextEditingController();
  final _explainIssueController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _urlController.text = prefs.getString('google_form_url') ?? 'https://docs.google.com/forms/d/e/1FAIpQLSdeWylhfFaHmM3osSGRbxh9S_XvnAEPCIhTemuh-I7-LNds_w/viewform?usp=pp_url';
      _crmIdController.text = prefs.getString('google_form_crmIdEntryId') ?? '1005447471';
      _advisorNameController.text = prefs.getString('google_form_advisorNameEntryId') ?? '44222229';
      _startTimeHourController.text = prefs.getString('google_form_startTimeHourEntryId') ?? '1521239602_hour';
      _startTimeMinuteController.text = prefs.getString('google_form_startTimeMinuteEntryId') ?? '1521239602_minute';
      _endTimeHourController.text = prefs.getString('google_form_endTimeHourEntryId') ?? '701130970_hour';
      _endTimeMinuteController.text = prefs.getString('google_form_endTimeMinuteEntryId') ?? '701130970_minute';
      _tlNameController.text = prefs.getString('google_form_tlNameEntryId') ?? '115861300';
      _organizationController.text = prefs.getString('google_form_organizationEntryId') ?? '313975949';
      _startDateYearController.text = prefs.getString('google_form_startDateYearEntryId') ?? '702818104_year';
      _startDateMonthController.text = prefs.getString('google_form_startDateMonthEntryId') ?? '702818104_month';
      _startDateDayController.text = prefs.getString('google_form_startDateDayEntryId') ?? '702818104_day';
      _endDateYearController.text = prefs.getString('google_form_endDateYearEntryId') ?? '514450388_year';
      _endDateMonthController.text = prefs.getString('google_form_endDateMonthEntryId') ?? '514450388_month';
      _endDateDayController.text = prefs.getString('google_form_endDateDayEntryId') ?? '514450388_day';
      _explainIssueController.text = prefs.getString('google_form_explainIssueEntryId') ?? '1211413190';
      _reasonController.text = prefs.getString('google_form_reasonEntryId') ?? '1231067802';
    });
  }

  _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('google_form_url', _urlController.text);
      await prefs.setString('google_form_crmIdEntryId', _crmIdController.text);
      await prefs.setString('google_form_advisorNameEntryId', _advisorNameController.text);
      await prefs.setString('google_form_startTimeHourEntryId', _startTimeHourController.text);
      await prefs.setString('google_form_startTimeMinuteEntryId', _startTimeMinuteController.text);
      await prefs.setString('google_form_endTimeHourEntryId', _endTimeHourController.text);
      await prefs.setString('google_form_endTimeMinuteEntryId', _endTimeMinuteController.text);
      await prefs.setString('google_form_tlNameEntryId', _tlNameController.text);
      await prefs.setString('google_form_organizationEntryId', _organizationController.text);
      await prefs.setString('google_form_startDateYearEntryId', _startDateYearController.text);
      await prefs.setString('google_form_startDateMonthEntryId', _startDateMonthController.text);
      await prefs.setString('google_form_startDateDayEntryId', _startDateDayController.text);
      await prefs.setString('google_form_endDateYearEntryId', _endDateYearController.text);
      await prefs.setString('google_form_endDateMonthEntryId', _endDateMonthController.text);
      await prefs.setString('google_form_endDateDayEntryId', _endDateDayController.text);
      await prefs.setString('google_form_explainIssueEntryId', _explainIssueController.text);
      await prefs.setString('google_form_reasonEntryId', _reasonController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
    }
  }

  _resetSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('google_form_url');
    await prefs.remove('google_form_crmIdEntryId');
    await prefs.remove('google_form_advisorNameEntryId');
    await prefs.remove('google_form_startTimeHourEntryId');
    await prefs.remove('google_form_startTimeMinuteEntryId');
    await prefs.remove('google_form_endTimeHourEntryId');
    await prefs.remove('google_form_endTimeMinuteEntryId');
    await prefs.remove('google_form_tlNameEntryId');
    await prefs.remove('google_form_organizationEntryId');
    await prefs.remove('google_form_startDateYearEntryId');
    await prefs.remove('google_form_startDateMonthEntryId');
    await prefs.remove('google_form_startDateDayEntryId');
    await prefs.remove('google_form_endDateYearEntryId');
    await prefs.remove('google_form_endDateMonthEntryId');
    await prefs.remove('google_form_endDateDayEntryId');
    await prefs.remove('google_form_explainIssueEntryId');
    await prefs.remove('google_form_reasonEntryId');

    _loadSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset to default.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Form Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Form URL'),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildTextField(
                      controller: _urlController,
                      labelText: 'Google Form URL',
                      icon: Icons.link,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'General Entry IDs'),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildTextField(
                      controller: _crmIdController,
                      labelText: 'CRM ID Entry ID',
                      icon: Icons.badge,
                    ),
                    _buildTextField(
                      controller: _advisorNameController,
                      labelText: 'Advisor Name Entry ID',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _tlNameController,
                      labelText: 'TL Name Entry ID',
                      icon: Icons.supervisor_account,
                    ),
                    _buildTextField(
                      controller: _organizationController,
                      labelText: 'Organization Entry ID',
                      icon: Icons.business,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Time Entry IDs'),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildTextField(
                      controller: _startTimeHourController,
                      labelText: 'Start Time Hour Entry ID',
                      icon: Icons.hourglass_empty,
                    ),
                    _buildTextField(
                      controller: _startTimeMinuteController,
                      labelText: 'Start Time Minute Entry ID',
                      icon: Icons.hourglass_empty,
                    ),
                    _buildTextField(
                      controller: _endTimeHourController,
                      labelText: 'End Time Hour Entry ID',
                      icon: Icons.hourglass_full,
                    ),
                    _buildTextField(
                      controller: _endTimeMinuteController,
                      labelText: 'End Time Minute Entry ID',
                      icon: Icons.hourglass_full,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Date Entry IDs'),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildTextField(
                      controller: _startDateYearController,
                      labelText: 'Start Date Year Entry ID',
                      icon: Icons.calendar_today,
                    ),
                    _buildTextField(
                      controller: _startDateMonthController,
                      labelText: 'Start Date Month Entry ID',
                      icon: Icons.calendar_today,
                    ),
                    _buildTextField(
                      controller: _startDateDayController,
                      labelText: 'Start Date Day Entry ID',
                      icon: Icons.calendar_today,
                    ),
                    _buildTextField(
                      controller: _endDateYearController,
                      labelText: 'End Date Year Entry ID',
                      icon: Icons.event,
                    ),
                    _buildTextField(
                      controller: _endDateMonthController,
                      labelText: 'End Date Month Entry ID',
                      icon: Icons.event,
                    ),
                    _buildTextField(
                      controller: _endDateDayController,
                      labelText: 'End Date Day Entry ID',
                      icon: Icons.event,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'Issue Details Entry IDs'),
                _buildSettingsCard(
                  context,
                  children: [
                    _buildTextField(
                      controller: _explainIssueController,
                      labelText: 'Explain Issue Entry ID',
                      icon: Icons.help_outline,
                    ),
                    _buildTextField(
                      controller: _reasonController,
                      labelText: 'Reason Entry ID',
                      icon: Icons.report_problem,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Save Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetSettings,
                        icon: Icon(Icons.restore, color: Theme.of(context).primaryColor),
                        label: Text(
                          'Reset to Default',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }
}
