import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();
  final ApiProvider _apiProvider = ApiProvider();

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString countryCode = ''.obs;
  final RxString membershipStatus = 'BUYER'.obs;
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Show stored data immediately, then refresh from server
    _loadFromStorage();
    _fetchFromServer();
  }

  // ── Load cached data ─────────────────────────────────────────────────────────

  void _loadFromStorage() {
    final userData = storage.read(AppConstants.storageKeyUser);
    if (userData is Map) {
      userName.value = userData['name']?.toString() ?? '';
      userEmail.value = userData['email']?.toString() ?? '';
      userPhone.value = userData['phone']?.toString() ?? '';
      countryCode.value = userData['country_code']?.toString() ?? '';
      profileImageUrl.value =
          (userData['profile_photo'] ?? userData['avatar_url'])?.toString() ??
              '';
      final status = userData['status']?.toString() ?? '';
      membershipStatus.value =
          status == 'active' ? 'BUYER' : status.toUpperCase();
    }
  }

  // ── Fetch live from server ───────────────────────────────────────────────────

  Future<void> _fetchFromServer() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.buyerProfile);
      final buyer = response.data['buyer'] as Map<String, dynamic>;

      userName.value = buyer['name']?.toString() ?? userName.value;
      userEmail.value = buyer['email']?.toString() ?? userEmail.value;
      userPhone.value = buyer['phone']?.toString() ?? userPhone.value;
      countryCode.value =
          buyer['country_code']?.toString() ?? countryCode.value;
      profileImageUrl.value =
          buyer['profile_photo']?.toString() ?? profileImageUrl.value;

      final status = buyer['status']?.toString() ?? '';
      membershipStatus.value =
          status == 'active' ? 'BUYER' : status.toUpperCase();

      // Keep storage in sync
      final existing =
          storage.read(AppConstants.storageKeyUser) as Map? ?? {};
      storage.write(AppConstants.storageKeyUser, {...existing, ...buyer});
    } catch (_) {
      // Silently fall back to cached data already shown
    } finally {
      isLoading.value = false;
    }
  }

  // Called when returning from edit profile screen to refresh data
  Future<void> refreshProfile() async {
    _loadFromStorage();
    await _fetchFromServer();
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  void editProfile() => Get.toNamed(Routes.BUYER_EDIT_PERSONAL_INFORMATION)
      ?.then((_) => refreshProfile());

  void navigateToOrders() => Get.toNamed(Routes.BUYER_ORDERS);
  void navigateToWishlist() => Get.toNamed(Routes.WISHLIST);
  void navigateToMessages() => Get.toNamed(Routes.BUYER_MESSAGES_INBOX);

  void navigateToPersonalInfo() =>
      Get.toNamed(Routes.BUYER_EDIT_PERSONAL_INFORMATION)
          ?.then((_) => refreshProfile());

  void navigateToAddresses() => Get.toNamed(Routes.BUYER_SAVED_ADDRESS);
  void navigateToPaymentMethods() => Get.toNamed(Routes.BUYER_SAVED_PAYMENT);
  void navigateToNotificationPreferences() =>
      Get.toNamed(Routes.BUYER_NOTIFICATION_PREFERENCES);

  void navigateToCoupons() {}
  void navigateToHelpCenter() {}

  void performLogout() {
    storage.remove(AppConstants.storageKeyToken);
    storage.remove(AppConstants.storageKeyUser);
    Get.offAllNamed(Routes.LOGIN);
  }
}
