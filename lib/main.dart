import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/initial_setup_screen.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:issue_tracker_app/history_screen.dart';
import 'package:issue_tracker_app/developer_info_screen.dart';

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSetupComplete = prefs.containsKey("crmId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Updated seed color
          brightness: Brightness.light,
        ),
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Poppins', // Changed font family
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Changed to transparent
          elevation: 0,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22, // Increased font size
            fontWeight: FontWeight.bold, // Changed to bold
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: const Color(0xFF1E3A8A).withOpacity(0.3),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isSetupComplete ? const HomeScreen() : const InitialSetupScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/issue_tracker': (context) => const IssueTrackerScreen(),
        '/history': (context) => const HistoryScreen(),
        '/developer_info': (context) => const DeveloperInfoScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";
  late final AnimationController _animationController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Issue Tracker App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', // Added Poppins font
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.info_outline,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pushNamed(context, '/developer_info');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Hero Section with Logo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E3A8A),
                                    Color(0xFF3B82F6)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF1E3A8A),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.track_changes,
                                      size: 50,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Track and manage your issues with precision',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // User Information Card with Enhanced Design
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E3A8A),
                                        Color(0xFF3B82F6)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'User Profile',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                    fontFamily: 'Poppins', // Added Poppins font
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildEnhancedInfoRow(
                                Icons.badge_outlined, 'CRM ID', _crmId),
                            const SizedBox(height: 16),
                            _buildEnhancedInfoRow(
                                Icons.supervisor_account_outlined,
                                'Team Leader',
                                _tlName),
                            const SizedBox(height: 16),
                            _buildEnhancedInfoRow(Icons.person_outline,
                                'Advisor Name', _advisorName),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Quick Actions Section
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        fontFamily: 'Poppins', // Added Poppins font
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildEnhancedActionCard(
                      icon: Icons.add_task_rounded,
                      title: 'Fill Issue Tracker',
                      subtitle:
                          'Record a new issue with precise timing details',
                      onTap: () {
                        Navigator.pushNamed(context, '/issue_tracker');
                      },
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildEnhancedActionCard(
                      icon: Icons.history_rounded,
                      title: 'View History',
                      subtitle:
                          'Browse and manage your previously recorded issues',
                      onTap: () {
                        Navigator.pushNamed(context, '/history');
                      },
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed background color
        borderRadius: BorderRadius.circular(12), // Slightly smaller radius
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1, // Slightly thinner border
        ),
        boxShadow: const [ // Added subtle shadow
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3B82F6), // Changed icon color
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, // Changed background color
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                          fontFamily: 'Poppins', // Added Poppins font
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins', // Added Poppins font
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC), // Changed background color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 16,
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
