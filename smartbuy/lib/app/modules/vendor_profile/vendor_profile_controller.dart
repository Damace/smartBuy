import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_pages.dart';

class VendorProfileController extends GetxController {
  final storage = GetStorage();

  // Store Information
  final RxString storeName = 'SmartBuy Official Store'.obs;
  final RxString storeLogoUrl = ''.obs;
  final RxString memberSince = 'April 2022'.obs;
  final RxBool isTopRated = true.obs;
  final RxBool isVerified = true.obs;

  // Statistics
  final RxString totalSales = '\$12,450'.obs;
  final RxInt activeProducts = 142.obs;
  final RxDouble rating = 4.8.obs;

  @override
  void onInit() {
    super.onInit();
    loadVendorData();
  }

  void loadVendorData() {
    // Load vendor data from storage
    storeName.value = storage.read('storeName') ?? 'SmartBuy Official Store';
    memberSince.value = storage.read('memberSince') ?? 'April 2022';
    totalSales.value = storage.read('totalSales') ?? '\$12,450';
    activeProducts.value = storage.read('activeProducts') ?? 142;
    rating.value = storage.read('rating') ?? 4.8;
  }

  void navigateToBusinessProfile() {
    print('Navigate to Business Profile');
  }

  void navigateToBankDetails() {
    print('Navigate to Bank Account Details');
  }

  void navigateToStorePolicies() {
    print('Navigate to Store Policies');
  }

  void navigateToTaxInfo() {
    print('Navigate to Tax & GST Information');
  }

  void navigateToShippingPartners() {
    print('Navigate to Shipping Partners');
  }

  void navigateToStoreCustomization() {
    print('Navigate to Store Customization');
  }

  void navigateToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void viewStoreAsBuyer() {
    // Navigate to store preview as buyer
    print('View Store as Buyer');
    Get.snackbar(
      'Store Preview',
      'Opening your store in buyer view...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signOut() {
    Get.defaultDialog(
      title: 'sign_out'.tr,
      middleText: 'sign_out_confirmation'.tr,
      textConfirm: 'sign_out'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      onConfirm: () {
        storage.erase();
        Get.back();
        Get.offAllNamed(Routes.VENDOR_LOGIN);
      },
    );
  }
}
