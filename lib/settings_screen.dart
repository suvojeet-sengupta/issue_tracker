import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:issue_tracker_app/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: notifier.darkTheme,
                  onChanged: (value) {
                    notifier.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
