part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const OTP = _Paths.OTP;
  static const VENDOR_REGISTER = _Paths.VENDOR_REGISTER;
  static const VENDOR_LOGIN = _Paths.VENDOR_LOGIN;
  static const VENDOR_STATUS = _Paths.VENDOR_STATUS;
  static const VENDOR_HOME = _Paths.VENDOR_HOME;
  static const HOME = _Paths.HOME;
  static const PROFILE = _Paths.PROFILE;
  static const CART = _Paths.CART;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const PRODUCT_DETAILS = _Paths.PRODUCT_DETAILS;
  static const CATEGORY = _Paths.CATEGORY;
  static const SEARCH = _Paths.SEARCH;
  static const ORDERS = _Paths.ORDERS;
  static const ORDER_DETAILS = _Paths.ORDER_DETAILS;
  static const WISHLIST = _Paths.WISHLIST;
  static const SETTINGS = _Paths.SETTINGS;
  static const ADDRESS = _Paths.ADDRESS;
  static const PAYMENT = _Paths.PAYMENT;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const OTP = '/otp';
  static const VENDOR_REGISTER = '/vendor-register';
  static const VENDOR_LOGIN = '/vendor-login';
  static const VENDOR_STATUS = '/vendor-status';
  static const VENDOR_HOME = '/vendor-home';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const CART = '/cart';
  static const CHECKOUT = '/checkout';
  static const PRODUCT_DETAILS = '/product-details';
  static const CATEGORY = '/category';
  static const SEARCH = '/search';
  static const ORDERS = '/orders';
  static const ORDER_DETAILS = '/order-details';
  static const WISHLIST = '/wishlist';
  static const SETTINGS = '/settings';
  static const ADDRESS = '/address';
  static const PAYMENT = '/payment';
}
