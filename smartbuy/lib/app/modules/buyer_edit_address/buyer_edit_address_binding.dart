import 'package:get/get.dart';
import 'buyer_edit_address_controller.dart';

class BuyerEditAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerEditAddressController>(
      () => BuyerEditAddressController(),
    );
  }
}
