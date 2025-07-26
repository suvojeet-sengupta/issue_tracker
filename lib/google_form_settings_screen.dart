
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
        title: const Text('Google Form Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'Form URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _crmIdController,
                decoration: const InputDecoration(labelText: 'CRM ID Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _advisorNameController,
                decoration: const InputDecoration(labelText: 'Advisor Name Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startTimeHourController,
                decoration: const InputDecoration(labelText: 'Start Time Hour Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startTimeMinuteController,
                decoration: const InputDecoration(labelText: 'Start Time Minute Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endTimeHourController,
                decoration: const InputDecoration(labelText: 'End Time Hour Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endTimeMinuteController,
                decoration: const InputDecoration(labelText: 'End Time Minute Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
               TextFormField(
                controller: _tlNameController,
                decoration: const InputDecoration(labelText: 'TL Name Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _organizationController,
                decoration: const InputDecoration(labelText: 'Organization Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateYearController,
                decoration: const InputDecoration(labelText: 'Start Date Year Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateMonthController,
                decoration: const InputDecoration(labelText: 'Start Date Month Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateDayController,
                decoration: const InputDecoration(labelText: 'Start Date Day Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateYearController,
                decoration: const InputDecoration(labelText: 'End Date Year Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateMonthController,
                decoration: const InputDecoration(labelText: 'End Date Month Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateDayController,
                decoration: const InputDecoration(labelText: 'End Date Day Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _explainIssueController,
                decoration: const InputDecoration(labelText: 'Explain Issue Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason Entry ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Entry ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save Settings'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _resetSettings,
                child: const Text('Reset to Default'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
