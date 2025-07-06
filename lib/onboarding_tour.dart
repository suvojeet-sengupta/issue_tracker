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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Home Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This is your main dashboard. Here you can see your CRM ID, Team Leader, Advisor Name, and a summary of your issue activity.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Fill Issue Tracker",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Tap this button to log a new issue. You'll fill out details like the CRM ID, issue type, and a detailed explanation.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Issue Tracker Tab",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "This tab is where you actively fill out and submit new issues. It's the core of the app's functionality.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Issue History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Review all the issues you've submitted here. You can see past entries and their details.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Settings & Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Manage your personal information, team leader details, and app preferences in this section.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
      },
    ).show(context: context);
  }
}
