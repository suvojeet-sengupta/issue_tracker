
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _issueHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _issueHistory = prefs.getStringList("issueHistory") ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issue History"),
      ),
      body: _issueHistory.isEmpty
          ? Center(
              child: Text("No issues recorded yet."),
            )
          : ListView.builder(
              itemCount: _issueHistory.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_issueHistory[index]),
                  ),
                );
              },
            ),
    );
  }
}


