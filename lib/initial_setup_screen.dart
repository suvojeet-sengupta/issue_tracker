
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetupScreen extends StatefulWidget {
  @override
  _InitialSetupScreenState createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _crmIdController = TextEditingController();
  final _advisorNameController = TextEditingController();
  String _selectedTlName = 'Manish Kumar';
  bool _showOtherTlNameField = false;
  final _otherTlNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _crmIdController.text = prefs.getString('crmId') ?? '';
      _advisorNameController.text = prefs.getString('advisorName') ?? '';
      _selectedTlName = prefs.getString('tlName') ?? 'Manish Kumar';
      if (_selectedTlName == 'Other') {
        _showOtherTlNameField = true;
        _otherTlNameController.text = prefs.getString('otherTlName') ?? '';
      }
    });
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('crmId', _crmIdController.text);
    await prefs.setString('advisorName', _advisorNameController.text);
    await prefs.setString('tlName', _selectedTlName);
    if (_showOtherTlNameField) {
      await prefs.setString('otherTlName', _otherTlNameController.text);
    } else {
      await prefs.remove('otherTlName');
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initial Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _crmIdController,
              decoration: InputDecoration(
                labelText: 'CRM ID',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedTlName,
              decoration: InputDecoration(
                labelText: 'Team Leader Name',
              ),
              items: <String>[
                'Manish Kumar',
                'Imran Khan',
                'Ravi',
                'Ankush',
                'Gajendra',
                'Suyash Upadhyay',
                'Aniket',
                'Randhir Kumar',
                'Shubham Kumar',
                'Karan',
                'Rohit',
                'Shilpa',
                'Vipin',
                'Sonu',
                'Other',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTlName = newValue!;
                  _showOtherTlNameField = (newValue == 'Other');
                });
              },
            ),
            if (_showOtherTlNameField)
              TextField(
                controller: _otherTlNameController,
                decoration: InputDecoration(
                  labelText: 'Other Team Leader Name',
                ),
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _advisorNameController,
              decoration: InputDecoration(
                labelText: 'Advisor Name',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

