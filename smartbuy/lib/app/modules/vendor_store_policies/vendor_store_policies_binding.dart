import 'package:get/get.dart';
import 'vendor_store_policies_controller.dart';

class VendorStorePoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorStorePoliciesController>(
      () => VendorStorePoliciesController(),
    );
  }
}
