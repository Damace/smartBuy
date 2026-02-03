class ApiConstants {
  ApiConstants._();

  // Base URL - Will be configured for Laravel backend
  static const String baseUrl = 'http://localhost:8000/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // Product Endpoints
  static const String products = '/products';
  static const String productDetails = '/products/{id}';
  static const String featuredProducts = '/products/featured';
  static const String newArrivals = '/products/new-arrivals';
  static const String bestSellers = '/products/best-sellers';
  static const String searchProducts = '/products/search';
  static const String productReviews = '/products/{id}/reviews';

  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryDetails = '/categories/{id}';
  static const String categoryProducts = '/categories/{id}/products';

  // Cart Endpoints
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update/{id}';
  static const String removeFromCart = '/cart/remove/{id}';
  static const String clearCart = '/cart/clear';

  // Wishlist Endpoints
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove/{id}';

  // Order Endpoints
  static const String orders = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String placeOrder = '/orders/place';
  static const String cancelOrder = '/orders/{id}/cancel';
  static const String trackOrder = '/orders/{id}/track';

  // Address Endpoints
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String updateAddress = '/addresses/update/{id}';
  static const String deleteAddress = '/addresses/delete/{id}';
  static const String setDefaultAddress = '/addresses/{id}/set-default';

  // Payment Endpoints
  static const String paymentMethods = '/payment-methods';
  static const String addPaymentMethod = '/payment-methods/add';
  static const String deletePaymentMethod = '/payment-methods/delete/{id}';
  static const String processPayment = '/payments/process';

  // Banner Endpoints
  static const String banners = '/banners';

  // Coupon Endpoints
  static const String coupons = '/coupons';
  static const String applyCoupon = '/coupons/apply';
  static const String removeCoupon = '/coupons/remove';

  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllNotificationsRead = '/notifications/read-all';

  // Review Endpoints
  static const String addReview = '/reviews/add';
  static const String updateReview = '/reviews/update/{id}';
  static const String deleteReview = '/reviews/delete/{id}';

  // Settings Endpoints
  static const String appSettings = '/settings';
}
