Quizzical  🎯
Quizzical 2 is a modern Flutter trivia/quiz application that lets users choose a trivia category, configure a quiz, answer timed questions, and view their results.
The application uses the Open Trivia Database (OpenTDB) API for live trivia categories and questions. Quiz configuration and the user's name are stored locally so the app can remember previous choices.
📱 Project Overview
Quizzical is designed as a clean, beginner-friendly Flutter application with a layered architecture:
Models — represent quiz categories, configuration, and questions.
Provider — manages quiz state, scoring, timers, and API loading state.
Services — communicate with the OpenTDB API and local storage.
Screens — contain the main user interface and navigation flow.
Widgets — contain reusable custom illustrations.
Theme — centralizes colors and application-wide styling.
Tests — verify model behavior, quiz configuration, and basic application startup.
Main user flow
Welcome Screen
      ↓
Category Screen
      ↓
Quiz Configuration Screen
      ↓
Quiz Screen
      ↓
 ┌───────────────┐
 │ Quiz Finished │
 └───────┬───────┘
         ↓
   Result Screen
   ↙           ↘
Play Again   New Category
Depending on the score, the final screen is either:
Congratulations Screen
Keep Trying Screen
✨ Features
1. Welcome Screen
The welcome screen is the entry point of the application.
It provides:
Quizzical branding
Custom animated/styled illustration
User name display
User name editing
GET STARTED button
Persistent user name using SharedPreferences
The default user name is Alex when no name has been saved yet.
2. Trivia Categories
The application retrieves available trivia categories from OpenTDB.
Examples of categories include:
General Knowledge
Books
Film
Music
Television
Video Games
Science
Computers
Mathematics
Mythology
Sports
Geography
History
Politics
Art
Animals
Vehicles
Comics
Anime & Manga
Cartoons
Each category has:
API ID
Full API name
Clean display name
Automatically selected pastel background color
Automatically selected Material icon
For example:
Entertainment: Books
        ↓
Display name:
Books
3. Quiz Configuration
Before starting a quiz, the user can configure:
Number of questions
The application supports:
1 → 50 questions
The default is:
10 questions
Difficulty
Available options:
Any Difficulty
Easy
Medium
Hard
Question type
Available options:
Any Type
Multiple Choice
True / False
The selected configuration is saved locally and restored the next time the application starts.
4. Timed Questions
Every question has a 25-second timer.
When a question starts:
25
24
23
...
2
1
0
If the user answers before the timer reaches zero:
The timer stops.
The answer is checked.
The score is updated.
The answer is recorded.
If the timer reaches zero:
The question is marked as timed out.
No answer is selected.
The question is recorded as incorrect.
5. Total Quiz Timer
In addition to the per-question timer, the application tracks the total quiz duration.
This allows the result screen to display:
Total Time
The total timer starts when the questions are successfully loaded and stops when the quiz finishes or is exited.
6. Automatic Answer Shuffling
For multiple-choice questions, the correct answer and incorrect answers are combined and shuffled.
Example:
Correct answer:
Paris

Incorrect:
London
Berlin
Madrid
The displayed choices may become:
Berlin
Paris
Madrid
London
This prevents the correct answer from always appearing in the same position.
For True/False questions, the choices are:
True
False
7. HTML Entity Decoding
OpenTDB can return HTML-encoded text.
For example:
Which character says &quot;I&#039;ll be back&quot;?
The application converts it to:
Which character says "I'll be back"?
This is handled using the html_unescape package.
8. Score Calculation
The application keeps track of:
Total questions
Correct answers
Incorrect answers
Timed-out questions
Accuracy
Total elapsed time
Accuracy is calculated as:
accuracy = (correct answers / total questions) × 100
For example:
8 correct out of 10

accuracy = (8 / 10) × 100
         = 80%
9. Result Screens
There are two result screens.
Congratulations Screen
Used for successful quiz results.
It displays:
Final score
Accuracy
Total time
Number of correct answers
Play Again
Choose New Category
Back to Home
Keep Trying Screen
Used for lower quiz results.
It displays:
Final score
Accuracy
Total time
Number of missed questions
Play Again
Choose New Category
Back to Home
Both result screens use custom illustrations.
🏗️ Architecture
The project follows a simple layered architecture.
lib/
│
├── main.dart
│
├── models/
│   ├── category.dart
│   ├── quiz_config.dart
│   └── quiz_question.dart
│
├── providers/
│   └── quiz_provider.dart
│
├── screens/
│   ├── welcome_screen.dart
│   ├── category_screen.dart
│   ├── quiz_config_screen.dart
│   ├── quiz_screen.dart
│   ├── congratulations_screen.dart
│   └── keep_trying_screen.dart
│
├── services/
│   ├── api_service.dart
│   └── storage_service.dart
│
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
│
└── widgets/
    └── custom_illustrations.dart
📂 Folder and File Explanation
lib/main.dart
This is the application entry point.
Responsibilities:
Initializes Flutter.
Configures system UI.
Creates the MultiProvider.
Registers QuizProvider.
Configures MaterialApp.
Applies the application theme.
Opens WelcomeScreen.
Important section:
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => QuizProvider()),
  ],
  child: const QuizzicalApp(),
)
This makes QuizProvider available to the application's widget tree.
🧩 Models
lib/models/category.dart
Contains the TriviaCategory model.
Main properties:
final int id;
final String name;
It also provides:
fromJson()
toJson()
displayName
backgroundColor
icon
Example:
Entertainment: Books
        ↓
Books
The icon getter selects an appropriate Material icon based on the category name.
lib/models/quiz_config.dart
Contains the configuration used to start a quiz.
QuizDifficulty
Any Difficulty
Easy
Medium
Hard
QuizType
Any Type
Multiple Choice
True / False
QuizConfig
Contains:
category
amount
difficulty
type
It also supports:
copyWith()
toJson()
fromJson()
This makes it possible to save and restore quiz configuration.
lib/models/quiz_question.dart
Represents a single trivia question.
It stores:
category
type
difficulty
question
correctAnswer
incorrectAnswers
shuffledAnswers
The model:
Reads JSON returned by OpenTDB.
Decodes HTML entities.
Stores the correct answer.
Stores incorrect answers.
Creates shuffled answer choices.
🧠 State Management
lib/providers/quiz_provider.dart
This is the central state-management class.
It extends:
ChangeNotifier
and is accessed using the provider package.
The provider controls almost all quiz logic.
Category State
The provider stores:
categories
isLoadingCategories
categoriesError
It loads categories through:
fetchCategories()
Configuration State
The provider stores:
selectedCategory
questionAmount
difficulty
quizType
These values are changed using:
selectCategory()
setQuestionAmount()
setDifficulty()
setQuizType()
Quiz State
The provider stores:
questions
currentIndex
selectedAnswer
hasAnswered
score
answerRecords
It also exposes:
currentQuestion
totalQuestions
progress
accuracy
Timer State
Each question has:
25 seconds
The provider uses Dart's Timer.periodic() for:
Question countdown
Total quiz duration
Timers are cancelled when:
A question is answered.
The quiz finishes.
The user exits.
The provider is disposed.
Answer Records
Each answer is stored using:
UserAnswerRecord
It contains:
question
selectedAnswer
isCorrect
timedOut
This makes it possible to keep a history of what happened during the quiz.
🌐 API Service
lib/services/api_service.dart
The application uses the Open Trivia Database API.
Categories endpoint
https://opentdb.com/api_category.php
Used to retrieve trivia categories.
Questions endpoint
https://opentdb.com/api.php
The application sends query parameters such as:
amount
category
difficulty
type
Example conceptually:
/api.php?
amount=10
&category=9
&difficulty=easy
&type=multiple
The actual request is constructed using Dart's Uri query parameters.
API Error Handling
The application handles common OpenTDB response codes.
Response code 0
Questions successfully returned.
Response code 1
Not enough questions are available for the requested combination.
The application asks the user to:
Reduce the number of questions.
Change difficulty to Any.
Try another category.
Response code 2
Invalid request parameters.
Response code 5
API rate limit exceeded.
The application tells the user to wait and try again.
💾 Local Storage
lib/services/storage_service.dart
The application uses:
shared_preferences
for simple local persistence.
Two values are stored.
Last quiz configuration
Key:
quizzical2_last_config
Stores:
category
question amount
difficulty
quiz type
User name
Key:
quizzical2_user_name
Stores the user's name.
🎨 Theme System
lib/theme/app_colors.dart
Contains the application's centralized color palette.
The primary brand color is:
Electric Indigo
#4F46E5
Other colors include:
Indigo
Violet
Amber
Pink
Cyan
Emerald
Slate
It also defines colors for:
Backgrounds
Text
Borders
Correct answers
Incorrect answers
Centralizing colors makes future design changes easier.
lib/theme/app_theme.dart
Defines the application's global ThemeData.
The application uses:
useMaterial3: true
It configures:
Background color
Color scheme
Typography
Buttons
Outlined buttons
Sliders
Border radius
Google Fonts
The application uses the Outfit font through google_fonts.
🖼️ Custom Widgets
lib/widgets/custom_illustrations.dart
This file contains custom Flutter illustrations created with widgets and CustomPainter.
It includes:
WelcomeIllustration
Used on the welcome screen.
ConfigIllustration
Used on the configuration screen.
CongratulationsIllustration
Used on the successful result screen.
KeepTryingIllustration
Used on the lower-score result screen.
The illustrations are generated directly with Flutter painting/widgets rather than external image files.
📱 Screens
1. welcome_screen.dart
Entry screen.
Main responsibilities:
Load saved user name
Display welcome UI
Edit user name
Navigate to CategoryScreen
2. category_screen.dart
Displays categories retrieved from OpenTDB.
It handles:
Loading
Success
Empty state
Error state
Retry
Category selection
A shimmer loading effect is used while categories are being retrieved.
3. quiz_config_screen.dart
Allows the user to select:
Number of questions
Difficulty
Question type
Then the user presses:
START QUIZ
The provider downloads questions and starts the quiz.
4. quiz_screen.dart
Displays the active quiz.
It contains:
Question number
Progress indicator
Countdown timer
Question text
Answer choices
Answer feedback
Next button
Exit confirmation
The screen gets its state from QuizProvider.
5. congratulations_screen.dart
Displays the final successful result.
Statistics include:
Score
Accuracy
Total Time
Correct answers
Actions:
Play Again
Choose New Category
Back to Home
6. keep_trying_screen.dart
Displays the alternative result screen.
Statistics include:
Score
Accuracy
Total Time
Missed questions
It provides the same navigation choices as the congratulations screen.
🔄 Complete Application Flow
Step 1 — Application starts
main()
  ↓
MultiProvider
  ↓
QuizProvider
  ↓
WelcomeScreen
When QuizProvider is created, it begins:
loadSavedConfig()
fetchCategories()
Step 2 — User starts
User presses:
GET STARTED
The app navigates to:
CategoryScreen
Step 3 — Category loading
QuizProvider.fetchCategories() calls:
ApiService.fetchCategories()
The API returns category JSON.
The JSON is converted into:
TriviaCategory
objects.
Step 4 — User chooses category
The selected category is stored in:
_selectedCategory
through:
selectCategory()
Step 5 — Quiz configuration
The user chooses:
Question amount
Difficulty
Question type
These values are stored inside QuizProvider.
Step 6 — Start quiz
The provider creates:
QuizConfig
and sends it to:
ApiService.fetchQuestions()
The questions are converted into:
QuizQuestion
objects.
Step 7 — Timers start
After questions successfully load:
Total timer starts
Question timer starts
Each question gets:
25 seconds
Step 8 — User answers
When the user selects an answer:
answerQuestion()
        ↓
Check selected answer
        ↓
Correct?
   ↙         ↘
 Yes          No
  ↓            ↓
score++      score unchanged
        ↓
record answer
Step 9 — Next question
The user presses the next button.
If questions remain:
currentIndex++
start 25-second timer
If no questions remain:
stop timers
finish quiz
Step 10 — Results
The result is calculated from:
score
totalQuestions
accuracy
totalElapsedSeconds
The application then displays the appropriate result screen.
📦 Dependencies
The project currently uses the following packages.
Package	Purpose
flutter	Flutter framework
cupertino_icons	iOS-style icons
provider	State management
http	REST API requests
shared_preferences	Local storage
html_unescape	Decode HTML entities
google_fonts	Outfit and other Google fonts
shimmer	Loading placeholders
flutter_test	Flutter testing
flutter_lints	Dart/Flutter linting
🛠️ Requirements
Before running the project, install:
Flutter SDK
Dart SDK (included with Flutter)
Android Studio or VS Code
Chrome, Android emulator/device, or iOS simulator/device depending on target
The project's pubspec.yaml requires:
Dart SDK ^3.11.1
Use:
flutter --version
to check your installed Flutter/Dart versions.
🚀 Installation
1. Clone or extract the project
Open a terminal inside the project directory.
Example:
cd quizz
2. Check Flutter installation
flutter doctor
If Flutter is not recognized, configure the Flutter SDK's bin directory in your system PATH.
3. Install dependencies
Run:
flutter pub get
This downloads all packages defined in pubspec.yaml.
4. Check available devices
flutter devices
For Chrome, you should see something similar to:
Chrome
🌐 Run on Chrome
To run the application in a browser:
flutter run -d chrome
For a web build:
flutter build web
The generated web application will be placed in:
build/web/
🤖 Run on Android
Start an Android emulator or connect a physical Android device.
Then run:
flutter devices
and:
flutter run
Or explicitly choose a device:
flutter run -d <device-id>
🍎 Run on iOS
On macOS with Xcode installed:
flutter run -d ios
The repository contains the standard Flutter iOS project under:
ios/
🧪 Testing
The project includes unit/model tests and a widget test.
Run all tests:
flutter test
Model Tests
test/quiz_test.dart checks:
Category model
Verifies:
Category display name
Pastel color generation
Question model
Verifies:
HTML entity decoding
Correct answer parsing
Answer shuffling
Number of choices
Quiz configuration
Verifies:
JSON serialization
JSON deserialization
Category
Question amount
Difficulty
Quiz type
Provider configuration
Verifies that question amount changes correctly.
Widget Test
test/widget_test.dart verifies that:
Quizzical
GET STARTED
are displayed when the application starts.
🧹 Useful Flutter Commands
Clean generated files
flutter clean
Then:
flutter pub get
Analyze code
flutter analyze
Run tests
flutter test
Run on Chrome
flutter run -d chrome
List devices
flutter devices
Check Flutter installation
flutter doctor -v
🐛 Troubleshooting
Flutter command not found
If Windows PowerShell shows that Flutter is not recognized, add the Flutter bin directory to PATH.
Example:
D:\flutter\bin
Then restart the terminal.
Check:
flutter --version
Dependency problems
Try:
flutter clean
flutter pub get
If the Dart/Flutter package cache appears corrupted, you can also run:
flutter pub cache repair
Then:
flutter pub get
OpenTDB returns no questions
This can happen when the selected combination does not have enough questions.
For example:
50 questions
+
Hard difficulty
+
specific category
may not have 50 available questions.
Try:
Any Difficulty
or reduce the number of questions.
API rate limit
OpenTDB can reject requests when too many requests are made in a short period.
The application handles response code 5 and displays a message asking the user to wait.
Chrome does not appear
Run:
flutter devices
If Chrome is missing, make sure Google Chrome is installed and Flutter web support is available.
You can also run:
flutter config --enable-web
and then:
flutter devices
🔐 Data and Privacy
The application does not require a login or account.
The current implementation stores only:
User name
Last quiz configuration
using local SharedPreferences.
Trivia categories and questions are retrieved from OpenTDB.
No custom backend/database is included in this project.
🔌 External API
This application depends on:
Open Trivia Database (OpenTDB)
The API provides:
Trivia categories
Trivia questions
Question difficulty
Question types
Correct answers
Incorrect answers
The application builds requests dynamically based on the user's quiz configuration.
🎨 UI Design
The application uses a modern Material 3 visual style.
Brand
Primary color:
#4F46E5
Typography
The application uses:
Outfit
through google_fonts.
Design characteristics
Rounded cards
Rounded buttons
Soft shadows
Pastel category colors
Indigo/violet branding
Clear answer feedback
Large readable typography
Responsive Flutter layouts
Custom illustrations
Shimmer loading states
🧱 Widget Structure
The application is primarily composed from standard Flutter widgets such as:
Scaffold
SafeArea
Column
Row
Expanded
Padding
Container
Card
Text
Icon
ElevatedButton
OutlinedButton
TextButton
ListView
GridView
SingleChildScrollView
Slider
DropdownButton
LinearProgressIndicator
State-dependent widgets use:
Consumer<QuizProvider>
or:
context.read<QuizProvider>()
to interact with the provider.
🔁 State Management Pattern
The application follows this general pattern:
UI
 ↓
QuizProvider
 ↓
Service
 ↓
API / Local Storage
For example:
QuizConfigScreen
       ↓
quizProvider.startQuiz()
       ↓
ApiService.fetchQuestions()
       ↓
OpenTDB API
       ↓
QuizQuestion objects
       ↓
QuizProvider
       ↓
QuizScreen
This separation prevents API and quiz-management logic from being placed directly inside UI widgets.
📈 Future Improvements
Possible future improvements include:
Dark mode
Quiz history
Leaderboard
User accounts
Offline question cache
More detailed answer review
Question explanations
Difficulty statistics
Category statistics
Sound effects
Haptic feedback
Animated transitions
Achievement/badge system
Favorite categories
Custom quiz presets
Better accessibility support
Localization/multiple languages
Backend synchronization
More extensive integration tests
📌 Project Structure
quizz/
│
├── android/                    # Android platform project
├── ios/                        # iOS platform project
├── web/                        # Flutter web project
│
├── lib/
│   ├── main.dart               # Application entry point
│   │
│   ├── models/
│   │   ├── category.dart       # Trivia category model
│   │   ├── quiz_config.dart    # Quiz configuration model
│   │   └── quiz_question.dart  # Quiz question model
│   │
│   ├── providers/
│   │   └── quiz_provider.dart  # Main application/quiz state
│   │
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── category_screen.dart
│   │   ├── quiz_config_screen.dart
│   │   ├── quiz_screen.dart
│   │   ├── congratulations_screen.dart
│   │   └── keep_trying_screen.dart
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   │
│   └── widgets/
│       └── custom_illustrations.dart
│
├── test/
│   ├── quiz_test.dart
│   └── widget_test.dart
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
👨‍💻 Development Workflow
When adding a new feature, a useful workflow is:
1. Define the data
Add or modify a model in:
lib/models/
2. Add business/state logic
Update:
lib/providers/quiz_provider.dart
if the feature changes application state.
3. Add external/local data operations
Use:
lib/services/
for API calls or persistent storage.
4. Build the UI
Create or modify:
lib/screens/
or:
lib/widgets/
5. Add theme values
If the feature needs new colors or common styles, update:
lib/theme/
6. Add tests
Add relevant tests under:
test/
7. Run validation
flutter analyze
flutter test
flutter run -d chrome
📜 License
No explicit license file is currently included in the project.
If this project will be published publicly, add an appropriate license such as MIT, Apache-2.0, or another license suitable for your intended use.
🙌 Acknowledgements
Flutter — application framework
Open Trivia Database — trivia categories and questions
Provider — state management
Google Fonts — typography
Shared Preferences — local persistence
⭐️ Summary
Quizzical 2 is a Flutter-based trivia application built around a simple and maintainable architecture.
The core flow is:
Choose Category
      ↓
Configure Quiz
      ↓
Fetch Questions
      ↓
Answer Timed Questions
      ↓
Calculate Score
      ↓
View Results
      ↓
Replay / New Category / Home
The project demonstrates several important Flutter concepts:
Widget composition
Material 3
Provider state management
REST API integration
JSON parsing
Local persistence
Timers
Navigation
Custom painting
Responsive layouts
Loading and error states
Unit testing
Widget testing
