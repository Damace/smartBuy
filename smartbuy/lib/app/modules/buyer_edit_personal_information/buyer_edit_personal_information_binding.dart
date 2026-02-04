import 'package:get/get.dart';
import 'buyer_edit_personal_information_controller.dart';

class BuyerEditPersonalInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerEditPersonalInformationController>(
      () => BuyerEditPersonalInformationController(),
    );
  }
}
