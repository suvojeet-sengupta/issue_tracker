
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/initial_setup_screen.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:issue_tracker_app/history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSetupComplete = false;

  @override
  void initState() {
    super.initState();
    _checkSetupStatus();
  }

  _checkSetupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSetupComplete = prefs.containsKey("crmId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isSetupComplete ? HomeScreen() : InitialSetupScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/issue_tracker': (context) => IssueTrackerScreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Issue Tracker App!'),
            SizedBox(height: 20),
            Text('CRM ID: $_crmId'),
            Text('Team Leader: $_tlName'),
            Text('Advisor Name: $_advisorName'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/issue_tracker');
              },
              child: Text('Fill Issue Tracker'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: Text('View History'),
            ),
          ],
        ),
      ),
    );
  }
}


