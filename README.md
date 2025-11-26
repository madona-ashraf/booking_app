# ✈️ Flight Booking App

A modern and feature-rich flight booking application built with Flutter. This app allows users to search for destinations, explore tourist attractions, and book flights seamlessly with an intuitive user interface.

## 🌟 Features

### 🔐 Authentication
- **Firebase Authentication**: Secure login and registration
- **Social Login**: Google Sign-In and Facebook Authentication
- **User Profile Management**: Manage your personal information and booking history

### 🗺️ Destination Search & Discovery
- **Place Search**: Search for any destination worldwide using Amadeus API
- **Tourist Attractions**: Discover popular tourist attractions at your destination
- **Location-based POI**: Get points of interest based on location coordinates
- **Real-time Search**: Instant search results as you type

### ✈️ Flight Booking
- **Flight Search**: Search for flights with flexible date options
- **Flight Details**: View comprehensive flight information including:
  - Departure and arrival times
  - Flight duration
  - Airline information
  - Price and class options
- **Booking Management**: Complete booking flow with seat selection and add-ons
- **Booking History**: View all your past and upcoming bookings

### 🎨 User Interface
- **Modern Design**: Clean, intuitive, and visually appealing UI
- **Responsive Layout**: Works seamlessly on all screen sizes
- **Custom Fonts**: Poppins font family for better readability
- **Smooth Animations**: Fluid transitions and interactions
- **Dark Theme Support**: Eye-friendly interface

### 📍 Popular Destinations
- **Curated Destinations**: Browse through popular travel destinations
- **City Highlights**: Quick access to major cities worldwide
- **Destination Cards**: Beautiful cards with images, ratings, and prices

## 📸 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center">
        <h3>Home Screen</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.45 AM.jpeg" alt="Home Screen" width="250">
        <p><em>Main dashboard with search and popular destinations</em></p>
      </td>
      <td align="center">
        <h3>Search Results</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.46 AM.jpeg" alt="Search Results" width="250">
        <p><em>Place search with real-time results</em></p>
      </td>
      <td align="center">
        <h3>Tourist Attractions</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.47 AM.jpeg" alt="Tourist Attractions" width="250">
        <p><em>Discover attractions at your destination</em></p>
      </td>
    </tr>
    <tr>
      <td align="center">
        <h3>Flight Search</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.48 AM.jpeg" alt="Flight Search" width="250">
        <p><em>Search and compare flights</em></p>
      </td>
      <td align="center">
        <h3>Flight Details</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.47 AM (1).jpeg" alt="Flight Details" width="250">
        <p><em>Detailed flight information</em></p>
      </td>
      <td align="center">
        <h3>Profile</h3>
        <img src="screenshots/WhatsApp Image 2025-11-27 at 12.43.47 AM (2).jpeg" alt="Profile" width="250">
        <p><em>User profile and booking history</em></p>
      </td>
    </tr>
  </table>
</div>

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest version) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)
- Firebase account (for authentication)
- Amadeus API credentials (for flight and location services)

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/madona-ashraf/booking_app.git
cd booking_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure Firebase:**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` for Android and place it in `android/app/`
   - Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`
   - Update `firebase_options.dart` with your Firebase configuration

4. **Configure Amadeus API:**
   - Sign up for Amadeus API at [Amadeus for Developers](https://developers.amadeus.com/)
   - Add your API credentials to the Amadeus service files

5. **Run the app:**
```bash
flutter run
```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc: ^9.1.1` - State management using BLoC pattern
- `provider: ^6.1.2` - Additional state management
- `equatable: ^2.0.0` - Value equality for Dart objects

### Firebase
- `firebase_core: ^3.6.0` - Firebase core functionality
- `firebase_auth: ^5.3.1` - Authentication services
- `cloud_firestore: ^5.6.12` - Cloud database

### Authentication
- `google_sign_in: ^6.2.1` - Google Sign-In
- `flutter_facebook_auth: ^7.1.1` - Facebook Authentication

### Networking & APIs
- `http: ^1.2.2` - HTTP requests for API calls

### UI & Utilities
- `intl: ^0.19.0` - Internationalization and date formatting
- `shared_preferences: ^2.3.2` - Local storage
- `url_launcher: ^6.3.1` - Launch URLs and external apps
- `curved_navigation_bar: ^1.0.6` - Custom navigation bar
- `flutter_svg: ^2.0.10+1` - SVG image support
- `lottie: ^3.1.2` - Lottie animations

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and colors
│   ├── models/             # Data models
│   └── widgets/            # Reusable widgets
├── features/
│   ├── auth/               # Authentication feature
│   │   ├── presentation/
│   │   │   ├── cubit/      # Auth state management
│   │   │   └── pages/      # Login, profile pages
│   │   └── domain/         # Auth business logic
│   ├── booking/            # Flight booking feature
│   │   ├── presentation/
│   │   │   └── pages/      # Search, details, booking pages
│   │   └── bookingengine/  # Flight API integration
│   ├── home/               # Home feature
│   │   └── presentation/
│   │       └── pages/      # Home page
│   └── navigation/         # Navigation feature
│       └── presentation/
│           └── pages/      # Main navigation
├── assets/
│   ├── images/             # App images
│   ├── icons/              # App icons
│   └── fonts/              # Custom fonts (Poppins)
└── main.dart               # App entry point
```

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication methods (Email/Password, Google, Facebook)
3. Add your app to Firebase project
4. Download configuration files

### Amadeus API Setup
1. Register at [Amadeus for Developers](https://developers.amadeus.com/)
2. Create a new app to get API credentials
3. Update API keys in:
   - `lib/features/booking/bookingengine/fligthrepo/amadeus_service.dart`
   - `lib/features/booking/bookingengine/fligthrepo/amadeus_poi_service.dart`

## 🎯 Key Features in Detail

### Place Search
- Real-time search using Amadeus Place API
- Displays location information with coordinates
- Navigate to tourist attractions page

### Tourist Attractions
- Fetches POI (Points of Interest) based on location
- Categorizes attractions (Monuments, Museums, Parks, etc.)
- Sort by distance, alphabetical, or recommended
- Beautiful card-based UI with images

### Flight Booking
- Search flights by origin and destination
- Filter by date, class, and passengers
- View detailed flight information
- Complete booking with seat selection

## 🛠️ Development

### Running the App
```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

### Building the App
```bash
# Build APK for Android
flutter build apk

# Build iOS app
flutter build ios

# Build web app
flutter build web
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication and backend services
- Amadeus for flight and location APIs
- All contributors who have helped in the development

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

Made with ❤️ using Flutter
