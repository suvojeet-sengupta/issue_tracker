import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HistoryOnboardingTour {
  final GlobalKey? firstHistoryItemKey;
  final GlobalKey dateFilterButtonKey;
  final GlobalKey startTimeFilterButtonKey;
  final GlobalKey endTimeFilterButtonKey;
  final GlobalKey clearHistoryButtonKey;

  HistoryOnboardingTour({
    this.firstHistoryItemKey,
    required this.dateFilterButtonKey,
    required this.startTimeFilterButtonKey,
    required this.endTimeFilterButtonKey,
    required this.clearHistoryButtonKey,
  });

  List<TargetFocus> _buildTargets() {
    List<TargetFocus> targets = [];

    if (firstHistoryItemKey != null) {
      targets.add(
        TargetFocus(
          keyTarget: firstHistoryItemKey,
          alignSkip: Alignment.topRight,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.top, // Changed from .bottom to .top
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "View Issue Details",
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
                        "Click on any issue entry to view its complete details, including all recorded information, time stamps, and attached images.",
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
    }

    targets.add(
      TargetFocus(
        keyTarget: dateFilterButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Filter by Date",
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
                      "Use this button to select a specific date and filter your issue history. You can then refine your search using time filters.",
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

    targets.add(
      TargetFocus(
        keyTarget: startTimeFilterButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Filter by Start Time",
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
                      "After selecting a date, use this to filter issues by their start time. The app will also look for issues within a 15-minute proximity if an exact match isn't found.",
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

    targets.add(
      TargetFocus(
        keyTarget: endTimeFilterButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Filter by End Time",
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
                      "Refine your search further by filtering issues based on their end time. Similar to start time, it will find nearby issues if no exact match is present.",
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

    targets.add(
      TargetFocus(
        keyTarget: clearHistoryButtonKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Clear History",
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
                      "This button allows you to clear all your recorded issue history. Use with caution as this action cannot be undone.",
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
        print("History onboarding tour finished");
      },
      onClickTarget: (target) {
        print("onClickTarget: $target");
      },
      onClickOverlay: (target) {
        print("onClickOverlay: $target");
      },
      onSkip: () {
        print("History onboarding tour skipped");
        return true;
      },
    ).show(context: context);
  }
}
