# SmartBuy - E-Commerce Flutter App

## Project Structure

```
smartbuy/
├── lib/
│   ├── app/
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   │   ├── api_constants.dart       # API endpoint URLs
│   │   │   │   └── app_constants.dart       # App-wide constants
│   │   │   ├── themes/
│   │   │   │   └── app_theme.dart           # App theme configuration
│   │   │   ├── utils/
│   │   │   │   └── helpers.dart             # Helper functions
│   │   │   └── widgets/                     # Reusable widgets (to be added)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── product_model.dart
│   │   │   │   ├── category_model.dart
│   │   │   │   ├── cart_item_model.dart
│   │   │   │   ├── order_model.dart
│   │   │   │   ├── address_model.dart
│   │   │   │   ├── review_model.dart
│   │   │   │   └── banner_model.dart
│   │   │   ├── providers/
│   │   │   │   └── api_provider.dart        # Dio HTTP client
│   │   │   └── repositories/                # Repository classes (to be added)
│   │   ├── modules/                         # Feature modules (screens)
│   │   │   └── (to be added based on designs)
│   │   └── routes/
│   │       ├── app_pages.dart               # GetX route configuration
│   │       └── app_routes.dart              # Route name definitions
│   └── main.dart                            # App entry point
├── assets/
│   ├── images/
│   ├── icons/
│   └── logos/
└── pubspec.yaml                             # Dependencies

```

## Key Features Implemented

### 1. State Management
- GetX for reactive state management
- Get Storage for local data persistence

### 2. API Service
- Dio-based HTTP client
- Automatic token injection
- Error handling
- Request/Response interceptors

### 3. Data Models
All models include:
- JSON serialization/deserialization
- copyWith methods
- Computed properties where applicable

Available Models:
- **UserModel**: User account data
- **ProductModel**: Product details with pricing, stock, ratings
- **CategoryModel**: Product categories
- **CartItemModel**: Shopping cart items
- **OrderModel**: Order details with status tracking
- **AddressModel**: Shipping/billing addresses
- **ReviewModel**: Product reviews and ratings
- **BannerModel**: Promotional banners

### 4. Constants & Configuration
- **API Constants**: All API endpoints centralized
- **App Constants**: App-wide settings (currency, date formats, validation rules)
- **Theme**: Custom Material 3 theme with brand colors

### 5. Helper Utilities
- Snackbar notifications (success, error, warning, info)
- Currency formatting
- Date/time formatting
- Validation (email, phone, password)
- Loading dialogs
- Confirmation dialogs
- And more...

## API Endpoints Structure

The app is configured to work with a Laravel backend with the following endpoint categories:

- **Auth**: Login, register, logout, password reset
- **User**: Profile management
- **Products**: Browse, search, details, reviews
- **Categories**: Category listing and filtering
- **Cart**: Add, update, remove items
- **Wishlist**: Manage favorite products
- **Orders**: Place, track, cancel orders
- **Addresses**: Shipping/billing address management
- **Payments**: Payment method management
- **Banners**: Promotional content
- **Coupons**: Discount code management
- **Notifications**: Push notification handling
- **Reviews**: Product rating and reviews

## Theme Colors

- **Primary**: #6C63FF (Purple)
- **Secondary**: #FF6584 (Pink)
- **Accent**: #00D9FF (Cyan)
- **Success**: #34C759 (Green)
- **Error**: #FF3B30 (Red)
- **Warning**: #FFCC00 (Yellow)
- **Info**: #007AFF (Blue)

## Next Steps

1. **Wait for screen designs** from the user
2. **Create screen modules** based on designs:
   - Each screen will have:
     - `view.dart` - UI layer
     - `controller.dart` - Business logic
     - `binding.dart` - Dependency injection
3. **Set up Laravel backend** with:
   - RESTful API endpoints
   - Admin panel
   - Database migrations
   - Authentication
4. **Connect frontend to backend**
5. **Testing and refinement**

## Dependencies

Key packages used:
- `get`: State management and routing
- `get_storage`: Local storage
- `dio`: HTTP client
- `cached_network_image`: Image caching
- `carousel_slider`: Image carousels
- `shimmer`: Loading placeholders
- `flutter_rating_bar`: Star ratings
- `image_picker`: Image selection
- `intl`: Internationalization
- And more...

## Running the App

```bash
cd smartbuy
flutter pub get
flutter run
```

Currently shows a placeholder screen until actual screens are designed.
