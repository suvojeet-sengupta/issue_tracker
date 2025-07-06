import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class OnboardingTour {
  final GlobalKey homeTabKey;
  final GlobalKey trackerTabKey;
  final GlobalKey historyTabKey;
  final GlobalKey settingsTabKey;
  final GlobalKey fillIssueButtonKey;

  OnboardingTour({
    required this.homeTabKey,
    required this.trackerTabKey,
    required this.historyTabKey,
    required this.settingsTabKey,
    required this.fillIssueButtonKey,
  });

  List<TargetFocus> _buildTargets() {
    List<TargetFocus> targets = [];

    // Target for Home tab
    targets.add(
      TargetFocus(
        keyTarget: homeTabKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Home Dashboard",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "This is your personalized dashboard. Here, you can view your Advisor Profile, track your total issues recorded, see daily issue counts, and get a breakdown of issue types. It provides a quick overview of your activity.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Target for Fill Issue Tracker button
    targets.add(
      TargetFocus(
        keyTarget: fillIssueButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Fill Issue Tracker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "This button is your gateway to logging new issues. Tap it to open the issue submission form where you can input all necessary details, including CRM ID, issue type, and a comprehensive explanation.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Target for Tracker tab
    targets.add(
      TargetFocus(
        keyTarget: trackerTabKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Issue Tracker Tab",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "This tab is dedicated to the active process of logging issues. Here, you will input all the necessary information for a new issue, ensuring accurate and complete records.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Target for History tab
    targets.add(
      TargetFocus(
        keyTarget: historyTabKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Issue History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "This section allows you to review all previously submitted issues. You can filter by date and time, and view detailed information for each entry, including attachments and a share option.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Target for Settings tab
    targets.add(
      TargetFocus(
        keyTarget: settingsTabKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Settings & Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "This section allows you to manage your personal information, including your CRM ID, Team Leader, and Advisor Name. You can also access administrative settings, view app information, and see the project credits.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return targets;
  }

  void show(BuildContext context) {
    TutorialCoachMark(
      targets: _buildTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("Onboarding tour finished");
        // Optionally mark onboarding as complete in SharedPreferences here
      },
      onClickTarget: (target) {
        print("onClickTarget: $target");
      },
      onClickOverlay: (target) {
        print("onClickOverlay: $target");
      },
      onSkip: () {
        print("Onboarding tour skipped");
        // Optionally mark onboarding as complete in SharedPreferences here
        return true; // Return true to indicate skip
      },
    ).show(context: context);
  }
}
