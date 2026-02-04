import 'package:get/get.dart';
import 'buyer_saved_address_controller.dart';

class BuyerSavedAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerSavedAddressController>(
      () => BuyerSavedAddressController(),
    );
  }
}
