import 'package:get/get.dart';
import 'vendor_business_details_controller.dart';

class VendorBusinessDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorBusinessDetailsController>(
      () => VendorBusinessDetailsController(),
    );
  }
}
