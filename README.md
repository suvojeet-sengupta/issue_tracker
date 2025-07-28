# 🚀 Issue Tracker App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)
[![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white)](https://kotlinlang.org/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://docs.github.com/en/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A robust and intuitive Flutter application designed to streamline the process of logging and tracking issues, seamlessly integrating with Google Forms for efficient data management. This app is built to enhance productivity for advisors and team leaders by automating data entry and providing a user-friendly interface.

---

## 🌟 Features

The Issue Tracker App is packed with functionalities designed for efficiency and a superior user experience:

-   **Automated Google Form Submission:** Automatically pre-fills and submits Google Forms, eliminating manual data entry and significantly reducing errors.
-   **Admin Notification Control:** Provides administrators with comprehensive control over in-app notifications, including enabling/disabling and setting custom reminder intervals.
-   **Secure & Consistent APK Signing:** Ensures seamless app updates without requiring prior uninstallation, maintaining signature consistency across all builds.
-   **User Profile Management:** Effortlessly input and manage CRM ID, Advisor Name, and Team Leader (TL) Name. Details are securely saved for quick access.
-   **Dynamic TL Selection:** Choose from a predefined list of Team Leaders or add an 'Other' TL name if not listed.
-   **Precise Issue Timing:** Accurately log the start and end times of issues using an intuitive time picker.
-   **Persistent Organization Preference:** The app intelligently remembers your organization (DISH or D2H) for auto-filling in subsequent Google Form submissions.
-   **Automated Date Pre-fill:** Current date is automatically fetched and pre-filled for issue start and end dates in the Google Form, enhancing accuracy and saving time.
-   **In-App Webview Experience:** Google Forms open directly within the application via a built-in webview, providing a smooth and uninterrupted user experience.
-   **Smart Auto-Scroll & Instruction:** The webview automatically scrolls to the submit button, with clear, visually appealing instructions for user guidance.
-   **Intelligent Submission Detection:** Accurately detects successful Google Form submissions by monitoring URL changes, providing instant feedback.
-   **Enhanced Back Navigation:** Smart navigation ensures seamless redirection to the home screen with a success message upon form submission, or a clear warning before exiting if not submitted.
-   **Intuitive & Modern UI:** Features a clean, modern, and highly responsive user interface designed for maximum ease of use and visual appeal.
-   **Automated Name Pre-fill in Feedback:** Your advisor name is automatically fetched and pre-filled in the feedback section for convenience.
-   **Comprehensive Changelog:** An in-app changelog screen provides a detailed history of updates, features, and bug fixes.
-   **Accurate Time Logging with NTP:** Utilizes the Network Time Protocol (NTP) to fetch precise internet time, ensuring that all issue logs are timestamped with maximum accuracy, independent of device time settings.

---

## 🛠️ Technologies Used

## 📱 Native Integrations

The app leverages native Android capabilities for robust notification management and background task scheduling:

-   **Kotlin WorkManager**: Utilized for efficient and reliable scheduling of daily notifications (`DailySchedulerWorker.kt`, `NotificationWorker.kt`).
-   **Platform Channels**: Custom platform channels (`MainActivity.kt`, `NotificationHelper.kt`) are used to communicate between Flutter and native Android code for scheduling, canceling, and managing notification states, ensuring seamless integration and control over system notifications.

-   **Flutter:** UI Toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
-   **Dart:** Programming language optimized for UI.
-   **Kotlin:** For native Android functionalities and WorkManager integration.
-   **`webview_flutter`:** For embedding web content (Google Forms) within the app.
-   **`shared_preferences`:** For lightweight, persistent key-value storage.
-   **`url_launcher`:** For launching URLs.
-   **`provider`:** For state management.
-   **`image_picker`:** For picking images from the gallery or camera.
-   **`path_provider`:** For accessing file system paths.
-   **`share_plus`:** For sharing content from the app.
-   **`pdf` & `excel`:** For generating reports.
-   **`flutter_local_notifications`:** For handling local notifications.
-   **`lottie`:** For displaying high-quality animations.
-   **`tutorial_coach_mark`:** For interactive onboarding tours.
-   **`flutter_launcher_icons`:** For managing app icons.
-   **`change_app_package_name`:** For easily changing the app's package name.
-   **GitHub Actions:** For Continuous Integration and automated APK builds.

---

## 🚀 Getting Started

Follow these steps to get the Issue Tracker App up and running on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:

-   **Flutter SDK:** [Install Flutter](https://flutter.dev/docs/get-started/install)
-   **Android Studio / VS Code:** With the official Flutter and Dart plugins installed.
-   **Java Development Kit (JDK):** Required for Android development.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/suvojit213/issue_tracker.git
    cd issue_tracker
    ```

2.  **Install Dependencies:**

    Ensure all necessary packages are installed by running:

    ```bash
    flutter pub get
    ```

3.  **Configure Android Permissions:**

    Open `android/app/src/main/AndroidManifest.xml` and verify that the internet permission is included inside the `<manifest>` tag, *before* the `<application>` tag:

    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">
        <uses-permission android:name="android.permission.INTERNET"/>
        <!-- Add other necessary permissions here, e.g., for notifications -->
        <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
        <application
            android:label="issue_tracker_app"
            android:name="${applicationName}"
            android:icon="@mipmap/ic_launcher">
            <!-- ... other application settings ... -->
        </application>
    </manifest>
    ```

4.  **Generate a Keystore (for Release Builds):**

    To sign your Android APKs consistently, generate a keystore. **Keep this file and its passwords secure.**

    ```bash
    keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias <your-key-alias>
    ```
    Replace `<your-key-alias>` with your desired alias (e.g., `mykey`). Remember the keystore password and key password.

5.  **Configure `key.properties`:**

    Create a file named `key.properties` in the `android/` directory (at the same level as `build.gradle.kts`) with the following content, replacing placeholders with your actual keystore details:

    ```properties
    storePassword=<YOUR_KEYSTORE_PASSWORD>
    keyPassword=<YOUR_KEY_PASSWORD>
    keyAlias=<YOUR_KEY_ALIAS>
    storeFile=<PATH_TO_YOUR_KEYSTORE_FILE>/keystore.jks
    ```
    **Important:** Ensure `key.properties` is added to your `.gitignore` to prevent it from being committed to version control.

6.  **Set up GitHub Secrets (for CI/CD):**

    For automated builds via GitHub Actions, you need to securely store your keystore and passwords as repository secrets.
    -   Base64 encode your `keystore.jks` file: `base64 keystore.jks`
    -   In your GitHub repository, go to `Settings` > `Secrets and variables` > `Actions` and add the following secrets:
        -   `KEYSTORE_BASE64`: Paste the base64 encoded string.
        -   `KEY_ALIAS`: Your key alias (e.g., `mykey`).
        -   `KEY_PASSWORD`: Your key password.
        -   `STORE_PASSWORD`: Your keystore password.

### Running the App

1.  **Connect a device or start an emulator.**
2.  **Run the app:**

    ```bash
    flutter run
    ```

### Running Tests

To execute the project's tests, run the following command in your terminal:

```bash
flutter test
```

---

## 💡 Usage

1.  **Initial Setup:** On first launch, complete a quick setup by entering your CRM ID, Advisor Name, Team Leader, and Organization. These details are saved for future use.
2.  **Issue Tracking:** From the main screen, record issue start and end times.
3.  **Automated Submission:** Tap "Submit Issue and Open Form". The app pre-fills the Google Form, opens it in a webview, and automatically submits it.
4.  **Notification Settings:** Access Admin Settings to enable/disable notifications and customize their frequency.
5.  **Feedback:** Provide feedback via the dedicated section, with your name pre-filled for convenience.

---

## 📂 Project Structure

```
issue_tracker/
├── android/                  # Android specific files (Kotlin source, Gradle configs)
├── assets/                   # Application assets (fonts, images, icons)
│   ├── fonts/
│   ├── icon/
│   └── images/
├── lib/                      # Core application source code (Dart)
│   ├── about_app_screen.dart
│   ├── admin_settings_screen.dart    # Admin settings including notification controls
│   ├── changelog_screen.dart         # In-app changelog display
│   ├── credits_screen.dart
│   ├── developer_info_screen.dart
│   ├── edit_profile_screen.dart
│   ├── feedback_screen.dart          # Feedback screen with auto-filled name
│   ├── google_form_webview_screen.dart # Handles Google Form display and automated submission
│   ├── history_onboarding_tour.dart
│   ├── history_screen.dart
│   ├── initial_setup_screen.dart     # Initial user setup
│   ├── issue_detail_screen.dart
│   ├── issue_tracker_screen.dart     # Main issue tracking screen
│   ├── main.dart                     # Application entry point and notification initialization
│   ├── notification_history_screen.dart # Displays history of notifications
│   ├── notification_settings_screen.dart # New screen for notification preferences
│   ├── ntp_time.dart                 # Fetches accurate time from NTP servers
│   ├── onboarding_tour.dart
│   ├── report_generator.dart         # Logic for generating PDF/XLSX reports
│   ├── settings_screen.dart
│   ├── splash_screen.dart
│   ├── theme_notifier.dart
│   ├── theme.dart
│   └── utils/
│       └── issue_parser.dart         # Utility for parsing issue data (candidate for refactoring)
├── test/                     # Unit and widget tests
├── .github/                  # GitHub Actions workflows for CI/CD
│   └── workflows/
│       └── flutter_apk_build.yml # Workflow for building and signing APK
├── .gitignore                # Files and directories to ignore in Git
├── pubspec.yaml              # Project dependencies and metadata
└── README.md                 # This documentation file
```

---

## 🔗 Google Form Integration Details

The app is configured to pre-fill a specific Google Form. The `entry` IDs used within `lib/issue_tracker_screen.dart` are crucial as they directly correspond to the fields in your Google Form. If you intend to use a different Google Form, you **must** update these `entry` IDs accordingly to ensure proper data mapping.

**Current Google Form Entry IDs Used:**

| Field Name             | Entry ID             | Description                                     |
| :--------------------- | :------------------- | :---------------------------------------------- |
| CRM ID                 | `entry.1005447471`   | Unique identifier for the customer relationship. |
| Advisor Name           | `entry.44222229`     | Name of the advisor reporting the issue.        |
| Issue Start Time (Hour)| `entry.1521239602_hour`| Hour component of when the issue began.         |
| Issue Start Time (Minute)| `entry.1521239602_minute`| Minute component of when the issue began.       |
| Issue End Time (Hour)  | `entry.701130970_hour` | Hour component of when the issue concluded.     |
| Issue End Time (Minute)| `entry.701130970_minute`| Minute component of when the issue concluded.   |
| TL Name                | `entry.115861300`    | Name of the Team Leader.                        |
| Organization           | `entry.313975949`    | The organization (e.g., DISH, D2H).             |
| Issue Start Date (Year)| `entry.702818104_year`| Year component of the issue start date.         |
| Issue Start Date (Month)| `entry.702818104_month`| Month component of the issue start date.        |
| Issue Start Date (Day) | `entry.702818104_day`| Day component of the issue start date.          |
| Issue End Date (Year)  | `entry.514450388_year`| Year component of the issue end date.           |
| Issue End Date (Month) | `entry.514450388_month`| Month component of the issue end date.          |
| Issue End Date (Day)   | `entry.514450388_day`| Day component of the issue end date.            |
| Explain Issue          | `entry.1211413190`   | Detailed explanation of the issue.              |
| Reason                 | `entry.1231067802`   | The categorized reason for the issue.            |

---

## 🎨 UI/UX Highlights

The Issue Tracker App boasts a modern and intuitive design, focusing on a seamless user experience:

-   **Clean Layout:** A well-structured and uncluttered interface ensures easy navigation and readability.
-   **Vibrant Gradients:** Strategic use of linear gradients provides a visually appealing and dynamic backdrop.
-   **Custom Typography:** Integration of the 'Poppins' font family across the app ensures a consistent, modern, and highly legible text presentation.
-   **Enhanced Input Fields:** Thoughtfully designed input fields and dropdowns with clear labels and subtle visual cues for improved usability.
-   **Animated Transitions:** Smooth and engaging animations for screen transitions and button interactions, adding a polished feel to the user journey.
-   **Informative SnackBars:** Contextual and visually distinct `SnackBar` messages provide clear feedback to the user.
-   **Adaptive Design:** The UI components are designed to be responsive, ensuring a consistent experience across various device sizes.

---

## 🤝 Contributing

We welcome contributions to enhance the Issue Tracker App! If you have suggestions, bug reports, or want to contribute code, please feel free to:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'feat: Add new feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🧑‍💻 About the Developer

This application was passionately developed by **Suvojeet** to provide an efficient, user-friendly, and visually appealing solution for issue tracking and seamless Google Form integration. This is a personal project and not an official product.

---