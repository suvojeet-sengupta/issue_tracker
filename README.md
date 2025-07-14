# 🚀 Issue Tracker App: Streamlined Issue Management

Welcome to the **Issue Tracker App**, a powerful and intuitive Flutter application designed to revolutionize how you log and track issues. Seamlessly integrating with Google Forms, this app ensures detailed record-keeping with minimal effort, making it an indispensable tool for advisors and team leaders.

---

## ✨ Features at a Glance

Our app is packed with features engineered for efficiency and user-friendliness:

-   **Secure & Consistent APK Signing:** Ensures that app updates can be installed seamlessly without requiring uninstallation, thanks to consistent signing across builds.
-   **Admin Notification Control:** Admins now have full control over notifications, including the ability to enable/disable them and set custom intervals.
-   **Automated Google Form Submission:** The app now automatically submits the Google Form after pre-filling, eliminating manual interaction.
-   **User Profile Management:** Effortlessly input and manage your CRM ID, Advisor Name, and Team Leader (TL) Name. Your details are securely saved for quick access in future sessions.
-   **Dynamic TL Selection:** Choose from a curated list of Team Leaders or easily add an 'Other' TL name if yours isn't predefined.
-   **Precise Issue Timing:** Accurately log the start and end times of issues using an elegant and intuitive time picker.
-   **Persistent Organization Preference:** Set your organization (DISH or D2H) once, and the app intelligently remembers your choice, auto-filling it for all subsequent Google Form submissions.
-   **Automated Date Pre-fill:** The current date is automatically fetched and pre-filled for both issue start and end dates in the Google Form, drastically cutting down on manual entry and boosting accuracy.
-   **Seamless Google Form Integration:** All captured issue details are automatically and intelligently pre-filled into a designated Google Form, eliminating manual data entry and significantly reducing errors.
-   **In-App Webview Experience:** The Google Form opens directly within the application via a built-in webview, providing a smooth, integrated, and uninterrupted user experience.
-   **Smart Auto-Scroll & Instruction:** Upon opening the Google Form, the webview automatically scrolls to the submit button, and a clear, visually appealing instruction guides the user to complete the submission.
-   **Intelligent Submission Detection:** The app now accurately detects if the Google Form has been successfully submitted by monitoring URL changes, providing instant feedback.
-   **Enhanced Back Navigation:** Smart navigation ensures that if a form is submitted, you're seamlessly redirected to the home screen with a success message. If not, a clear warning prompts you before exiting.
-   **Intuitive & Modern UI:** Experience a clean, modern, and highly responsive user interface designed for maximum ease of use and visual appeal.
-   **Automated Name Pre-fill in Feedback:** Your advisor name is automatically fetched and pre-filled in the feedback section, making it easier to share your thoughts.

---

## 🚀 Getting Started

Follow these steps to get the Issue Tracker App up and running on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:

-   **Flutter SDK:** [Install Flutter](https://flutter.dev/docs/get-started/install)
-   **Android Studio / VS Code:** With the official Flutter and Dart plugins installed.

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
        <application
            android:label="issue_tracker_app"
            android:name="${applicationName}"
            android:icon="@mipmap/ic_launcher">
            <!-- ... other application settings ... -->
        </application>
    </manifest>
    ```

### Running the App

1.  **Connect a device or start an emulator.**
2.  **Run the app:**

    ```bash
    flutter run
    ```

---

## 💡 Usage

1.  **Initial Setup:** Upon the very first launch, you'll be guided through a quick setup process. Here, you'll enter your CRM ID, Advisor Name, Team Leader, and select your Organization (DISH/D2H). These details are saved for future convenience.
2.  **Issue Tracking:** From the main screen, you can easily record the start and end times of any issue.
3.  **Automated Submission:** After filling in the required times, tap the prominent `Submit Issue and Open Form` button. The app will intelligently pre-fill the Google Form with your collected data, open it directly within the app's webview, and automatically submit it.
4.  **Feedback:** Navigate to the feedback section to share your experience, where your name will be pre-filled for convenience.

---

## 📂 Project Structure

A well-organized project structure ensures maintainability and scalability:

```
issue_tracker/
├── android/                  # Android specific files
├── assets/                   # Application assets (fonts, images, icons)
│   ├── fonts/
│   ├── icon/
│   └── images/
├── ios/                      # iOS specific files
├── lib/                      # Core application source code
│   ├── about_app_screen.dart
│   ├── admin_settings_screen.dart
│   ├── credits_screen.dart
│   ├── developer_info_screen.dart
│   ├── edit_profile_screen.dart
│   ├── feedback_screen.dart          # Feedback screen with auto-filled name
│   ├── google_form_webview_screen.dart # Handles Google Form display and submission logic
│   ├── history_onboarding_tour.dart
│   ├── history_screen.dart
│   ├── initial_setup_screen.dart     # Initial user setup
│   ├── issue_detail_screen.dart
│   ├── issue_tracker_screen.dart     # Main issue tracking screen
│   ├── main.dart                     # Application entry point
│   ├── onboarding_tour.dart
│   ├── settings_screen.dart
│   ├── splash_screen.dart
│   ├── theme_notifier.dart
│   ├── theme.dart
│   └── utils/
│       └── issue_parser.dart
├── linux/                    # Linux specific files
├── macos/                    # macOS specific files
├── test/                     # Unit and widget tests
├── web/                      # Web specific files
├── windows/                  # Windows specific files
├── .github/                  # GitHub Actions workflows
│   └── workflows/
│       └── flutter_apk_build.yml # Workflow for building APK
├── .gitignore                # Files and directories to ignore in Git
├── .metadata                 # Flutter metadata
├── analysis_options.yaml     # Dart analyzer options
├── pubspec.lock              # Pinpoint versions of dependencies
├── pubspec.yaml              # Project dependencies and metadata
├── README.md                 # This documentation file
└── UI_IMPROVEMENTS_SUMMARY.md # Summary of UI improvements
```

### Key Files & Directories:

-   `lib/main.dart`: The heart of the application, where the Flutter app starts.
-   `lib/initial_setup_screen.dart`: Manages the first-time user setup, capturing essential user and team details.
-   `lib/issue_tracker_screen.dart`: The central hub for logging issues, managing timings, and initiating the Google Form process.
-   `lib/google_form_webview_screen.dart`: A dedicated screen that hosts the Google Form within an in-app webview, handling auto-scrolling, submission detection, and navigation.
-   `lib/feedback_screen.dart`: Allows users to provide feedback, with their name automatically populated for convenience.
-   `assets/`: Contains all static resources like custom fonts, application icons, and images, contributing to the app's visual identity.

---

## 🔗 Google Form Integration Details

The app is meticulously configured to pre-fill a specific Google Form. The `entry` IDs used within `lib/issue_tracker_screen.dart` are crucial as they directly correspond to the fields in your Google Form. If you intend to use a different Google Form, you **must** update these `entry` IDs accordingly to ensure proper data mapping.

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
-   **Informative SnackBars:** Contextual and visually distinct `SnackBar` messages provide clear feedback to the user, including a prominent, animated instruction for Google Form submission.
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

## 🧑‍💻 About the Developer

This application was passionately developed by **Suvojeet** to provide an efficient, user-friendly, and visually appealing solution for issue tracking and seamless Google Form integration.

---