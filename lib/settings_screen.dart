import 'package:flutter/material.dart';
import 'package:issue_tracker_app/admin_settings_screen.dart';
import 'package:issue_tracker_app/about_app_screen.dart'; // New import
import 'package:issue_tracker_app/developer_info_screen.dart'; // New import
import 'package:issue_tracker_app/credits_screen.dart'; // New import
import 'package:issue_tracker_app/feedback_screen.dart'; // New import
import 'package:issue_tracker_app/changelog_screen.dart'; // New import for changelog
import 'package:url_launcher/url_launcher.dart'; // New import for url_launcher
import 'package:package_info_plus/package_info_plus.dart'; // For app version
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON decoding
import 'package:flutter/services.dart'; // For MethodChannel

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentVersion = 'Loading...';
  String _latestVersion = 'Loading...';
  String? _downloadUrl;
  bool _updateAvailable = false;
  bool _checkingForUpdate = false;

  static const platform = MethodChannel('com.suvojeet.issue_tracker_app/update');

  @override
  void initState() {
    super.initState();
    _getCurrentAppVersion();
    _checkForUpdate();
  }

  Future<void> _getCurrentAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _currentVersion = packageInfo.version;
    });
  }

  Future<void> _checkForUpdate() async {
    setState(() {
      _checkingForUpdate = true;
    });
    try {
      const String repo = 'suvojit213/issue_tracker'; // Your GitHub repo
      final response = await http.get(Uri.parse('https://api.github.com/repos/$repo/releases/latest'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> release = json.decode(response.body);
        final String latestVersionTag = release['tag_name'];
        final String latestVersion = latestVersionTag.startsWith('v') ? latestVersionTag.substring(1) : latestVersionTag;

        // Find the APK asset
        final assets = release['assets'] as List;
        final apkAsset = assets.firstWhere(
          (asset) => asset['name'].endsWith('.apk'),
          orElse: () => null,
        );

        setState(() {
          _latestVersion = latestVersion;
          if (apkAsset != null) {
            _downloadUrl = apkAsset['browser_download_url'];
          }

          // Simple version comparison (you might want a more robust one for complex versioning)
          if (_currentVersion != 'Loading...' && _compareVersions(_latestVersion, _currentVersion) > 0) {
            _updateAvailable = true;
          } else {
            _updateAvailable = false;
          }
        });
      } else {
        // Handle API error
        setState(() {
          _latestVersion = 'Error fetching updates';
          _updateAvailable = false;
        });
        print('Failed to load latest release: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _latestVersion = 'Error fetching updates';
        _updateAvailable = false;
      });
      print('Error checking for update: $e');
    } finally {
      setState(() {
        _checkingForUpdate = false;
      });
    }
  }

  int _compareVersions(String v1, String v2) {
    final v1Parts = v1.split('.').map(int.parse).toList();
    final v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < v1Parts.length && i < v2Parts.length; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return v1Parts.length.compareTo(v2Parts.length);
  }

  Future<void> _downloadAndInstallApk() async {
    if (_downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No download URL available.')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading update...')),
      );
      await platform.invokeMethod('downloadAndInstallApk', {'url': _downloadUrl});
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download/install: ${e.message}')),
      );
    }
  }

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
                    // Check for Update Section
                    _buildSettingsTile(
                      context,
                      icon: Icons.update,
                      title: 'Check for Update',
                      subtitle: _checkingForUpdate
                          ? 'Checking for updates...'
                          : _updateAvailable
                              ? 'Update Available (v$_latestVersion)'
                              : 'You are on the latest version (v$_currentVersion)',
                      onTap: _checkingForUpdate ? null : _checkForUpdate,
                      trailing: _updateAvailable
                          ? ElevatedButton(
                              onPressed: _downloadAndInstallApk,
                              child: const Text('Download'),
                            )
                          : null,
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
                    _buildSettingsTile(
                      context,
                      icon: Icons.feedback_outlined,
                      title: 'Feedback',
                      subtitle: 'Share your thoughts and suggestions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.people_outline,
                      title: 'Credits',
                      subtitle: 'Meet the team behind the app',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreditsScreen()),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.history,
                      title: 'Changelog',
                      subtitle: 'View app version history and updates',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangelogScreen()),
                        );
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

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, VoidCallback? onTap, Widget? trailing}) {
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
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
