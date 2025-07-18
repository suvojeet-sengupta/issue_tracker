import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/initial_setup_screen.dart';
import 'package:issue_tracker_app/main.dart'; // Import MainAppScreen

import 'package:issue_tracker_app/access_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward().whenComplete(() {
      _navigateToNextScreen();
    });
  }

  _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isAccessGranted = prefs.getBool('isAccessGranted') ?? false;
    final bool isSetupComplete = prefs.containsKey("crmId");

    if (mounted) {
      if (!isAccessGranted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AccessScreen()),
        );
      } else if (!isSetupComplete) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const InitialSetupScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainAppScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Use app's primary color for splash background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png', // Specific logo for splash screen
                  height: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Issue Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
