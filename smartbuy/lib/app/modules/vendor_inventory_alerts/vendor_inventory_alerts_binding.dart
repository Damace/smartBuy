import 'package:get/get.dart';
import 'vendor_inventory_alerts_controller.dart';

class VendorInventoryAlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorInventoryAlertsController>(
      () => VendorInventoryAlertsController(),
    );
  }
}
