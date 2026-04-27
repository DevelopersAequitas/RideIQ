# RideIQ Development Rules & Architecture

## 🏗 Architecture: MVVM + Clean Architecture
We follow a strict **Model-View-ViewModel (MVVM)** pattern combined with **Clean Architecture** principles to ensure scalability, maintainability, and testability.

### Separation of Concerns
1.  **View (UI)**: 
    *   Responsible ONLY for rendering the UI.
    *   No business logic, no API calls, no direct repository access.
    *   Uses `ConsumerWidget` or `ConsumerStatefulWidget` to interact with ViewModels.
2.  **ViewModel (State Management)**:
    *   Handles all business logic and state transitions.
    *   Communicates ONLY with Repositories.
    *   Uses Riverpod `AsyncNotifier` or `Notifier`.
    *   No UI imports (e.g., `material.dart`) allowed in ViewModels.
3.  **Model (Data)**:
    *   Plain data structures (using `Freezed` for immutability and JSON serialization).
4.  **Repository (Data Layer)**:
    *   Handles data operations (API calls, local database, caching).
    *   Returns clean models to the ViewModel.
    *   Abstracts the data source from the rest of the app.

---

## 📁 Folder Structure
The project is organized by **Features**. Each feature module must contain the following sub-directories:

```text
lib/
├── core/                   # Shared logic across the app
│   ├── services/           # External services (API, Storage, Network)
│   ├── utils/              # Helper functions & extensions
│   ├── constants/          # App constants (Colors, Strings, Sizes)
│   └── theme/              # App styling and themes
├── features/               # Feature-based modules
│   └── <feature_name>/
│       ├── model/          # Data classes & DTOs
│       ├── repository/     # Abstract & concrete repositories
│       ├── viewmodel/      # Riverpod Notifiers/Providers
│       └── view/           # UI components
│           ├── screens/    # Full-page widgets
│           └── widgets/    # Reusable feature-specific widgets
└── shared/                 # Shared widgets used across multiple features
```

---

## 🧪 State Management: Riverpod
*   **Provider Types**: Use `AsyncNotifierProvider` for asynchronous state and `NotifierProvider` for synchronous state.
*   **Dependency Injection**: Use Riverpod Providers to inject Repositories and Services.
*   **State Handling**: Always use `.when()` or `AsyncValue` patterns in the UI for handling Loading, Data, and Error states.
*   **Generation**: Use `@riverpod` annotation and `riverpod_generator`.

---

## 🛠 View Rules (UI)
*   **No StatefulWidget**: Use `ConsumerWidget` for all UI components. Avoid `StatefulWidget` to maintain high performance and clean state management with Riverpod.
*   **Keep it Small**: No single UI file should exceed 300 lines. 
*   **Widget Splitting**: Split screens into smaller, reusable widgets within the `features/<feature>/view/widgets/` directory.
*   **Pixel Perfect**: Follow Figma designs exactly for padding, colors, fonts, and spacing.
*   **Responsiveness**: Ensure UI works on all screen sizes. Use `SingleChildScrollView` to prevent overflows, `Flexible`/`Expanded` for fluid layouts, and avoid hardcoded pixel values for layout-critical dimensions. Test on different device aspect ratios.
*   **Zero Logic**: If you find yourself writing `if` or `for` logic for data processing, it belongs in the ViewModel.
*   **Consumer usage**: Use `ref.watch` for state and `ref.read` for triggering actions inside callbacks.

---

## 🔒 ViewModel Rules
*   **Purity**: Do not import `package:flutter/material.dart` in ViewModels. Use `AsyncValue` to communicate status back to the UI.
*   **Error Handling**: Wrap repository calls in `try-catch` and map errors to user-friendly messages or states.

---

## 📦 Repository Rules
*   **Interface First**: Always define an abstract class (interface) for repositories to allow for easy mocking/testing.
*   **Clean Models**: Repositories should convert raw API responses (JSON/Map) into typed Models before returning them.

---

## 🏷 Naming Conventions
*   **ViewModel**: `<Feature>NameViewModel`
*   **Repository**: `<Feature>NameRepository`
*   **Model**: `<Feature>NameModel`
*   **Provider Names**: 
    *   `featureNameProvider` (for the ViewModel)
    *   `featureRepositoryProvider` (for the Repository)

---

## ✅ Code Quality & Best Practices
*   **No Deprecated Components**: Never use deprecated Flutter/Dart components. Always use the latest recommended alternatives (e.g., use `ElevatedButton` instead of `RaisedButton`, `ColorScheme` instead of `accentColor`, etc.).
*   **Null Safety**: Use `?` and `!` judiciously. Prefer default values or required parameters.
*   **Immutability**: Use `freezed` for all models and states.
*   **Documentation**: Document complex business logic inside ViewModels.
*   **Linting**: Follow the rules defined in `analysis_options.yaml`.
