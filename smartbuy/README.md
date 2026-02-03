# SmartBuy - E-Commerce Flutter Application

<div align="center">
  <h3>Your Smart Shopping Companion</h3>
  <p>A modern, full-featured e-commerce mobile application built with Flutter and GetX</p>
</div>

## About

SmartBuy is a comprehensive e-commerce mobile application that provides a seamless shopping experience. Built with Flutter for cross-platform compatibility and powered by GetX for efficient state management.

## Features

- User Authentication (Login, Register, Password Reset)
- Product Browsing and Search
- Product Details with Reviews and Ratings
- Shopping Cart Management
- Wishlist/Favorites
- Order Placement and Tracking
- Multiple Address Management
- Payment Integration (Ready)
- Order History
- User Profile Management
- Promotional Banners
- Coupon/Discount System
- Push Notifications
- And more...

## Tech Stack

### Frontend (Flutter)
- **Framework**: Flutter
- **State Management**: GetX
- **HTTP Client**: Dio
- **Local Storage**: GetStorage
- **UI Components**: Material 3

### Backend (Planned)
- **Framework**: Laravel
- **Database**: MySQL/PostgreSQL
- **API**: RESTful
- **Admin Panel**: Laravel with full e-commerce features

## Project Status

✅ Flutter project setup complete
✅ GetX state management configured
✅ Data models created
✅ API service ready
✅ Theme and utilities implemented
⏳ Waiting for screen designs
⏳ Backend development pending

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd smartbuy
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed project structure and documentation.

## Configuration

### API Base URL
Update the base URL in [lib/app/core/constants/api_constants.dart](lib/app/core/constants/api_constants.dart):
```dart
static const String baseUrl = 'http://your-api-url.com/api';
```

### App Constants
Customize app settings in [lib/app/core/constants/app_constants.dart](lib/app/core/constants/app_constants.dart)

## Contributing

This is a private project. Contributions will be accepted after initial release.

## License

All rights reserved.

## Contact

For questions or support, contact: support@smartbuy.com

---

Built with ❤️ using Flutter and GetX
