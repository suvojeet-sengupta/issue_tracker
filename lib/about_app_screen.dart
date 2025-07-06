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
                    'assets/icon/app_icon_foreground.png', // Your app logo
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
                    'Version 1.0.1', // Replace with dynamic version if available
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
              'Our Motive',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The Issue Tracker App is designed to streamline the process of logging, tracking, and managing issues within a team or personal workflow. Our primary motive is to provide a simple, efficient, and intuitive platform that helps users:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildMotivePoint('Enhance Productivity', 'By offering a quick and easy way to report and categorize issues, we aim to reduce friction in your daily tasks.'),
            _buildMotivePoint('Improve Accountability', 'Clearly assign and track issues to ensure nothing falls through the cracks, fostering a sense of responsibility.'),
            _buildMotivePoint('Gain Insights', 'With built-in history and analytics, understand your issue patterns and improve your problem-solving strategies over time.'),
            _buildMotivePoint('Simplify Collaboration', 'Though currently focused on individual tracking, future updates will aim to facilitate seamless team collaboration on issues.'),
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
