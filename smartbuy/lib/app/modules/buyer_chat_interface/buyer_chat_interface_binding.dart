import 'package:get/get.dart';
import 'buyer_chat_interface_controller.dart';

class BuyerChatInterfaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerChatInterfaceController>(
      () => BuyerChatInterfaceController(),
    );
  }
}
