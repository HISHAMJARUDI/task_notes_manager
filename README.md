Task Notes Manager
A simple Flutter app for managing tasks and notes with local persistence, theme toggling, and CRUD operations.
Description
This app allows users to:
•	View a dynamic list of tasks/notes on the home screen.
•	Add new tasks/notes via a form with validation (title, priority, description, completion status).
•	Toggle between light and dark themes, with preferences saved across app restarts.
•	Persist data using SQFLite (SQLite) for offline access—data survives app closes/restarts.
Built as a Flutter tutorial project demonstrating navigation, forms, data modeling, JSON serialization, SharedPreferences, and SQFLite.
Features
•	Home Screen: Welcome message, theme toggle switch, dynamic ListView of tasks (fetched from DB), FAB to add new items.
•	Add Screen: Form with TextFields, Dropdown for priority (Low/Medium/High), Checkbox for completion, Submit button that saves to DB.
•	Persistence: Themes via SharedPreferences; tasks via SQFLite (insert, retrieve all).
•	Bonus: Database includes delete method (not yet integrated in UI).
•	Theme Support: Automatic light/dark mode based on user preference.

Tech Stack

•	Flutter: UI framework (Dart language).
•	Packages:
◦	shared_preferences: ^2.3.0 (theme persistence).
◦	sqflite: ^2.3.3 + path: ^1.9.0 (local SQLite DB).
•	Data Model: TaskItem class with toJson() and fromJson() for serialization.
•	Database: Singleton DatabaseHelper for init/insert/getAll/delete tasks.
•	IDE: Android Studio.
Installation & Setup
1	Clone/Setup Project:git clone
2	cd task_notes_manager
3
4	Flutter Setup:
◦	Ensure Flutter SDK is installed: flutter.dev/docs/get-started/install.
◦	Run flutter doctor to verify (fix any issues).
5	Dependencies:flutter pub get
6
7	Run the App:
◦	Start an emulator/device: Tools > AVD Manager in Android Studio.
◦	Run: flutter run (or green ▶ button in IDE).
◦	For web: flutter run -d chrome (enable web if needed: flutter config --enable-web).
Usage
1	Launch the app → Home screen shows empty list (or existing tasks).
2	Toggle “Dark Mode” switch → Theme changes and persists on restart.
3	Tap + FAB → Navigate to Add screen.
4	Fill form (title required, description required, pick priority, optional completed) → Tap Submit.
5	Back to Home → New task appears in list with details (priority, description, checkmark if completed).
6	Data persists: Close/reopen app → Tasks and theme remain.
Project Structure
lib/
├── main.dart              # App entry, MyApp, HomeScreen, Screen2 (form)
├── models/
│   └── task_item.dart     # TaskItem class with JSON methods
└── services/
└── database_helper.dart # SQFLite init, insert, getAll, delete
pubspec.yaml               # Dependencies (shared_preferences, sqflite, path)
Future Enhancements
•	Integrate delete (e.g., swipe-to-delete in ListView).
•	Add edit functionality (navigate to form with pre-filled data).
•	Search/filter tasks by priority.
•	Export/import DB as JSON.
•	Unit tests for DB helper and model.
Contributing
•	Fork the repo.
•	Create a feature branch (git checkout -b feature/amazing-feature).
•	Commit changes (git commit -m 'Add some amazing feature').
•	Push (git push origin feature/amazing-feature).
•	Open a Pull Request.
License
MIT License - feel free to use/modify for learning or projects. (Add your name/year if needed.)

Built with ❤ using Flutter. Questions? Open an issue!