# Issue Tracker App

Welcome to the Issue Tracker App! This Flutter application is designed to streamline the process of logging and tracking issues, integrating seamlessly with Google Forms for detailed record-keeping. It's built to be user-friendly and efficient for advisors and team leaders.

## Features

This application comes packed with features to enhance your issue tracking workflow:

*   **User Information Management:** Easily input and manage your CRM ID, Advisor Name, and Team Leader (TL) Name. Your preferences are saved for future use.
*   **Dynamic Team Leader Selection:** Choose from a predefined list of Team Leaders or specify an 'Other' TL name if yours isn't listed.
*   **Issue Timing:** Accurately record the start and end times of issues using an intuitive time picker.
*   **Persistent Organization Preference:** Select your organization (DISH or D2H) once, and the app will remember your choice, automatically pre-filling it in the Google Form.
*   **Automated Date Pre-fill:** The current date is automatically fetched and pre-filled for both issue start and end dates in the Google Form, saving you time and ensuring accuracy.
*   **Seamless Google Form Integration:** All collected issue details are automatically pre-filled into a designated Google Form, eliminating manual data entry and reducing errors.
*   **In-App Webview for Google Form:** The Google Form opens directly within the application using a built-in webview, providing a smooth and integrated user experience without needing to switch to an external browser.
*   **Intuitive User Interface:** A clean and modern UI designed for ease of use.

## Getting Started

Follow these steps to get the Issue Tracker App up and running on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:

*   **Flutter SDK:** [Install Flutter](https://flutter.dev/docs/get-started/install)
*   **Android Studio / VS Code:** With Flutter and Dart plugins installed.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/suvojit213/issue_tracker.git
    cd issue_tracker
    ```

2.  **Install Dependencies:**
    Add the `webview_flutter` dependency to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter

      cupertino_icons: ^1.0.8
      shared_preferences: ^2.0.15
      url_launcher: ^6.1.10
      webview_flutter: ^4.0.5 # Add this line
    ```
    Then, run:
    ```bash
    flutter pub get
    ```

3.  **Configure Android Permissions:**
    Open `android/app/src/main/AndroidManifest.xml` and ensure the internet permission is included inside the `<manifest>` tag, before the `<application>` tag:

    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        <uses-permission android:name="android.permission.INTERNET"/>
        <application
            ...
        </application>
    </manifest>
    ```

### Running the App

1.  **Connect a device or start an emulator.**
2.  **Run the app:**
    ```bash
    flutter run
    ```

## Usage

1.  **Initial Setup:** On first launch, you will be guided through an initial setup where you can enter your CRM ID, Advisor Name, Team Leader, and select your Organization (DISH/D2H).
2.  **Issue Tracking:** Once set up, you can record issue start and end times.
3.  **Submit and Open Form:** After entering the times, click the 


`Submit Issue and Open Form` button. This will automatically pre-fill the Google Form with the collected data and open it within the app for any additional details.

## Project Structure

```
issue_tracker/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── initial_setup_screen.dart
│   ├── issue_tracker_screen.dart
│   └── google_form_webview_screen.dart
├── pubspec.yaml
├── README.md
└── ... (other Flutter files and folders)
```

*   `lib/main.dart`: Entry point of the Flutter application.
*   `lib/initial_setup_screen.dart`: Handles the initial user setup, including CRM ID, Advisor Name, Team Leader, and Organization selection.
*   `lib/issue_tracker_screen.dart`: The main screen for tracking issues, selecting times, and triggering the Google Form pre-fill.
*   `lib/google_form_webview_screen.dart`: A new screen that embeds a webview to display the Google Form directly within the app.

## Google Form Configuration

The app is configured to pre-fill a specific Google Form. The `entry` IDs used in `issue_tracker_screen.dart` correspond to the fields in your Google Form. If you use a different Google Form, you will need to update these `entry` IDs accordingly.

**Current Entry IDs Used:**

*   `entry.1005447471`: CRM ID
*   `entry.44222229`: Advisor Name
*   `entry.1521239602_hour`: Issue Start Time (Hour)
*   `entry.1521239602_minute`: Issue Start Time (Minute)
*   `entry.701130970_hour`: Issue End Time (Hour)
*   `entry.701130970_minute`: Issue End Time (Minute)
*   `entry.115861300`: TL Name
*   `entry.313975949`: Organization (DISH/D2H)
*   `entry.702818104_year`: Issue Start Date (Year)
*   `entry.702818104_month`: Issue Start Date (Month)
*   `entry.702818104_day`: Issue Start Date (Day)
*   `entry.514450388_year`: Issue End Date (Year)
*   `entry.514450388_month`: Issue End Date (Month)
*   `entry.514450388_day`: Issue End Date (Day)

## Developed by Suvojeet

This application was developed by Suvojeet to provide an efficient and user-friendly solution for issue tracking and Google Form integration.


