# SmartFab Tracker App

A comprehensive Flutter-based Material Tracking & Costing App designed for SmartFab Industries. This app replaces manual paper logs and spreadsheets used in raw material tracking and manufacturing cost calculation.

## Features

### Role-Based Access Control (RBAC)
- **Admin Role**: Manage materials, processes, users, and view analytics
- **Operator Role**: Scan QR/barcodes, log consumption, view assigned tasks

### Material Management
- Real-time material tracking and inventory management
- QR/barcode scanning for quick material identification
- Automated cost calculations for materials and products
- Low-stock alerts and inventory level visualization

### Manufacturing Cost Management
- Raw material cost tracking
- Manufacturing cost calculation (labor, overhead)
- Final product price calculation with suggested profit margins
- Cost breakdown reports and analytics

### Offline Functionality
- Local caching of scans/logs using Hive
- Seamless synchronization with Firebase Firestore when reconnected

### Reporting & Analytics
- Generate cost breakdown reports
- Export to PDF/CSV formats
- Consumption history tracking
- Real-time cost performance visibility

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider & Bloc
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Local Storage**: Hive & SQLite
- **Barcode/QR Scanning**: mobile_scanner
- **PDF/CSV Export**: pdf, printing, csv packages
- **Charts & Graphs**: fl_chart

## Architecture

The app is built using Clean Architecture principles:

- **Presentation Layer**: UI components, Bloc/Provider state management
- **Domain Layer**: Business logic, use cases, repository interfaces
- **Data Layer**: Repository implementations, data sources (remote & local)

## Setup Instructions

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase Project
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository
```bash
git clone https://github.com/smartfab/smart-tracking-app.git
cd smart-tracking-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a Firebase project
   - Add Android & iOS apps to your Firebase project
   - Download and place the Firebase configuration files:
     - `google-services.json` for Android (in android/app/)
     - `GoogleService-Info.plist` for iOS (in ios/Runner/)
     - Run `flutterfire configure` if using FlutterFire CLI

4. Run the app
```bash
flutter run
```

## Development

### Code Generation
For generating Hive adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Rules
Ensure proper Firestore security rules for RBAC:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Basic rules
    match /{document=**} {
      allow read, write: if false;
    }
    
    // User rules
    match /users/{userId} {
      allow read: if request.auth != null && (request.auth.uid == userId || isAdmin());
      allow write: if request.auth != null && isAdmin();
      allow create: if request.auth != null;
      allow update: if request.auth != null && request.auth.uid == userId;
    }
    
    // Material rules
    match /materials/{materialId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && isAdmin();
    }
    
    // Helper functions
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## Contributing

1. Create a feature branch
2. Commit your changes
3. Push to your branch
4. Create a Pull Request

## License

This project is proprietary software owned by SmartFab Industries.
