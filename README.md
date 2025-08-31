# Currency Converter App

A beautiful, responsive, and delightfully animated currency converter mobile app built with Flutter.

## Demo Video

[Demo Video](assets/currencyconverter.mp4)


## 📦 Download APK
[Download APK (v1.0.0)](https://github.com/abhijithaj0004/Currency-Converter-App/commits/v1.0.0)


## Architecture

This project follows the **BLoC (Business Logic Component)** architecture pattern to separate presentation from business logic, making the app scalable, testable, and maintainable.

### Architecture Diagram

```
   +-------------------+       +----------------------+       +------------------------+
   |   UI (Widgets)    |------>|   BLoC (Events)      |<----->|   Repository           |
   |  (Presentation)   |       | (State Management)   |       | (Data Abstraction)     |
   +-------------------+<------|   (States)           |       +------------------------+
                               +----------------------+                 |
                                                                        |
                                                                        v
                                                            +--------------------------+
                                                            |   Data Sources           |
                                                            | (API Client, Cache)      |
                                                            +--------------------------+
```

### Folder Structure

The `lib` folder is organized as follows:

-   `main.dart`: The entry point of the application.
-   `app.dart`: The root widget of the application, which sets up the BLoC providers.
-   `bloc/`: Contains all BLoC classes, responsible for managing the application's state.
    -   `app_bloc/`, `authentication/`, `currencyconverter/`: Each feature has its own BLoC, events, and states.
-   `config/`: Application-level configurations, like API keys and base URLs.
-   `data/`: Static or cached data models.
-   `model/`: Data models for the application (e.g., `Currency`, `User`).
-   `presentation/`: Contains all UI-related widgets, organized by screens.
-   `repositories/`: Abstract the data layer from the BLoCs. They are responsible for fetching data from various sources (API, cache, etc.).
-   `services/`: Concrete implementations of data sources, such as the `ApiClient` for making HTTP requests.

## Setup Steps

### 1. Flutter and Dart Versions

-   **Flutter**: Make sure you have the Flutter SDK installed. This project is tested with Flutter version `3.22.3`.
-   **Dart**: The project uses Dart SDK version `3.4.4`.

### 2. Firebase Configuration

This project uses Firebase for authentication.

1.  Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com/).
2.  **Android**: Follow the instructions to add an Android app to your Firebase project. Download the `google-services.json` file and place it in the `android/app/` directory.


## How to Run the Application

The application can be configured to run with a real API.

### Running with the Real API

To run the app with the default production API, you need to provide your API access key at compile time.

```bash
flutter run
```

### Running in Mock Mode

To run the app against a local or mock API server, you can specify a different `BASE_URL`.

1.  Run a mock server (e.g., `npm package mockoon-cli` or a custom one) that serves mock data on a local URL (e.g., `http://localhost:3000`).
2.  Run the app with the `BASE_URL` pointing to your mock server.

```bash
flutter run --dart-define=BASE_URL=http://localhost:3000
```

## Caching Strategy

**Currently, this application does not implement a data caching strategy.** API calls are made for every request.

### Proposed Caching Strategy

A simple caching mechanism can be implemented in the `CurrencyRepository` to reduce network requests and improve offline experience.

-   **Strategy**: Use a package like `shared_preferences` or `hive` to store API responses locally.
-   **TTL (Time-To-Live)**: Cache currency conversion rates for a specific period (e.g., 1 hour) to ensure the data remains relatively fresh without hitting the API on every request. The key for the cache could be a combination of the `from` and `to` currencies.

## API Failure Handling

The current implementation has basic error handling using `try-catch` blocks in the repository.

### Proposed Enhancements

-   **Retry Mechanism**: Implement a retry policy for failed API requests using a package like `retry`. This can help recover from transient network issues.
-   **Offline UI**: The BLoC can manage a state to indicate network failure. The UI can listen to this state and show a user-friendly message or a cached result if available.
-   **Fallbacks**: If the primary API fails, you could implement a fallback to a secondary API or a default conversion rate.