import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class VendorProfileController extends GetxController {
  final storage = GetStorage();
  final ApiProvider _apiProvider = ApiProvider();

  // Store Information
  final RxString storeName = ''.obs;
  final RxString storeLogoUrl = ''.obs;
  final RxString memberSince = ''.obs;
  final RxBool isTopRated = false.obs;
  final RxBool isVerified = false.obs;
  final RxBool isLoading = false.obs;

  // Statistics
  final RxString totalSales = '—'.obs;
  final RxInt activeProducts = 0.obs;
  final RxDouble rating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    _fetchActiveProductCount();
  }

  void _loadFromStorage() {
    final vendor = storage.read(AppConstants.storageKeyUser);
    if (vendor == null) return;

    storeName.value = vendor['business_name']?.toString() ?? '';
    isVerified.value = vendor['verification_status'] == 'verified';

    // Format created_at → "MMM YYYY"
    final createdAt = vendor['created_at']?.toString();
    if (createdAt != null && createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        memberSince.value = '${months[date.month - 1]} ${date.year}';
      } catch (_) {
        memberSince.value = createdAt;
      }
    }

    // total_sales → formatted currency string
    final sales = vendor['total_sales'];
    if (sales != null) {
      final amount = double.tryParse(sales.toString()) ?? 0.0;
      totalSales.value = '\$${amount.toStringAsFixed(0)}';
    }

    // rating
    final r = vendor['rating'];
    if (r != null) {
      rating.value = double.tryParse(r.toString()) ?? 0.0;
      isTopRated.value = rating.value >= 4.5;
    }
  }

  Future<void> _fetchActiveProductCount() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorProducts);
      final data = response.data;
      if (data is Map) {
        // Laravel paginate returns `total` at top level
        final total = data['total'];
        if (total != null) {
          activeProducts.value =
              total is int ? total : int.tryParse(total.toString()) ?? 0;
        } else {
          final list = data['data'];
          if (list is List) activeProducts.value = list.length;
        }
      }
    } catch (_) {
      // Keep default 0
    } finally {
      isLoading.value = false;
    }
  }

  void loadVendorData() {
    _loadFromStorage();
  }

  void navigateToBusinessProfile() {
    Get.toNamed(Routes.VENDOR_BUSINESS_DETAILS);
  }

  void navigateToBankDetails() {
    Get.toNamed(Routes.VENDOR_BANK_ACCOUNT_DETAILS);
  }

  void navigateToStorePolicies() {
    Get.toNamed(Routes.VENDOR_STORE_POLICIES);
  }

  void navigateToStockInventory() {
    Get.toNamed(Routes.VENDOR_STOCK_INVENTORY);
  }

  void navigateToShippingPartners() {
    Get.toNamed(Routes.VENDOR_SHIPPING_PARTNERS);
  }

  void navigateToInventoryAlerts() {
    Get.toNamed(Routes.VENDOR_INVENTORY_ALERTS);
  }

  void navigateToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void viewStoreAsBuyer() {
    Get.toNamed(Routes.VENDOR_STORE_PREVIEW);
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
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }
}
