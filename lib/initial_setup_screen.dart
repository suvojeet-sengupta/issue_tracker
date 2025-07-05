import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  _InitialSetupScreenState createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen>
    with TickerProviderStateMixin {
  final _crmIdController = TextEditingController();
  final _advisorNameController = TextEditingController();
  String _selectedTlName = 'Manish Kumar';
  bool _showOtherTlNameField = false;
  final _otherTlNameController = TextEditingController();
  String _selectedOrganization = 'DISH';

  late AnimationController _animationController;
  late AnimationController _buttonController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _buttonScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonController.dispose();
    _crmIdController.dispose();
    _advisorNameController.dispose();
    _otherTlNameController.dispose();
    super.dispose();
  }

  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _crmIdController.text = prefs.getString("crmId") ?? '';
      _advisorNameController.text = prefs.getString("advisorName") ?? '';
      _selectedTlName = prefs.getString("tlName") ?? 'Manish Kumar';
      if (_selectedTlName == 'Other') {
        _showOtherTlNameField = true;
        _otherTlNameController.text = prefs.getString("otherTlName") ?? '';
      }
      _selectedOrganization = prefs.getString("organization") ?? "DISH";
    });
  }

  bool _isFormValid() {
    return _crmIdController.text.isNotEmpty &&
        _advisorNameController.text.isNotEmpty &&
        (_selectedTlName != 'Other' || _otherTlNameController.text.isNotEmpty);
  }

  _saveData() async {
    final crmId = _crmIdController.text;
    final advisorName = _advisorNameController.text;
    final tlName = _selectedTlName;
    final otherTlName = _otherTlNameController.text;

    if (advisorName.isEmpty || (tlName == 'Other' && otherTlName.isEmpty)) {
      _showErrorSnackbar('Please fill in all required fields');
      return;
    }

    if (crmId.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(crmId)) {
      _showErrorSnackbar('CRM ID must contain only digits');
      return;
    }

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('crmId', crmId);
    await prefs.setString('advisorName', advisorName);
    await prefs.setString("tlName", tlName);
    if (_showOtherTlNameField) {
      await prefs.setString("otherTlName", otherTlName);
    } else {
      await prefs.remove("otherTlName");
    }
    await prefs.setString("organization", _selectedOrganization);

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
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
            stops: [0.0, 0.4, 1.0],
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
                    const SizedBox(height: 20),

                    // Welcome Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
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
                                    Icons.track_changes_rounded,
                                    size: 50,
                                    color: Color(0xFF1E3A8A),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome to',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Issue Tracker App',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Let's set up your profile to get started',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins', // Added Poppins font
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Setup Form
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
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
                                    Icons.person_add_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Profile Setup',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                    fontFamily: 'Poppins', // Added Poppins font
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // CRM ID Field
                            _buildEnhancedTextField(
                              controller: _crmIdController,
                              label: 'CRM ID',
                              icon: Icons.badge_outlined,
                              hint: 'Enter your CRM ID',
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 20),

                            // Advisor Name Field
                            _buildEnhancedTextField(
                              controller: _advisorNameController,
                              label: 'Advisor Name',
                              icon: Icons.person_outline,
                              hint: 'Enter your advisor name',
                            ),

                            const SizedBox(height: 20),

                            // Team Leader Dropdown
                            _buildTeamLeaderDropdown(),

                            // Other TL Name Field (conditional)
                            if (_showOtherTlNameField) ...[
                              const SizedBox(height: 20),
                              _buildEnhancedTextField(
                                controller: _otherTlNameController,
                                label: 'Other Team Leader Name',
                                icon: Icons.supervisor_account_outlined,
                                hint: 'Enter team leader name',
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Organization Dropdown
                            _buildOrganizationDropdown(),

                            const SizedBox(height: 32),

                            // Save Button
                            ScaleTransition(
                              scale: _buttonScale,
                              child: Container(
                                width: double.infinity,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: _isFormValid()
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF1E3A8A),
                                            Color(0xFF3B82F6)
                                          ],
                                        )
                                      : null,
                                  color:
                                      _isFormValid() ? null : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: _isFormValid()
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF1E3A8A)
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _isFormValid() ? _saveData : null,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 24,
                                            color: _isFormValid()
                                                ? Colors.white
                                                : Colors.grey[600],
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Complete Setup',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: _isFormValid()
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Changed background color
            borderRadius: BorderRadius.circular(12), // Slightly smaller radius
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1, // Slightly thinner border
            ),
            boxShadow: [ // Added subtle shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) => setState(() {}),
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Padding( // Changed to Padding for better spacing
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: const Color(0xFF3B82F6), // Changed icon color
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Adjusted padding
              hintStyle: TextStyle(
                color: Colors.grey[400], // Lighter hint color
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins', // Added Poppins font
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500, // Slightly lighter font weight
              color: Color(0xFF1E3A8A),
              fontFamily: 'Poppins', // Added Poppins font
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLeaderDropdown() {
    List<String> tlOptions = [
      'Manish Kumar',
      'Aniket',
      'Imran Khan',
      'Ravi',
      'Gajendra',
      'Suyash Upadhyay',
      'Randhir Kumar',
      'Subham Kumar',
      'Karan',
      'Rohit',
      'Shilpa',
      'Vipin',
      'Sonu',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Leader',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding
          decoration: BoxDecoration(
            color: Colors.white, // Changed background color
            borderRadius: BorderRadius.circular(12), // Slightly smaller radius
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1, // Slightly thinner border
            ),
            boxShadow: [ // Added subtle shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedTlName,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding( // Changed to Padding for better spacing
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.supervisor_account_outlined,
                  color: Color(0xFF3B82F6), // Changed icon color
                  size: 20,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Adjusted padding
            ),
            items: tlOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Slightly lighter font weight
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedTlName = newValue!;
                _showOtherTlNameField = newValue == 'Other';
                if (!_showOtherTlNameField) {
                  _otherTlNameController.clear();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationDropdown() {
    List<String> orgOptions = ['DISH', 'D2H'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Organization',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
            fontFamily: 'Poppins', // Added Poppins font
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding
          decoration: BoxDecoration(
            color: Colors.white, // Changed background color
            borderRadius: BorderRadius.circular(12), // Slightly smaller radius
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1, // Slightly thinner border
            ),
            boxShadow: [ // Added subtle shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedOrganization,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding( // Changed to Padding for better spacing
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFF3B82F6), // Changed icon color
                  size: 20,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Adjusted padding
            ),
            items: orgOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Slightly lighter font weight
                    color: Color(0xFF1E3A8A),
                    fontFamily: 'Poppins', // Added Poppins font
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOrganization = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
