class ApiConstants {
  ApiConstants._();

  // Base URL - Will be configured for Laravel backend
  //static const String baseUrl = 'https://smartbuy.sutech.co.tz/api';
  static const String baseUrl = 'http://192.168.1.181:8000/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String googleLogin = '/auth/google';
  static const String appleLogin = '/auth/apple';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // Buyer Profile Endpoints
  static const String buyerProfile = '/auth/profile';
  static const String buyerProfilePhoto = '/auth/profile/photo';

  // Buyer Order Endpoints
  static const String buyerOrders = '/auth/orders';

  // Buyer Wishlist Endpoints
  static const String buyerWishlist = '/auth/wishlist';

  // Buyer Address Endpoints
  static const String buyerAddresses = '/auth/addresses';

  // Buyer Payment Method Endpoints
  static const String buyerPaymentMethods = '/auth/payment-methods';

  // Buyer Notification Preferences Endpoints
  static const String buyerNotificationPreferences =
      '/auth/notification-preferences';

  // Buyer Place Order Endpoint
  static const String buyerPlaceOrder = '/auth/orders';

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
  static const String cart = '/auth/cart';
  static const String addToCart = '/auth/cart/add';
  static const String updateCartItem = '/auth/cart/{id}';
  static const String removeFromCart = '/auth/cart/{id}';
  static const String clearCart = '/auth/cart/clear';

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

  // Vendor Auth Endpoints
  static const String vendorRegister = '/vendor/register';
  static const String vendorLogin = '/vendor/login';
  static const String vendorLogout = '/vendor/logout';

  // Vendor Business Details Endpoints
  static const String vendorBusinessDetails = '/vendor/business-details';

  // Vendor Bank Account Endpoints
  static const String vendorBankAccount = '/vendor/bank-account';

  // Vendor Inventory Endpoints
  static const String vendorInventory = '/vendor/inventory';

  // Vendor Shipping Partners Endpoints
  static const String vendorShippingPartners = '/vendor/shipping-partners';

  // Vendor Settings Endpoints
  static const String vendorSettings = '/vendor/settings';

  // Vendor Product Endpoints
  static const String vendorProducts = '/vendor/products';

  // Vendor Order Endpoints
  static const String vendorOrders = '/vendor/orders';
}
