import 'package:get/get.dart';
import 'vendor_shipping_partners_controller.dart';

class VendorShippingPartnersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorShippingPartnersController>(
      () => VendorShippingPartnersController(),
    );
  }
}
