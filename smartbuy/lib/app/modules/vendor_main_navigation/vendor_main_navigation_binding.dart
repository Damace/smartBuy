import 'package:get/get.dart';
import 'vendor_main_navigation_controller.dart';
import '../vendor_profile/vendor_profile_controller.dart';

class VendorMainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorMainNavigationController>(
      () => VendorMainNavigationController(),
    );
    Get.lazyPut<VendorProfileController>(
      () => VendorProfileController(),
    );
  }
}
