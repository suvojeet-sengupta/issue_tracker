import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _googleFormUrlController;
  late TextEditingController _crmIdEntryController;
  late TextEditingController _advisorNameEntryController;
  late TextEditingController _issueStartTimeHourEntryController;
  late TextEditingController _issueStartTimeMinuteEntryController;
  late TextEditingController _issueEndTimeHourEntryController;
  late TextEditingController _issueEndTimeMinuteEntryController;
  late TextEditingController _tlNameEntryController;
  late TextEditingController _organizationEntryController;
  late TextEditingController _issueStartDateYearEntryController;
  late TextEditingController _issueStartDateMonthEntryController;
  late TextEditingController _issueStartDateDayEntryController;
  late TextEditingController _issueEndDateYearEntryController;
  late TextEditingController _issueEndDateMonthEntryController;
  late TextEditingController _issueEndDateDayEntryController;

  @override
  void initState() {
    super.initState();
    _googleFormUrlController = TextEditingController();
    _crmIdEntryController = TextEditingController();
    _advisorNameEntryController = TextEditingController();
    _issueStartTimeHourEntryController = TextEditingController();
    _issueStartTimeMinuteEntryController = TextEditingController();
    _issueEndTimeHourEntryController = TextEditingController();
    _issueEndTimeMinuteEntryController = TextEditingController();
    _tlNameEntryController = TextEditingController();
    _organizationEntryController = TextEditingController();
    _issueStartDateYearEntryController = TextEditingController();
    _issueStartDateMonthEntryController = TextEditingController();
    _issueStartDateDayEntryController = TextEditingController();
    _issueEndDateYearEntryController = TextEditingController();
    _issueEndDateMonthEntryController = TextEditingController();
    _issueEndDateDayEntryController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _googleFormUrlController.dispose();
    _crmIdEntryController.dispose();
    _advisorNameEntryController.dispose();
    _issueStartTimeHourEntryController.dispose();
    _issueStartTimeMinuteEntryController.dispose();
    _issueEndTimeHourEntryController.dispose();
    _issueEndTimeMinuteEntryController.dispose();
    _tlNameEntryController.dispose();
    _organizationEntryController.dispose();
    _issueStartDateYearEntryController.dispose();
    _issueStartDateMonthEntryController.dispose();
    _issueStartDateDayEntryController.dispose();
    _issueEndDateYearEntryController.dispose();
    _issueEndDateMonthEntryController.dispose();
    _issueEndDateDayEntryController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _googleFormUrlController.text = prefs.getString('googleFormUrl') ?? '';
      _crmIdEntryController.text = prefs.getString('crmIdEntry') ?? 'entry.1005447471';
      _advisorNameEntryController.text = prefs.getString('advisorNameEntry') ?? 'entry.44222229';
      _issueStartTimeHourEntryController.text = prefs.getString('issueStartTimeHourEntry') ?? 'entry.1521239602_hour';
      _issueStartTimeMinuteEntryController.text = prefs.getString('issueStartTimeMinuteEntry') ?? 'entry.1521239602_minute';
      _issueEndTimeHourEntryController.text = prefs.getString('issueEndTimeHourEntry') ?? 'entry.701130970_hour';
      _issueEndTimeMinuteEntryController.text = prefs.getString('issueEndTimeMinuteEntry') ?? 'entry.701130970_minute';
      _tlNameEntryController.text = prefs.getString('tlNameEntry') ?? 'entry.115861300';
      _organizationEntryController.text = prefs.getString('organizationEntry') ?? 'entry.313975949';
      _issueStartDateYearEntryController.text = prefs.getString('issueStartDateYearEntry') ?? 'entry.702818104_year';
      _issueStartDateMonthEntryController.text = prefs.getString('issueStartDateMonthEntry') ?? 'entry.702818104_month';
      _issueStartDateDayEntryController.text = prefs.getString('issueStartDateDayEntry') ?? 'entry.702818104_day';
      _issueEndDateYearEntryController.text = prefs.getString('issueEndDateYearEntry') ?? 'entry.514450388_year';
      _issueEndDateMonthEntryController.text = prefs.getString('issueEndDateMonthEntry') ?? 'entry.514450388_month';
      _issueEndDateDayEntryController.text = prefs.getString('issueEndDateDayEntry') ?? 'entry.514450388_day';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('googleFormUrl', _googleFormUrlController.text);
    await prefs.setString('crmIdEntry', _crmIdEntryController.text);
    await prefs.setString('advisorNameEntry', _advisorNameEntryController.text);
    await prefs.setString('issueStartTimeHourEntry', _issueStartTimeHourEntryController.text);
    await prefs.setString('issueStartTimeMinuteEntry', _issueStartTimeMinuteEntryController.text);
    await prefs.setString('issueEndTimeHourEntry', _issueEndTimeHourEntryController.text);
    await prefs.setString('issueEndTimeMinuteEntry', _issueEndTimeMinuteEntryController.text);
    await prefs.setString('tlNameEntry', _tlNameEntryController.text);
    await prefs.setString('organizationEntry', _organizationEntryController.text);
    await prefs.setString('issueStartDateYearEntry', _issueStartDateYearEntryController.text);
    await prefs.setString('issueStartDateMonthEntry', _issueStartDateMonthEntryController.text);
    await prefs.setString('issueStartDateDayEntry', _issueStartDateDayEntryController.text);
    await prefs.setString('issueEndDateYearEntry', _issueEndDateYearEntryController.text);
    await prefs.setString('issueEndDateMonthEntry', _issueEndDateMonthEntryController.text);
    await prefs.setString('issueEndDateDayEntry', _issueEndDateDayEntryController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _googleFormUrlController,
                decoration: const InputDecoration(
                  labelText: 'Google Form URL',
                  hintText: 'Enter the full Google Form URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Google Form Entry IDs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _crmIdEntryController,
                decoration: const InputDecoration(labelText: 'CRM ID Entry'),
              ),
              TextFormField(
                controller: _advisorNameEntryController,
                decoration: const InputDecoration(labelText: 'Advisor Name Entry'),
              ),
              TextFormField(
                controller: _issueStartTimeHourEntryController,
                decoration: const InputDecoration(labelText: 'Issue Start Time (Hour) Entry'),
              ),
              TextFormField(
                controller: _issueStartTimeMinuteEntryController,
                decoration: const InputDecoration(labelText: 'Issue Start Time (Minute) Entry'),
              ),
              TextFormField(
                controller: _issueEndTimeHourEntryController,
                decoration: const InputDecoration(labelText: 'Issue End Time (Hour) Entry'),
              ),
              TextFormField(
                controller: _issueEndTimeMinuteEntryController,
                decoration: const InputDecoration(labelText: 'Issue End Time (Minute) Entry'),
              ),
              TextFormField(
                controller: _tlNameEntryController,
                decoration: const InputDecoration(labelText: 'TL Name Entry'),
              ),
              TextFormField(
                controller: _organizationEntryController,
                decoration: const InputDecoration(labelText: 'Organization Entry'),
              ),
              TextFormField(
                controller: _issueStartDateYearEntryController,
                decoration: const InputDecoration(labelText: 'Issue Start Date (Year) Entry'),
              ),
              TextFormField(
                controller: _issueStartDateMonthEntryController,
                decoration: const InputDecoration(labelText: 'Issue Start Date (Month) Entry'),
              ),
              TextFormField(
                controller: _issueStartDateDayEntryController,
                decoration: const InputDecoration(labelText: 'Issue Start Date (Day) Entry'),
              ),
              TextFormField(
                controller: _issueEndDateYearEntryController,
                decoration: const InputDecoration(labelText: 'Issue End Date (Year) Entry'),
              ),
              TextFormField(
                controller: _issueEndDateMonthEntryController,
                decoration: const InputDecoration(labelText: 'Issue End Date (Month) Entry'),
              ),
              TextFormField(
                controller: _issueEndDateDayEntryController,
                decoration: const InputDecoration(labelText: 'Issue End Date (Day) Entry'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveSettings();
                  }
                },
                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
