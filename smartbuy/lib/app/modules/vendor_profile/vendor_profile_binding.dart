import 'package:get/get.dart';
import 'vendor_profile_controller.dart';

class VendorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorProfileController>(
      () => VendorProfileController(),
    );
  }
}
