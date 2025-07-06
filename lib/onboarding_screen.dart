import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/initial_setup_screen.dart'; // Assuming this is the next screen after onboarding/setup

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageContent() {
    return [
      _buildOnboardingPage(
        image: 'assets/images/app_logo.png', // Placeholder image
        title: 'Welcome to Issue Tracker!',
        description: "Your ultimate tool for tracking and managing issues efficiently. Let's get you started!",
      ),
      _buildOnboardingPage(
        image: 'assets/images/app_launcher_icon.png', // Placeholder image
        title: 'Effortless Issue Submission',
        description: "Tap the 'Fill Issue Tracker' button to open the form. Provide details like CRM ID, issue type, and explanation.",
      ),
      _buildOnboardingPage(
        image: 'assets/images/developer_profile.jpg', // Placeholder image
        title: 'Track Your Progress',
        description: "The 'History' tab shows all your submitted issues. The 'Home' dashboard provides analytics on your activity.",
      ),
      _buildOnboardingPage(
        image: 'assets/images/app_logo.png', // Placeholder image
        title: 'Personalize Your Experience',
        description: "In 'Settings', you can update your profile (CRM ID, TL Name, Advisor Name) and customize app themes.",
        isLastPage: true,
      ),
    ];
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
    bool isLastPage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 200),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 40),
          if (isLastPage)
            ElevatedButton(
              onPressed: _onDoneButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onDoneButtonPressed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const InitialSetupScreen(), // Navigate to initial setup or main app
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _buildPageContent(),
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _buildPageContent().length,
                (index) => _buildDot(index: index),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: _currentPage < _buildPageContent().length - 1
                ? FloatingActionButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    backgroundColor: const Color(0xFF3B82F6),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  )
                : Container(),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: _currentPage > 0 && _currentPage < _buildPageContent().length - 1
                ? FloatingActionButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    backgroundColor: const Color(0xFF3B82F6),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 10.0,
      width: _currentPage == index ? 24.0 : 10.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF3B82F6) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
