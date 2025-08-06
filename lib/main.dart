import 'dart:convert'; // Added for JSON encoding/decoding
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:issue_tracker_app/initial_setup_screen.dart';
import 'package:issue_tracker_app/issue_tracker_screen.dart';
import 'package:issue_tracker_app/history_screen.dart';
import 'package:issue_tracker_app/splash_screen.dart'; // New import for splash screen
import 'package:issue_tracker_app/onboarding_tour.dart'; // Import the new onboarding tour
import 'package:issue_tracker_app/theme_notifier.dart';

import 'package:issue_tracker_app/edit_profile_screen.dart';
import 'package:issue_tracker_app/notification_history_screen.dart';

import 'package:issue_tracker_app/settings_screen.dart';
import 'package:issue_tracker_app/developer_info_screen.dart';
import 'package:issue_tracker_app/theme.dart';
import 'package:issue_tracker_app/utils/issue_parser.dart'; // New import for issue parsing utility
import 'package:issue_tracker_app/logger_service.dart'; // New import for logging service
import 'firebase_options.dart';

// Helper function to save notifications to SharedPreferences
Future<void> _saveNotificationToHistory(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> notificationHistory = prefs.getStringList('notificationHistory') ?? [];

  final notificationData = {
    'title': message.notification?.title ?? 'No Title',
    'body': message.notification?.body ?? 'No Body',
    'timestamp': DateTime.now().toIso8601String(),
    'data': message.data, // Include data payload if any
    'isRead': false, // New notifications are unread
  };
  notificationHistory.add(jsonEncode(notificationData));
  await prefs.setStringList('notificationHistory', notificationHistory);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _saveNotificationToHistory(message);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await LoggerService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
     
    _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      _saveNotificationToHistory(message); // Save foreground notifications
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Issue Tracker App',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(), // Set SplashScreen as the initial home
          routes: {
            '/home': (context) => const MainAppScreen(),
            '/issue_tracker': (context) => const IssueTrackerScreen(),
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/edit_profile': (context) => const EditProfileScreen(),
          },
        );
      },
    );
  }
}



class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // GlobalKeys for onboarding tour
  final GlobalKey _homeTabKey = GlobalKey();
  final GlobalKey _trackerTabKey = GlobalKey();
  final GlobalKey _historyTabKey = GlobalKey();
  final GlobalKey _settingsTabKey = GlobalKey();
  final GlobalKey _fillIssueButtonKey = GlobalKey();
  final GlobalKey _notificationIconKey = GlobalKey();

  late AnimationController _bottomBarAnimationController;
  late Animation<Offset> _bottomBarSlideAnimation;


  List<Widget> get _widgetOptions => <Widget>[
        DashboardScreen(fillIssueButtonKey: _fillIssueButtonKey, notificationIconKey: _notificationIconKey), // Pass the key to DashboardScreen
        const IssueTrackerScreen(),
        const HistoryScreen(),
        const SettingsScreen(), // Settings screen is now part of bottom nav
      ];

  @override
  void initState() {
    super.initState();
    _checkAndShowOnboardingTour();
    _bottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bottomBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bottomBarAnimationController,
      curve: Curves.easeOutBack,
    ));
    _bottomBarAnimationController.forward();
  }

  _checkAndShowOnboardingTour() async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingComplete = prefs.getBool('interactive_onboarding_complete') ?? false;

    if (!onboardingComplete) {
      // Delay showing the tour until the UI is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        OnboardingTour onboardingTour = OnboardingTour(
          homeTabKey: _homeTabKey,
          trackerTabKey: _trackerTabKey,
          historyTabKey: _historyTabKey,
          settingsTabKey: _settingsTabKey,
          fillIssueButtonKey: _fillIssueButtonKey,
          notificationIconKey: _notificationIconKey,
        );
        onboardingTour.show(context);
        prefs.setBool('interactive_onboarding_complete', true);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SlideTransition(
        position: _bottomBarSlideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16), // Shifted upward
          child: Container(
            height: 60, // Explicitly set height for a more compact look
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8), // Subtle transparency
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    key: _homeTabKey, // Assign key
                    icon: const Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    key: _trackerTabKey, // Assign key
                    icon: const Icon(Icons.add_task_rounded),
                    label: 'Tracker',
                  ),
                  BottomNavigationBarItem(
                    key: _historyTabKey, // Assign key
                    icon: const Icon(Icons.history_rounded),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    key: _settingsTabKey, // Assign key
                    icon: const Icon(Icons.settings_rounded),
                    label: 'Settings',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent, // Make it transparent to show container's color
                elevation: 0, // Remove default elevation
                selectedFontSize: 12, // Adjust font size for compactness
                unselectedFontSize: 12, // Adjust font size for compactness
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final Key? fillIssueButtonKey;
  final Key? notificationIconKey;
  const DashboardScreen({super.key, this.fillIssueButtonKey, this.notificationIconKey});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  String _crmId = "";
  String _tlName = "";
  String _advisorName = "";
  bool _isLoading = true; // Added loading state
  int _totalIssues = 0;
  Map<String, int> _issuesPerDay = {};
  Map<String, int> _issueTypeBreakdown = {};
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late ScrollController _scrollController; // Added ScrollController
  int _unreadNotificationCount = 0;
  static const platform = MethodChannel('com.suvojeet.issue_tracker_app/notifications');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _loadAnalyticsData(); // Load analytics data
    _getUnreadNotificationCount();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
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
    _animationController.forward();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getUnreadNotificationCount();
    }
  }

  Future<void> _getUnreadNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = prefs.getStringList('notificationHistory') ?? [];
    int unreadCount = 0;
    for (String notificationJson in historyStrings) {
      try {
        Map<String, dynamic> notificationData = jsonDecode(notificationJson);
        if (notificationData['isRead'] == false) {
          unreadCount++;
        }
      } catch (e) {
        print("Error decoding notification JSON: $e");
      }
    }
    setState(() {
      _unreadNotificationCount = unreadCount;
    });
  }

  

  _loadUserData() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _crmId = prefs.getString("crmId") ?? "";
      _tlName = prefs.getString("tlName") ?? "";
      if (_tlName == "Other") {
        _tlName = prefs.getString("otherTlName") ?? "";
      }
      _advisorName = prefs.getString("advisorName") ?? "";
      _isLoading = false; // Set loading to false after data is loaded
    });
  }

  _loadAnalyticsData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> rawIssueHistory = prefs.getStringList("issueHistory") ?? [];
    List<Map<String, String>> issueHistory = rawIssueHistory.map((entry) => parseHistoryEntry(entry)).toList();

    int total = issueHistory.length;
    Map<String, int> issuesPerDay = {};
    Map<String, int> issueTypeBreakdown = {};

    for (Map<String, String> entry in issueHistory) {
      String? fillTime = entry['Fill Time'];
      String? issueType = entry['Issue Explanation'];

      if (fillTime != null) {
        DateTime date = DateTime.parse(fillTime);
        String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        issuesPerDay.update(formattedDate, (value) => value + 1, ifAbsent: () => 1);
      }

      if (issueType != null) {
        issueTypeBreakdown.update(issueType, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    setState(() {
      _totalIssues = total;
      _issuesPerDay = issuesPerDay;
      _issueTypeBreakdown = issueTypeBreakdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_slideAnimation),
                    child: SingleChildScrollView(
                      controller: _scrollController, // Assign the scroll controller
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom App Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Issue Tracker App',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.info_outline_rounded,
                                    color: Theme.of(context).colorScheme.onSurface),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DeveloperInfoScreen()),
                                  );
                                },
                              ),
                              Stack(
                                children: [
                                  IconButton(
                                    key: widget.notificationIconKey,
                                    icon: Icon(Icons.notifications_active_outlined,
                                        color: Theme.of(context).colorScheme.onSurface),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationHistoryScreen()),
                                      );
                                      _getUnreadNotificationCount(); // Refresh count after returning
                                    },
                                  ),
                                  if (_unreadNotificationCount > 0)
                                    Positioned(
                                      right: 11,
                                      top: 11,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          '$_unreadNotificationCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Hero Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Welcome Back, ${_advisorName.split(" ").first}!',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Track and manage your issues with precision',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Advisor Information Card with Enhanced Design
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context).primaryColor.withOpacity(0.8)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.person_outline,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Advisor Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildInfoRow(
                                      Icons.badge_outlined, 'CRM ID', _crmId),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                      Icons.supervisor_account_outlined,
                                      'Team Leader',
                                      _tlName),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(Icons.person_outline,
                                      'Advisor Name', _advisorName),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final result = await Navigator.pushNamed(
                                            context, '/edit_profile');
                                        if (result == true) {
                                          _loadUserData(); // Reload data if profile was updated
                                        }
                                      },
                                      icon: const Icon(Icons.edit_rounded,
                                          color: Colors.white),
                                      label: const Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 3,
                                        shadowColor: Theme.of(context).primaryColor
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Analytics Section
                          if (_totalIssues > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Activity',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildAnalyticsCard(
                                  title: 'Total Issues Recorded',
                                  value: '$_totalIssues',
                                  icon: Icons.task_alt_rounded,
                                  color: const Color(0xFF059669),
                                ),
                                const SizedBox(height: 16),
                                _buildAnalyticsCard(
                                  title: 'Issues Today',
                                  value: '${_issuesPerDay[DateTime.now().toString().substring(0, 10)] ?? 0}',
                                  icon: Icons.calendar_today_rounded,
                                  color: const Color(0xFF3B82F6),
                                ),
                                const SizedBox(height: 16),
                                if (_issueTypeBreakdown.isNotEmpty)
                                  _buildIssueTypeBreakdownCard(),
                                const SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: _FabExtensionButton(
        scrollController: _scrollController,
        fillIssueButtonKey: widget.fillIssueButtonKey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssueTypeBreakdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue Type Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          ..._issueTypeBreakdown.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _FabExtensionButton extends StatefulWidget {
  final ScrollController scrollController;
  final Key? fillIssueButtonKey;

  const _FabExtensionButton({
    required this.scrollController,
    this.fillIssueButtonKey,
  });

  @override
  State<_FabExtensionButton> createState() => _FabExtensionButtonState();
}

class _FabExtensionButtonState extends State<_FabExtensionButton> {
  bool _isFabExtended = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 0 && _isFabExtended) {
        setState(() {
          _isFabExtended = false;
        });
      } else if (widget.scrollController.offset <= 0 && !_isFabExtended) {
        setState(() {
          _isFabExtended = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
      child: _isFabExtended
          ? FloatingActionButton.extended(
              key: widget.fillIssueButtonKey,
              onPressed: () {
                Navigator.pushNamed(context, '/issue_tracker');
              },
              label: const Text('Fill Issue Tracker'),
              icon: const Icon(Icons.add_task_rounded),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            )
          : FloatingActionButton(
              key: widget.fillIssueButtonKey,
              onPressed: () {
                Navigator.pushNamed(context, '/issue_tracker');
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              child: const Icon(Icons.add_task_rounded),
            ),
    );
  }
}
