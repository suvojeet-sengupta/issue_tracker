import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangelogScreen extends StatelessWidget {
  const ChangelogScreen({super.key});

  final String githubRepoUrl = 'https://github.com/suvojeet213/issue_tracker_app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changelog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildChangelogEntry(
            context,
            'bc50a335262a4351f24196b369940f86bc51c621',
            'suvojit213',
            '2025-07-13 17:04:43',
            "feat: Add 'Good Morning' notification with advisor name",
          ),
          _buildChangelogEntry(
            context,
            '6fbb2fcdba6d020aac4755e2103bb1a5fd3ee038',
            'suvojit213',
            '2025-07-13 17:02:15',
            'feat: Dynamically schedule notifications based on message count',
          ),
          _buildChangelogEntry(
            context,
            'c10e9b9c5d2ddd6d11e2c54aa863b13f1549321d',
            'suvojit213',
            '2025-07-13 16:51:11',
            'feat: Update notification messages in DailySchedulerWorker',
          ),
          _buildChangelogEntry(
            context,
            'ac3dac770ca788bcde45b569ac089bfe5c3ee1d1',
            'suvojit213',
            '2025-07-13 16:33:06',
            'fix: Adjust notification onboarding text alignment',
          ),
          _buildChangelogEntry(
            context,
            '104775fb4241308fa34f5c3a0c9c603eb23cc25c',
            'suvojit213',
            '2025-07-13 16:18:57',
            'fix: Remove duplicate imports in NotificationHelper.kt',
          ),
          _buildChangelogEntry(
            context,
            '40f1cb71972fb3c62ba62a8f6e6abf2a129e1127',
            'suvojit213',
            '2025-07-13 16:04:56',
            'fix: Resolve compilation errors in Kotlin files and improve JSON handling',
          ),
          _buildChangelogEntry(
            context,
            '2cff4f358be59f0e5333c86909976a22a260b0f7',
            'suvojit213',
            '2025-07-13 15:48:06',
            'fix: Remove duplicate dispose method in DashboardScreen',
          ),
          _buildChangelogEntry(
            context,
            'e6ba993d8a0d56671c1e5d0951ef204feb52d98a',
            'suvojit213',
            '2025-07-13 15:28:50',
            'feat: Add unread notification count badge to home screen icon',
          ),
          _buildChangelogEntry(
            context,
            '087ff9329f9230fe9868dbace03e00d804c58631',
            'suvojit213',
            '2025-07-13 12:47:22',
            'fix: Resolve _notificationIconKey not defined error in DashboardScreen',
          ),
          _buildChangelogEntry(
            context,
            '7aae18aa7211ee2460e4de26a0be1b185faefbd4',
            'suvojit213',
            '2025-07-13 12:38:32',
            'feat: Add notification icon onboarding to home screen',
          ),
          _buildChangelogEntry(
            context,
            'f2f30b6a6bae88d905e47464a574649d3c6c268d',
            'suvojit213',
            '2025-07-13 11:47:24',
            'fix: Resolve compilation errors in DailySchedulerWorker and MainActivity',
          ),
          _buildChangelogEntry(
            context,
            '1d40e27ba471f605e686a22815b5def5c43ce8ed',
            'suvojit213',
            '2025-07-13 11:38:55',
            'feat: Implement advanced daily notification scheduling',
          ),
          _buildChangelogEntry(
            context,
            '84f60700f0b254e5dd68c8f3d8e5d23b2256685e',
            'suvojit213',
            '2025-07-13 11:14:41',
            'feat: Enhance NotificationHistoryScreen UI/UX',
          ),
          _buildChangelogEntry(
            context,
            '0682cbff5890ce580b74e44a72b43245a9561e97',
            'suvojit213',
            '2025-07-13 10:53:48',
            'fix: Resolve MainActivity.kt compilation errors',
          ),
          _buildChangelogEntry(
            context,
            '738820978e22bb9bee764eedbbe6d1675a5625e4',
            'github-actions[bot]',
            '2025-07-13 05:18:06',
            'chore: Update pubspec.lock [skip ci]',
          ),
          _buildChangelogEntry(
            context,
            'cc89b387315930d15516235dbf67cc47563d3fa4',
            'suvojit213',
            '2025-07-13 01:33:07',
            'feat: Implement Kotlin-based notification system with history and UI',
          ),
          _buildChangelogEntry(
            context,
            '7a17f79e87b05bc557ef02dec371f6c17e5cace9',
            'suvojit213',
            '2025-07-13 01:15:08',
            'fix: Configure FileProvider to access external storage (Documents folder)',
          ),
          _buildChangelogEntry(
            context,
            '7cea68d411bd6fa6ef1e9a982ca0ca5b32a75423',
            'suvojit213',
            '2025-07-13 00:59:54',
            'feat: Save generated reports to Documents folder and open from there',
          ),
          _buildChangelogEntry(
            context,
            '4f30763ecef23fb6ccea7ee8174c882ebe6501c6',
            'suvojit213',
            '2025-07-13 00:45:26',
            'fix: Configure FileProvider to access cache directory for report files',
          ),
          _buildChangelogEntry(
            context,
            '533502ff7f00ee88d986fba254724a21b427a5ab',
            'suvojit213',
            '2025-07-13 00:33:19',
            'fix: Remove remaining share_plus usage and _shareIssue method from HistoryScreen',
          ),
          _buildChangelogEntry(
            context,
            '744bb463b3876d755802d33e8d062eb87020563c',
            'suvojit213',
            '2025-07-13 00:23:43',
            'feat: Implement direct download and open functionality for reports via Kotlin native code',
          ),
          _buildChangelogEntry(
            context,
            'efccd322b71e0a1e4a9ac56994ce128a5acc92a5',
            'suvojit213',
            '2025-07-13 00:06:37',
            'feat: Automate initial setup for CRM ID 1210793 with auto-fill and auto-submit',
          ),
          _buildChangelogEntry(
            context,
            'e078a2716928d22e7598f62b23ea6e0ae9001367',
            'suvojit213',
            '2025-07-12 23:07:31',
            'fix: Further adjust PDF report column widths for Advisor Name, Organization, and Reason',
          ),
          _buildChangelogEntry(
            context,
            'd50aeb81ad62733def391300c0cfa03c8789d505',
            'suvojit213',
            '2025-07-12 22:52:57',
            'fix: Adjust PDF report column widths for better readability',
          ),
          _buildChangelogEntry(
            context,
            '45259e37c66079fb6d2af97ff83f6481ac52d344',
            'suvojit213',
            '2025-07-12 22:37:22',
            'fix: Correct _downloadReport calls in HistoryScreen',
          ),
          _buildChangelogEntry(
            context,
            '6f5de8f7ac12f6cf28f4c2eaf31c64621b8ce454',
            'suvojit213',
            '2025-07-12 22:29:16',
            'feat: Change download filtering to single date and update report titles',
          ),
          _buildChangelogEntry(
            context,
            'f62522a162676422937032f2759cd17a90889229',
            'suvojit213',
            '2025-07-12 22:05:07',
            'fix: Adapt XLSX generation to new excel package API and temporarily disable mergeCells',
          ),
          _buildChangelogEntry(
            context,
            '4e22ececf9b37bc01345f2d7a66bcd91a4f4e8ba',
            'github-actions[bot]',
            '2025-07-12 16:30:31',
            'chore: Update pubspec.lock [skip ci]',
          ),
          _buildChangelogEntry(
            context,
            'a7a56eb8a5970ca6ad7779ad9a5548261a5634bf',
            'suvojit213',
            '2025-07-12 21:59:29',
            'fix: Update excel package version to resolve mergeCells error',
          ),
          _buildChangelogEntry(
            context,
            'c8b5c88f1494a8c35ee29e33fb5c6d6516ced61a',
            'suvojit213',
            '2025-07-12 21:54:15',
            'feat: Add date-wise filtering for PDF and XLSX downloads in History Screen',
          ),
          _buildChangelogEntry(
            context,
            'a48f25abfe2360497768a1e0d886ab0940f474e6',
            'suvojit213',
            '2025-07-12 21:26:07',
            'feat: Improve PDF report layout and readability',
          ),
          _buildChangelogEntry(
            context,
            '98bd1abf326a9951a36f1cecae6f285c6cd4e049',
            'github-actions[bot]',
            '2025-07-12 15:42:57',
            'chore: Update pubspec.lock [skip ci]',
          ),
          _buildChangelogEntry(
            context,
            'f04d7c7d4f9cca284c9d0a9ac44fcbdd6f48a7d0',
            'suvojit213',
            '2025-07-12 20:56:59',
            'feat: Ensure download button is always visible in HistoryScreen and fix key assignment.',
          ),
          _buildChangelogEntry(
            context,
            '9c991cd84e2fd673a0bcd0fd6a7995dd14abc0a6',
            'suvojit213',
            '2025-07-12 19:39:33',
            'feat: Move download functionality to history screen with date filtering',
          ),
          _buildChangelogEntry(
            context,
            'df97cd0f4dfb5fac6935c7bd35a25d341ef00978',
            'github-actions[bot]',
            '2025-07-12 13:44:00',
            'chore: Update pubspec.lock [skip ci]',
          ),
          _buildChangelogEntry(
            context,
            '5f954992ec31125733a86063fb6c5f9a733739b1',
            'suvojit213',
            '2025-07-12 19:13:10',
            'feat: Add PDF and CSV download functionality for issue reports',
          ),
        ],
      ),
    );
  }

  Widget _buildChangelogEntry(
    BuildContext context,
    String commitHash,
    String author,
    String date,
    String subject,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Author: $author',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Date: $date',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('$githubRepoUrl/commit/$commitHash');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                }
              },
              child: Text(
                'Commit: ${commitHash.substring(0, 7)}...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
