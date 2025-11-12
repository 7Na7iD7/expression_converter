# 🚀 Expression Converter Pro

An advanced Flutter application designed to teach and visualize the conversion of mathematical expressions between **Infix, Postfix, and Prefix** notations. Built with a focus on clean architecture, modern UI, and providing a powerful educational tool far beyond a simple calculator.

## ✨ Features

This application goes beyond basic conversion by providing a rich, interactive, and educational experience.

### 1. **Stack Visualization (The Core Feature)**
The standout feature is the detailed, step-by-step visualization of the conversion process.
* **Real-time Steps:** The core logic generates a `List<ConversionStep>` allowing users to follow the algorithm's execution step-by-step.
* **Interactive Controls:** Users can manually navigate through steps or use the "Auto Play" function to watch the conversion unfold.
* **Visual Stack:** A dedicated `StackVisualizer` widget graphically represents the stack and the output string in real-time.

### 2. **Comprehensive Conversion Types**
Supports all four primary expression conversions:
* Infix to Postfix
* Infix to Prefix
* Postfix to Infix
* Prefix to Infix

### 3. **Clean Architecture & State Management**
* Utilizes the **Provider** package for robust and scalable state management.
* Code is cleanly separated into specialized providers: `ConverterProvider` (logic), `ThemeProvider` (UI state), and `LocaleProvider` (localization state).
* The `LocaleProvider` is implemented using advanced architectural patterns (Repository pattern) and persists user settings via `shared_preferences`.

### 4. **Modern UI/UX & Theming**
* Built with **Material 3** principles (using `ThemeData.fromSeed`).
* Full support for **Light, Dark, and System** themes, with persistence.
* Users can customize the primary color scheme.
* Incorporates subtle micro-interactions and animations using the `flutter_animate` package.

### 5. **Educational Tools**
* **Examples Library (`ExamplesScreen.dart`):** A curated list of ready-to-use expressions, searchable and filterable by **Difficulty** (Easy, Medium, Hard) and **Conversion Type**.
* **Tutorial Section (`TutorialScreen.dart`):** Contains theoretical explanations of notations, precedence rules, and stack operations using well-organized, expandable cards.

### 6. **Internationalization (i18n)**
* Full support for multiple languages including **English, Persian (Farsi - RTL), Chinese, and Spanish**, with language preference persisted across sessions.

---

## 🛠️ Getting Started

### Prerequisites

* Flutter SDK (version 3.0.0 or higher)
* Dart SDK (version 3.0.0 or higher)

### Installation and Run

1.  **Clone the repository:**
    ```bash
    git clone [YOUR_REPO_URL]
    cd expression_converter_pro
    ```

2.  **Get packages:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 📦 Project Structure Overview

The project follows a standard Flutter structure with an emphasis on separation of concerns:

```
lib/
├── models/          # Data structures (ExampleModel, ConversionStep)
├── providers/       # State management logic (ConverterProvider, ThemeProvider, etc.)
├── screens/         # Full-page UI widgets (HomeScreen, SettingsScreen, ConversionResultScreen)
├── utils/           # Helper classes (ThemeStyles)
├── widgets/         # Reusable UI components (StackVisualizer, AdvancedStepCard)
├── l10n/            # Localization files (app_localizations.dart - Custom implementation)
└── main.dart        # Application entry point
```

---

## 💡 Future Enhancements

Based on standard development practices, the following areas are open for refinement:

* **Localization Refactor:** Migrate the current custom localization implementation (`app_localizations.dart` Map-based) to the standard Flutter `.arb` file format for easier maintenance and scalability.
* **Service Layer Extraction:** Extract the core conversion algorithms from `ConverterProvider` into a separate `ConverterService` class to improve testability and further decouple logic from state management.
* **Improved Error Handling:** Implement more granular error messaging within the `ConverterProvider` to pinpoint specific syntax errors in invalid expressions (e.g., unmatched parentheses).

---

## ✍️ Author

* **[7Na7iD7](https://github.com/7Na7iD7)**

## 📜 License

This project is licensed under the [Choose a License, e.g., MIT License] - see the [LICENSE.md](LICENSE.md) file for details.

