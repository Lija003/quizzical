# Quizzical — Mobile App Development Lab Final Exam (CSE-3212)

**University of Barishal**  
*Department of Computer Science & Engineering (CSE)*  
*3rd Year, 2nd Semester (2021-22)*  
*Course Code: CSE-3212 | Course Title: Mobile App Development Lab*

---

## 📱 Project Overview

**Quizzical** is a clean, responsive, and accessible trivia quiz application built with Flutter, Provider state management, and the Open Trivia Database (OpenTDB) REST API.

### ✨ Features & Screen Implementations

1. **Screen 1 — Welcome Screen (`lib/screens/welcome_screen.dart`)**
   - App title: **"Quizzical"**
   - Modern, responsive hero illustration & feature pills
   - Primary CTA: **"Start Quiz"** (`ElevatedButton`)
   - Adapts to both compact mobile screens and tablet/desktop widths.

2. **Screen 2 — Category Selection Screen (`lib/screens/category_selection_screen.dart`)**
   - Visual grid of trivia categories fetched from OpenTDB (`GET https://opentdb.com/api_category.php`).
   - Categorized cards with distinct icons and background colors (`lib/utils/category_icons.dart`).
   - **Shimmer / Skeleton loading** state (`lib/widgets/skeleton_loader.dart`).
   - **Retry banner on error** with one-tap retry.
   - **Session Caching**: Loads categories once during the session to avoid duplicate network calls.

3. **Screen 3 — Quiz Configuration Screen (`lib/screens/quiz_config_screen.dart`)**
   - **Number of questions**: Interactive Slider (1–50, default 10).
   - **Difficulty**: Dropdown (`Any` / `Easy` / `Medium` / `Hard`).
   - **Question Type**: Dropdown (`Any` / `Multiple Choice` / `True / False`).
   - **Timer per question**: Dropdown (15s, 20s, 30s).
   - **Persistence**: Remembers and restores last configuration via `SharedPreferences`.

4. **Screen 3 (Active Quiz) — Quiz Play Screen (`lib/screens/quiz_play_screen.dart`)**
   - Fetches questions dynamically based on configured criteria from OpenTDB API:  
     `https://opentdb.com/api.php?amount=<n>&category=<id>&difficulty=<level>&type=<multiple|boolean>`
   - HTML entity decoding (`HtmlUnescapeHelper`) to display clean questions and answers.
   - Shows one question at a time.
   - 4 shuffled options for Multiple Choice, 2 options (`True / False`) for Boolean.
   - Exactly one correct answer.
   - **Question Timer**: Visual circular countdown per question. Auto-advances on timeout (unanswered/incorrect).
   - **Visual Feedback**: Instant color highlighting on selection (Green for correct, Red for wrong, showing correct answer).
   - **Live Progress & Score**: Live score badge and linear progress bar below the AppBar.
   - Skeletons on loading; errors preserve configuration and allow instant retry.

5. **Screen 4 — Results Screen (`lib/screens/results_screen.dart`)**
   - Prominent score presentation: *"You scored X/Y!"*
   - Performance celebration badge and feedback message.
   - Quick stats grid: **Accuracy %**, **Total Time Elapsed**, **Correct Answers**, and **Incorrect / Skipped**.
   - **Play Again CTA**: Resets quiz state and launches replay with preserved configuration.
   - Back to category selection option.

---

## 🏗️ Architecture & Project Structure

The project strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern:

```text
quizzical/
├── android/               # Native Android configuration & gradle
├── ios/                   # Native iOS runner
├── web/                   # Web runner
├── windows/               # Windows desktop runner
├── lib/
│   ├── main.dart          # Entry point, MultiProvider & Theme setup
│   ├── models/
│   │   ├── category.dart      # OpenTDB Category Model
│   │   ├── quiz_config.dart   # Quiz Configuration & query builder
│   │   └── quiz_question.dart # Question model with shuffled answers
│   ├── services/
│   │   ├── api_service.dart          # HTTP OpenTDB API client
│   │   └── preferences_service.dart  # SharedPreferences persistence
│   ├── providers/
│   │   ├── category_provider.dart    # Category state & session caching
│   │   └── quiz_provider.dart        # Quiz logic, timer & session metrics
│   ├── screens/
│   │   ├── welcome_screen.dart            # Screen 1: Welcome & Start
│   │   ├── category_selection_screen.dart # Screen 2: Category Grid & Cache
│   │   ├── quiz_config_screen.dart        # Screen 3a: Slider & Dropdowns
│   │   ├── quiz_play_screen.dart          # Screen 3b: Question & Timer UI
│   │   └── results_screen.dart            # Screen 4: Score & Stats Summary
│   ├── widgets/
│   │   ├── answer_button.dart        # Shuffled answer button with feedback
│   │   ├── category_card.dart        # Category tile with color/icon
│   │   ├── question_progress_bar.dart# Live progress indicator
│   │   ├── retry_banner.dart         # Error message with retry action
│   │   ├── skeleton_loader.dart      # Shimmer loading skeleton
│   │   └── timer_indicator.dart      # Circular countdown timer widget
│   └── utils/
│       ├── app_theme.dart            # Material 3 theme & typography
│       ├── category_icons.dart       # Category colors & icon mappings
│       └── html_unescape_helper.dart # Robust HTML entity decoder
├── test/
│   └── unit_test.dart     # Comprehensive unit tests
└── pubspec.yaml           # Dependencies: provider, http, shared_preferences
```

---

## 🚀 How to Run the App

1. Ensure the Flutter SDK is installed and added to your system `PATH`.
2. Navigate to this directory in PowerShell or VS Code:
   ```powershell
   cd C:\Users\CSE\.gemini\antigravity\scratch\quizzical
   ```
3. Get packages:
   ```powershell
   flutter pub get
   ```
4. Run on your desired target (Chrome, Windows, or an Android emulator/device):
   ```powershell
   flutter run -d chrome
   # or
   flutter run -d windows
   ```
5. Run unit tests:
   ```powershell
   flutter test
   ```
