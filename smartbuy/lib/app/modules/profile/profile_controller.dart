import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();
  final RxString userName = 'Alex Johnson'.obs;
  final RxString userEmail = 'alex.johnson@example.com'.obs;
  final RxString userPhone = '+1 234 567 8900'.obs;
  final RxString membershipStatus = 'GOLD MEMBER'.obs;
  final RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Load user data from storage
    userName.value = storage.read('userName') ?? 'Alex Johnson';
    userEmail.value = storage.read('userEmail') ?? 'alex.johnson@example.com';
    userPhone.value = storage.read('userPhone') ?? '+1 234 567 8900';
    membershipStatus.value = storage.read('membershipStatus') ?? 'GOLD MEMBER';
    profileImageUrl.value = storage.read('profileImageUrl') ?? '';
  }

  void editProfile() {
    // Navigate to edit profile or show edit dialog
    print('Edit profile tapped');
  }

  void navigateToOrders() {
    Get.toNamed(Routes.ORDERS);
  }

  void navigateToWishlist() {
    Get.toNamed(Routes.WISHLIST);
  }

  void navigateToCoupons() {
    // Navigate to coupons screen
    print('Navigate to coupons');
  }

  void navigateToHelpCenter() {
    // Navigate to help center
    print('Navigate to help center');
  }

  void navigateToPersonalInfo() {
    // Navigate to personal information screen
    print('Navigate to personal info');
  }

  void navigateToAddresses() {
    Get.toNamed(Routes.ADDRESS);
  }

  void navigateToPaymentMethods() {
    Get.toNamed(Routes.PAYMENT);
  }

  void navigateToNotificationPreferences() {
    // Navigate to notification preferences
    print('Navigate to notification preferences');
  }

  void performLogout() {
    storage.remove(AppConstants.storageKeyToken);
    storage.remove('userName');
    storage.remove('userEmail');
    storage.remove('userPhone');
    storage.remove('membershipStatus');
    storage.remove('profileImageUrl');
    Get.offAllNamed(Routes.LOGIN);
  }
}
