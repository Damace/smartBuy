class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'SmartBuy';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyCart = 'cart_items';
  static const String storageKeyWishlist = 'wishlist_items';
  static const String storageKeyLanguage = 'app_language';
  static const String storageKeyTheme = 'app_theme';
  static const String storageKeyIsFirstTime = 'is_first_time';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int defaultPage = 1;

  // Image Paths
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String logoPath = 'assets/logos/';

  // Default Images
  static const String defaultProductImage = 'assets/images/default_product.png';
  static const String defaultUserImage = 'assets/images/default_user.png';
  static const String defaultBanner = 'assets/images/default_banner.png';

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[0-9]{10}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 20;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Currency
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String timeFormat = 'hh:mm a';

  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
  static const String orderStatusRefunded = 'refunded';

  // Payment Methods
  static const String paymentMethodCOD = 'cod';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodUPI = 'upi';
  static const String paymentMethodWallet = 'wallet';

  // Social Links
  static const String facebookUrl = 'https://facebook.com/smartbuy';
  static const String instagramUrl = 'https://instagram.com/smartbuy';
  static const String twitterUrl = 'https://twitter.com/smartbuy';
  static const String linkedinUrl = 'https://linkedin.com/company/smartbuy';

  // Support
  static const String supportEmail = 'support@smartbuy.com';
  static const String supportPhone = '+1234567890';
  static const String privacyPolicyUrl = 'https://smartbuy.com/privacy-policy';
  static const String termsConditionsUrl = 'https://smartbuy.com/terms-conditions';
}
