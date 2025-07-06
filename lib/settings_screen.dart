import 'package:flutter/material.dart';
import 'package:issue_tracker_app/admin_settings_screen.dart';
import 'package:issue_tracker_app/about_app_screen.dart'; // New import
import 'package:issue_tracker_app/developer_info_screen.dart'; // New import
import 'package:url_launcher/url_launcher.dart'; // New import for url_launcher

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your CRM ID, Team Leader, and Advisor Name',
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_profile');
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'Admin Settings',
                      subtitle: 'Access administrative configurations',
                      onTap: () {
                        _showAdminPasswordDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // About Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: Icons.info_outline,
                      title: 'About App',
                      subtitle: 'Learn more about the Issue Tracker App',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutAppScreen()),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.code,
                      title: 'Developer Info',
                      subtitle: 'Information about the app developer',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DeveloperInfoScreen()),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.data_object,
                      title: 'View App Source Code',
                      subtitle: 'Explore the code on GitHub',
                      onTap: () async {
                        const url = 'https://github.com/suvojit213/issue_tracker';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url. Please ensure you have a web browser installed and an active internet connection.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showAdminPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Admin Access'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enter'),
              onPressed: () {
                if (passwordController.text == '01082005') {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminSettingsScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
