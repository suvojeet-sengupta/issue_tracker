import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png', // Specific logo for About App
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Issue Tracker App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const Text(
                    'Version 1.0.3',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const Text(
              'About the Issue Tracker App',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Issue Tracker App is a meticulously crafted, open-source solution designed to revolutionize how advisors manage and report issues within the DishTV/D2H ecosystem. Developed independently by Suvojeet, this application stands as a testament to innovative problem-solving, offering a streamlined and user-friendly alternative to traditional, lengthy form submissions.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bridging the Gap: Google Forms Integration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              """At its core, the Issue Tracker App seamlessly integrates with the existing Google Form-based issue tracking system previously utilized by DishTV/D2H. This intelligent integration eliminates the cumbersome manual entry process, automatically populating critical data fields within the Google Form. Advisors can now effortlessly record details such as CRM ID, full name, team leader, brand (DISH/D2H), issue type, and precise start and end times directly through the app's intuitive interface. This not only saves valuable time but also significantly reduces the potential for human error, ensuring data accuracy and consistency.""",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Features Designed for Efficiency:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            _buildMotivePoint('Intuitive User Interface', 'A clean, modern, and easy-to-navigate design ensures a smooth user experience for all advisors.'),
            _buildMotivePoint('Automated Data Pre-filling', 'Say goodbye to repetitive typing. The app intelligently pre-fills relevant information into the Google Form, including user details, organization preference, and current date.'),
            _buildMotivePoint('Dynamic Team Leader Selection', 'Easily select your team leader from a predefined list or add a new one, ensuring accurate reporting hierarchies.'),
            _buildMotivePoint('Precise Issue Timing', 'Accurately log the start and end times of issues with a user-friendly time picker, providing comprehensive data for analysis.'),
            _buildMotivePoint('Persistent Preferences', 'The app remembers your organization (DISH/D2H) and other key details, minimizing setup time for subsequent issue reports.'),
            _buildMotivePoint('In-App Webview', 'Experience a fully integrated workflow as the Google Form opens directly within the app, eliminating the need to switch between applications.'),
            const SizedBox(height: 24),
            const Text(
              'An Open-Source Initiative for the Community',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This Issue Tracker App is a proudly open-source project, built with the community in mind. It is not an official product of DishTV or D2H but rather a dedicated effort by Suvojeet to enhance the daily operations of advisors. Its open-source nature encourages transparency, collaboration, and continuous improvement, allowing for future enhancements and adaptations based on user feedback and evolving needs.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Developed by Suvojeet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              """This application is the result of Suvojeet's commitment to creating practical and efficient tools that empower users. It reflects a deep understanding of the challenges faced by advisors and a passion for leveraging technology to simplify complex processes.""",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                '© 2025 Issue Tracker App. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivePoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF3B82F6),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
