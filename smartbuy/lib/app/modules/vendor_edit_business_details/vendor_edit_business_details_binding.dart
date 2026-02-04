import 'package:get/get.dart';
import 'vendor_edit_business_details_controller.dart';

class VendorEditBusinessDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorEditBusinessDetailsController>(
      () => VendorEditBusinessDetailsController(),
    );
  }
}
