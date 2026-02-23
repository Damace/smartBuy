import 'package:SmartBuy/app/core/constants/system_status_view.dart';
import 'package:SmartBuy/app/modules/LoadingScreen/LoadingScreen_binding.dart';
import 'package:SmartBuy/app/modules/LoadingScreen/LoadingScreen_view.dart';
import 'package:SmartBuy/app/modules/category_list/category_list_binding.dart';
import 'package:SmartBuy/app/modules/category_list/category_list_view.dart';
import 'package:SmartBuy/app/modules/notification/notification_binding.dart';
import 'package:SmartBuy/app/modules/notification/notification_view.dart';
import 'package:SmartBuy/app/modules/search/search_binding.dart';
import 'package:SmartBuy/app/modules/search/search_view.dart';
import 'package:SmartBuy/app/modules/vendor_payment_details/vendor_payment_details_binding.dart';
import 'package:SmartBuy/app/modules/vendor_payment_details/vendor_payment_details_view.dart';
import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/auth/otp/otp_binding.dart';
import '../modules/auth/otp/otp_view.dart';
import '../modules/auth/vendor_login/vendor_login_binding.dart';
import '../modules/auth/vendor_login/vendor_login_view.dart';
import '../modules/auth/vendor_register/vendor_register_binding.dart';
import '../modules/auth/vendor_register/vendor_register_view.dart';
import '../modules/vendor_status/vendor_status_binding.dart';
import '../modules/vendor_status/vendor_status_view.dart';
import '../modules/vendor_main_navigation/vendor_main_navigation_binding.dart';
import '../modules/vendor_main_navigation/vendor_main_navigation_view.dart';
import '../modules/vendor_add_product/vendor_add_product_binding.dart';
import '../modules/vendor_add_product/vendor_add_product_view.dart';
import '../modules/vendor_edit_product/vendor_edit_product_binding.dart';
import '../modules/vendor_edit_product/vendor_edit_product_view.dart';
import '../modules/vendor_order_details/vendor_order_details_binding.dart';
import '../modules/vendor_order_details/vendor_order_details_view.dart';
import '../modules/vendor_business_details/vendor_business_details_binding.dart';
import '../modules/vendor_business_details/vendor_business_details_view.dart';
import '../modules/vendor_bank_account_details/vendor_bank_account_details_binding.dart';
import '../modules/vendor_bank_account_details/vendor_bank_account_details_view.dart';
import '../modules/vendor_store_policies/vendor_store_policies_binding.dart';
import '../modules/vendor_store_policies/vendor_store_policies_view.dart';
import '../modules/vendor_shipping_partners/vendor_shipping_partners_binding.dart';
import '../modules/vendor_shipping_partners/vendor_shipping_partners_view.dart';
import '../modules/vendor_stock_inventory/vendor_stock_inventory_binding.dart';
import '../modules/vendor_stock_inventory/vendor_stock_inventory_view.dart';
import '../modules/vendor_inventory_alerts/vendor_inventory_alerts_binding.dart';
import '../modules/vendor_inventory_alerts/vendor_inventory_alerts_view.dart';
import '../modules/vendor_edit_business_details/vendor_edit_business_details_binding.dart';
import '../modules/vendor_edit_business_details/vendor_edit_business_details_view.dart';
import '../modules/vendor_edit_bank_account_details/vendor_edit_bank_account_details_binding.dart';
import '../modules/vendor_edit_bank_account_details/vendor_edit_bank_account_details_view.dart';
import '../modules/vendor_store_preview/vendor_store_preview_binding.dart';
import '../modules/vendor_store_preview/vendor_store_preview_view.dart';
import '../modules/settings/settings_binding.dart';
import '../modules/settings/settings_view.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/buyer_edit_personal_information/buyer_edit_personal_information_binding.dart';
import '../modules/buyer_edit_personal_information/buyer_edit_personal_information_view.dart';
import '../modules/buyer_orders/buyer_orders_binding.dart';
import '../modules/buyer_orders/buyer_orders_view.dart';
import '../modules/buyer_order_details/buyer_order_details_binding.dart';
import '../modules/buyer_order_details/buyer_order_details_view.dart';
import '../modules/buyer_track_order/buyer_track_order_binding.dart';
import '../modules/buyer_track_order/buyer_track_order_view.dart';
import '../modules/wishlist/wishlist_binding.dart';
import '../modules/wishlist/wishlist_view.dart';
import '../modules/buyer_saved_address/buyer_saved_address_binding.dart';
import '../modules/buyer_saved_address/buyer_saved_address_view.dart';
import '../modules/buyer_edit_address/buyer_edit_address_binding.dart';
import '../modules/buyer_edit_address/buyer_edit_address_view.dart';
import '../modules/buyer_saved_payment/buyer_saved_payment_binding.dart';
import '../modules/buyer_saved_payment/buyer_saved_payment_view.dart';
import '../modules/buyer_edit_payment/buyer_edit_payment_binding.dart';
import '../modules/buyer_edit_payment/buyer_edit_payment_view.dart';
import '../modules/buyer_notification_preferences/buyer_notification_preferences_binding.dart';
import '../modules/buyer_notification_preferences/buyer_notification_preferences_view.dart';
import '../modules/network_connection/network_connection_binding.dart';
import '../modules/network_connection/network_connection_view.dart';
import '../modules/buyer_messages_inbox/buyer_messages_inbox_binding.dart';
import '../modules/buyer_messages_inbox/buyer_messages_inbox_view.dart';
import '../modules/buyer_chat_interface/buyer_chat_interface_binding.dart';
import '../modules/buyer_chat_interface/buyer_chat_interface_view.dart';
import '../modules/buyer_checkout/buyer_checkout_binding.dart';
import '../modules/buyer_checkout/buyer_checkout_view.dart';
import '../modules/buyer_order_success/buyer_order_success_binding.dart';
import '../modules/buyer_order_success/buyer_order_success_view.dart';
import '../modules/main_navigation/main_navigation_binding.dart';
import '../modules/main_navigation/main_navigation_view.dart';
import '../modules/product_details/product_details_binding.dart';
import '../modules/product_details/product_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static const INITIAL = Routes.SPLASH;

  static const INITIAL = Routes.SPLASH;
  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      // transition: Transition.fade,
      // transitionDuration: const Duration(milliseconds: 1000),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_LOGIN,
      page: () => const VendorLoginView(),
      binding: VendorLoginBinding(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.VENDOR_REGISTER,
      page: () => const VendorRegisterView(),
      binding: VendorRegisterBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_STATUS,
      page: () => const VendorStatusView(),
      binding: VendorStatusBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.VENDOR_HOME,
      page: () => const VendorMainNavigationView(),
      binding: VendorMainNavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.VENDOR_ADD_PRODUCT,
      page: () => const VendorAddProductView(),
      binding: VendorAddProductBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_EDIT_PRODUCT,
      page: () => const VendorEditProductView(),
      binding: VendorEditProductBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_ORDER_DETAILS,
      page: () => const VendorOrderDetailsView(),
      binding: VendorOrderDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_BUSINESS_DETAILS,
      page: () => const VendorBusinessDetailsView(),
      binding: VendorBusinessDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_BANK_ACCOUNT_DETAILS,
      page: () => const VendorBankAccountDetailsView(),
      binding: VendorBankAccountDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_STORE_POLICIES,
      page: () => const VendorStorePoliciesView(),
      binding: VendorStorePoliciesBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_SHIPPING_PARTNERS,
      page: () => const VendorShippingPartnersView(),
      binding: VendorShippingPartnersBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_STOCK_INVENTORY,
      page: () => const VendorStockInventoryView(),
      binding: VendorStockInventoryBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_INVENTORY_ALERTS,
      page: () => const VendorInventoryAlertsView(),
      binding: VendorInventoryAlertsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_EDIT_BUSINESS_DETAILS,
      page: () => const VendorEditBusinessDetailsView(),
      binding: VendorEditBusinessDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_EDIT_BANK_ACCOUNT_DETAILS,
      page: () => const VendorEditBankAccountDetailsView(),
      binding: VendorEditBankAccountDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_STORE_PREVIEW,
      page: () => const VendorStorePreviewView(),
      binding: VendorStorePreviewBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_EDIT_PERSONAL_INFORMATION,
      page: () => const BuyerEditPersonalInformationView(),
      binding: BuyerEditPersonalInformationBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_ORDERS,
      page: () => const BuyerOrdersView(),
      binding: BuyerOrdersBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_ORDER_DETAILS,
      page: () => const BuyerOrderDetailsView(),
      binding: BuyerOrderDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_TRACK_ORDER,
      page: () => const BuyerTrackOrderView(),
      binding: BuyerTrackOrderBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_SAVED_ADDRESS,
      page: () => const BuyerSavedAddressView(),
      binding: BuyerSavedAddressBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_EDIT_ADDRESS,
      page: () => const BuyerEditAddressView(),
      binding: BuyerEditAddressBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_SAVED_PAYMENT,
      page: () => const BuyerSavedPaymentView(),
      binding: BuyerSavedPaymentBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_EDIT_PAYMENT,
      page: () => const BuyerEditPaymentView(),
      binding: BuyerEditPaymentBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_NOTIFICATION_PREFERENCES,
      page: () => const BuyerNotificationPreferencesView(),
      binding: BuyerNotificationPreferencesBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.NETWORK_CONNECTION,
      page: () => const NetworkConnectionView(),
      binding: NetworkConnectionBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: _Paths.BUYER_MESSAGES_INBOX,
      page: () => const BuyerMessagesInboxView(),
      binding: BuyerMessagesInboxBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_CHAT_INTERFACE,
      page: () => const BuyerChatInterfaceView(),
      binding: BuyerChatInterfaceBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_CHECKOUT,
      page: () => const BuyerCheckoutView(),
      binding: BuyerCheckoutBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.BUYER_ORDER_SUCCESS,
      page: () => const BuyerOrderSuccessView(),
      binding: BuyerOrderSuccessBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: _Paths.CATEGORY_LIST,
      page: () => const CategoryListView(),
      binding: CategoryListBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.VENDOR_PAYMENT_DETAILS,
      page: () => const VendorPaymentDetailsView(),
      binding: VendorPaymentDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.LOADING_SCREEN,
      page: () => const LoadingScreen(),
      binding: LoadingScreenBinding(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 10),
    ),

    GetPage(
      name: _Paths.SYSTEM_STATUS,
      page: () => const SystemStatusView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
