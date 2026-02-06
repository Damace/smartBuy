import 'package:get/get.dart';
import 'buyer_messages_inbox_controller.dart';

class BuyerMessagesInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerMessagesInboxController>(
      () => BuyerMessagesInboxController(),
    );
  }
}
