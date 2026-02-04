import 'package:get/get.dart';
import 'vendor_main_navigation_controller.dart';
import '../vendor_home/vendor_home_controller.dart';
import '../vendor_orders/vendor_orders_controller.dart';
import '../vendor_products/vendor_products_controller.dart';
import '../vendor_profile/vendor_profile_controller.dart';

class VendorMainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorMainNavigationController>(
      () => VendorMainNavigationController(),
    );
    Get.lazyPut<VendorHomeController>(
      () => VendorHomeController(),
    );
    Get.lazyPut<VendorOrdersController>(
      () => VendorOrdersController(),
    );
    Get.lazyPut<VendorProductsController>(
      () => VendorProductsController(),
    );
    Get.lazyPut<VendorProfileController>(
      () => VendorProfileController(),
    );
  }
}
